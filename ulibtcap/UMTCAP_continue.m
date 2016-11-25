//
//  UMTCAP_continue.m
//  ulibtcap
//
//  Created by Andreas Fink on 22/04/16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_continue.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_asn1_dialoguePortion.h"

@implementation UMTCAP_continue

- (UMTCAP_continue *)initForTcap:(UMLayerTCAP *)xtcap
                   transactionId:(NSString *)xtransactionId
                    userDialogId:(NSString *)xuserDialogId
                         variant:(UMTCAP_Variant)xvariant
                            user:(id<UMLayerUserProtocol>)xuser
                  callingAddress:(SccpAddress *)xsrc
                   calledAddress:(SccpAddress *)xdst
                 dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                      components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
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
        components=xcomponents;
        options=xoptions;
    }
    return self;
}

- (void)main
{
    @throw([NSException exceptionWithName:@"NOT_IMPL" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
}
@end
