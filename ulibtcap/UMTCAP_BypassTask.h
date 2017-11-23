//
//  UMTCAP_BypassTask.h
//  ulibtcap
//
//  Created by Andreas Fink on 22.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

// this is a nonstandard function which allows a SCCP packet to be forwarded after inspection of upper layers.
// as we have already created in memory structures for a incoming tcap transaction etc,
// we have to tear down the internal structures again

#import <ulib/ulib.h>
#import <ulibsccp/ulibsccp.h>
#import <ulibgt/ulibgt.h>
#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_Variant.h"
#import "UMTCAP_UserProtocol.h"
#import "UMTCAP_asn1_objectIdentifier.h"
#import "UMTCAP_asn1_dialoguePortion.h"

@interface UMTCAP_BypassTask : UMLayerTask
{
    UMLayerTCAP *_tcap;
    NSString *_transactionId;
    NSString *_userDialogId;
    UMTCAP_Variant _variant;
    id<UMLayerUserProtocol> _user;
    SccpAddress *_callingAddress;
    SccpAddress *_calledAddress;
    NSDictionary *_options;
    NSData *_sccpPayload;
}

- (UMTCAP_BypassTask *)initForTcap:(UMLayerTCAP *)xtcap
                     transactionId:(NSString *)transactionId
                      userDialogId:(NSString *)userDialogId
                           variant:(UMTCAP_Variant)variant
                              user:(id<UMLayerUserProtocol>)xuser
                    callingAddress:(SccpAddress *)xsrc
                     calledAddress:(SccpAddress *)xdst
                       sccpPayload:(NSData *)sccpPayload
                           options:(NSDictionary *)xoptions;
@end
