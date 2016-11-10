//
//  UMTCAP_itu_continue.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_continue.h"
#import "UMTCAP_itu_asn1_continue.h"
#import "UMTCAP_Transaction.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_itu_asn1_dialoguePortion.h"

@implementation UMTCAP_itu_continue


- (UMTCAP_continue *)initForTcap:(UMLayerTCAP *)xtcap
                   transactionId:(NSString *)transactionId
                    userDialogId:(NSString *)userDialogId
                         variant:(UMTCAP_Variant)variant
                            user:(id<UMLayerUserProtocol>)xuser
                  callingAddress:(SccpAddress *)xsrc
                   calledAddress:(SccpAddress *)xdst
              applicationContext:(UMTCAP_asn1_objectIdentifier *)xappContext
                        userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
           dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                      components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                         options:(NSDictionary *)xoptions
{
    UMTCAP_itu_asn1_dialoguePortion *itu_dialoguePortion = NULL;
    if((xdialogProtocolVersion) || (xappContext) || (xuserInfo))
    {
        itu_dialoguePortion = [[UMTCAP_itu_asn1_dialoguePortion alloc]init];
        itu_dialoguePortion.dialogRequest = [[UMTCAP_asn1_AARE_apdu alloc]init];
        itu_dialoguePortion.dialogRequest.protocolVersion = xdialogProtocolVersion;
        itu_dialoguePortion.dialogRequest.objectIdentifier = xappContext;
        itu_dialoguePortion.dialogRequest.user_information = xuserInfo;
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
                      options:xoptions];
}

- (void)main
{
    UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];

    UMTCAP_itu_asn1_continue *q = [[UMTCAP_itu_asn1_continue alloc]init];
    
    
    if(components.count>0)
    {
        UMTCAP_itu_asn1_componentPortion *componentsPortion = [[UMTCAP_itu_asn1_componentPortion alloc]init];
        for(id item in components)
        {
            [componentsPortion addComponent:(UMTCAP_itu_asn1_componentPDU *)item];
        }
        q.componentPortion = componentsPortion;
    }
    
    UMTCAP_itu_asn1_otid *otid = [[UMTCAP_itu_asn1_otid alloc]init];
    UMTCAP_itu_asn1_dtid *dtid = [[UMTCAP_itu_asn1_dtid alloc]init];
    otid.transactionId = transactionId;
    dtid.transactionId = t.remoteTransactionId;
    
    q.otid = otid;
    q.dtid = dtid;
    
    q.dialoguePortion = dialoguePortion;
    
    NSData *pdu = [q berEncoded];
    [tcap.attachedLayer sccpNUnidata:pdu
                        callingLayer:tcap
                             calling:callingAddress
                              called:calledAddress
                    qualityOfService:0
                             options:options];
    [t touch];
}

@end
