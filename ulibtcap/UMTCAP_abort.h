//
//  UMTCAP_abort.h
//  ulibtcap
//
//  Created by Andreas Fink on 22/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

#import <ulib/ulib.h>
#import <ulibgt/ulibgt.h>
#import <ulibasn1/ulibasn1.h>
#import <ulibsccp/ulibsccp.h>
#import "UMTCAP_Variant.h"
#import "UMTCAP_UserProtocol.h"
#import "UMTCAP_asn1_objectIdentifier.h"
#import "UMTCAP_asn1_external.h"

@interface UMTCAP_abort : UMLayerTask
{
    UMLayerTCAP                 *_tcap;
    NSString                    *_transactionId;
    UMTCAP_UserDialogIdentifier *_userDialogId;
    int64_t                     _pAbortCause;
    UMTCAP_asn1_dialoguePortion *_dialoguePortion;
    UMTCAP_Variant              _variant;
    id<UMLayerUserProtocol>     _user;
    SccpAddress                 *_callingAddress;
    SccpAddress                 *_calledAddress;
    NSDictionary                *_options;
}


- (UMTCAP_abort *)initForTcap:(UMLayerTCAP *)xtcap
                transactionId:(NSString *)xtransactionId
                 userDialogId:(UMTCAP_UserDialogIdentifier *)xuserDialogId
                      variant:(UMTCAP_Variant)xvariant
                         user:(id<UMLayerUserProtocol>)xuser
               callingAddress:(SccpAddress *)xsrc
                calledAddress:(SccpAddress *)xdst
                        cause:(int64_t)pAbortCause
                dialogPortion:(UMTCAP_asn1_dialoguePortion *)uAbortCause
                      options:(NSDictionary *)xoptions;

@end
