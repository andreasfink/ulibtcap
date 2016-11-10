//
//  UMTCAP_itu_begin.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>
#import "UMTCAP_begin.h"

@interface UMTCAP_itu_begin : UMTCAP_begin
{
}

/* for old compatibility */
- (UMTCAP_begin *)initForTcap:(UMLayerTCAP *)xtcap
                transactionId:(NSString *)xtransactionId
                 userDialogId:(NSString *)xuserDialogId
                      variant:(UMTCAP_Variant)xvariant
                         user:(id<UMLayerUserProtocol>)xuser
               callingAddress:(SccpAddress *)xsrc
                calledAddress:(SccpAddress *)xdst
           applicationContext:(UMTCAP_asn1_objectIdentifier *)xapplicationContext
                     userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
        dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                   components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                      options:(NSDictionary *)xoptions;

@end
