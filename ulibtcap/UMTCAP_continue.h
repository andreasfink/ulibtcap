//
//  UMTCAP_continue.h
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
#import "UMTCAP_Variant.h"
#import "UMTCAP_UserProtocol.h"
#import "UMTCAP_asn1_objectIdentifier.h"
#import "UMTCAP_ansi_asn1_componentPDU.h"
#import "UMTCAP_itu_asn1_componentPDU.h"

@class UMLayerTCAP;
@class UMTCAP_asn1_dialoguePortion;

@interface UMTCAP_continue : UMLayerTask
{
    UMLayerTCAP *tcap;
    NSString *transactionId;
    UMTCAP_UserDialogIdentifier *userDialogId;
    UMTCAP_Variant variant;
    id<UMLayerUserProtocol> user;
    UMTCAP_asn1_dialoguePortion *dialoguePortion;
    SccpAddress *callingAddress;
    SccpAddress *calledAddress;
    NSArray<UMTCAP_ansi_asn1_componentPDU *> *components_ansi;
    NSArray<UMTCAP_itu_asn1_componentPDU *> *components_itu;
    NSDictionary *options;
}

/*
- (UMTCAP_continue *)initForTcap:(UMLayerTCAP *)xtcap
                   transactionId:(NSString *)transactionId
                    userDialogId:(UMTCAP_UserDialogIdentifier *)userDialogId
                         variant:(UMTCAP_Variant)variant
                            user:(id<UMLayerUserProtocol>)xuser
                  callingAddress:(SccpAddress *)xsrc
                   calledAddress:(SccpAddress *)xdst
                 dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                      components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                         options:(NSDictionary *)xoptions;
 */
- (UMTCAP_continue *)initForTcap:(UMLayerTCAP *)xtcap
                   transactionId:(NSString *)xtransactionId
                    userDialogId:(UMTCAP_UserDialogIdentifier *)xuserDialogId
                         variant:(UMTCAP_Variant)xvariant
                            user:(id<UMLayerUserProtocol>)xuser
                  callingAddress:(SccpAddress *)xsrc
                   calledAddress:(SccpAddress *)xdst
                 dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                 components_ansi:(NSArray<UMTCAP_ansi_asn1_componentPDU *> *)xcomponents_ansi
                  components_itu:(NSArray<UMTCAP_itu_asn1_componentPDU *> *)xcomponents_itu
                         options:(NSDictionary *)xoptions;

@end
