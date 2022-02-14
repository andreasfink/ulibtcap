//
//  UMTCAP_begin.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_begin.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_asn1_dialoguePortion.h"

@implementation UMTCAP_begin


- (UMTCAP_begin *)initForTcap:(UMLayerTCAP *)xtcap
                transactionId:(NSString *)xtransactionId
                 userDialogId:(UMTCAP_UserDialogIdentifier *)xuserDialogId
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

    self = [super initWithName:@"UMTCAP_begin"
                      receiver:xtcap
                        sender:xuser
       requiresSynchronisation:NO];
    if(self)
    {
        _tcap = xtcap;
        _transactionId = xtransactionId;
        _userDialogId = xuserDialogId;
        _variant = xvariant;
        _user =xuser;
        _dialoguePortion = xdialoguePortion;
        _callingAddress=xsrc;
        _calledAddress=xdst;
        _components=xcomponents;
        _options=xoptions;
    }
    return self;
}

- (void)main
{
    @autoreleasepool
    {
        @throw([NSException exceptionWithName:@"NOT_IMPL" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
        /* this should be overriden by itu and ANSI versions */
    }
}
@end
