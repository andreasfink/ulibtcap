//
//  UMTCAP_ProviderProtocol.h
//  ulibtcap
//
//  Created by Andreas Fink on 19.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>


/*
 Four classes of operations are considered:
 – Class 1 – Both success and failure are reported.
 – Class 2 – Only failure is reported.
 – Class 3 – Only success is reported.
 – Class 4 – Neither success, nor failure is reported.
 */
#import <ulib/ulib.h>
#import <ulibasn1/ulibasn1.h>
#import <ulibgt/ulibgt.h>
#import <ulibsccp/ulibsccp.h>
#import <ulibtcap/UMTCAP_generic_asn1_componentPDU.h>
#import <ulibtcap/UMTCAP_Operation.h>
#import <ulibtcap/UMTCAP_asn1_objectIdentifier.h>
#import <ulibtcap/UMTCAP_asn1_external.h>
#import <ulibtcap/UMTCAP_asn1_userInformation.h>
#import <ulibtcap/UMTCAP_asn1_dialoguePortion.h>
#import <ulibtcap/UMTCAP_UserDialogIdentifier.h>
#import <ulibtcap/UMTCAP_QualityOfService.h>
#import <ulibtcap/UMTCAP_asn1_userInformation.h>
#import <ulibtcap/UMTCAP_Termination.h>
#import <ulibtcap/UMTCAP_AbortReason.h>
#import <ulibtcap/UMTCAP_operationClass.h>
#import <ulibtcap/UMTCAP_Operation.h>
#import <ulibtcap/UMTCAP_InvokeId.h>

@class UMLayerTCAP;
@class UMTCAP_generic_asn1_componentPDU;

#ifdef __APPLE__
#define TCAP_NSARRAY_OF_COMPONENT_PDU  NSArray<UMTCAP_generic_asn1_componentPDU *>
#else
#define TCAP_NSARRAY_OF_COMPONENT_PDU  NSArray
#endif


@protocol UMTCAP_ProviderProtocol <NSObject,UMLayerUserProtocol>

/* Table 1/Q.771 – Primitives for dialogue handling */

/* – TC-UNI: Requests/indicates an unstructured dialogue */
- (void) tcUniRequest:(UMTCAP_QualityOfService *)qos        /* user optional */
   destinationAddress:(SccpAddress *)dst                    /* mandatory */
   applicationContext:(UMTCAP_asn1_objectIdentifier *)applicationContext    /* user optional */
   originatingAddress:(SccpAddress *)src                    /* this parameter is imlicitly associated with the accespoint at which the primitive is used if NULL is set */
             dialogId:(UMTCAP_UserDialogIdentifier *)dialogId               /* only local significant */
      userInformation:(UMTCAP_asn1_userInformation *)userInfo;              /* The user information can only be included if the application context name parameter is also included. */

/* – TC-BEGIN: Begins a dialogue */
- (void) tcBeginRequest:(UMTCAP_QualityOfService *)qos        /* user optional */
     destinationAddress:(SccpAddress *)dst                    /* mandatory */
     applicationContext:(UMTCAP_asn1_objectIdentifier *)applicationContext    /* user optional */
     originatingAddress:(SccpAddress *)src                    /* this parameter is imlicitly associated with the accespoint at which the primitive is used if NULL is set */
               dialogId:(UMTCAP_UserDialogIdentifier *)dialogId               /* only local significant */
        userInformation:(UMTCAP_asn1_userInformation *)userInfo               /* The user information can only be included if the application context name parameter is also included. */
             components:(TCAP_NSARRAY_OF_COMPONENT_PDU)components;

/* – TC-CONTINUE: Begins a dialogue */
- (void) tcContinueRequest:(UMTCAP_QualityOfService *)qos        /* user optional */
        originatingAddress:(SccpAddress *)src                    /* optional */
        applicationContext:(UMTCAP_asn1_objectIdentifier *)applicationContext    /* user optional */
                  dialogId:(UMTCAP_UserDialogIdentifier *)dialogId               /* only local significant */
           userInformation:(UMTCAP_asn1_userInformation *)userInfo               /* The user information can only be included if the application context name parameter is also included. */
                components:(TCAP_NSARRAY_OF_COMPONENT_PDU)components;

- (void) tcEndRequest:(UMTCAP_QualityOfService *)qos                        /* user optional */
             dialogId:(UMTCAP_UserDialogIdentifier *)dialogId               /* only local significant */
   applicationContext:(UMTCAP_asn1_objectIdentifier *)applicationContext    /* user optional */
           components:(TCAP_NSARRAY_OF_COMPONENT_PDU)components
      userInformation:(UMTCAP_asn1_userInformation *)userInfo               /* The user information can only be included if the application context name parameter is also included. */
       prearrangedEnd:(UMTCAP_Termination)prearrangedEnd;

- (void) tcUAbortRequest:(UMTCAP_QualityOfService *)qos        /* user optional */
      applicationContext:(UMTCAP_asn1_objectIdentifier *)applicationContext    /* user optional */
                dialogId:(UMTCAP_UserDialogIdentifier *)dialogId               /* only local significant */
         userInformation:(UMTCAP_asn1_userInformation *)userInfo               /* The user information can only be included if the application context name parameter is also included. */
              components:(TCAP_NSARRAY_OF_COMPONENT_PDU)components
             abortReason:(UMTCAP_AbortReason)reason;

- (void)tcInvokeRequest:(UMTCAP_UserDialogIdentifier *)dialogId
         operationClass:(UMTCAP_operationClass)operationClass
               invokeId:(UMTCAP_InvokeId *)invokeId
               linkedId:(UMTCAP_InvokeId *)linkedId;
            operation:(UMTCAP_Operation *)operation

{

}
- (void)tcResultLastRequest;
- (void)tcResultNotLastRequest;
- (void)tcUErrorRequest;
- (void)tcUCancelRequest;
- (void)tcURejectRequest;




@end
