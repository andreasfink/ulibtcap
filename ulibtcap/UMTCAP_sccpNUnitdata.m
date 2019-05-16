//
//  UMTCAP_sccp_unidata.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_sccpNUnitdata.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_Operation.h"
#import "UMTCAP_Transaction.h"
#import "UMTCAP_asn1.h"
#import "UMTCAP_ansi_asn1_queryWithPerm.h"
#import "UMTCAP_ansi_asn1_queryWithoutPerm.h"
#import "UMTCAP_ansi_asn1_conversationWithPerm.h"
#import "UMTCAP_ansi_asn1_conversationWithoutPerm.h"
#import "UMTCAP_ansi_asn1_invoke.h"
#import "UMTCAP_ansi_asn1_transactionPDU.h"
#import "UMTCAP_ansi_asn1_uniTransactionPDU.h"
#import "UMTCAP_ansi_asn1_transactionID.h"
#import "UMTCAP_Transaction.h"
#import "UMTCAP_asn1.h"
#import "UMTCAP_itu_asn1_begin.h"
#import "UMTCAP_itu_asn1_invoke.h"
#import "UMTCAP_itu_asn1_returnResult.h"
#import "UMTCAP_itu_asn1_reject.h"
#import "UMTCAP_itu_asn1_returnError.h"
#import "UMTCAP_Variant.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_Filter.h"
#import "UMTCAP_itu_asn1_pAbortCause.h"

@implementation UMTCAP_sccpNUnitdata


- (UMTCAP_sccpNUnitdata *)initForTcap:(UMLayerTCAP *)tcap
                                 sccp:(UMLayerSCCP *)sccp
                             userData:(NSData *)xdata
                              calling:(SccpAddress *)xsrc
                               called:(SccpAddress *)xdst
                     qualityOfService:(int)xqos
                              options:(NSDictionary *)xoptions
{
    self = [super initWithName:@"UMSCCP_sccpNUnitdata"
                      receiver:tcap
                        sender:sccp
       requiresSynchronisation:NO];
    if(self)
    {
        _sccpLayer = sccp;
        _tcapLayer = tcap;
        _data = xdata;
        _src = xsrc;
        _dst = xdst;
        if(xoptions)
        {
            _options = [xoptions mutableCopy];
        }
        else
        {
            _options = [[NSMutableDictionary alloc]init];
        }
        _qos = xqos;
    }
    return self;
}

- (void)main
{
    NSUInteger pos = 0;
    BOOL decodeOnly = [_options[@"decode-only"] boolValue];
    _mtp3_pdu =_options[@"mtp3-pdu"];
    NSDate *ts = [NSDate new];
    _options[@"tcap-timestamp"] = ts;

    if(_tcapLayer.logLevel <= UMLOG_DEBUG)
    {
        [_tcapLayer.logFeed debugText:[NSString stringWithFormat:@"task sccpNUnidata:\n"
                                 @"SccpCallingAddress:%@\n"
                                 @"SccpCalledAddress:%@\n"
                                 @"PDU:%@\n",
                                 _src,
                                 _dst,
                                 [_data hexString]
                                 ]];
    }

    _options[@"tcap-pdu"] = [_data hexString];
    @try
    {
        [self startDecodingOfPdu];
        _asn1 = [[UMTCAP_asn1 alloc] initWithBerData:_data atPosition:&pos context:self];

        BOOL furtherProcessing = [self endDecodingOfPdu];
        if(furtherProcessing)
        {
            [self handlePdu];
        }
    }
    @catch(NSException *ex)
    {
        NSLog(@"Exception: %@",ex);
        [self errorDecodingPdu];
        if(decodeOnly)
        {
            _decodeError = [NSString stringWithFormat:@"Error while decoding: %@\r\n",ex];
        }
        if(_currentRemoteTransactionId != NULL)
        {
            [_tcapLayer sendPAbort:_currentRemoteTransactionId
                       cause:UMTCAP_pAbortCause_badlyFormattedTransactionPortion
              callingAddress:_dst
               calledAddress:_src
                     options:@{}];
        }
    }
}

- (void) startDecodingOfPdu
{
    _currentCommand = -1;
    _currentOperationType = -1;
    _currentComponents = [[NSMutableArray alloc]init];
    _currentOperationCode = UMTCAP_FILTER_OPCODE_MISSING;
}

- (BOOL) endDecodingOfPdu /* returns yes if processing should be done , no if PDU is redirected or fitlered away */
{
    [_currentTransaction touch];

    UMTCAP_Filter *inboundFilter = _tcapLayer.inboundFilter;

    if(inboundFilter)
    {
        if(_tcapLayer.logLevel <= UMLOG_DEBUG)
        {
            [_tcapLayer.logFeed debugText:@"inbound-filter-trigger"];
        }

        UMSynchronizedSortedDictionary *oid = _applicationContext.objectValue;
        NSString *appContextString = oid[@"objectIdentifier"];
        UMTCAP_FilterResult r = [inboundFilter filterPacket:_currentCommand
                                         applicationContext:appContextString
                                              operationCode:_currentOperationCode
                                             callingAddress:_src
                                              calledAddress:_dst];
        switch(r)
        {
            case UMTCAP_FilterResult_accept:
            case UMTCAP_FilterResult_continue:
                break;
            case UMTCAP_FilterResult_drop:
                return NO;
            case UMTCAP_FilterResult_reject:
                /* fixme: send abort here */
                return NO;
            case UMTCAP_FilterResult_redirect:
            {
                _dst.tt.tt = inboundFilter.bypass_translation_type;
                [_tcapLayer.attachedLayer sccpNUnidata:_data
                                         callingLayer:_tcapLayer
                                              calling:_src
                                               called:_dst
                                     qualityOfService:_qos
                                                class:SCCP_CLASS_BASIC
                                             handling:SCCP_HANDLING_RETURN_ON_ERROR
                                              options:_options];
                _currentTransaction.transactionIsClosed = YES;
                return NO;
            }
        }
    }
    return YES;
}

- (void) handlePdu
{
    BOOL destroyTransaction = YES;
    tcapUser = [_tcapLayer tcapDefaultUser];
    _tcapVariant = TCAP_VARIANT_ITU;
    BOOL perm = YES;

    switch(_currentCommand)
    {
        case TCAP_TAG_ANSI_UNIDIRECTIONAL:
            _tcapVariant = TCAP_VARIANT_ANSI;
        case TCAP_TAG_ITU_UNIDIRECTIONAL:
        {
            [tcapUser tcapUnidirectionalIndication:NULL
                                 tcapTransactionId:NULL
                           tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                           variant:_tcapVariant
                                    callingAddress:_src
                                     calledAddress:_dst
                                   dialoguePortion:_dialoguePortion
                                      callingLayer:_tcapLayer
                                        components:_currentComponents
                                           options:_options];
        }
            break;

        case TCAP_TAG_ANSI_QUERY_WITHOUT_PERM:
            perm=NO;
#pragma unused(perm) /* silence warning for now */
        case TCAP_TAG_ANSI_QUERY_WITH_PERM:
        {
            _tcapVariant = TCAP_VARIANT_ANSI;
            UMTCAP_UserDialogIdentifier *userDialogId = [tcapUser getNewUserDialogId];
            _currentTransaction.userDialogId = userDialogId;
            destroyTransaction = NO;
                [tcapUser tcapBeginIndication:userDialogId
                            tcapTransactionId:_currentTransaction.localTransactionId
                      tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                      variant:_tcapVariant
                               callingAddress:_src
                                calledAddress:_dst
                              dialoguePortion:_dialoguePortion
                                 callingLayer:_tcapLayer
                                   components:_currentComponents
                                      options:_options];
        }
            break;

        case TCAP_TAG_ITU_BEGIN:
        {
            _tcapVariant = TCAP_VARIANT_ITU;
            _currentTransaction = [_tcapLayer getNewIncomingTransactionForRemoteTransactionId:_currentRemoteTransactionId];
            UMTCAP_UserDialogIdentifier *userDialogId = [tcapUser getNewUserDialogId];
            _currentTransaction.userDialogId = userDialogId;
            destroyTransaction  = NO;

/*
            UMTCAP_itu_asn1_begin *o = [[UMTCAP_itu_asn1_begin alloc]initWithASN1Object:asn1 context:self];
            UMTCAP_asn1_userInformation *userInfo = o.dialoguePortion.dialogRequest.user_information;
            UMTCAP_asn1_objectIdentifier *objectIdentifier = o.dialoguePortion.dialogRequest.objectIdentifier;
*/
            if(_tcapLayer.logLevel <= UMLOG_DEBUG)
            {
                NSString *dbgTxt = [NSString stringWithFormat:@"itu tcapBeginIndication:\n"
                                    @"userDialogId:%@\n"
                                    @"SccpCallingAddress:%@\n"
                                    @"SccpCalledAddress:%@\n"
                                    @"localTransactionId:%@\n"
                                    @"remoteTransactionId:%@\n"
                                    @"dialoguePortion:%@\n"
                                    @"components:%@\n"
                                    @"options:%@\n",
                                    userDialogId,
                                    _src,
                                    _dst,
                                    _currentTransaction.localTransactionId,
                                    _currentTransaction.remoteTransactionId,
                                    _dialoguePortion,
                                    _currentComponents,
                                    _options];
                [_tcapLayer.logFeed debugText:dbgTxt];
            }
            [tcapUser tcapBeginIndication:userDialogId
                        tcapTransactionId:_currentTransaction.localTransactionId
                  tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                  variant:_tcapVariant
                           callingAddress:_src
                            calledAddress:_dst
                          dialoguePortion:_dialoguePortion
                             callingLayer:_tcapLayer
                               components:_currentComponents
                                  options:_options];
        }
            break;

        
        case TCAP_TAG_ANSI_RESPONSE:
        {
            _tcapVariant = TCAP_VARIANT_ANSI;

            [self findTransactionAndUser];
            if(tcapUser==NULL)
            {
                [_handlingLayer sendPAbort:_currentRemoteTransactionId
                                    cause:UMTCAP_pAbortCause_unrecognizedTransactionID
                           callingAddress:_dst
                            calledAddress:_src
                                  options:@{}];
                _currentTransaction.transactionIsClosed = YES;
                break;
            }
            else
            {
                destroyTransaction = YES;
                [tcapUser tcapEndIndication:_currentTransaction.userDialogId
                          tcapTransactionId:_currentTransaction.localTransactionId
                    tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                    variant:_tcapVariant
                             callingAddress:_src
                              calledAddress:_dst
                            dialoguePortion:_dialoguePortion
                               callingLayer:_handlingLayer
                                 components:_currentComponents
                                    options:_options];
                /* remove transaction data */
            }
        }
            break;
        case TCAP_TAG_ITU_END:
        {
            _tcapVariant = TCAP_VARIANT_ITU;

            [self findTransactionAndUser];
            if(tcapUser==NULL)
            {
                [_handlingLayer sendPAbort:_currentRemoteTransactionId
                                    cause:UMTCAP_pAbortCause_unrecognizedTransactionID
                           callingAddress:_dst
                            calledAddress:_src
                                  options:@{}];
                _currentTransaction.transactionIsClosed = YES;
                break;
            }
            else
            {
                destroyTransaction = YES;
                if(_tcapLayer.logLevel <= UMLOG_DEBUG)
                {
                    NSString *dbgTxt = [NSString stringWithFormat:@"itu tcapEndIndication:\n"
                                        @"userDialogId:%@\n"
                                        @"SccpCallingAddress:%@\n"
                                        @"SccpCalledAddress:%@\n"
                                        @"localTransactionId:%@\n"
                                        @"remoteTransactionId:%@\n"
                                        @"dialoguePortion:%@\n"
                                        @"components:%@\n"
                                        @"options:%@\n",
                                        _currentTransaction.userDialogId,
                                        _src,
                                        _dst,
                                        _currentTransaction.localTransactionId,
                                        _currentTransaction.remoteTransactionId,
                                        _dialoguePortion,
                                        _currentComponents,
                                        _options
                                        ];
                    [_tcapLayer.logFeed debugText:dbgTxt];
                }
                [tcapUser tcapEndIndication:_currentTransaction.userDialogId
                          tcapTransactionId:_currentTransaction.localTransactionId
                    tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                    variant:_tcapVariant
                             callingAddress:_src
                              calledAddress:_dst
                            dialoguePortion:_dialoguePortion
                               callingLayer:_handlingLayer
                                 components:_currentComponents
                                    options:_options];
                /* remove transaction data */
            }
        }
            break;
        case TCAP_TAG_ANSI_CONVERSATION_WITH_PERM:
        {
            perm = NO;
#pragma unused(perm) /* silence warning for now */
        }
        case TCAP_TAG_ANSI_CONVERSATION_WITHOUT_PERM:
        {
            _tcapVariant = TCAP_VARIANT_ANSI;
            [self findTransactionAndUser];

            if(tcapUser==NULL)
            {
                [_handlingLayer sendPAbort:_currentRemoteTransactionId
                                    cause:UMTCAP_pAbortCause_unrecognizedTransactionID
                           callingAddress:_dst
                            calledAddress:_src
                                  options:@{}];
                _currentTransaction.transactionIsClosed = YES;
                break;
            }
            else
            {
                destroyTransaction = NO;
                [tcapUser tcapContinueIndication:_currentTransaction.userDialogId
                               tcapTransactionId:_currentTransaction.localTransactionId
                         tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                         variant:_tcapVariant
                                  callingAddress:_src
                                   calledAddress:_dst
                                 dialoguePortion:_dialoguePortion
                                    callingLayer:_handlingLayer
                                      components:_currentComponents
                                         options:_options];
            }
        }
            break;
        case TCAP_TAG_ITU_CONTINUE:
        {

            [self findTransactionAndUser];
            if(tcapUser==NULL)
            {
                [_handlingLayer sendPAbort:_currentRemoteTransactionId
                                    cause:UMTCAP_pAbortCause_unrecognizedTransactionID
                           callingAddress:_dst
                            calledAddress:_src
                                  options:@{}];
                _currentTransaction.transactionIsClosed = YES;
                break;
            }
            else
            {
                _currentTransaction.remoteTransactionId = _otid;
                destroyTransaction = NO;
                if(_tcapLayer.logLevel <= UMLOG_DEBUG)
                {
                    NSString *dbgTxt = [NSString stringWithFormat:@"itu tcapContinueIndication:\n"
                                        @"userDialogId:%@\n"
                                        @"SccpCallingAddress:%@\n"
                                        @"SccpCalledAddress:%@\n"
                                        @"localTransactionId:%@\n"
                                        @"remoteTransactionId:%@\n"
                                        @"dialoguePortion:%@\n"
                                        @"components:%@\n"
                                        @"options:%@\n",
                                        _currentTransaction.userDialogId,
                                        _src,
                                        _dst,
                                        _currentTransaction.localTransactionId,
                                        _currentTransaction.remoteTransactionId,
                                        _dialoguePortion,
                                        _currentComponents,
                                        _options
                                        ];
                    [_tcapLayer.logFeed debugText:dbgTxt];
                }
                [tcapUser tcapContinueIndication:_currentTransaction.userDialogId
                               tcapTransactionId:_currentTransaction.localTransactionId
                         tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                         variant:_tcapVariant
                                  callingAddress:_src
                                   calledAddress:_dst
                                 dialoguePortion:_dialoguePortion
                                    callingLayer:_handlingLayer
                                      components:_currentComponents
                                         options:_options];
            }
        }
            break;
            
            
        case TCAP_TAG_ANSI_ABORT:
        {
            _tcapVariant = TCAP_VARIANT_ANSI;
            [self findTransactionAndUser];
            if(tcapUser)
            {
                destroyTransaction = YES;
                [tcapUser tcapUAbortIndication:_currentTransaction.userDialogId
                             tcapTransactionId:_currentTransaction.localTransactionId
                       tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                       variant:_tcapVariant
                                callingAddress:_src
                                 calledAddress:_dst
                               dialoguePortion:_dialoguePortion
                                  callingLayer:_handlingLayer
                                          asn1:(UMASN1Object *)_asn1
                                       options:_options];
            }
        }
            break;
        case TCAP_TAG_ITU_ABORT:
        {
            _tcapVariant = TCAP_VARIANT_ANSI;
            [self findTransactionAndUser];
            if(tcapUser)
            {

                destroyTransaction = YES;
                if(_tcapLayer.logLevel <= UMLOG_DEBUG)
                {
                    NSString *dbgTxt = [NSString stringWithFormat:@"itu tcapUAbortIndication:\n"
                                        @"userDialogId:%@\n"
                                        @"SccpCallingAddress:%@\n"
                                        @"SccpCalledAddress:%@\n"
                                        @"localTransactionId:%@\n"
                                        @"remoteTransactionId:%@\n"
                                        @"dialoguePortion:%@\n"
                                        @"components:%@\n"
                                        @"options:%@\n",
                                        _currentTransaction.userDialogId,
                                        _src,
                                        _dst,
                                        _currentTransaction.localTransactionId,
                                        _currentTransaction.remoteTransactionId,
                                        _dialoguePortion,
                                        _currentComponents,
                                        _options
                                        ];
                    [_tcapLayer.logFeed debugText:dbgTxt];
                }
                if(_tcapLayer.logLevel <= UMLOG_DEBUG)
                {
                    NSString *s = [NSString stringWithFormat:@"calling tcapUAbortIndication with dialogPortion: %@ (%@)",_dialoguePortion,[_dialoguePortion className]];
                    [_tcapLayer.logFeed debugText:s];
                }
                [tcapUser tcapUAbortIndication:_currentTransaction.userDialogId
                             tcapTransactionId:_currentLocalTransactionId
                       tcapRemoteTransactionId:_currentRemoteTransactionId
                                       variant:_tcapVariant
                                callingAddress:_src
                                 calledAddress:_dst
                               dialoguePortion:_dialoguePortion
                                  callingLayer:_handlingLayer
                                          asn1:(UMASN1Object *)_asn1
                                       options:_options
             ];
            }
        }
        default:
            break;
            
    }
    if(destroyTransaction)
    {
        _currentTransaction.transactionIsClosed = YES;
        [_tcapLayer removeTransaction:_currentTransaction];
    }
}


- (void)errorDecodingPdu
{
    [_sccpLayer.mtp3.problematicPacketDumper logRawPacket:_mtp3_pdu withComment:@"Can not decode UMTCAP_sccpNUnidata"];
}

- (void)handleLocalTransactionId:(NSString *)xotid
{
    _currentLocalTransactionId = xotid;
}

- (void)handleRemoteTransactionId:(NSString *)xotid
{
    _currentRemoteTransactionId = xotid;
}

- (void)handleAnsiTransactionId:(NSString *)xdtid
{
    _currentLocalTransactionId = xdtid;
}

- (void)handleComponents:(UMASN1ObjectConstructed *)componets
{
    for(UMASN1Object *o in componets.asn1_list)
    {
        UMTCAP_generic_asn1_componentPDU *c = (UMTCAP_generic_asn1_componentPDU *)o;
        [self handleComponent:c];
    }
}

- (void)handleComponent:(UMTCAP_generic_asn1_componentPDU *)component
{
    _currentOperationCode = component.operationCode;
    id<UMTCAP_UserProtocol> user = [_tcapLayer getUserForOperation:_currentOperationCode];

    if(user)
    {
        switch(component.asn1_tag.tagNumber)
        {
            case TCAP_ITU_COMPONENT_INVOKE:
            case TCAP_ANSI_COMPONENT_INVOKE_LAST:
            case TCAP_ANSI_COMPONENT_INVOKE_NOT_LAST:
                component.operationType = UMTCAP_InternalOperation_Request;
                _currentOperationType = UMTCAP_InternalOperation_Request;
                _currentOperationCode = component.operationCode;
                break;
            case TCAP_ITU_COMPONENT_RETURN_RESULT_LAST:
            case TCAP_ITU_COMPONENT_RETURN_RESULT_NOT_LAST:
            case TCAP_ANSI_COMPONENT_RETURN_RESULT_LAST:
            case TCAP_ANSI_COMPONENT_RETURN_RESULT_NOT_LAST:
                component.operationType = UMTCAP_InternalOperation_Response;
                _currentOperationType = UMTCAP_InternalOperation_Response;
                _currentOperationCode = component.operationCode;
                break;

            case TCAP_ITU_COMPONENT_RETURN_ERROR:
            case TCAP_ANSI_COMPONENT_RETURN_ERROR:
                component.operationType = UMTCAP_InternalOperation_Error;
                _currentOperationType = UMTCAP_InternalOperation_Error;
                _currentOperationCode = component.operationCode;
                break;

            case TCAP_ITU_COMPONENT_REJECT:
            case TCAP_ANSI_COMPONENT_REJECT:
                component.operationType = UMTCAP_InternalOperation_Reject;
                _currentOperationType = UMTCAP_InternalOperation_Reject;
                _currentOperationCode = component.operationCode;
                break;
        }

        NSString *xoperationName = NULL;;
        component.params = [user decodeASN1:component.params
                              operationCode:component.operationCode
                              operationType:component.operationType
                              operationName:&xoperationName
                                    context:self];
        if(xoperationName)
        {
            component.operationName = xoperationName;
        }
    }
    [_currentComponents addObject:component];
}

- (void)handleItuDialogue:(UMTCAP_itu_asn1_dialoguePortion *)dp
{
    _dialoguePortion = dp;
    if(dp.dialogRequest)
    {
        _dialogProtocolVersion = dp.dialogRequest.protocolVersion;
        _applicationContext = dp.dialogRequest.objectIdentifier;
        _userInfo =  dp.dialogRequest.user_information;
    }
    else if(dp.dialogResponse)
    {
        _dialogProtocolVersion = dp.dialogResponse.protocolVersion;
        _userInfo = dp.dialogResponse.user_information;
        _applicationContext = dp.dialogResponse.objectIdentifier;
    }
}

- (void)handleAnsiUniTransactionPDU:(UMTCAP_ansi_asn1_uniTransactionPDU *)i
{
    _unidirectional = YES;
}

- (void)handleItuBegin:(UMTCAP_itu_asn1_begin *)beginPdu
{
    UMTCAP_Transaction *t = [_tcapLayer getNewIncomingTransactionForRemoteTransactionId:beginPdu.otid.transactionId];
    t.tcapVariant = TCAP_VARIANT_ITU;
    t.remoteTransactionId = beginPdu.otid.transactionId;
    t.incoming = YES;
    _currentTransaction = t;
    
}

- (void)handleItuReturnError:(UMTCAP_itu_asn1_returnError *)i
{
    _currentOperationCode = i.operationCode;
    if(_currentTransaction.user==NULL)
    {
        _currentTransaction.user = [_tcapLayer getUserForOperation:_currentOperationCode];
    }
    
    if(_currentTransaction.user)
    {
        NSString *xoperationName;
        i.params = [_currentTransaction.user decodeASN1:i.params
                                         operationCode:i.operationCode
                                         operationType:UMTCAP_InternalOperation_Error
                                         operationName:&xoperationName
                            context:self];
        if(xoperationName)
        {
            i.operationName = xoperationName;
        }
    }
}

- (void)handleItuReturnResult:(UMTCAP_itu_asn1_returnResult *)i
{
    id<UMTCAP_UserProtocol> user;
    user = _currentTransaction.user;
    
    _currentOperationCode = i.operationCode;
    if(user==NULL)
    {
        user = [_tcapLayer getUserForOperation:_currentOperationCode];
        _currentTransaction.user  = user;
    }
    
    if(user)
    {
        NSString *xoperationName;
        i.params = [user decodeASN1:i.params
                      operationCode:i.operationCode
                      operationType:UMTCAP_InternalOperation_Response
                      operationName:&xoperationName
                            context:self];
        if(xoperationName)
        {
            i.operationName = xoperationName;
        }
    }
}

- (void)handleItuReject:(UMTCAP_itu_asn1_reject *)i
{
    if(_currentTransaction.user==NULL)
    {
        _currentTransaction.user = [_tcapLayer getUserForOperation:_currentOperationCode];
    }
    
    if(_currentTransaction.user)
    {
        NSString *xoperationName;
        i.params = [_currentTransaction.user decodeASN1:i.params
                                         operationCode:i.operationCode
                                         operationType:UMTCAP_InternalOperation_Reject
                                         operationName:&xoperationName
                            context:self];
        if(xoperationName)
        {
            i.operationName = xoperationName;
        }
    }
}

- (int64_t)operationCode
{
    return _currentOperationCode;
}

- (UMTCAP_InternalOperation)operationType
{
    return _currentOperationType;
}

- (void)setOperationType:(UMTCAP_InternalOperation)op
{
    _currentOperationType = op;
}

- (NSString *) errorCodeToErrorString:(int)err
{
    if(err==1)
    {
        return @"unknownSubscriber";
    }
    if(_currentTransaction.user==NULL)
    {
        _currentTransaction.user = [_tcapLayer getUserForOperation:_currentOperationCode];
    }
    if(_currentTransaction.user)
    {
        return [_currentTransaction.user decodeError:err ];
    }
    return NULL;
}

- (void)findTransactionAndUser
{
    _currentTransaction = [_tcapLayer findTransactionByLocalTransactionId:_currentLocalTransactionId];
    if(_currentTransaction==NULL)
    {
        NSString *instance = [_tcapLayer.tidPool findInstanceForTransaction:_dtid];
        if(instance)
        {
            UMLayerTCAP *handlingLayer = [_tcapLayer.appContext getTCAP:instance];
            _currentTransaction = [handlingLayer findTransactionByLocalTransactionId:_dtid];
            tcapUser = _currentTransaction.user;
        }
    }
}

@end
