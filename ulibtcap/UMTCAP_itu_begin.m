//
//  UMTCAP_itu_begin.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_begin.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_itu_asn1_dialoguePortion.h"
#import "UMTCAP_itu_asn1_begin.h"
#import "UMTCAP_itu_asn1_otid.h"
#import "UMTCAP_itu_asn1_componentPortion.h"

@implementation UMTCAP_itu_begin

- (UMTCAP_begin *)initForTcap:(UMLayerTCAP *)xtcap
                transactionId:(NSString *)xtransactionId
                 userDialogId:(NSString *)xuserDialogId
                      variant:(UMTCAP_Variant)xvariant
                         user:(id<UMLayerUserProtocol>)xuser
               callingAddress:(SccpAddress *)xsrc
                calledAddress:(SccpAddress *)xdst
           applicationContext:(UMTCAP_asn1_objectIdentifier *)xapplicationContext
                     userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
        dialogProtocolVersion:(UMASN1BitString *)xdialogProtocolVersion
                   components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                      options:(NSDictionary *)xoptions
{
    NSAssert(xtcap != NULL,@"tcap is null");
    NSAssert(xuser != NULL,@"user can not be null");
    
    
    UMTCAP_itu_asn1_dialoguePortion *itu_dialoguePortion = NULL;
    if((xdialogProtocolVersion) || (xapplicationContext) || (xuserInfo))
    {
        itu_dialoguePortion = [[UMTCAP_itu_asn1_dialoguePortion alloc]init];
        itu_dialoguePortion.dialogRequest = [[UMTCAP_asn1_AARQ_apdu alloc]init];
        itu_dialoguePortion.dialogRequest.protocolVersion = xdialogProtocolVersion;
        itu_dialoguePortion.dialogRequest.objectIdentifier = xapplicationContext;
        itu_dialoguePortion.dialogRequest.user_information = xuserInfo;
    }
    return [super initForTcap:xtcap
                transactionId:xtransactionId
                 userDialogId:xuserDialogId
                      variant:xvariant
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

    UMTCAP_itu_asn1_begin *q = [[UMTCAP_itu_asn1_begin alloc]init];
    UMTCAP_itu_asn1_otid *otid = [[UMTCAP_itu_asn1_otid alloc]init];
    
    if(transactionId == NULL)
    {
        NSLog(@"why is the transaction ID not yet set?!?");
        transactionId = [tcap getNewTransactionId];
    }

    otid.transactionId = transactionId;

    q.otid = otid;
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
    [t touch];
}

@end
