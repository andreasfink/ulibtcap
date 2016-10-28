//
//  UMTCAP_end.m
//  ulibtcap
//
//  Created by Andreas Fink on 22/04/16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_end.h"
#import "UMLayerTCAP.h"

@implementation UMTCAP_end


- (UMTCAP_end *)initForTcap:(UMLayerTCAP *)xtcap
              transactionId:(NSString *)xtransactionId
               userDialogId:(NSString *)xuserDialogId
                    variant:(UMTCAP_Variant)xvariant
                       user:(id<UMLayerUserProtocol>)xuser
             callingAddress:(SccpAddress *)xsrc
              calledAddress:(SccpAddress *)xdst
         applicationContext:(UMTCAP_asn1_objectIdentifier *)xappContext
                   userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
                 components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                 permission:(BOOL)xpermission /* only relevant for ANSI */
                    options:(NSDictionary *)xoptions
{
    NSAssert(xtcap != NULL,@"tcap is null");
    NSAssert(xuser != NULL,@"user can not be null");

    self = [super initWithName:@"UMTCAP_end"
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
        callingAddress=xsrc;
        calledAddress=xdst;
        components=xcomponents;
        permission = xpermission;
        options=xoptions;
    }
    return self;
}

- (void)main
{
    @throw([NSException exceptionWithName:@"NOT_IMPL" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}]);
}
@end
