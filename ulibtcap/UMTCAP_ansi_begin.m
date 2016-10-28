//
//  UMTCAP_ansi_begin.m
//  ulibtcap
//
//  Created by Andreas Fink on 05/04/16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_begin.h"
#import "UMTCAP_ansi_asn1_transactionPDU.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_ansi_asn1_dialoguePortion.h"
@implementation UMTCAP_ansi_begin


- (void)main
{
    UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];

    UMTCAP_ansi_asn1_transactionPDU *q;
    
    if(options[@"ansi-without-permission"])
    {
        q = [[UMTCAP_ansi_asn1_queryWithoutPerm alloc]init];
    }
    else
    {
        q = [[UMTCAP_ansi_asn1_queryWithPerm alloc]init];
    }

    UMTCAP_ansi_asn1_transactionID *tid = [[UMTCAP_ansi_asn1_transactionID alloc]init];
    tid.tid = transactionId;
    
    UMTCAP_ansi_asn1_componentSequence *compSequence = [[UMTCAP_ansi_asn1_componentSequence alloc]init];
    for(id item in components)
    {
        [compSequence addComponent:(UMTCAP_ansi_asn1_componentPDU *)item];
    }

    if(applicationContext)
    {
        q.dialogPortion = [[UMTCAP_ansi_asn1_dialoguePortion alloc]initWithASN1Object:applicationContext context:self];
    }
    else
    {
        q.dialogPortion = NULL;
    }
    
    q.identifier = tid;
    q.componentPortion = compSequence;
    
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
