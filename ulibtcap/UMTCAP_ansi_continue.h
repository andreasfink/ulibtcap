//
//  UMTCAP_ansi_continue.h
//  ulibtcap
//
//  Created by Andreas Fink on 22/04/16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_continue.h"

@interface UMTCAP_ansi_continue : UMTCAP_continue
{
    
}

- (UMTCAP_continue *)initForTcap:(UMLayerTCAP *)xtcap
                   transactionId:(NSString *)transactionId
                    userDialogId:(NSString *)userDialogId
                         variant:(UMTCAP_Variant)variant
                            user:(id<UMLayerUserProtocol>)xuser
                  callingAddress:(SccpAddress *)xsrc
                   calledAddress:(SccpAddress *)xdst
              applicationContext:(UMTCAP_asn1_objectIdentifier *)xappContext
                        userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
                      components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                         options:(NSDictionary *)xoptions;

@end
