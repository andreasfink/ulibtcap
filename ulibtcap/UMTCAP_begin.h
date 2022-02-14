//
//  UMTCAP_begin.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
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
#import "UMTCAP_asn1_external.h"

@class UMLayerTCAP;
@class UMTCAP_generic_asn1_componentPDU;
@class UMTCAP_asn1_dialoguePortion;

@interface UMTCAP_begin : UMLayerTask
{
    UMLayerTCAP                     *_tcap;
    NSString                        *_transactionId;
    UMTCAP_UserDialogIdentifier     *_userDialogId;
    UMTCAP_Variant                  _variant;
    id<UMLayerUserProtocol>         _user;
    SccpAddress                     *_callingAddress;
    SccpAddress                     *_calledAddress;
    TCAP_NSARRAY_OF_COMPONENT_PDU   *_components;
    NSDictionary                    *_options;
    UMTCAP_asn1_dialoguePortion     *_dialoguePortion;
}

@property(readwrite,strong,atomic)  UMLayerTCAP                     *tcap;
@property(readwrite,strong,atomic)  NSString                        *transactionId;
@property(readwrite,strong,atomic)  UMTCAP_UserDialogIdentifier     *userDialogId;
@property(readwrite,assign,atomic)  UMTCAP_Variant                  variant;
@property(readwrite,strong,atomic)  id<UMLayerUserProtocol>         user;
@property(readwrite,strong,atomic)  SccpAddress                     *callingAddress;
@property(readwrite,strong,atomic)  SccpAddress                     *calledAddress;
@property(readwrite,strong,atomic)  TCAP_NSARRAY_OF_COMPONENT_PDU   *components;
@property(readwrite,strong,atomic)  NSDictionary                    *options;
@property(readwrite,strong,atomic)  UMTCAP_asn1_dialoguePortion     *dialoguePortion;

- (UMTCAP_begin *)initForTcap:(UMLayerTCAP *)xtcap
                transactionId:(NSString *)transactionId
                 userDialogId:(UMTCAP_UserDialogIdentifier *)userDialogId
                      variant:(UMTCAP_Variant)variant
                         user:(id<UMLayerUserProtocol>)xuser
               callingAddress:(SccpAddress *)xsrc
                calledAddress:(SccpAddress *)xdst
              dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                   components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                      options:(NSDictionary *)xoptions;

@end
