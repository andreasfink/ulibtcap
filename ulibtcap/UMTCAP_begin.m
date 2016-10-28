//
//  UMTCAP_begin.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_begin.h"
#import "UMLayerTCAP.h"

@implementation UMTCAP_begin

- (UMTCAP_begin *)initForTcap:(UMLayerTCAP *)xtcap
                transactionId:(NSString *)xtransactionId
                 userDialogId:(NSString *)xuserDialogId
                      variant:(UMTCAP_Variant)xvariant
                         user:(id<UMLayerUserProtocol>)xuser
               callingAddress:(SccpAddress *)xsrc
                calledAddress:(SccpAddress *)xdst
           applicationContext:(UMTCAP_asn1_objectIdentifier *)xappContext
                     userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
                   components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                      options:(NSDictionary *)xoptions
{
    NSAssert(xtcap != NULL,@"tcap is null");
    NSAssert(xuser != NULL,@"user can not be null");

    self = [super initWithName:@"UMTCAP_begin"
                      receiver:xtcap
                        sender:xuser
       requiresSynchronisation:YES];
    if(self)
    {
        tcap = xtcap;
        transactionId = xtransactionId;
        userDialogId = xuserDialogId;
        variant = xvariant;
        user =xuser;
        applicationContext=xappContext;
        userInfo = xuserInfo;
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
    /* this should be overriden by itu and ANSI versions */
}
@end
