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

#import <ulibtcap/UMTCAP_itu_continue.h>
#import <ulibtcap/UMTCAP_itu_asn1_continue.h>
#import <ulibtcap/UMTCAP_Transaction.h>
#import "UMLayerTCAP.h"
#import <ulibtcap/UMTCAP_itu_asn1_dialoguePortion.h>

@implementation UMTCAP_itu_continue

- (void)main
{
    @autoreleasepool
    {
        UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];
        UMTCAP_itu_asn1_continue *q = [[UMTCAP_itu_asn1_continue alloc]init];
        _operationEncoding = t.operationEncoding;
        q.classEncoding = UMTCAP_itu_classEncoding_Application;

        if(components_itu.count>0)
        {
            UMTCAP_itu_asn1_componentPortion *componentsPortion = [[UMTCAP_itu_asn1_componentPortion alloc]init];
            for(UMTCAP_itu_asn1_componentPDU *item in components_itu)
            {
                if(_operationEncoding != UMTCAP_itu_operationCodeEncoding_default)
                {
                    item.operationCodeEncoding = _operationEncoding;
                }
                [componentsPortion addComponent:item];
            }
            q.componentPortion = componentsPortion;
        }
        
        if(transactionId)
        {
            UMTCAP_itu_asn1_otid *otid = [[UMTCAP_itu_asn1_otid alloc]init];
            otid.transactionId = transactionId;
            q.otid = otid;
        }
        if((t.remoteTransactionId) && !(t.noDestinationTransationIdInContinue))
        {
            UMTCAP_itu_asn1_dtid *dtid;
            if(t.doubleOriginationTransationIdInContinue)
            {
                dtid =(UMTCAP_itu_asn1_dtid *)[[UMTCAP_itu_asn1_otid alloc]init];
            }
            else
            {
                dtid = [[UMTCAP_itu_asn1_dtid alloc]init];
            }
            dtid.transactionId = t.remoteTransactionId;
            q.dtid = dtid;
        }
        q.dialoguePortion = (UMTCAP_itu_asn1_dialoguePortion *)dialoguePortion;
        
        NSData *pdu = [q berEncoded];
        [tcap.attachedLayer sccpNUnidata:pdu
                            callingLayer:tcap
                                 calling:callingAddress
                                  called:calledAddress
                        qualityOfService:_sccpQoS
                                   class:_sccpServiceClass
                                handling:_sccpHandling
                                 options:options];

        [t touch];
    }
}
@end
