//
//  UMTCAP_ansi_begin.h
//  ulibtcap
//
//  Created by Andreas Fink on 05/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/ulibtcap.h>
#import "UMTCAP_begin.h"

@class UMTCAP_ansi_asn1_dialoguePortion;

@interface UMTCAP_ansi_begin : UMTCAP_begin
{
}

/* for old compatibility */
- (UMTCAP_ansi_begin *)initForTcap:(UMLayerTCAP *)xtcap
                     transactionId:(NSString *)xtransactionId
                      userDialogId:(NSString *)xuserDialogId
                           variant:(UMTCAP_Variant)xvariant
                              user:(id<UMLayerUserProtocol>)xuser
                    callingAddress:(SccpAddress *)xsrc
                     calledAddress:(SccpAddress *)xdst
                applicationContext:(UMTCAP_asn1_objectIdentifier *)xapplicationContext
                          userInfo:(UMTCAP_asn1_external *)xuserInfo
             dialogProtocolVersion:(UMASN1Object *)xdialogProtocolVersion
                        components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                           options:(NSDictionary *)xoptions;

@end
