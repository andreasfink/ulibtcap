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

#import <ulibtcap/UMTCAP_sccpNUnitdata.h>
#import "UMLayerTCAP.h"
#import <ulibtcap/UMTCAP_Operation.h>
#import <ulibtcap/UMTCAP_Transaction.h>
#import <ulibtcap/UMTCAP_asn1.h>
#import <ulibtcap/UMTCAP_ansi_asn1_queryWithPerm.h>
#import <ulibtcap/UMTCAP_ansi_asn1_queryWithoutPerm.h>
#import <ulibtcap/UMTCAP_ansi_asn1_conversationWithPerm.h>
#import <ulibtcap/UMTCAP_ansi_asn1_conversationWithoutPerm.h>
#import <ulibtcap/UMTCAP_ansi_asn1_invoke.h>
#import <ulibtcap/UMTCAP_ansi_asn1_transactionPDU.h>
#import <ulibtcap/UMTCAP_ansi_asn1_uniTransactionPDU.h>
#import <ulibtcap/UMTCAP_ansi_asn1_transactionID.h>
#import <ulibtcap/UMTCAP_Transaction.h>
#import <ulibtcap/UMTCAP_asn1.h>
#import <ulibtcap/UMTCAP_itu_asn1_begin.h>
#import <ulibtcap/UMTCAP_itu_asn1_invoke.h>
#import <ulibtcap/UMTCAP_itu_asn1_returnResult.h>
#import <ulibtcap/UMTCAP_itu_asn1_reject.h>
#import <ulibtcap/UMTCAP_itu_asn1_returnError.h>
#import <ulibtcap/UMTCAP_Variant.h>
#import "UMLayerTCAP.h"
#import <ulibtcap/UMTCAP_Filter.h>
#import <ulibtcap/UMTCAP_itu_asn1_pAbortCause.h>

@implementation UMTCAP_sccpNUnitdata

/* fallback */
- (UMTCAP_sccpNUnitdata *)initForTcap:(UMLayerTCAP *)tcap
                                 sccp:(UMLayerSCCP *)sccp
                             userData:(NSData *)xdata
                              calling:(SccpAddress *)xsrc
                               called:(SccpAddress *)xdst
                     qualityOfService:(int)xqos
                              options:(NSDictionary *)xoptions
{
    return [self initForTcap:tcap
                        sccp:sccp
                    userData:xdata
                     calling:xsrc
                      called:xdst
            qualityOfService:xqos
                     options:xoptions
            verifyAcceptance:NO];

}

- (UMTCAP_sccpNUnitdata *)initForTcap:(UMLayerTCAP *)tcap
                                 sccp:(UMLayerSCCP *)sccp
                             userData:(NSData *)xdata
                              calling:(SccpAddress *)xsrc
                               called:(SccpAddress *)xdst
                     qualityOfService:(int)xqos
                              options:(NSDictionary *)xoptions
                     verifyAcceptance:(BOOL)verAcc
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
        _verifyAcceptance = verAcc;
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
    _verifyAcceptance=NO;
    [self mainWithResult];
}

- (BOOL)mainWithResult /* returns true if accepted . false if no transaction found for this */
{
    BOOL returnValue = NO;
    @autoreleasepool
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
                if(decodeOnly==NO)
                {
                    returnValue = [self handlePdu];
                }
                else
                {
                    returnValue = YES;
                }
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
                if(_verifyAcceptance == YES)
                {
                    returnValue = NO;
                }
                else
                {
                    [_tcapLayer sendPAbort:_currentRemoteTransactionId
                                     cause:UMTCAP_pAbortCause_badlyFormattedTransactionPortion
                            callingAddress:_dst
                             calledAddress:_src
                                   options:@{}];
                    returnValue = YES;
                }
            }
        }
    }
    return returnValue;
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

- (BOOL) handlePdu
{
    BOOL returnValue = NO;
    _tcapUser = [_tcapLayer tcapDefaultUser];
    _tcapVariant = TCAP_VARIANT_ITU;

    switch(_currentCommand)
    {
        case TCAP_TAG_ANSI_UNIDIRECTIONAL:
            returnValue = [self handleAnsiUnidirectional];
            break;
        case TCAP_TAG_ITU_UNIDIRECTIONAL:
            returnValue = [self handleItuUnidirectional];
            break;
        case TCAP_TAG_ANSI_QUERY_WITHOUT_PERM:
            returnValue = [self handleAnsiQueryWithoutPerm];
            break;
        case TCAP_TAG_ANSI_QUERY_WITH_PERM:
            returnValue = [self handleAnsiQueryWithPerm];
            break;
        case TCAP_TAG_ITU_BEGIN:
            returnValue = [self handleItuBegin];
            break;
        case TCAP_TAG_ANSI_RESPONSE:
            returnValue = [self handleAnsiResponse];
            break;
        case TCAP_TAG_ITU_END:
            returnValue = [self handleItuEnd];
            break;
        case TCAP_TAG_ANSI_CONVERSATION_WITH_PERM:
            returnValue = [self handleAnsiConversationWithPerm];
            break;
        case TCAP_TAG_ANSI_CONVERSATION_WITHOUT_PERM:
            returnValue = [self handleAnsiConversationWithoutPerm];
            break;
        case TCAP_TAG_ITU_CONTINUE:
            returnValue = [self handleItuContinue];
            break;
        case TCAP_TAG_ANSI_ABORT:
            returnValue = [self handleAnsiAbort];
            break;
        case TCAP_TAG_ITU_ABORT:
            returnValue = [self handleItuAbort];
            break;
        default:
            returnValue = NO;
            break;
    }
    if(_destroyTransaction)
    {
        _currentTransaction.transactionIsClosed = YES;
        [_tcapLayer removeTransaction:_currentTransaction];
    }
    return returnValue;
}

- (BOOL)handleItuUnidirectional
{
    _tcapVariant = TCAP_VARIANT_ITU;
    return [self handleUnidirectional];
}

- (BOOL)handleAnsiUnidirectional
{
    _tcapVariant = TCAP_VARIANT_ANSI;
    return [self handleUnidirectional];
}

- (BOOL)handleUnidirectional
{
    if(_tcapLayer.ssn.ssn != _dst.ssn.ssn)
    {
        return NO;
    }
    [_tcapUser tcapUnidirectionalIndication:NULL
                          tcapTransactionId:NULL
                    tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                    variant:_tcapVariant
                             callingAddress:_src
                              calledAddress:_dst
                            dialoguePortion:_dialoguePortion
                               callingLayer:_tcapLayer
                                 components:_currentComponents
                                    options:_options];
    return YES;
}

- (BOOL)handleAnsiQueryWithoutPerm
{
    _perm=NO;
    return [self handleAnsiQuery];
}

- (BOOL)handleAnsiQueryWithPerm
{
    _perm=YES;
    return [self handleAnsiQuery];
}

- (BOOL)handleAnsiQuery
{
    if(_tcapLayer.ssn.ssn != _dst.ssn.ssn)
    {
        return NO;
    }
    _tcapVariant = TCAP_VARIANT_ANSI;
    _currentTransaction = [_tcapLayer getNewIncomingTransactionForRemoteTransactionId:_currentRemoteTransactionId];
    UMTCAP_UserDialogIdentifier *userDialogId = [_tcapUser getNewUserDialogId];
    _currentTransaction.userDialogId = userDialogId;
    _destroyTransaction = NO;
    ummutex_lock(_currentTransaction.incomingLock);
    @try
    {
        [_tcapUser tcapBeginIndication:userDialogId
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
    @finally
    {
        ummutex_unlock(_currentTransaction.incomingLock);
    }
    return YES;
}

- (BOOL)handleItuBegin
{
    if(_tcapLayer.ssn.ssn != _dst.ssn.ssn)
    {
        return NO;
    }
    _tcapVariant = TCAP_VARIANT_ITU;
    _currentTransaction = [_tcapLayer getNewIncomingTransactionForRemoteTransactionId:_currentRemoteTransactionId];
    UMTCAP_UserDialogIdentifier *userDialogId = [_tcapUser getNewUserDialogId];
    _currentTransaction.userDialogId = userDialogId;
    _destroyTransaction  = NO;
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
    ummutex_lock(_currentTransaction.incomingLock);
    @try
    {
        [_tcapUser tcapBeginIndication:userDialogId
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
    @finally
    {
        ummutex_unlock(_currentTransaction.incomingLock);
    }
    return YES;
}

- (BOOL)handleAnsiResponse
{
    _tcapVariant = TCAP_VARIANT_ANSI;
    [self findTransactionAndUser];
    if(_tcapUser==NULL)
    {
        if(_verifyAcceptance==NO)
        {
            [_handlingLayer sendPAbort:_currentRemoteTransactionId
                                 cause:UMTCAP_pAbortCause_unrecognizedTransactionID
                        callingAddress:_dst
                         calledAddress:_src
                               options:@{}];
            _currentTransaction.transactionIsClosed = YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        ummutex_lock(_currentTransaction.incomingLock);
        @try
        {
            _destroyTransaction = YES;
            [_tcapUser tcapEndIndication:_currentTransaction.userDialogId
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
        @finally
        {
            /* remove transaction data */
            ummutex_unlock(_currentTransaction.incomingLock);
        }
    }
    return YES;
}

- (BOOL)handleItuEnd
{
    _tcapVariant = TCAP_VARIANT_ITU;
    [self findTransactionAndUser];
    if(_tcapUser==NULL)
    {
        if(_verifyAcceptance==NO)
        {
            [_handlingLayer sendPAbort:_currentRemoteTransactionId
                                 cause:UMTCAP_pAbortCause_unrecognizedTransactionID
                        callingAddress:_dst
                         calledAddress:_src
                               options:@{}];
            _currentTransaction.transactionIsClosed = YES;
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        ummutex_lock(_currentTransaction.incomingLock);
        @try
        {
            _destroyTransaction = YES;
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
            [_tcapUser tcapEndIndication:_currentTransaction.userDialogId
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
        @finally
        {
            ummutex_unlock(_currentTransaction.incomingLock);
        }
        return YES;
    }
}

- (BOOL)handleAnsiConversationWithPerm
{
    _perm=YES;
    return [self handleAnsiConversation];
}

- (BOOL)handleAnsiConversationWithoutPerm
{
    _perm=NO;
    return [self handleAnsiConversation];
}

- (BOOL)handleAnsiConversation
{
    _tcapVariant = TCAP_VARIANT_ANSI;
    [self findTransactionAndUser];
    if(_tcapUser==NULL)
    {
        if(_verifyAcceptance == YES)
        {
            return NO;
        }
        [_handlingLayer sendPAbort:_currentRemoteTransactionId
                             cause:UMTCAP_pAbortCause_unrecognizedTransactionID
                    callingAddress:_dst
                     calledAddress:_src
                           options:@{}];
        _currentTransaction.transactionIsClosed = YES;
    }
    else
    {
        ummutex_lock(_currentTransaction.incomingLock);
        @try
        {
            _destroyTransaction = NO;
            [_tcapUser tcapContinueIndication:_currentTransaction.userDialogId
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
        @finally
        {
            ummutex_unlock(_currentTransaction.incomingLock);
        }
    }
    return YES;
}

- (BOOL)handleItuContinue
{
    [self findTransactionAndUser];
    if(_tcapUser==NULL)
    {
        if(_verifyAcceptance == YES)
        {
            return NO;
        }
        [_handlingLayer sendPAbort:_currentRemoteTransactionId
                             cause:UMTCAP_pAbortCause_unrecognizedTransactionID
                    callingAddress:_dst
                     calledAddress:_src
                           options:@{}];
        _currentTransaction.transactionIsClosed = YES;
    }
    else
    {
        _currentTransaction.remoteTransactionId = _otid;
        _destroyTransaction = NO;
        ummutex_lock(_currentTransaction.incomingLock);
        @try
        {
            
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
                NSLog(@"DEBUG: %@",dbgTxt);
                [_tcapLayer.logFeed debugText:dbgTxt];
            }
            [_tcapUser tcapContinueIndication:_currentTransaction.userDialogId
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
        @catch(NSException *e)
        {
            NSLog(@"Exception: %@",e);
        }
        @finally
        {
            ummutex_unlock(_currentTransaction.incomingLock);
        }
    }
    return YES;
}

- (BOOL)handleAnsiAbort
{
    _tcapVariant = TCAP_VARIANT_ANSI;
    [self findTransactionAndUser];
    if(_tcapUser==NULL)
    {
        if(_verifyAcceptance == YES)
        {
            return NO;
        }
        return YES;
    }
    else
    {
        ummutex_lock(_currentTransaction.incomingLock);
        @try
        {
            _destroyTransaction = YES;
            [_tcapUser tcapUAbortIndication:_currentTransaction.userDialogId
                         tcapTransactionId:_currentTransaction.localTransactionId
                   tcapRemoteTransactionId:_currentTransaction.remoteTransactionId
                                   variant:_tcapVariant
                            callingAddress:_src
                             calledAddress:_dst
                           dialoguePortion:_dialoguePortion
                              callingLayer:_handlingLayer
                                      asn1:(UMASN1Object *)_asn1
                                   options:_options];
            ummutex_unlock(_currentTransaction.incomingLock);
        }
        @finally
        {
            ummutex_unlock(_currentTransaction.incomingLock);
        }
    }
    return YES;
}

- (BOOL)handleItuAbort
{
    _tcapVariant = TCAP_VARIANT_ANSI;
    [self findTransactionAndUser];
    if(_tcapUser==NULL)
    {
        if(_verifyAcceptance == YES)
        {
            return NO;
        }
        return YES;
    }
    ummutex_lock(_currentTransaction.incomingLock);
    @try
    {
        _destroyTransaction = YES;
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
        [_tcapUser tcapUAbortIndication:_currentTransaction.userDialogId
                      tcapTransactionId:_currentLocalTransactionId
                tcapRemoteTransactionId:_currentRemoteTransactionId
                                variant:_tcapVariant
                         callingAddress:_src
                          calledAddress:_dst
                        dialoguePortion:_dialoguePortion
                           callingLayer:_handlingLayer
                                   asn1:(UMASN1Object *)_asn1
                                options:_options];
    }
    @finally
    {
        ummutex_unlock(_currentTransaction.incomingLock);
    }
    return YES;
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

        if(component.hasGlobalOperationCode)
        {
            UMTCAP_itu_asn1_componentPDU *icomponent = (UMTCAP_itu_asn1_componentPDU *)component;
            NSData *d =  icomponent.itu_globalOperationCode.value;
            if(d.length == 1)
            {
                _currentOperationCode = *(uint8_t *)d.bytes;
            }
        }
        
        NSString *xoperationName = NULL;
        component.params = [user decodeASN1:component.params
                              operationCode:_currentOperationCode
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
        NSLog(@"Transaction ID %@ not found. lets look for alternative ones",_currentLocalTransactionId);
        NSString *instance = [_tcapLayer.tidPool findInstanceForTransaction:_currentLocalTransactionId];
        if(instance)
        {
            NSLog(@"  found one in instance %@",instance);
            UMLayerTCAP *handlingLayer = [_tcapLayer.appContext getTCAP:instance];
            _currentTransaction = [handlingLayer findTransactionByLocalTransactionId:_currentLocalTransactionId];
            _tcapUser = _currentTransaction.user;
        }
        else
        {
            NSLog(@"  also not found");
        }
    }
}

@end
