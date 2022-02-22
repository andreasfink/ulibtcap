//
//  UMTCAP_continue.m
//  ulibtcap
//
//  Created by Andreas Fink on 22/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_continue.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_asn1_dialoguePortion.h"

@implementation UMTCAP_continue

- (UMTCAP_continue *)init
{
    self = [super init];
    if(self)
    {
        _sccpServiceClass = SCCP_CLASS_INSEQ_CL;
        _sccpHandling = SCCP_HANDLING_RETURN_ON_ERROR;
        _sccpQoS = 0;
    }
    return self;
}

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
                         options:(NSDictionary *)xoptions
{
    NSAssert(xtcap != NULL,@"tcap is null");
    NSAssert(xuser != NULL,@"user can not be null");

    self = [super initWithName:@"UMTCAP_continue"
                      receiver:xtcap
                        sender:xuser
       requiresSynchronisation:NO];
    if(self)
    {
        tcap = xtcap;
        transactionId = xtransactionId;
        userDialogId = xuserDialogId;
        variant = xvariant;
        user =xuser;
        dialoguePortion = xdialoguePortion;
        callingAddress=xsrc;
        calledAddress=xdst;
        components_ansi = xcomponents_ansi;
        components_itu = xcomponents_itu;
        options=xoptions;
        _sccpServiceClass = SCCP_CLASS_INSEQ_CL;
        _sccpHandling = SCCP_HANDLING_RETURN_ON_ERROR;
        _sccpQoS = 0;

    }
    return self;
}

- (void)main
{
    @autoreleasepool
    {
        @throw([NSException exceptionWithName:@"NOT_IMPL" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
    }
}
@end
