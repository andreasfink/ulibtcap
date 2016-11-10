 //
//  UMLayerTCAP.m
//  ulibtcap
//
//  Created by Andreas Fink on 01/07/15.
//  Copyright (c) 2016 Andreas Fink
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

#import "UMTCAP_Transaction.h"
#import <ulibgt/ulibgt.h>
#import <ulibsccp/ulibsccp.h>

#import "UMTCAP_begin.h"
#import "UMTCAP_ansi_begin.h"
#import "UMTCAP_itu_begin.h"
#import "UMTCAP_sccpNUnitdata.h"
#import "UMTCAP_sccpNNotice.h"

@implementation UMLayerTCAP

@synthesize tcapVariant;
@synthesize transactionTimeout;
@synthesize invokeTimeout;
@synthesize tcapDefaultUser;
@synthesize tcapUserByOperation;

@synthesize attachTo;
@synthesize attachedLayer;
@synthesize ssn;

- (UMLayerTCAP *)init
{
    self = [super init];
    if(self)
    {
        [self genericInitialisation];
    }
    return self;
}

- (UMLayerTCAP *)initWithTaskQueueMulti:(UMTaskQueueMulti *)tq
{
    self = [super initWithTaskQueueMulti:tq];
    if(self)
    {
        [self genericInitialisation];
    }
    return self;
}

- (void)genericInitialisation
{
    transactionsByLocalTransactionId = [[UMSynchronizedDictionary alloc]init];
    tcapUserByOperation = [[UMSynchronizedDictionary alloc]init];
    transactionTimeout = 90.0; /* default timeout */
    invokeTimeout = 80.0; /* default timeout */
}

- (void)sccpNUnitdata:(NSData *)data
         callingLayer:(UMLayerSCCP *)sccpLayer
              calling:(SccpAddress *)src
               called:(SccpAddress *)dst
     qualityOfService:(int)qos
              options:(NSDictionary *)options;
{
    if(data.length < 3)
    {
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
                     userDialogId:(NSString *)userDialogId
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
    /* FIXME: to be done */
}


- (void)tcapBeginRequest:(NSString *)tcapTransactionId
            userDialogId:(NSString *)userDialogId
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
        @throw([NSException exceptionWithName:@"API_EXCEPTION" reason:@"tcapBeginRequest with unknown transaction ID. did you forgot to create it first?" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    [transaction touch];
    UMTCAP_begin *begin;
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
               userDialogId:(NSString *)userDialogId
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
        @throw([NSException exceptionWithName:@"API_EXCEPTION" reason:@"tcapContinueRequest with unknown transaction ID" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    [transaction touch];
    UMTCAP_continue *continueRequest = NULL;
    
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
          userDialogId:(NSString *)userDialogId
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
        @throw([NSException exceptionWithName:@"API_EXCEPTION" reason:@"tcapContinueRequest with unknown transaction ID" userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
    [transaction touch];
    UMTCAP_end *endRequest;
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

- (void)tcapUAbortRequest:(NSString *)invokeId
                  variant:(UMTCAP_Variant)variant
                     user:(id<UMTCAP_UserProtocol>)user
           callingAddress:(SccpAddress *)src
            calledAddress:(SccpAddress *)dst
          dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
             callingLayer:(UMLayer *)tcapLayer
               components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                  options:(NSDictionary *)options
{
    if(variant == TCAP_VARIANT_DEFAULT)
    {
        variant = tcapVariant;
    }
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
    if(variant == TCAP_VARIANT_DEFAULT)
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
    if(variant == TCAP_VARIANT_DEFAULT)
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
                        params: params
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
    /* FIXME: to be done */
    @throw([NSException exceptionWithName:@"not yet implemented" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
}

- (void)setConfig:(NSDictionary *)cfg
{
    [self readLayerConfig:cfg];
    if (cfg[@"attach-to"])
    {
        attachTo =  [cfg[@"attach-to"] stringValue];
    }
    if (cfg[@"attach-number"])
    {
        attachNumber =  [[SccpAddress alloc]initWithHumanReadableString:[cfg[@"attach-number"] stringValue]];
    }
    else
    {
        attachNumber =  [[SccpAddress alloc]initWithHumanReadableString:@"any"];
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
    /* lets call housekeeping once per second */
    houseKeepingTimer = [[UMTimer alloc]initWithTarget:self selector:@selector(housekeeping) object:NULL duration:1000000 name:@"tcap-housekeeping" repeats:YES];
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
    int64_t tid;
    @synchronized(self)
    {
        lastTransactionId = (lastTransactionId + 1 ) % 0x7FFF;
        tid = lastTransactionId;
    }
    return [NSString stringWithFormat:@"%08lX",(long)tid];
}



- (UMTCAP_Transaction *)getNewOutgoingTransactionForUserDialogId:(NSString *)userDialogId
{
    return [self getNewOutgoingTransactionForUserDialogId:userDialogId user:NULL];

}
- (UMTCAP_Transaction *)getNewOutgoingTransactionForUserDialogId:(NSString *)userDialogId user:(id <UMTCAP_UserProtocol>)usr
{
    UMTCAP_Transaction *t = [[UMTCAP_Transaction alloc]init];
    t.localTransactionId = [self getNewTransactionId];
    t.remoteTransactionId = NULL;
    t.userDialogId = userDialogId;
    t.user = usr;
    t.incoming=NO;
    t.timeoutValue = transactionTimeout;
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
    t.timeoutValue = transactionTimeout;
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
    if(t.localTransactionId)
    {
        [transactionsByLocalTransactionId removeObjectForKey:t.localTransactionId];
    }
}


NSTimeInterval timeoutValue;
NSDate *timeoutDate;

- (void)housekeeping
{
    NSArray *keys = [transactionsByLocalTransactionId allKeys];
    for(NSString *key in keys)
    {
        UMTCAP_Transaction *t = transactionsByLocalTransactionId[key];
        if(t.transactionIsClosed)
        {
            [self removeTransaction:t];
        }
        if([t isTimedOut]==YES)
        {
            [t timeOut];
        }
    }
}

- (NSString *)decodePdu:(NSData *)data
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
        NSString *s = asn1.objectValue;
        return [s jsonString];
    }
    else
    {
        return task.decodeError;
    }
}

+ (NSString *)decodePdu:(NSData *)pdu
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
        return [asn1.objectValue description];
    }
    else
    {
        return task.decodeError;
    }
}

- (NSString *)status
{
    return [NSString stringWithFormat:@"IS:%lu",(unsigned long)[transactionsByLocalTransactionId count]];
}


@end
