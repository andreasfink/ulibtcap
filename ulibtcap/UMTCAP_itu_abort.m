//
//  UMTCAP_itu_abort.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.


#import "UMLayerTCAP.h"
#import "UMTCAP_abort.h"
#import "UMTCAP_itu_abort.h"
#import "UMTCAP_itu_asn1_abort.h"
#import "UMTCAP_itu_asn1_dialoguePortion.h"
#import "UMTCAP_itu_asn1_otid.h"

@implementation UMTCAP_itu_abort


- (void)main
{

    if(_tcap.logLevel <= UMLOG_DEBUG)
    {
        [_tcap.logFeed debugText:[NSString stringWithFormat:@"UMTCAP_itu_abort for transaction %@",_transactionId]];
    }

    UMTCAP_Transaction *t = [_tcap findTransactionByLocalTransactionId:_transactionId];
    UMTCAP_itu_asn1_abort *q = [[UMTCAP_itu_asn1_abort alloc]init];
    UMTCAP_itu_asn1_dtid *dtid = [[UMTCAP_itu_asn1_dtid alloc]init];
    dtid.transactionId = t.remoteTransactionId;
    q.dtid = dtid;
    q.uAbortCause = (UMTCAP_itu_asn1_dialoguePortion *)_dialoguePortion;

    if(!_dialoguePortion)
    {
        q.pAbortCause = [[UMTCAP_itu_asn1_pAbortCause alloc]initWithValue:_pAbortCause];
    }

    [t touch];
    if(_tcap.logLevel <= UMLOG_DEBUG)
    {
        [_tcap.logFeed debugText:[NSString stringWithFormat:@" transaction %@: encoding PDU now",_transactionId]];
    }

    NSData *pdu;
    @try
    {
        pdu = [q berEncoded];
    }
    @catch(NSException *e)
    {
        [_tcap.logFeed majorErrorText:[NSString stringWithFormat:@"BER encoding of PDU failed with exception %@",e]];
    }
    if(pdu)
    {
        if(_tcap.logLevel <= UMLOG_DEBUG)
        {
            NSString *s = [NSString stringWithFormat:@"Sending PDU to %@: %@",_tcap.attachedLayer.layerName, pdu];
            [_tcap.logFeed debugText:s];
        }
        [_tcap.attachedLayer sccpNUnidata:pdu
                             callingLayer:_tcap
                                  calling:_callingAddress
                                   called:_calledAddress
                         qualityOfService:0
                                    class:SCCP_CLASS_BASIC
                                 handling:UMSCCP_HANDLING_RETURN_ON_ERROR
                                  options:_options];
    }
    if(_tcap.logLevel <= UMLOG_DEBUG)
    {
        [_tcap.logFeed debugText:[NSString stringWithFormat:@" done with sending tcapAbort for transaction %@",_transactionId]];
    }
    t.transactionIsClosed = YES;
}

@end

