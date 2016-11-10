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
@class UMTCAP_asn1_dialoguePortion;

@interface UMTCAP_begin : UMLayerTask
{
    UMLayerTCAP             *tcap;
    
    NSString *transactionId;
    NSString *userDialogId;
    UMTCAP_Variant variant;
    id<UMLayerUserProtocol> user;
    SccpAddress *callingAddress;
    SccpAddress *calledAddress;
    TCAP_NSARRAY_OF_COMPONENT_PDU *components;
    NSDictionary *options;
    UMTCAP_asn1_dialoguePortion *dialoguePortion;
}

- (UMTCAP_begin *)initForTcap:(UMLayerTCAP *)xtcap
                transactionId:(NSString *)transactionId
                 userDialogId:(NSString *)userDialogId
                      variant:(UMTCAP_Variant)variant
                         user:(id<UMLayerUserProtocol>)xuser
               callingAddress:(SccpAddress *)xsrc
                calledAddress:(SccpAddress *)xdst
              dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                   components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                      options:(NSDictionary *)xoptions;

@end
