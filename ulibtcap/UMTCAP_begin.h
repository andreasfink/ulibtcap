//
//  UMTCAP_begin.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>
#import <ulibgt/ulibgt.h>
#import <ulibasn1/ulibasn1.h>
#import <ulibsccp/ulibsccp.h>
#import "UMTCAP_Variant.h"
#import "UMTCAP_UserProtocol.h"
#import "UMTCAP_asn1_objectIdentifier.h"
#import "UMTCAP_asn1_external.h"

@class UMLayerTCAP;
@class UMTCAP_generic_asn1_componentPDU;

@interface UMTCAP_begin : UMLayerTask
{
    UMLayerTCAP             *tcap;
    
    NSString *transactionId;
    NSString *userDialogId;
    UMTCAP_Variant variant;
    id<UMLayerUserProtocol> user;
    UMTCAP_asn1_objectIdentifier *applicationContext;
    UMTCAP_asn1_userInformation *userInfo;
    SccpAddress *callingAddress;
    SccpAddress *calledAddress;
    TCAP_NSARRAY_OF_COMPONENT_PDU *components;
    NSDictionary *options;
}

- (UMTCAP_begin *)initForTcap:(UMLayerTCAP *)xtcap
                transactionId:(NSString *)transactionId
                 userDialogId:(NSString *)userDialogId
                      variant:(UMTCAP_Variant)variant
                         user:(id<UMLayerUserProtocol>)xuser
               callingAddress:(SccpAddress *)xsrc
                calledAddress:(SccpAddress *)xdst
           applicationContext:(UMTCAP_asn1_objectIdentifier *)xappContext
                     userInfo:(UMTCAP_asn1_external *)userInfo
                   components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                      options:(NSDictionary *)xoptions;

@end
