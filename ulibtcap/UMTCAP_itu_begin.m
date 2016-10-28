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
    
    if((applicationContext) || (userInfo))
    {
        q.dialoguePortion = [[UMTCAP_itu_asn1_dialoguePortion alloc]init];
        q.dialoguePortion.dialogRequest = [[UMTCAP_asn1_AARQ_apdu alloc]init];
        q.dialoguePortion.dialogRequest.objectIdentifier = applicationContext;
        q.dialoguePortion.dialogRequest.user_information = userInfo;
    }
    else
    {
        q.dialoguePortion = NULL;
    }
    
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
