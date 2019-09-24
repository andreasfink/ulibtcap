//
//  UMTCAP_itu_continue.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
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

- (void)main
{
    UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];
    UMTCAP_itu_asn1_continue *q = [[UMTCAP_itu_asn1_continue alloc]init];
    
    if(components_itu.count>0)
    {
        UMTCAP_itu_asn1_componentPortion *componentsPortion = [[UMTCAP_itu_asn1_componentPortion alloc]init];
        for(UMTCAP_itu_asn1_componentPDU *item in components_itu)
        {
            [componentsPortion addComponent:item];
        }
        q.componentPortion = componentsPortion;
    }
    
    UMTCAP_itu_asn1_otid *otid = [[UMTCAP_itu_asn1_otid alloc]init];
    UMTCAP_itu_asn1_dtid *dtid = [[UMTCAP_itu_asn1_dtid alloc]init];
    otid.transactionId = transactionId;
    dtid.transactionId = t.remoteTransactionId;
    
    q.otid = otid;
    q.dtid = dtid;
    q.dialoguePortion = (UMTCAP_itu_asn1_dialoguePortion *)dialoguePortion;
    
    NSData *pdu = [q berEncoded];
    [tcap.attachedLayer sccpNUnidata:pdu
                        callingLayer:tcap
                             calling:callingAddress
                              called:calledAddress
                    qualityOfService:0
                               class:SCCP_CLASS_BASIC
                            handling:SCCP_HANDLING_RETURN_ON_ERROR
                             options:options];
    [t touch];
}

@end
