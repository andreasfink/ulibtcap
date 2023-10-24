//
//  UMTCAP_ansi_end.h
//  ulibtcap
//
//  Created by Andreas Fink on 10.10.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_end.h>

@interface UMTCAP_ansi_end : UMTCAP_end


- (UMTCAP_ansi_end *)initForTcap:(UMLayerTCAP *)xtcap
                   transactionId:(NSString *)xtransactionId
                    userDialogId:(UMTCAP_UserDialogIdentifier *)xuserDialogId
                         variant:(UMTCAP_Variant)xvariant
                            user:(id<UMLayerUserProtocol>)xuser
                  callingAddress:(SccpAddress *)xsrc
                   calledAddress:(SccpAddress *)xdst
              applicationContext:(UMTCAP_asn1_objectIdentifier *)xappContext
                        userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
           dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                      components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                      permission:(BOOL)xpermission /* only relevant for ANSI */
                         options:(NSDictionary *)xoptions;

@end
