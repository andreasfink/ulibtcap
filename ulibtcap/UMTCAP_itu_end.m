//
//  UMTCAP_itu_end.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_end.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_itu_asn1_dialoguePortion.h"
#import "UMTCAP_itu_asn1_end.h"
#import "UMTCAP_itu_asn1_dtid.h"
#import "UMTCAP_itu_asn1_componentPortion.h"

@implementation UMTCAP_itu_end

- (UMTCAP_itu_end *)initForTcap:(UMLayerTCAP *)xtcap
                  transactionId:(NSString *)xtransactionId
                   userDialogId:(NSString *)xuserDialogId
                        variant:(UMTCAP_Variant)xvariant
                           user:(id<UMLayerUserProtocol>)xuser
                 callingAddress:(SccpAddress *)xsrc
                  calledAddress:(SccpAddress *)xdst
             applicationContext:(UMTCAP_asn1_objectIdentifier *)xappContext
                       userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
          dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                     components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                     permission:(BOOL)xpermission /* only relevant for ANSI */
                        options:(NSDictionary *)xoptions
{
    
    UMTCAP_itu_asn1_dialoguePortion *itu_dialoguePortion = NULL;
    if((xdialogProtocolVersion) || (xappContext) || (xuserInfo))
    {
        itu_dialoguePortion = [[UMTCAP_itu_asn1_dialoguePortion alloc]init];
        itu_dialoguePortion.dialogResponse= [[UMTCAP_asn1_AARE_apdu alloc]init];
        itu_dialoguePortion.dialogResponse.protocolVersion = xdialogProtocolVersion;
        itu_dialoguePortion.dialogResponse.objectIdentifier = xappContext;
        itu_dialoguePortion.dialogResponse.user_information = xuserInfo;
    }
    
    return [super initForTcap:xtcap
                transactionId:transactionId
                 userDialogId:userDialogId
                      variant:variant
                         user:xuser
               callingAddress:xsrc
                calledAddress:xdst
              dialoguePortion:itu_dialoguePortion
                   components:xcomponents
                   permission:xpermission
                      options:xoptions];
}

- (void)main
{
    UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];
    UMTCAP_itu_asn1_end *q = [[UMTCAP_itu_asn1_end alloc]init];

    UMTCAP_itu_asn1_dtid *dtid = [[UMTCAP_itu_asn1_dtid alloc]init];
    dtid.transactionId = t.remoteTransactionId;
    q.dtid = dtid;
    q.dialoguePortion = (UMTCAP_itu_asn1_dialoguePortion *)dialoguePortion;
    
    if(components.count > 0)
    {
        UMTCAP_itu_asn1_componentPortion *componentsPortion = [[UMTCAP_itu_asn1_componentPortion alloc]init];
        for(id item in components)
        {
            [componentsPortion addComponent:(UMTCAP_itu_asn1_componentPDU *)item];
        }
        q.componentPortion = componentsPortion;
    }

    NSData *pdu = [q berEncoded];
    
    [tcap.attachedLayer sccpNUnidata:pdu
                        callingLayer:tcap
                             calling:callingAddress
                              called:calledAddress
                    qualityOfService:0
                             options:options];
    t.transactionIsClosed = YES;
}

@end
