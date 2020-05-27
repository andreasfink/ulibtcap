//
//  UMTCAP_itu_begin.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
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
#import "UMTCAP_Transaction.h"

@implementation UMTCAP_itu_begin


- (void)main
{
    @autoreleasepool
    {

        if(tcap.logLevel <= UMLOG_DEBUG)
        {
            [tcap.logFeed debugText:[NSString stringWithFormat:@"UMTCAP_itu_begin for transaction %@",transactionId]];
        }

        UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];
        UMTCAP_itu_asn1_begin *q = [[UMTCAP_itu_asn1_begin alloc]init];
        UMTCAP_itu_asn1_otid *otid = [[UMTCAP_itu_asn1_otid alloc]init];
        
        if(transactionId == NULL)
        {
            [tcap.logFeed majorErrorText:@"why is the transaction ID not yet set?!?"];
            transactionId = [tcap getNewTransactionId];
        }

        otid.transactionId = transactionId;

        q.otid = otid;
        q.dialoguePortion = (UMTCAP_itu_asn1_dialoguePortion *)dialoguePortion;
            
        if(components.count > 0)
        {
            if(tcap.logLevel <= UMLOG_DEBUG)
            {
                [tcap.logFeed debugText:[NSString stringWithFormat:@" transaction %@: components count = %d",transactionId,(int)components.count]];
            }
            UMTCAP_itu_asn1_componentPortion *componentsPortion = [[UMTCAP_itu_asn1_componentPortion alloc]init];
            for(id item in components)
            {
                [componentsPortion addComponent:(UMTCAP_itu_asn1_componentPDU *)item];
            }
            q.componentPortion = componentsPortion;
        }
        else
        {
            [tcap.logFeed majorErrorText:@"componentsCount is zero"];
        }
        [t touch];
        if(tcap.logLevel <= UMLOG_DEBUG)
        {
            [tcap.logFeed debugText:[NSString stringWithFormat:@" transaction %@: encoding PDU now",transactionId]];
        }

        NSData *pdu;
        @try
        {
            pdu = [q berEncoded];
        }
        @catch(NSException *e)
        {
            [tcap.logFeed majorErrorText:[NSString stringWithFormat:@"BER encoding of PDU failed with exception %@",e]];
        }
        if(pdu)
        {
            if(tcap.logLevel <= UMLOG_DEBUG)
            {
                NSString *s = [NSString stringWithFormat:@"Sending PDU to %@: %@", tcap.attachedLayer.layerName, pdu];
                [tcap.logFeed debugText:s];
            }
            [tcap.attachedLayer sccpNUnidata:pdu
                                callingLayer:tcap
                                     calling:callingAddress
                                      called:calledAddress
                            qualityOfService:0
                                       class:SCCP_CLASS_BASIC
                                    handling:SCCP_HANDLING_RETURN_ON_ERROR
                                     options:options];
        }
        if(tcap.logLevel <= UMLOG_DEBUG)
        {
            [tcap.logFeed debugText:[NSString stringWithFormat:@" done with sending tcapBegin for transaction %@",transactionId]];
        }
    }
}

@end
