//
//  UMLayerTCAP.h
//  ulibtcap
//
//  Created by Andreas Fink on 01/07/15.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibgt/ulibgt.h>
#import <ulibsccp/ulibsccp.h>
#import <ulibtcap/ulibtcap.h>
#import "UMTCAP_Variant.h"
#import "UMTCAP_UserProtocol.h"
#import "UMTCAP_operationClass.h"
#import "UMTCAP_generic_asn1_componentPDU.h"


@class UMTCAP_Transaction;
@class UMLayerSCCP;

@interface UMLayerTCAP : UMLayer<UMSCCP_UserProtocol>
{
    id<UMTCAP_UserProtocol> tcapDefaultUser;
    UMSynchronizedDictionary *tcapUserByOperation;
    
    NSString        *attachTo;
    UMLayerSCCP     *attachedLayer;
    UMTCAP_Variant tcapVariant;
    
    UMSynchronizedDictionary *transactionsByLocalTransactionId;
//    UMSynchronizedDictionary *transactionsByUserDialogId;
    NSTimeInterval transactionTimeout;
    NSTimeInterval invokeTimeout;
    SccpSubSystemNumber *ssn;
    SccpAddress *attachNumber;
    int64_t lastDialogId;
    int64_t lastTransactionId;
    UMTimer *houseKeepingTimer;
    BOOL houseKeepingRunning;
}

@property(readwrite,strong) id<UMTCAP_UserProtocol> tcapDefaultUser;
@property(readwrite,strong) UMSynchronizedDictionary *tcapUserByOperation;

@property(readwrite,assign) UMTCAP_Variant tcapVariant;
@property(readwrite,assign) NSTimeInterval transactionTimeout;
@property(readwrite,assign) NSTimeInterval invokeTimeout;
@property(readwrite,strong) NSString        *attachTo;
@property(readwrite,strong) UMLayerSCCP     *attachedLayer;
@property(readwrite,strong) SccpSubSystemNumber *ssn;
@property(readwrite,assign) BOOL transactionIsClosed;


/* this is called from lower layer to deliver data to the TCAP Layer */
- (NSString *)status;

- (void)sccpNUnitdata:(NSData *)data
         callingLayer:(UMLayerSCCP *)sccpLayer
              calling:(SccpAddress *)src
               called:(SccpAddress *)dst
     qualityOfService:(int)qos
              options:(NSDictionary *)options;


/* this is called from uppper layer */


/* Dialog Handling primmitives */

- (void)tcapUnidirectionalRequest:(NSString *)tcapTransactionId
                     userDialogId:(NSString *)userDialogId
                          variant:(UMTCAP_Variant)variant
                             user:(id<UMTCAP_UserProtocol>)user
                   callingAddress:(SccpAddress *)src
                    calledAddress:(SccpAddress *)dst
                  dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                       components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                          options:(NSDictionary *)options;


- (void)tcapBeginRequest:(NSString *)tcapDialogId
            userDialogId:(NSString *)userDialogId
                 variant:(UMTCAP_Variant)variant
                    user:(id<UMTCAP_UserProtocol>)user
          callingAddress:(SccpAddress *)src
           calledAddress:(SccpAddress *)dst
         dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
              components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                 options:(NSDictionary *)options;

- (void)tcapContinueRequest:(NSString *)tcapDialogId
               userDialogId:(NSString *)userDialogId
                    variant:(UMTCAP_Variant)variant
                       user:(id<UMTCAP_UserProtocol>)user
             callingAddress:(SccpAddress *)src
              calledAddress:(SccpAddress *)dst
            dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                 components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                    options:(NSDictionary *)options;


- (void)tcapEndRequest:(NSString *)tcapDialogId
          userDialogId:(NSString *)userDialogId
               variant:(UMTCAP_Variant)variant
                  user:(id<UMTCAP_UserProtocol>)user
        callingAddress:(SccpAddress *)src
         calledAddress:(SccpAddress *)dst
       dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
            components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
               options:(NSDictionary *)options;


- (void)tcapUAbortRequest:(NSString *)tcapDialogId
                  variant:(UMTCAP_Variant)variant
                     user:(id<UMTCAP_UserProtocol>)user
           callingAddress:(SccpAddress *)src
            calledAddress:(SccpAddress *)dst
          dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
             callingLayer:(UMLayer *)tcapLayer
               components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                  options:(NSDictionary *)options;


/* component handling primitives */

- (UMTCAP_generic_asn1_componentPDU *)tcapInvoke:(UMASN1Object *)params
                                         variant:(UMTCAP_Variant)variant
                                        invokeId:(int64_t)invId
                                        linkedId:(int64_t)lnkId
                                     useLinkedId:(BOOL)useLinkedId
                                     opCodeValue:(int64_t)op
                                    opCodeFamily:(int64_t)fam
                                  opCodeNational:(BOOL)nat
                                            last:(BOOL)last;

- (UMTCAP_generic_asn1_componentPDU *)tcapInvokeLast:(UMASN1Object *)params
                                             variant:(UMTCAP_Variant)variant
                                            invokeId:(int64_t)invId
                                            linkedId:(int64_t)lnkId
                                         useLinkedId:(BOOL)useLinkedId
                                         opCodeValue:(int64_t)op
                                        opCodeFamily:(int64_t)fam
                                      opCodeNational:(BOOL)nat;

- (UMTCAP_generic_asn1_componentPDU *)tcapInvokeNotLast:(UMASN1Object *)params
                                                variant:(UMTCAP_Variant)variant
                                               invokeId:(int64_t)invId
                                               linkedId:(int64_t)lnkId
                                            useLinkedId:(BOOL)useLinkedId
                                            opCodeValue:(int64_t)op
                                           opCodeFamily:(int64_t)fam
                                         opCodeNational:(BOOL)nat;

- (UMTCAP_generic_asn1_componentPDU *)tcapResultLastRequest:(UMASN1Object *)params
                                                    variant:(UMTCAP_Variant)variant
                                                   invokeId:(int64_t)invId
                                                   linkedId:(int64_t)lnkId
                                                useLinkedId:(BOOL)useLinkedId
                                                opCodeValue:(int64_t)op
                                               opCodeFamily:(int64_t)fam
                                             opCodeNational:(BOOL)nat;

- (UMTCAP_generic_asn1_componentPDU *)tcapResultNotLastRequest:(UMASN1Object *)params
                                                       variant:(UMTCAP_Variant)variant
                                                      invokeId:(int64_t)invId
                                                      linkedId:(int64_t)lnkId
                                                   useLinkedId:(BOOL)useLinkedId
                                                   opCodeValue:(int64_t)op
                                                  opCodeFamily:(int64_t)fam
                                                opCodeNational:(BOOL)nat;

- (UMTCAP_generic_asn1_componentPDU *)tcapUErrorRequest:(UMASN1Object *)params
                                                variant:(UMTCAP_Variant)variant
                                               invokeId:(int64_t)invId
                                              errorCode:(int64_t)err
                                         isPrivateError:(BOOL)priv;

- (UMTCAP_generic_asn1_componentPDU *)tcapURejectRequest:(UMASN1Object *)error
                                                 variant:(UMTCAP_Variant)variant
                                                invokeId:(int64_t)invId
                                             opCodeValue:(int64_t)op
                                            opCodeFamily:(int64_t)fam
                                          opCodeNational:(BOOL)nat;


/* internal methods to keep track of transactions */

- (void)setConfig:(NSDictionary *)cfg;
- (NSDictionary *)config;
- (id<UMTCAP_UserProtocol>)getUserForOperation:(int64_t)operationCode;
- (void) setUser:(id<UMTCAP_UserProtocol>)user forOperation:(int64_t)operationCode;
- (void)setDefaultUser:(id<UMTCAP_UserProtocol>)user;
- (void)startUp;

- (NSString *)getNewTransactionId;

- (UMTCAP_Transaction *)findTransactionByLocalTransactionId:(NSString *)tid;
- (UMTCAP_Transaction *)getNewOutgoingTransactionForUserDialogId:(NSString *)userDialogId;
- (UMTCAP_Transaction *)getNewOutgoingTransactionForUserDialogId:(NSString *)userDialogId user:(id <UMTCAP_UserProtocol>)usr;
- (UMTCAP_Transaction *)getNewIncomingTransactionForRemoteTransactionId:(NSString *)remoteTransactionId;
- (void)removeTransaction:(UMTCAP_Transaction *)t;


- (NSString *)decodePdu:(NSData *)data;
+ (NSString *)decodePdu:(NSData *)data;


@end
