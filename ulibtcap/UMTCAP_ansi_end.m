//
//  UMTCAP_ansi_end.m
//  ulibtcap
//
//  Created by Andreas Fink on 10.10.16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_end.h"

#import "UMLayerTCAP.h"

#import "UMTCAP_ansi_asn1_transactionPDU.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_ansi_asn1_dialoguePortion.h"

@implementation UMTCAP_ansi_end

- (void)main
{
    UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];

    UMTCAP_ansi_asn1_transactionPDU *q;
    if(options[@"ansi-without-permission"])
    {
        q = [[UMTCAP_ansi_asn1_conversationWithoutPerm alloc]init];
    }
    else
    {
        q = [[UMTCAP_ansi_asn1_conversationWithPerm alloc]init];
    }

    //UMTCAP_ansi_asn1_transactionID      *identifier;
    //UMTCAP_ansi_asn1_dialoguePortion    *dialogPortion;
    //UMTCAP_ansi_asn1_componentSequence  *componentPortion;

    UMTCAP_ansi_asn1_transactionID *transactionIdentifier = [[UMTCAP_ansi_asn1_transactionID alloc]init];
    transactionIdentifier.tid = t.remoteTransactionId;
    q.identifier = transactionIdentifier;

    /*
    if(applicationContext)
    {
        q.dialogPortion = [[UMTCAP_ansi_asn1_dialoguePortion alloc]init];
        q.dialogPortion.dialogRequest = [[UMTCAP_asn1_AARQ_apdu alloc]init];
        q.dialogPortion.dialogRequest.objectIdentifier = applicationContext;
    }
    else
    {
        q.dialoguePortion = NULL;
    }
     */
    if(components.count > 0)
    {
        UMTCAP_ansi_asn1_componentSequence *componentsPortion = [[UMTCAP_ansi_asn1_componentSequence alloc]init];
        for(id item in components)
        {
            [componentsPortion addComponent:(UMTCAP_ansi_asn1_componentPDU *)item];
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
