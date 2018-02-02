 //
//  UMLayerTCAP.m
//  ulibtcap
//
//  Created by Andreas Fink on 01/07/15.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMLayerTCAP.h"
#import "UMTCAP_all_tasks.h"
#import "UMTCAP_Transaction.h"
#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_itu_asn1_invoke.h"
#import "UMTCAP_ansi_asn1_invoke.h"
#import "UMTCAP_itu_asn1_returnResult.h"
#import "UMTCAP_ansi_asn1_returnResult.h"
#import "UMTCAP_itu_asn1_returnError.h"
#import "UMTCAP_ansi_asn1_returnError.h"

#import "UMTCAP_continue.h"
#import "UMTCAP_ansi_continue.h"
#import "UMTCAP_itu_continue.h"

#import "UMTCAP_end.h"
#import "UMTCAP_ansi_response.h"
#import "UMTCAP_itu_end.h"
#import "UMTCAP_ansi_end.h"


#import "UMTCAP_abort.h"
#import "UMTCAP_itu_abort.h"
#import "UMTCAP_ansi_abort.h"


#import "UMTCAP_Transaction.h"
#import <ulibgt/ulibgt.h>
#import <ulibsccp/ulibsccp.h>

#import "UMTCAP_begin.h"
#import "UMTCAP_ansi_begin.h"
#import "UMTCAP_itu_begin.h"
#import "UMTCAP_sccpNUnitdata.h"
#import "UMTCAP_sccpNNotice.h"
#import "UMLayerTCAPApplicationContextProtocol.h"
#import "UMTCAP_HousekeepingTask.h"
#import "UMTCAP_TimeoutTask.h"
#import "UMTCAP_TransactionIdPool.h"
#import "UMTCAP_Filter.h"

@implementation UMLayerTCAP

@synthesize tcapVariant;
@synthesize tcapDefaultUser;
@synthesize tcapUserByOperation;

@synthesize attachTo;
@synthesize attachedLayer;
@synthesize ssn;

-(UMMTP3Variant) variant
{
    return attachedLayer.variant;
}

- (void)genericInitialisation
{
    transactionsByLocalTransactionId = [[UMSynchronizedDictionary alloc]init];
    tcapUserByOperation = [[UMSynchronizedDictionary alloc]init];
    _transactionTimeoutInSeconds = 60.0; /* default timeout */
    _housekeeping_lock = [[UMMutex alloc]init];
    _houseKeepingTimerRun = [[UMAtomicDate alloc]init];
}

- (UMLayerTCAP *)init
{
    self = [super init];
    if(self)
    {
        [self genericInitialisation];
    }
    return self;
}

- (UMLayerTCAP *)initWithTaskQueueMulti:(UMTaskQueueMulti *)tq tidPool:(id<UMTCAP_TransactionIdPoolProtocol>)tidPool
{
    self = [super initWithTaskQueueMulti:tq];
    if(self)
    {
        [self genericInitialisation];
        _tidPool = tidPool;
    }
    return self;
}

- (UMLayerTCAP *)initWithTaskQueueMulti:(UMTaskQueueMulti *)tq
{
    self = [super initWithTaskQueueMulti:tq];
    if(self)
    {
        [self genericInitialisation];
        _tidPool = [[UMTCAP_TransactionIdPool alloc]initWithPrefabricatedIds:100000];
    }
    return self;
}

- (void)sccpNUnitdata:(NSData *)data
         callingLayer:(UMLayerSCCP *)sccpLayer
              calling:(SccpAddress *)src
               called:(SccpAddress *)dst
     qualityOfService:(int)qos
              options:(NSDictionary *)options;
{
    NSData *rawMtp3 = options[@"mtp3-pdu"];
    if(data.length < 3)
    {
        [sccpLayer.mtp3.problematicPacketDumper logRawPacket:rawMtp3];
        return;
    }

    const uint8_t *bytes = data.bytes;
    uint8_t tag = bytes[0];
    UMTCAP_sccpNUnitdata *task = [UMTCAP_sccpNUnitdata alloc];
    
    if( ((tag>>6) & 0x3) == UMASN1Class_Private)
    {
        task.tcapVariant = TCAP_VARIANT_ANSI;
    }
    else
    {
        task.tcapVariant = TCAP_VARIANT_ITU;
    }
    task.sccpVariant = sccpLayer.sccpVariant;

    if(logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"sccpNUnidata:\n"
                                 @"SccpCallingAddress:%@\n"
                                 @"SccpCalledAddress:%@\n"
                                 @"PDU:%@\n",
                                 src,
                                 dst,
                                 [data hexString]
                                 ]];
    }
    task = [task initForTcap:self
                        sccp:sccpLayer
                    userData:data
                     calling:src
                      called:dst
            qualityOfService:qos
                     options:options];
    [self queueFromLower:task];
}

- (void)sccpNNotice:(NSData *)data
       callingLayer:(UMLayerSCCP *)sccpLayer
            calling:(SccpAddress *)src
             called:(SccpAddress *)dst
             reason:(int)reason
            options:(NSDictionary *)options
{
    if(data.length < 3)
    {
        return;
    }
    
    const uint8_t *bytes = data.bytes;
    uint8_t tag = bytes[0];
    UMTCAP_sccpNNotice *task = [UMTCAP_sccpNNotice alloc];
    
    if( ((tag>>6) & 0x3) == UMASN1Class_Private)
    {
        task.tcapVariant = TCAP_VARIANT_ANSI;
    }
    else
    {
        task.tcapVariant = TCAP_VARIANT_ITU;
    }
    task.sccpVariant = sccpLayer.sccpVariant;
    
    if(logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"sccpNNotice:\n"
                                 @"SccpCallingAddress:%@\n"
                                 @"SccpCalledAddress:%@\n"
                                 @"PDU:%@\n"
                                 @"Reason:%d",
                                 src,
                                 dst,
                                 [data hexString],
                                 reason
                                 ]];
    }
    task = [task initForTcap:self
                        sccp:sccpLayer
                    userData:data
                     calling:src
                      called:dst
                      reason:reason
                     options:options];
    [self queueFromLower:task];
}


/*****/

/* Dialog Handling primmitives */

- (void)tcapUnidirectionalRequest:(NSString *)tcapTransactionId
                     userDialogId:(UMTCAP_UserDialogIdentifier *)userDialogId
                          variant:(UMTCAP_Variant)variant
                             user:(id<UMTCAP_UserProtocol>)user
                   callingAddress:(SccpAddress *)src
                    calledAddress:(SccpAddress *)dst
                  dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                       components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                          options:(NSDictionary *)options
{
    if(variant != TCAP_VARIANT_DEFAULT)
    {
        tcapVariant = variant;
    }
    if(logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"%@ tcapUnidirectionalRequest:\n"
                                 @"userDialogId:%@\n"
                                 @"transactionId:%@\n"
                                 @"SccpCallingAddress:%@\n"
                                 @"SccpCalledAddress:%@\n"
                                 @"dialoguePortion:%@\n"
                                 @"components:%@\n"
                                 @"options:%@\n",
                                 ((variant == TCAP_VARIANT_ITU) ? @"itu" : @"ansi"),
                                 userDialogId.description,
                                 tcapTransactionId,
                                 src,
                                 dst,
                                 xdialoguePortion,
                                 components,
                                 options
                                 ]];
    }
    /* FIXME: to be done */
}


- (void)tcapBeginRequest:(NSString *)tcapTransactionId
            userDialogId:(UMTCAP_UserDialogIdentifier *)userDialogId
                 variant:(UMTCAP_Variant)variant
                    user:(id<UMTCAP_UserProtocol>)user
          callingAddress:(SccpAddress *)src
           calledAddress:(SccpAddress *)dst
         dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
              components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                 options:(NSDictionary *)options
{
    if(variant == TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }

    UMTCAP_begin *begin;
    
    if(logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"%@ tcapBeginReq:\n"
                                 @"userDialogId:%@\n"
                                 @"transactionId:%@\n"
                                 @"SccpCallingAddress:%@\n"
                                 @"SccpCalledAddress:%@\n"
                                 @"dialoguePortion:%@\n"
                                 @"components:%@\n"
                                 @"options:%@\n",
                                 ((variant == TCAP_VARIANT_ITU) ? @"itu" : @"ansi"),
                                 userDialogId.description,
                                 tcapTransactionId,
                                 src,
                                 dst,
                                 xdialoguePortion,
                                 components,
                                 options
                                 ]];
    }
    if(variant ==TCAP_VARIANT_ITU)
    {
        begin = [[UMTCAP_itu_begin alloc]initForTcap:self
                                       transactionId:tcapTransactionId
                                        userDialogId:userDialogId
                                             variant:variant
                                                user:user
                                      callingAddress:src
                                       calledAddress:dst
                                     dialoguePortion:xdialoguePortion
                                          components:components
                                             options:options];
    }
    else if(variant ==TCAP_VARIANT_ANSI)
    {
        begin = [[UMTCAP_ansi_begin alloc]initForTcap:self
                                        transactionId:tcapTransactionId
                                         userDialogId:userDialogId
                                              variant:variant
                                                 user:user
                                       callingAddress:src
                                        calledAddress:dst
                                      dialoguePortion:xdialoguePortion
                                           components:components
                                              options:options];

    }
    [self queueFromUpper:begin];
}



- (void)tcapContinueRequest:(NSString *)tcapTransactionId
               userDialogId:(UMTCAP_UserDialogIdentifier *)userDialogId
                    variant:(UMTCAP_Variant)variant
                       user:(id<UMTCAP_UserProtocol>)user
             callingAddress:(SccpAddress *)src
              calledAddress:(SccpAddress *)dst
            dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                 components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                    options:(NSDictionary *)options
{
    if(variant == TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }
    UMTCAP_Transaction *transaction = [self findTransactionByLocalTransactionId:tcapTransactionId];
    if(transaction == NULL)
    {
        NSString *s = [NSString stringWithFormat:@"tcapContinueRequest with unknown transaction ID '%@'",tcapTransactionId];
        @throw([NSException exceptionWithName:@"API_EXCEPTION" reason:s userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    [transaction touch];
    UMTCAP_continue *continueRequest = NULL;
    
    if(logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"%@ tcapContinueReq:\n"
                                 @"userDialogId:%@\n"
                                 @"transactionId:%@\n"
                                 @"SccpCallingAddress:%@\n"
                                 @"SccpCalledAddress:%@\n"
                                 @"dialoguePortion:%@\n"
                                 @"components:%@\n"
                                 @"options:%@\n",
                                 ((variant == TCAP_VARIANT_ITU) ? @"itu" : @"ansi"),
                                 userDialogId.description,
                                 tcapTransactionId,
                                 src,
                                 dst,
                                 xdialoguePortion,
                                 components,
                                 options
                                 ]];
    }
    if(variant ==TCAP_VARIANT_ITU)
    {
        continueRequest = [[UMTCAP_itu_continue alloc]initForTcap:self
                                                    transactionId:tcapTransactionId
                                                     userDialogId:userDialogId
                                                          variant:variant
                                                             user:user
                                                   callingAddress:src
                                                    calledAddress:dst
                                                  dialoguePortion:xdialoguePortion
                                                       components:components
                                                          options:options];
        
    }
    else if(variant ==TCAP_VARIANT_ANSI)
    {
        continueRequest = [[UMTCAP_ansi_continue alloc]initForTcap:self
                                                     transactionId:tcapTransactionId
                                                      userDialogId:userDialogId
                                                           variant:variant
                                                              user:user
                                                    callingAddress:src
                                                     calledAddress:dst
                                                   dialoguePortion:xdialoguePortion
                                                        components:components
                                                           options:options];
        
    }
    [self queueFromUpper:continueRequest];
}

- (void)tcapEndRequest:(NSString *)tcapTransactionId
          userDialogId:(UMTCAP_UserDialogIdentifier *)userDialogId
               variant:(UMTCAP_Variant)variant
                  user:(id<UMTCAP_UserProtocol>)user
        callingAddress:(SccpAddress *)src
         calledAddress:(SccpAddress *)dst
       dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
            components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
               options:(NSDictionary *)options
{
    if(variant == TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }
    UMTCAP_Transaction *transaction = [self findTransactionByLocalTransactionId:tcapTransactionId];
    if(transaction == NULL)
    {
        NSString *s = [NSString stringWithFormat:@"tcapEndRequest with unknown transaction ID '%@'",tcapTransactionId];
        NSLog(@"%@",s);
        return;
//        @throw([NSException exceptionWithName:@"API_EXCEPTION" reason:s userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }

    [transaction touch];
    UMTCAP_end *endRequest;
    
    if(logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"%@ tcapEndReq:\n"
                                 @"userDialogId:%@\n"
                                 @"SccpCallingAddress:%@\n"
                                 @"SccpCalledAddress:%@\n"
                                 @"localTransactionId:%@\n"
                                 @"dialoguePortion:%@\n"
                                 @"components:%@\n"
                                 @"options:%@\n",
                                 ((variant == TCAP_VARIANT_ITU) ? @"itu" : @"ansi"),
                                 userDialogId.description,
                                 src,
                                 dst,
                                 tcapTransactionId,
                                 xdialoguePortion,
                                 components,
                                 options
                                 ]];
    }
    if(variant ==TCAP_VARIANT_ITU)
    {
        endRequest = [[UMTCAP_itu_end alloc]initForTcap:self
                                          transactionId:tcapTransactionId
                                           userDialogId:userDialogId
                                                variant:variant
                                                   user:user
                                         callingAddress:src
                                          calledAddress:dst
                                        dialoguePortion:xdialoguePortion
                                             components:components
                                             permission:transaction.withPermission
                                                options:options];
    }
    else if(variant ==TCAP_VARIANT_ANSI)
    {
        endRequest = [[UMTCAP_ansi_end alloc]initForTcap:self
                                           transactionId:tcapTransactionId
                                            userDialogId:userDialogId
                                                 variant:variant
                                                    user:user
                                          callingAddress:src
                                           calledAddress:dst
                                         dialoguePortion:xdialoguePortion
                                              components:components
                                              permission:transaction.withPermission
                                                 options:options];

    }
    [self queueFromUpper:endRequest];
}

- (void)tcapUAbortRequest:(NSString *)tcapTransactionId
             userDialogId:(UMTCAP_UserDialogIdentifier *)userDialogId
                  variant:(UMTCAP_Variant)variant
                     user:(id<UMTCAP_UserProtocol>)user
           callingAddress:(SccpAddress *)src
            calledAddress:(SccpAddress *)dst
                    cause:(int64_t)cause
          dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
               components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                  options:(NSDictionary *)options
{
    if(variant==TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }
    if(logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"%@ tcapUAbortReq:\n"
                                 @"transactionId:%@\n"
                                 @"userDialogId:%@\n"
                                 @"SccpCallingAddress:%@\n"
                                 @"SccpCalledAddress:%@\n"
                                 @"dialoguePortion:%@\n"
                                 @"components:%@\n"
                                 @"options:%@\n",
                                 ((variant == TCAP_VARIANT_ITU) ? @"itu" : @"ansi"),
                                 tcapTransactionId,
                                 userDialogId,
                                 src,
                                 dst,
                                 xdialoguePortion,
                                 components,
                                 options
                                 ]];
    }

    UMTCAP_Transaction *transaction = [self findTransactionByLocalTransactionId:tcapTransactionId];
    if(transaction == NULL)
    {
        NSString *s = [NSString stringWithFormat:@"tcapUAbortRequest with unknown transaction ID '%@'",tcapTransactionId];
        @throw([NSException exceptionWithName:@"API_EXCEPTION" reason:s userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }

    [transaction touch];
    UMTCAP_abort *abortRequest;

    if(variant ==TCAP_VARIANT_ITU)
    {
        abortRequest = [[UMTCAP_itu_abort alloc]initForTcap:self
                                              transactionId:tcapTransactionId
                                               userDialogId:userDialogId
                                                    variant:variant
                                                       user:user
                                             callingAddress:src
                                              calledAddress:dst
                                                      cause:cause
                                              dialogPortion:xdialoguePortion
                                                    options:options];


    }
    else if(variant ==TCAP_VARIANT_ANSI)
    {
        abortRequest = [[UMTCAP_ansi_abort alloc]initForTcap:self
                                               transactionId:tcapTransactionId
                                                userDialogId:userDialogId
                                                     variant:variant
                                                        user:user
                                              callingAddress:src
                                               calledAddress:dst
                                                       cause:cause
                                               dialogPortion:xdialoguePortion
                                                     options:options];

    }
    [self queueFromUpper:abortRequest];
}


- (void)tcapPAbortRequest:(NSString *)tcapTransactionId
                  variant:(UMTCAP_Variant)variant
           callingAddress:(SccpAddress *)src
            calledAddress:(SccpAddress *)dst
                    cause:(int64_t)cause
                  options:(NSDictionary *)options
{
    if(variant==TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }
    if(logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"%@ tcapPAbortReq:\n"
                                 @"transactionId:%@\n"
                                 @"SccpCallingAddress:%@\n"
                                 @"SccpCalledAddress:%@\n"
                                 @"cause:%lld\n"
                                 @"options:%@\n",
                                 ((variant == TCAP_VARIANT_ITU) ? @"itu" : @"ansi"),
                                 tcapTransactionId,
                                 src,
                                 dst,
                                 (long long)cause,
                                 options
                                 ]];
    }

    UMTCAP_Transaction *transaction = [self findTransactionByLocalTransactionId:tcapTransactionId];
    if(transaction == NULL)
    {
        NSString *s = [NSString stringWithFormat:@"tcapUAbortRequest with unknown transaction ID '%@'",tcapTransactionId];
        @throw([NSException exceptionWithName:@"API_EXCEPTION" reason:s userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }

    [transaction touch];
    UMTCAP_abort *abortRequest;

    if(variant ==TCAP_VARIANT_ITU)
    {
        abortRequest = [[UMTCAP_itu_abort alloc]initForTcap:self
                                              transactionId:tcapTransactionId
                                               userDialogId:NULL
                                                    variant:variant
                                                       user:NULL
                                             callingAddress:src
                                              calledAddress:dst
                                                      cause:cause
                                              dialogPortion:NULL
                                                    options:options];


    }
    else if(variant ==TCAP_VARIANT_ANSI)
    {
        abortRequest = [[UMTCAP_ansi_abort alloc]initForTcap:self
                                               transactionId:tcapTransactionId
                                                userDialogId:NULL
                                                     variant:variant
                                                        user:NULL
                                              callingAddress:src
                                               calledAddress:dst
                                                       cause:cause
                                               dialogPortion:NULL
                                                     options:options];

    }
    [self queueFromUpper:abortRequest];
}

- (void)setGenericComponents:(UMTCAP_generic_asn1_componentPDU *)pdu
                      params:(UMASN1Object *)params
                     variant:(UMTCAP_Variant)variant
                    invokeId:(int64_t)invId
                    linkedId:(int64_t)lnkId
                 useLinkedId:(BOOL)useLinkedId
                 opCodeValue:(int64_t)op
                opCodeFamily:(int64_t)opf
              opCodeNational:(BOOL)nat
                      isLast:(BOOL)last
{
    [pdu setInvokeId:invId];
    if(useLinkedId)
    {
        pdu.linkedId = lnkId;
    }
    else
    {
        [pdu clearLinkedId];
    }
    pdu.operationCode = op;
    pdu.operationCodeFamily = opf;
    pdu.operationNational = nat;
    pdu.params = params;
    pdu.isLast = last;
}


/* component handling primitives */
- (UMASN1Object *)tcapInvokeNotLast:(UMASN1Object *)params
                            variant:(UMTCAP_Variant)variant
                           invokeId:(int64_t)invId
                           linkedId:(int64_t)lnkId
                        useLinkedId:(BOOL)useLinkedId
                        opCodeValue:(int64_t)op
                       opCodeFamily:(int64_t)opf
                     opCodeNational:(BOOL)nat
{
    if(variant==TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }

    return [self tcapInvoke:params
                    variant:variant
                   invokeId:invId
                   linkedId:lnkId
                useLinkedId:useLinkedId
                opCodeValue:op
               opCodeFamily:opf
             opCodeNational:nat
                       last:NO];
}

- (UMASN1Object *)tcapInvokeLast:(UMASN1Object *)params
                         variant:(UMTCAP_Variant)variant
                           invokeId:(int64_t)invId
                           linkedId:(int64_t)lnkId
                        useLinkedId:(BOOL)useLinkedId
                     opCodeValue:(int64_t)op
                    opCodeFamily:(int64_t)opf
                  opCodeNational:(BOOL)nat
{
    if(variant==TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }

    return [self tcapInvoke:params
                    variant:variant
                   invokeId:invId
                   linkedId:lnkId
                useLinkedId:useLinkedId
                opCodeValue:op
               opCodeFamily:opf
             opCodeNational:nat
                       last:YES];
}


- (UMASN1Object *)tcapInvoke:(UMASN1Object *)params
                     variant:(UMTCAP_Variant)variant
                    invokeId:(int64_t)invId
                    linkedId:(int64_t)lnkId
                 useLinkedId:(BOOL)useLinkedId
                 opCodeValue:(int64_t)op
                opCodeFamily:(int64_t)opf
              opCodeNational:(BOOL)nat
                        last:(BOOL)last
{
    if(variant == TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }

    UMTCAP_generic_asn1_componentPDU *inv;
    if(variant == TCAP_VARIANT_ITU)
    {
        inv = [[UMTCAP_itu_asn1_invoke alloc]init];
    }
    else if(variant == TCAP_VARIANT_ANSI)
    {
        inv = [[UMTCAP_ansi_asn1_invoke alloc]init];
    }
    else
    {
        @throw([NSException exceptionWithName:@"TCAP_VARIANT_UNKNOWN" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }

    [self setGenericComponents:inv
                        params: params
                       variant:variant
                      invokeId:invId
                      linkedId:lnkId
                   useLinkedId:useLinkedId
                   opCodeValue:op
                  opCodeFamily:opf
                opCodeNational:nat
                        isLast:last];
    return inv;
}

- (UMASN1Object *)tcapResultLastRequest:(UMASN1Object *)params
                                variant:(UMTCAP_Variant)variant
                               invokeId:(int64_t)invId
                               linkedId:(int64_t)lnkId
                            useLinkedId:(BOOL)useLinkedId
                            opCodeValue:(int64_t)op
                           opCodeFamily:(int64_t)opf
                         opCodeNational:(BOOL)nat
{

    if(self.logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"tcapResultLastRequest:\n"
                                 @"params:%@\n"
                                 @"invokeId:%lld\n"
                                 @"linkedId:%lld\n"
                                 @"opcode:%lld\n",
                                 [params.objectValue jsonString],
                                 (long long)invId,
                                 (long long)lnkId,
                                 (long long)op]];
    }

    if(variant == TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }

    UMTCAP_generic_asn1_componentPDU *rrl;
    if(variant == TCAP_VARIANT_ITU)
    {
        rrl = [[UMTCAP_itu_asn1_returnResult alloc]init];
    }
    else if(variant == TCAP_VARIANT_ANSI)
    {
        rrl = [[UMTCAP_ansi_asn1_returnResult alloc]init];
    }
    else
    {
        @throw([NSException exceptionWithName:@"TCAP_VARIANT_UNKNOWN" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    
    [self setGenericComponents:rrl
                        params:params
                       variant:variant
                      invokeId:invId
                      linkedId:lnkId
                   useLinkedId:useLinkedId
                   opCodeValue:op
                  opCodeFamily:opf
                opCodeNational:nat
                        isLast:YES];
    return rrl;
}


- (UMASN1Object *)tcapResultNotLastRequest:(UMASN1Object *)params
                                   variant:(UMTCAP_Variant)variant
                                  invokeId:(int64_t)invId
                                  linkedId:(int64_t)lnkId
                               useLinkedId:(BOOL)useLinkedId
                               opCodeValue:(int64_t)op
                              opCodeFamily:(int64_t)opf
                            opCodeNational:(BOOL)nat;
{
    if(variant == TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }

    UMTCAP_generic_asn1_componentPDU *rrl;
    if(variant == TCAP_VARIANT_ITU)
    {
        rrl = [[UMTCAP_itu_asn1_returnResult alloc]init];
    }
    else if(variant == TCAP_VARIANT_ANSI)
    {
        rrl = [[UMTCAP_ansi_asn1_returnResult alloc]init];
    }
    else
    {
        @throw([NSException exceptionWithName:@"TCAP_VARIANT_UNKNOWN" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }

    [self setGenericComponents:rrl
                        params:params
                       variant:variant
                      invokeId:invId
                      linkedId:lnkId
                   useLinkedId:useLinkedId
                   opCodeValue:op
                  opCodeFamily:opf
                opCodeNational:nat
                        isLast:NO];
    return rrl;
}

- (UMASN1Object *)tcapUErrorRequest:(UMASN1Object *)params
                            variant:(UMTCAP_Variant)variant
                           invokeId:(int64_t)invId
                          errorCode:(int64_t)errCode
                     isPrivateError:(BOOL)priv;
{
    if(variant == TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }

    UMTCAP_generic_asn1_componentPDU *err;
    if(variant == TCAP_VARIANT_ITU)
    {
        err = [[UMTCAP_itu_asn1_returnError alloc]init];
    }
    else if(variant == TCAP_VARIANT_ANSI)
    {
        err = [[UMTCAP_itu_asn1_returnError alloc]init];
    }
    else
    {
        @throw([NSException exceptionWithName:@"TCAP_VARIANT_UNKNOWN" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    
    [self setGenericComponents:err
                        params: params
                       variant:variant
                      invokeId:invId
                      linkedId:0 /* not used */
                   useLinkedId:NO /* not used */
                   opCodeValue:0 /* not used */
                  opCodeFamily:0 /* not used */
                opCodeNational:NO /* not used */
                        isLast:NO]; /* not used */
    err.errorCode = errCode;
    err.errorCodePrivate = priv;
    return err;
}

- (UMASN1Object *)tcapURejectRequest:(UMASN1Object *)error
                             variant:(UMTCAP_Variant)variant
                            invokeId:(int64_t)invId
                         opCodeValue:(int64_t)op
                        opCodeFamily:(int64_t)fam
                      opCodeNational:(BOOL)nat;

{
    if(variant == TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }
#pragma unused(variant)
    /* FIXME: to be done */
    @throw([NSException exceptionWithName:@"not yet implemented" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
}

- (void)setConfig:(NSDictionary *)cfg applicationContext:(id<UMLayerTCAPApplicationContextProtocol>)appContext
{
    _appContext = appContext;
    [self readLayerConfig:cfg];
    if (cfg[@"attach-to"])
    {
        attachTo =  [cfg[@"attach-to"] stringValue];
    }
    if (cfg[@"attach-number"])
    {
        attachNumber =  [[SccpAddress alloc]initWithHumanReadableString:[cfg[@"attach-number"] stringValue] variant:self.variant];
    }
    else
    {
        attachNumber =  [[SccpAddress alloc]initWithHumanReadableString:@"any" variant:self.variant];
    }
    if (cfg[@"attach-ssn"])
    {
        ssn =  [[SccpSubSystemNumber alloc]initWithName:[cfg[@"attach-ssn"] stringValue]];
    }
    if (cfg[@"variant"])
    {
        NSString *v = [cfg[@"variant"] stringValue];
        if([v isEqualToString:@"itu"])
        {
            tcapVariant = TCAP_VARIANT_ITU;
        }
        if([v isEqualToString:@"ansi"])
        {
            tcapVariant = TCAP_VARIANT_ANSI;
        }
    }
    else
    {
        tcapVariant = TCAP_VARIANT_ITU;
    }
    if (cfg[@"timeout"])
    {
        _transactionTimeoutInSeconds = [cfg[@"timeout"] doubleValue];
    }
    else
    {
        _transactionTimeoutInSeconds = 60.0;
    }

    if(_transactionTimeoutInSeconds <= 5.0)
    {
        NSLog(@"TCAP Transactiong Timeout is below 5s. Setting it to 5s");
        _transactionTimeoutInSeconds = 5.0;
    }
    else if(_transactionTimeoutInSeconds >=120.0)
    {
        NSLog(@"TCAP Transaction Timeout is above 120s. Setting it to 60s");
        _transactionTimeoutInSeconds = 60.0;
    }
}

- (NSDictionary *)config
{
    NSMutableDictionary *cfg = [[NSMutableDictionary alloc]init];
    [self addLayerConfig:cfg];
    
    cfg[@"attach-to"] = attachTo;

    if(tcapVariant==TCAP_VARIANT_ITU)
    {
        cfg[@"variant"] = @"itu";
    }
    else if(tcapVariant==TCAP_VARIANT_ANSI)
    {
        cfg[@"variant"] = @"ansi";
    }

    if (cfg[@"attach-ssn"])
    {
        NSString *s =  [cfg[@"attach-ssn"] stringValue];
        ssn = [[SccpSubSystemNumber alloc]initWithName:s];
    }
    else
    {
        ssn = NULL;
    }
    return cfg;
}

- (void)startUp
{
    if(ssn)
    {
        [attachNumber setSsnFromInt:ssn.ssn];
        [attachedLayer setUser:self forSubsystem:ssn number:attachNumber];
    }
    else
    {
        [attachedLayer setDefaultUser:self];
    }
    /* lets call housekeeping once per 2.6 seconds */
    houseKeepingTimer = [[UMTimer alloc]initWithTarget:self
                                              selector:@selector(housekeepingTask)
                                                object:NULL
                                               seconds:2.6
                                                  name:@"tcap-housekeeping"
                                               repeats:YES];
    [houseKeepingTimer start];
}

- (void)sccpNDataIndication:(NSData *)data
                 connection:(UMSCCPConnection *)connection
                    options:(NSDictionary *)options
{
    
}

-(id<UMTCAP_UserProtocol>)getUserForOperation:(int64_t)operationCode
{
    id<UMTCAP_UserProtocol> user = tcapUserByOperation[@(operationCode)];
    if (user==NULL)
    {
        return tcapDefaultUser;
    }
    return user;

}

- (void) setUser:(id<UMTCAP_UserProtocol>)user forOperation:(int64_t)operationCode
{
    tcapUserByOperation[@(operationCode)] = user;
}

- (void)setDefaultUser:(id<UMTCAP_UserProtocol>)user
{
    tcapDefaultUser = user;
}

- (NSString *)getNewTransactionId
{
    return [_tidPool newTransactionIdForInstance:self.layerName];
}

- (void)returnTransactionId:(NSString *)tid
{
    if(_tidPool)
    {
        [_tidPool returnTransactionId:tid];
    }
}


- (UMTCAP_Transaction *)getNewOutgoingTransactionForUserDialogId:(UMTCAP_UserDialogIdentifier *)userDialogId
{
    return [self getNewOutgoingTransactionForUserDialogId:userDialogId user:NULL];

}
- (UMTCAP_Transaction *)getNewOutgoingTransactionForUserDialogId:(UMTCAP_UserDialogIdentifier *)userDialogId user:(id <UMTCAP_UserProtocol>)usr
{
    UMTCAP_Transaction *t = [[UMTCAP_Transaction alloc]init];
    t.localTransactionId = [self getNewTransactionId];
    t.remoteTransactionId = NULL;
    t.userDialogId = userDialogId;
    t.user = usr;
    t.incoming=NO;
    t.timeoutInSeconds = self.transactionTimeoutInSeconds;
    [t touch];

    transactionsByLocalTransactionId[t.localTransactionId] = t;
    return t;
}

- (UMTCAP_Transaction *)getNewIncomingTransactionForRemoteTransactionId:(NSString *)remoteTransactionId
{    
    UMTCAP_Transaction *t = [[UMTCAP_Transaction alloc]init];
    t.localTransactionId = [self getNewTransactionId];
    t.remoteTransactionId = remoteTransactionId;
    t.userDialogId = NULL;
    t.incoming=YES;
    t.timeoutInSeconds = self.transactionTimeoutInSeconds;
    [t touch];
    transactionsByLocalTransactionId[t.localTransactionId] = t;
    return t;
}

- (UMTCAP_Transaction *)findTransactionByLocalTransactionId:(NSString *)s
{

    UMTCAP_Transaction *t = transactionsByLocalTransactionId[s];
    return t;
}

- (void)removeTransaction:(UMTCAP_Transaction *)t
{
    NSString *tid =t.localTransactionId;
    if(tid.length > 0)
    {
        [transactionsByLocalTransactionId removeObjectForKey:tid];
        [self returnTransactionId:tid];
    }
}

- (id)decodePdu:(NSData *)data /* should return a type which can be converted to json */
{
    UMTCAP_sccpNUnitdata *task;
    task = [[UMTCAP_sccpNUnitdata alloc]initForTcap:self
                                               sccp:NULL
                                           userData:data
                                            calling:NULL
                                             called:NULL
                                   qualityOfService:0
                                            options:@{ @"decode-only" : @YES }];
    [task main];
    UMASN1Object *asn1 = task.asn1;
    if(asn1)
    {
        return asn1.objectValue;
    }
    else
    {
        UMSynchronizedSortedDictionary *e = [[UMSynchronizedSortedDictionary alloc]init];
        e[@"decode-error"] = task.decodeError;
        return e;
    }
}

+ (id)decodePdu:(NSData *)pdu /* should return a type which can be converted to json */
{
    UMTCAP_sccpNUnitdata *task;
    task = [[UMTCAP_sccpNUnitdata alloc]initForTcap:NULL
                                               sccp:NULL
                                           userData:pdu
                                            calling:NULL
                                             called:NULL
                                   qualityOfService:0
                                            options:@{ @"decode-only" : @YES }];
    [task main];
    UMASN1Object *asn1 = task.asn1;
    if(asn1)
    {
        return asn1.objectValue;
    }
    else
    {
        UMSynchronizedSortedDictionary *e = [[UMSynchronizedSortedDictionary alloc]init];
        e[@"decode-error"] = task.decodeError;
        return e;
    }
}

- (NSString *)status
{
    return [NSString stringWithFormat:@"IS:%lu",(unsigned long)[transactionsByLocalTransactionId count]];
}

- (void)housekeeping
{
    if([_housekeeping_lock tryLock] == 0)
    {
        NSMutableArray *tasksToQueue = [[NSMutableArray alloc]init];
        self.housekeeping_running = YES;
        NSArray *keys = [transactionsByLocalTransactionId allKeys];
        for(NSString *key in keys)
        {
            UMTCAP_Transaction *t = transactionsByLocalTransactionId[key];
            if(t.transactionIsClosed)
            {
                [self removeTransaction:t];
            }
            else if([t isTimedOut]==YES)
            {
                UMTCAP_TimeoutTask *task = [[UMTCAP_TimeoutTask alloc]initForTCAP:self transaction:t];
                [tasksToQueue addObject:task];
            }
        }
        self.housekeeping_running = NO;
        [_houseKeepingTimerRun touch];
        [_housekeeping_lock unlock];
        for(UMTCAP_TimeoutTask *task in tasksToQueue)
        {
            [self queueFromLower:task];
        }
    }
}

- (void)housekeepingTask
{
    UMTCAP_HousekeepingTask *task = [[UMTCAP_HousekeepingTask alloc]initForTcap:self];
    //[self queueFromLower:task];
    ulib_set_thread_name(@"tcap-housekeeping");
    [task main];
}

-(NSUInteger)pendingTransactionCount
{
    return transactionsByLocalTransactionId.count;
}

- (void)dump:(NSFileHandle *)filehandler
{
    [super dump:filehandler];
    
    NSArray *allTransactionIds = [transactionsByLocalTransactionId allKeys];
    for(NSString *tid in allTransactionIds)
    {
        NSMutableString *s = [[NSMutableString alloc]init];
        [s appendString:@"    ----------------------------------------------------------------------------\n"];
        [s appendFormat:@"    Transaction: %@\n",tid];
        [s appendString:@"    ----------------------------------------------------------------------------\n"];
        [filehandler writeData: [s dataUsingEncoding:NSUTF8StringEncoding]];
        UMTCAP_Transaction *t = transactionsByLocalTransactionId[tid];
        [t dump:filehandler];
    }
}

- (void)sendPAbort:(NSString *)remoteTransactionId
             cause:(int64_t)cause
    callingAddress:(SccpAddress *)src
     calledAddress:(SccpAddress *)dst
           options:(NSDictionary *)options

{
    if(self.logLevel <= UMLOG_DEBUG)
    {
        [self.logFeed debugText:[NSString stringWithFormat:@"sendingPAbort for remoteTransaction %@",remoteTransactionId]];
    }

    UMTCAP_itu_asn1_abort *q = [[UMTCAP_itu_asn1_abort alloc]init];
    UMTCAP_itu_asn1_dtid *dtid = [[UMTCAP_itu_asn1_dtid alloc]init];
    dtid.transactionId = remoteTransactionId;
    q.dtid = dtid;
    q.pAbortCause = [[UMTCAP_itu_asn1_pAbortCause alloc]initWithValue:cause];

    NSData *pdu;
    @try
    {
        pdu = [q berEncoded];
    }
    @catch(NSException *e)
    {
        [self.logFeed majorErrorText:[NSString stringWithFormat:@"BER encoding of PDU failed with exception %@",e]];
    }
    if(pdu)
    {
        if(self.logLevel <= UMLOG_DEBUG)
        {
            NSString *s = [NSString stringWithFormat:@"Sending PDU to %@: %@",self.attachedLayer.layerName, pdu];
            [self.logFeed debugText:s];
        }
        [self.attachedLayer sccpNUnidata:pdu
                             callingLayer:self
                                  calling:src
                                   called:dst
                         qualityOfService:0
                                  options:options];
    }
}
@end
