//
//  UMTCAP_itu_end.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright (c) 2016 Andreas Fink
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


- (void)main
{
    UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];
    UMTCAP_itu_asn1_end *q = [[UMTCAP_itu_asn1_end alloc]init];

    UMTCAP_itu_asn1_dtid *dtid = [[UMTCAP_itu_asn1_dtid alloc]init];
    dtid.transactionId = t.remoteTransactionId;
    q.dtid = dtid;

    if(applicationContext)
    {
        q.dialoguePortion = [[UMTCAP_itu_asn1_dialoguePortion alloc]init];
        q.dialoguePortion.dialogResponse = [[UMTCAP_asn1_AARE_apdu alloc]init];

        unsigned char byte = 0x80 ;
        NSData *d = [NSData dataWithBytes:&byte length:1];

        q.dialoguePortion.dialogResponse.protocolVersion = [[UMASN1BitString alloc]initWithValue:d bitcount:1];
        q.dialoguePortion.dialogResponse.protocolVersion.asn1_tag.tagNumber = 0;
        q.dialoguePortion.dialogResponse.protocolVersion.asn1_tag.tagClass = UMASN1Class_ContextSpecific;

        q.dialoguePortion.dialogResponse.objectIdentifier = applicationContext;
        q.dialoguePortion.dialogResponse.result = [[UMTCAP_asn1_Associate_result alloc]initWithValue:0];
        q.dialoguePortion.dialogResponse.result_source_diagnostic = [[UMTCAP_asn1_Associate_source_diagnostic alloc]init];
        q.dialoguePortion.dialogResponse.result_source_diagnostic.dialogue_service_user =[[UMASN1Integer alloc]initWithValue:0];
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
    t.transactionIsClosed = YES;
}

@end
