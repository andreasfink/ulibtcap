//
//  UMTCAP_end.h
//  ulibtcap
//
//  Created by Andreas Fink on 22/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.


#import <ulib/ulib.h>
#import <ulibgt/ulibgt.h>
#import <ulibasn1/ulibasn1.h>
#import <ulibsccp/ulibsccp.h>
#import <ulibtcap/UMTCAP_Variant.h>
#import <ulibtcap/UMTCAP_UserProtocol.h>
#import <ulibtcap/UMTCAP_asn1_objectIdentifier.h>
#import <ulibtcap/UMTCAP_asn1_dialoguePortion.h>

@class UMLayerTCAP;
@class UMTCAP_generic_asn1_componentPDU;

@interface UMTCAP_end : UMLayerTask
{
    UMLayerTCAP             *tcap;
    
    NSString *transactionId;
    UMTCAP_UserDialogIdentifier *userDialogId;
    UMTCAP_Variant variant;
    id<UMLayerUserProtocol> user;
    UMTCAP_asn1_objectIdentifier *applicationContext;
    UMTCAP_asn1_userInformation *userInfo;
    UMASN1BitString *dialogProtocolVersion;
    SccpAddress *callingAddress;
    SccpAddress *calledAddress;
    TCAP_NSARRAY_OF_COMPONENT_PDU *components;
    UMTCAP_asn1_dialoguePortion *dialoguePortion;
    BOOL permission;
    NSDictionary *options;
    int                             _sccpQoS;
    SCCP_ServiceClass               _sccpServiceClass;
    SCCP_Handling                   _sccpHandling;
}

- (UMTCAP_end *)initForTcap:(UMLayerTCAP *)xtcap
              transactionId:(NSString *)xtransactionId
               userDialogId:(UMTCAP_UserDialogIdentifier *)xuserDialogId
                    variant:(UMTCAP_Variant)xvariant
                       user:(id<UMLayerUserProtocol>)xuser
             callingAddress:(SccpAddress *)xsrc
              calledAddress:(SccpAddress *)xdst
            dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                 components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                 permission:(BOOL)xpermission /* only relevant for ANSI */
                    options:(NSDictionary *)xoptions;

@end
