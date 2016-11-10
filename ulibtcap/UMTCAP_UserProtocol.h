//
//  UMTCAP_UserProtocol.h
//  ulibtcap
//
//  Created by Andreas Fink on 31/03/16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>
#import <ulibasn1/ulibasn1.h>
#import <ulibgt/ulibgt.h>
#import <ulibsccp/ulibsccp.h>
#import "UMTCAP_generic_asn1_componentPDU.h"
#import "UMTCAP_Operation.h"
#import "UMTCAP_asn1_objectIdentifier.h"
#import "UMTCAP_asn1_external.h"
#import "UMTCAP_asn1_userInformation.h"

@class UMLayerTCAP;
@class UMTCAP_generic_asn1_componentPDU;

#ifdef __APPLE__
#define TCAP_NSARRAY_OF_COMPONENT_PDU  NSArray<UMTCAP_generic_asn1_componentPDU *>
#else
#define TCAP_NSARRAY_OF_COMPONENT_PDU  NSArray
#endif

@protocol UMTCAP_UserProtocol <NSObject,UMLayerUserProtocol>

- (NSString *)getNewUserDialogId;

- (void)tcapBeginIndication:(NSString *)userDialogId
          tcapTransactionId:(NSString *)localTransactionId
    tcapRemoteTransactionId:(NSString *)remoteTransactionId
                    variant:(UMTCAP_Variant)var
             callingAddress:(SccpAddress *)src
              calledAddress:(SccpAddress *)dst
         applicationContext:(UMTCAP_asn1_objectIdentifier *)appContext
                   userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
      dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
               callingLayer:(UMLayerTCAP *)tcapLayer
                 components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                    options:(NSDictionary *)options;

- (void)tcapContinueIndication:(NSString *)userDialogId
             tcapTransactionId:(NSString *)localTransactionId
       tcapRemoteTransactionId:(NSString *)remoteTransactionId
                       variant:(UMTCAP_Variant)var
                callingAddress:(SccpAddress *)src
                 calledAddress:(SccpAddress *)dst
            applicationContext:(UMTCAP_asn1_objectIdentifier *)appContext
                      userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
         dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                  callingLayer:(UMLayerTCAP *)tcapLayer
                    components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                       options:(NSDictionary *)options;

- (void)tcapEndIndication:(NSString *)userDialogId
        tcapTransactionId:(NSString *)localTransactionId
  tcapRemoteTransactionId:(NSString *)remoteTransactionId
                  variant:(UMTCAP_Variant)var
           callingAddress:(SccpAddress *)src
            calledAddress:(SccpAddress *)dst
       applicationContext:(UMTCAP_asn1_objectIdentifier *)appContext
                 userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
    dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
             callingLayer:(UMLayerTCAP *)tcapLayer
               components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                  options:(NSDictionary *)options;


- (void)tcapUnidirectionalIndication:(NSString *)userDialogId
                   tcapTransactionId:(NSString *)localTransactionId
             tcapRemoteTransactionId:(NSString *)remoteTransactionId
                             variant:(UMTCAP_Variant)variant
                      callingAddress:(SccpAddress *)src
                       calledAddress:(SccpAddress *)dst
                  applicationContext:(UMTCAP_asn1_objectIdentifier *)appContext
                            userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
               dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                        callingLayer:(UMLayerTCAP *)tcapLayer
                          components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                             options:(NSDictionary *)options;


- (void)tcapNoticeIndication:(NSString *)userDialogId
           tcapTransactionId:(NSString *)localTransactionId
     tcapRemoteTransactionId:(NSString *)remoteTransactionId
                     variant:(UMTCAP_Variant)variant
              callingAddress:(SccpAddress *)src
               calledAddress:(SccpAddress *)dst
          applicationContext:(UMTCAP_asn1_objectIdentifier *)appContext
                    userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
       dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                callingLayer:(UMLayerTCAP *)tcapLayer
                  components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)components
                      reason:(SCCP_ReturnCause)reason
                     options:(NSDictionary *)options;



- (void)tcapPAbortIndication:(NSString *)userDialogId
           tcapTransactionId:(NSString *)localTransactionId
     tcapRemoteTransactionId:(NSString *)remoteTransactionId
                     variant:(UMTCAP_Variant)variant
              callingAddress:(SccpAddress *)src
               calledAddress:(SccpAddress *)dst
          applicationContext:(UMTCAP_asn1_objectIdentifier *)appContext
                    userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
       dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                callingLayer:(UMLayerTCAP *)tcapLayer
                        asn1:(UMASN1Object *)asn1
                     options:(NSDictionary *)options;


- (void)tcapUAbortIndication:(NSString *)userDialogId
           tcapTransactionId:(NSString *)localTransactionId
     tcapRemoteTransactionId:(NSString *)remoteTransactionId
                     variant:(UMTCAP_Variant)variant
              callingAddress:(SccpAddress *)src
               calledAddress:(SccpAddress *)dst
          applicationContext:(UMTCAP_asn1_objectIdentifier *)appContext
                    userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
       dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                callingLayer:(UMLayerTCAP *)tcapLayer
                        asn1:(UMASN1Object *)asn1
                     options:(NSDictionary *)options;


- (UMASN1Object *)decodeASN1:(UMASN1Object *)params
               operationCode:(int64_t)opcode
               operationType:(UMTCAP_Operation)operation
               operationName:(NSString **)xoperationName
                     context:(id)context;

- (NSString *)decodeError:(int)err;

@end
