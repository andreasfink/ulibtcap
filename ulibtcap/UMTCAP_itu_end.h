//
//  UMTCAP_itu_end.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>
#import <ulibtcap/UMTCAP_end.h>
#import <ulibtcap/UMTCAP_itu_asn1_componentPDU.h>

@interface UMTCAP_itu_end : UMTCAP_end
{
    UMTCAP_itu_operationCodeEncoding _operationEncoding;
    UMTCAP_itu_classEncoding         _classEncoding;
}

@property(readwrite,assign,atomic)  UMTCAP_itu_operationCodeEncoding operationEncoding;
@property(readwrite,assign,atomic)  UMTCAP_itu_classEncoding         classEncoding;

- (UMTCAP_itu_end *)initForTcap:(UMLayerTCAP *)xtcap
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
