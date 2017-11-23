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
#import "UMTCAP_TransactionInvoke.h"
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
#import "UMTCAP_TransactionInvoke.h"
#import "UMTCAP_asn1.h"
#import "UMTCAP_itu_asn1_begin.h"
#import "UMTCAP_itu_asn1_invoke.h"
#import "UMTCAP_itu_asn1_returnResult.h"
#import "UMTCAP_itu_asn1_reject.h"
#import "UMTCAP_itu_asn1_returnError.h"
#import "UMTCAP_TransactionInvoke.h"
#import "UMTCAP_Variant.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_Filter.h"

@implementation UMTCAP_sccpNUnitdata

@synthesize sccpLayer;
@synthesize data;
@synthesize src;
@synthesize dst;
@synthesize options;
@synthesize currentTransaction;
@synthesize newTransaction;
@synthesize qos;
@synthesize tcapVariant;
@synthesize sccpVariant;
@synthesize asn1;
//@synthesize tcapUser;
@synthesize currentCommand;
@synthesize ansi_permission;
@synthesize ansiTransactionId;
@synthesize otid;
@synthesize dtid;
@synthesize applicationContext;
@synthesize decodeError;
@synthesize userInfo;

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
        sccpLayer = sccp;
        tcapLayer = tcap;
        data = xdata;
        src = xsrc;
        dst = xdst;
        options = xoptions;
        qos = xqos;
    }
    return self;
}

- (void)main
{
    NSUInteger pos = 0;
    BOOL decodeOnly = [options[@"decode-only"] boolValue];

    if(options)
    {
        NSMutableDictionary *o = [options mutableCopy];
        o[@"tcap-pdu"] = [data hexString];
        options = o;
    }
    else
    {
        options = @{@"tcap-pdu":[data hexString]};
    }
    @try
    {
        [self startDecodingOfPdu];
        asn1 = [[UMTCAP_asn1 alloc] initWithBerData:data atPosition:&pos context:self];
        [self endDecodingOfPdu];
    }
    @catch(NSException *ex)
    {
        NSLog(@"Exception: %@",ex);
        [self errorDecodingPdu];
        if(decodeOnly)
        {
            decodeError = [NSString stringWithFormat:@"Error while decoding: %@\r\n",ex];
        }
    }
}

- (void) startDecodingOfPdu
{
    currentCommand = -1;
    currentOperationType = -1;
    currentComponents = [[NSMutableArray alloc]init];
    currentOperationCode = UMTCAP_FILTER_OPCODE_MISSING;
}

- (void) endDecodingOfPdu
{
    //BOOL decodeOnly = [options[@"decode-only"] boolValue];
    BOOL destoryTransaction = YES;
    id<UMTCAP_UserProtocol> tcapUser = [tcapLayer tcapDefaultUser];

    tcapVariant = TCAP_VARIANT_ITU;
    BOOL perm = YES;

    [currentTransaction touch];

    UMTCAP_Filter *inboundFilter = tcapLayer.inboundFilter;
    if(inboundFilter)
    {
        UMSynchronizedSortedDictionary *oid = applicationContext.objectValue;
        NSString *appContextString = oid[@"objectIdentifier"];
        UMTCAP_FilterResult r = [inboundFilter filterPacket:currentCommand
                                         applicationContext:appContextString
                                              operationCode:currentOperationCode
                                             callingAddress:src
                                              calledAddress:dst];
        switch(r)
        {
            case UMTCAP_FilterResult_accept:
            case UMTCAP_FilterResult_continue:
                break;
            case UMTCAP_FilterResult_drop:
                return;
            case UMTCAP_FilterResult_reject:
                /* fixme: send abort here */
                return;
            case UMTCAP_FilterResult_redirect:
            {
                dst.tt.tt = inboundFilter.bypass_translation_type;
                [tcapLayer.attachedLayer sccpNUnidata:data
                                         callingLayer:tcapLayer
                                         calling:src
                                          called:dst
                                qualityOfService:qos
                                         options:options];
            }
                return;
        }
    }
    
    switch(currentCommand)
    {
        case TCAP_TAG_ANSI_UNIDIRECTIONAL:
            tcapVariant = TCAP_VARIANT_ANSI;
        case TCAP_TAG_ITU_UNIDIRECTIONAL:
        {
            [tcapUser tcapUnidirectionalIndication:NULL
                                 tcapTransactionId:NULL
                           tcapRemoteTransactionId:currentTransaction.remoteTransactionId
                                           variant:tcapVariant
                                    callingAddress:src
                                     calledAddress:dst
                                   dialoguePortion:dialoguePortion
                                      callingLayer:tcapLayer
                                        components:currentComponents
                                           options:options];
        }
            break;

        case TCAP_TAG_ANSI_QUERY_WITHOUT_PERM:
            perm=NO;
#pragma unused(perm) /* silence warning for now */
        case TCAP_TAG_ANSI_QUERY_WITH_PERM:
        {
            tcapVariant = TCAP_VARIANT_ANSI;
            currentTransaction = [tcapLayer getNewIncomingTransactionForRemoteTransactionId:ansiTransactionId];
            if(currentTransaction.user)
            {
                tcapUser = currentTransaction.user;
            }

            NSString *userDialogId = [tcapUser getNewUserDialogId];
            currentTransaction.userDialogId = userDialogId;
            destoryTransaction = NO;
                [tcapUser tcapBeginIndication:userDialogId
                            tcapTransactionId:currentTransaction.localTransactionId
                      tcapRemoteTransactionId:currentTransaction.remoteTransactionId
                                      variant:tcapVariant
                               callingAddress:src
                                calledAddress:dst
                              dialoguePortion:dialoguePortion
                                 callingLayer:tcapLayer
                                   components:currentComponents
                                      options:options];
        }
            break;

        case TCAP_TAG_ITU_BEGIN:
        {
            tcapVariant = TCAP_VARIANT_ITU;
            currentTransaction = [tcapLayer getNewIncomingTransactionForRemoteTransactionId:currentRemoteTransactionId];
            if(currentTransaction.user)
            {
                tcapUser = currentTransaction.user;
            }

            NSString *userDialogId = [tcapUser getNewUserDialogId];
            currentTransaction.userDialogId = userDialogId;
            destoryTransaction = NO;

/*
            UMTCAP_itu_asn1_begin *o = [[UMTCAP_itu_asn1_begin alloc]initWithASN1Object:asn1 context:self];
            UMTCAP_asn1_userInformation *userInfo = o.dialoguePortion.dialogRequest.user_information;
            UMTCAP_asn1_objectIdentifier *objectIdentifier = o.dialoguePortion.dialogRequest.objectIdentifier;
*/
            if(tcapLayer.logLevel <= UMLOG_DEBUG)
            {
                [self.logFeed debugText:[NSString stringWithFormat:@"itu tcapBeginIndication:\n"
                                         @"userDialogId:%@\n"
                                         @"SccpCallingAddress:%@\n"
                                         @"SccpCalledAddress:%@\n"
                                         @"localTransactionId:%@\n"
                                         @"remoteTransactionId:%@\n"
                                         @"dialoguePortion:%@\n"
                                         @"components:%@\n"
                                         @"options:%@\n",
                                         userDialogId,
                                         src,
                                         dst,
                                         currentTransaction.localTransactionId,
                                         currentTransaction.remoteTransactionId,
                                         dialoguePortion,
                                         currentComponents,
                                         options
                                         ]];
            }
            [tcapUser tcapBeginIndication:userDialogId
                        tcapTransactionId:currentTransaction.localTransactionId
                  tcapRemoteTransactionId:currentTransaction.remoteTransactionId
                                  variant:tcapVariant
                           callingAddress:src
                            calledAddress:dst
                          dialoguePortion:dialoguePortion
                             callingLayer:tcapLayer
                               components:currentComponents
                                  options:options];
        }
            break;

        
        case TCAP_TAG_ANSI_RESPONSE:
        {
            tcapVariant = TCAP_VARIANT_ANSI;

            UMLayerTCAP *otherLayer = tcapLayer;
            currentTransaction = [tcapLayer findTransactionByLocalTransactionId:currentLocalTransactionId];
            if(currentTransaction==NULL)
            {
                NSString *instance = [tcapLayer.tidPool findInstanceForTransaction:dtid];
                if(instance)
                {
                    otherLayer = [tcapLayer.appContext getTCAP:instance];
                    currentTransaction = [otherLayer findTransactionByLocalTransactionId:dtid];
                }
            }
            if(currentTransaction.user)
            {
                tcapUser = currentTransaction.user;
            }

            destoryTransaction = YES;
            [tcapUser tcapEndIndication:currentTransaction.userDialogId
                      tcapTransactionId:currentTransaction.localTransactionId
                tcapRemoteTransactionId:currentTransaction.remoteTransactionId
                                variant:tcapVariant
                         callingAddress:src
                          calledAddress:dst
                        dialoguePortion:dialoguePortion
                           callingLayer:otherLayer
                             components:currentComponents
                                options:options];
            /* remove transaction data */
        }
            break;
        case TCAP_TAG_ITU_END:
        {
            tcapVariant = TCAP_VARIANT_ITU;
            UMLayerTCAP *otherLayer = tcapLayer;
            currentTransaction = [tcapLayer findTransactionByLocalTransactionId:currentLocalTransactionId];
            if(currentTransaction==NULL)
            {
                NSString *instance = [tcapLayer.tidPool findInstanceForTransaction:dtid];
                if(instance)
                {
                    otherLayer = [tcapLayer.appContext getTCAP:instance];
                    currentTransaction = [otherLayer findTransactionByLocalTransactionId:dtid];
                }
            }
            if(currentTransaction.user)
            {
                tcapUser = currentTransaction.user;
            }
            destoryTransaction = YES;
            if(tcapLayer.logLevel <= UMLOG_DEBUG)
            {
                [self.logFeed debugText:[NSString stringWithFormat:@"itu tcapEndIndication:\n"
                                         @"userDialogId:%@\n"
                                         @"SccpCallingAddress:%@\n"
                                         @"SccpCalledAddress:%@\n"
                                         @"localTransactionId:%@\n"
                                         @"remoteTransactionId:%@\n"
                                         @"dialoguePortion:%@\n"
                                         @"components:%@\n"
                                         @"options:%@\n",
                                         currentTransaction.userDialogId,
                                         src,
                                         dst,
                                         currentTransaction.localTransactionId,
                                         currentTransaction.remoteTransactionId,
                                         dialoguePortion,
                                         currentComponents,
                                         options
                                         ]];
            }
            [tcapUser tcapEndIndication:currentTransaction.userDialogId
                      tcapTransactionId:currentTransaction.localTransactionId
                tcapRemoteTransactionId:currentTransaction.remoteTransactionId
                                variant:tcapVariant
                         callingAddress:src
                          calledAddress:dst
                        dialoguePortion:dialoguePortion
                           callingLayer:otherLayer
                             components:currentComponents
                                options:options];
            /* remove transaction data */
        }
            break;
        case TCAP_TAG_ANSI_CONVERSATION_WITH_PERM:
            perm = NO;
#pragma unused(perm) /* silence warning for now */
        case TCAP_TAG_ANSI_CONVERSATION_WITHOUT_PERM:
            tcapVariant = TCAP_VARIANT_ANSI;
        {
            UMLayerTCAP *otherLayer = tcapLayer;
            currentTransaction = [tcapLayer findTransactionByLocalTransactionId:currentLocalTransactionId];
            if(currentTransaction==NULL)
            {
                NSString *instance = [tcapLayer.tidPool findInstanceForTransaction:dtid];
                if(instance)
                {
                    otherLayer = [tcapLayer.appContext getTCAP:instance];
                    currentTransaction = [otherLayer findTransactionByLocalTransactionId:dtid];
                }
            }
            if(currentTransaction.user)
            {
                tcapUser = currentTransaction.user;
            }
            destoryTransaction = NO;
                [tcapUser tcapContinueIndication:currentTransaction.userDialogId
                               tcapTransactionId:currentTransaction.localTransactionId
                         tcapRemoteTransactionId:currentTransaction.remoteTransactionId
                                         variant:tcapVariant
                                  callingAddress:src
                                   calledAddress:dst
                                 dialoguePortion:dialoguePortion
                                    callingLayer:otherLayer
                                      components:currentComponents
                                         options:options];
        }
            break;
        case TCAP_TAG_ITU_CONTINUE:
        {
            UMLayerTCAP *otherLayer = tcapLayer;
            currentTransaction = [tcapLayer findTransactionByLocalTransactionId:currentLocalTransactionId];
            if(currentTransaction==NULL)
            {
                NSString *instance = [tcapLayer.tidPool findInstanceForTransaction:dtid];
                if(instance)
                {
                    otherLayer = [tcapLayer.appContext getTCAP:instance];
                    currentTransaction = [otherLayer findTransactionByLocalTransactionId:dtid];
                }
            }

            if(currentTransaction.user)
            {
                tcapUser = currentTransaction.user;
            }
            currentTransaction.remoteTransactionId = otid;
            destoryTransaction = NO;
            if(tcapLayer.logLevel <= UMLOG_DEBUG)
            {
                [self.logFeed debugText:[NSString stringWithFormat:@"itu tcapContinueIndication:\n"
                                         @"userDialogId:%@\n"
                                         @"SccpCallingAddress:%@\n"
                                         @"SccpCalledAddress:%@\n"
                                         @"localTransactionId:%@\n"
                                         @"remoteTransactionId:%@\n"
                                         @"dialoguePortion:%@\n"
                                         @"components:%@\n"
                                         @"options:%@\n",
                                         currentTransaction.userDialogId,
                                         src,
                                         dst,
                                         currentTransaction.localTransactionId,
                                         currentTransaction.remoteTransactionId,
                                         dialoguePortion,
                                         currentComponents,
                                         options
                                         ]];
            }
            [tcapUser tcapContinueIndication:currentTransaction.userDialogId
                               tcapTransactionId:currentTransaction.localTransactionId
                         tcapRemoteTransactionId:currentTransaction.remoteTransactionId
                                         variant:tcapVariant
                                  callingAddress:src
                                   calledAddress:dst
                                 dialoguePortion:dialoguePortion
                                    callingLayer:otherLayer
                                      components:currentComponents
                                         options:options];
        }
            break;
            
            
        case TCAP_TAG_ANSI_ABORT:
            tcapVariant = TCAP_VARIANT_ANSI;
        {
            UMLayerTCAP *otherLayer = tcapLayer;

            currentTransaction = [tcapLayer findTransactionByLocalTransactionId:currentRemoteTransactionId];
            if(currentTransaction==NULL)
            {
                NSString *instance = [tcapLayer.tidPool findInstanceForTransaction:dtid];
                if(instance)
                {
                    otherLayer = [tcapLayer.appContext getTCAP:instance];
                    currentTransaction = [otherLayer findTransactionByLocalTransactionId:dtid];
                }
            }
            if(currentTransaction.user)
            {
                tcapUser = currentTransaction.user;
            }
            destoryTransaction = YES;
                [tcapUser tcapUAbortIndication:currentTransaction.userDialogId
                             tcapTransactionId:currentTransaction.localTransactionId
                       tcapRemoteTransactionId:currentTransaction.remoteTransactionId
                                       variant:tcapVariant
                                callingAddress:src
                                 calledAddress:dst
                               dialoguePortion:dialoguePortion
                                  callingLayer:otherLayer
                                          asn1:(UMASN1Object *)asn1
                                       options:options];
        }
            break;
        case TCAP_TAG_ITU_ABORT:
        {
            UMLayerTCAP *otherLayer = tcapLayer;
            currentTransaction = [tcapLayer findTransactionByLocalTransactionId:currentLocalTransactionId];
            if(currentTransaction==NULL)
            {
                NSString *instance = [tcapLayer.tidPool findInstanceForTransaction:dtid];
                if(instance)
                {
                    otherLayer = [tcapLayer.appContext getTCAP:instance];
                    currentTransaction = [otherLayer findTransactionByLocalTransactionId:dtid];
                }
            }
            if(currentTransaction.user)
            {
                tcapUser = currentTransaction.user;
            }
            destoryTransaction = YES;
            if(tcapLayer.logLevel <= UMLOG_DEBUG)
            {
                [self.logFeed debugText:[NSString stringWithFormat:@"itu tcapUAbortIndication:\n"
                                         @"userDialogId:%@\n"
                                         @"SccpCallingAddress:%@\n"
                                         @"SccpCalledAddress:%@\n"
                                         @"localTransactionId:%@\n"
                                         @"remoteTransactionId:%@\n"
                                         @"dialoguePortion:%@\n"
                                         @"components:%@\n"
                                         @"options:%@\n",
                                         currentTransaction.userDialogId,
                                         src,
                                         dst,
                                         currentTransaction.localTransactionId,
                                         currentTransaction.remoteTransactionId,
                                         dialoguePortion,
                                         currentComponents,
                                         options
                                         ]];
            }
            [tcapUser tcapUAbortIndication:currentTransaction.userDialogId
                         tcapTransactionId:currentLocalTransactionId
                   tcapRemoteTransactionId:currentRemoteTransactionId
                                   variant:tcapVariant
                            callingAddress:src
                             calledAddress:dst
                           dialoguePortion:dialoguePortion
                              callingLayer:otherLayer
                                      asn1:(UMASN1Object *)asn1
                                   options:options
             ];
        }
        default:
            break;
            
    }
    if(destoryTransaction)
    {
        [tcapLayer removeTransaction:currentTransaction];
    }
}


- (void)errorDecodingPdu
{
}

- (void)handleLocalTransactionId:(NSString *)xotid
{
    currentLocalTransactionId = xotid;
}
- (void)handleRemoteTransactionId:(NSString *)xotid
{
    currentRemoteTransactionId = xotid;
}

- (void)handleAnsiTransactionId:(NSString *)xdtid
{
    currentLocalTransactionId = xdtid;
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
    currentOperationCode = component.operationCode;
    id<UMTCAP_UserProtocol> user = [tcapLayer getUserForOperation:currentOperationCode];

    if(user)
    {
        switch(component.asn1_tag.tagNumber)
        {
            case TCAP_ITU_COMPONENT_INVOKE:
            case TCAP_ANSI_COMPONENT_INVOKE_LAST:
            case TCAP_ANSI_COMPONENT_INVOKE_NOT_LAST:
                component.operationType = UMTCAP_Operation_Request;
                currentOperationType = UMTCAP_Operation_Request;
                currentOperationCode = component.operationCode;
                break;
            case TCAP_ITU_COMPONENT_RETURN_RESULT_LAST:
            case TCAP_ITU_COMPONENT_RETURN_RESULT_NOT_LAST:
            case TCAP_ANSI_COMPONENT_RETURN_RESULT_LAST:
            case TCAP_ANSI_COMPONENT_RETURN_RESULT_NOT_LAST:
                component.operationType = UMTCAP_Operation_Response;
                currentOperationType = UMTCAP_Operation_Response;
                currentOperationCode = component.operationCode;
                break;

            case TCAP_ITU_COMPONENT_RETURN_ERROR:
            case TCAP_ANSI_COMPONENT_RETURN_ERROR:
                component.operationType = UMTCAP_Operation_Error;
                currentOperationType = UMTCAP_Operation_Error;
                currentOperationCode = component.operationCode;
                break;

            case TCAP_ITU_COMPONENT_REJECT:
            case TCAP_ANSI_COMPONENT_REJECT:
                component.operationType = UMTCAP_Operation_Reject;
                currentOperationType = UMTCAP_Operation_Reject;
                currentOperationCode = component.operationCode;
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
    [currentComponents addObject:component];
}

- (void)handleItuDialogue:(UMTCAP_itu_asn1_dialoguePortion *)dp
{
    dialoguePortion = dp;
    if(dp.dialogRequest)
    {
        dialogProtocolVersion = dp.dialogRequest.protocolVersion;
        applicationContext = dp.dialogRequest.objectIdentifier;
        userInfo =  dp.dialogRequest.user_information;
    }
    else if(dp.dialogResponse)
    {
        dialogProtocolVersion = dp.dialogResponse.protocolVersion;
        userInfo = dp.dialogResponse.user_information;
        applicationContext = dp.dialogResponse.objectIdentifier;
    }
}

- (void)handleAnsiUniTransactionPDU:(UMTCAP_ansi_asn1_uniTransactionPDU *)i
{
    unidirectional = YES;
}

- (void)handleItuBegin:(UMTCAP_itu_asn1_begin *)beginPdu
{
    UMTCAP_Transaction *t = [tcapLayer getNewIncomingTransactionForRemoteTransactionId:beginPdu.otid.transactionId];
    t.tcapVariant = TCAP_VARIANT_ITU;
    t.remoteTransactionId = beginPdu.otid.transactionId;
    t.incoming = YES;
    currentTransaction = t;
    
}
/*
- (void)handleItuInvoke:(UMTCAP_itu_asn1_invoke *)inv
{
    UMTCAP_TransactionInvoke *tInv = [[UMTCAP_TransactionInvoke alloc]init];
    tInv.tcapVariant = TCAP_VARIANT_ITU;
    tInv.transaction = currentTransaction;
    tInv.invokeId = inv.invokeId;
    tInv.started = [NSDate date];
    tInv.timeOutTime = [NSDate dateWithTimeIntervalSinceNow:tcapLayer.invokeTimeout];
    tInv.pdu =inv;
    [self handleInvoke:tInv];
}
*/
- (void)handleItuReturnError:(UMTCAP_itu_asn1_returnError *)i
{
    currentOperationCode = i.operationCode;
    if(currentTransaction.user==NULL)
    {
        currentTransaction.user = [tcapLayer getUserForOperation:currentOperationCode];
    }
    
    if(currentTransaction.user)
    {
        NSString *xoperationName;
        i.params = [currentTransaction.user decodeASN1:i.params
                                         operationCode:i.operationCode
                                         operationType:UMTCAP_Operation_Error
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
    user = currentTransaction.user;
    
    currentOperationCode = i.operationCode;
    if(user==NULL)
    {
        user = [tcapLayer getUserForOperation:currentOperationCode];
        currentTransaction.user  = user;
    }
    
    if(user)
    {
        NSString *xoperationName;
        i.params = [user decodeASN1:i.params
                      operationCode:i.operationCode
                      operationType:UMTCAP_Operation_Response
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
    if(currentTransaction.user==NULL)
    {
        currentTransaction.user = [tcapLayer getUserForOperation:currentOperationCode];
    }
    
    if(currentTransaction.user)
    {
        NSString *xoperationName;
        i.params = [currentTransaction.user decodeASN1:i.params
                                         operationCode:i.operationCode
                                         operationType:UMTCAP_Operation_Reject
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
    return currentOperationCode;
}

- (UMTCAP_Operation)operationType
{
    return currentOperationType;
}

- (void)setOperationType:(UMTCAP_Operation)op
{
    currentOperationType = op;
}

- (NSString *) errorCodeToErrorString:(int)err
{
    if(err==1)
    {
        return @"unknownSubscriber";
    }
    if(currentTransaction.user==NULL)
    {
        currentTransaction.user = [tcapLayer getUserForOperation:currentOperationCode];
    }

    if(currentTransaction.user)
    {
        return [currentTransaction.user decodeError:err ];
    }
    return NULL;
}

@end
