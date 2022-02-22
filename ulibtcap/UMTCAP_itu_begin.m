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
        if(_tcap.logLevel <= UMLOG_DEBUG)
        {
            [_tcap.logFeed debugText:[NSString stringWithFormat:@"UMTCAP_itu_begin for transaction %@",_transactionId]];
        }

        UMTCAP_Transaction *t = [_tcap findTransactionByLocalTransactionId:_transactionId];
        UMTCAP_itu_asn1_begin *q = [[UMTCAP_itu_asn1_begin alloc]init];
        UMTCAP_itu_asn1_otid *otid = [[UMTCAP_itu_asn1_otid alloc]init];
        _operationEncoding = t.operationEncoding;
        _classEncoding = t.classEncoding;
        if(_transactionId == NULL)
        {
            [_tcap.logFeed majorErrorText:@"why is the transaction ID not yet set?!?"];
            _transactionId = [_tcap getNewTransactionId];
        }

        otid.transactionId =_transactionId;
        q.classEncoding = _classEncoding;
        q.otid = otid;
        q.dialoguePortion = (UMTCAP_itu_asn1_dialoguePortion *)_dialoguePortion;
        
        if(_components.count > 0)
        {
            if(_tcap.logLevel <= UMLOG_DEBUG)
            {
                [_tcap.logFeed debugText:[NSString stringWithFormat:@" transaction %@: components count = %d",_transactionId,(int)_components.count]];
            }
            UMTCAP_itu_asn1_componentPortion *componentsPortion = [[UMTCAP_itu_asn1_componentPortion alloc]init];
            for(UMTCAP_itu_asn1_componentPDU *item in _components)
            {
                if(_operationEncoding != UMTCAP_itu_operationCodeEncoding_default)
                {
                    item.operationCodeEncoding = _operationEncoding;
                }
                [componentsPortion addComponent:(UMTCAP_itu_asn1_componentPDU *)item];
            }
            q.componentPortion = componentsPortion;
        }
        else
        {
            [_tcap.logFeed majorErrorText:@"componentsCount is zero"];
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
                NSString *s = [NSString stringWithFormat:@"Sending PDU to %@: %@", _tcap.attachedLayer.layerName, pdu];
                [_tcap.logFeed debugText:s];
            }
            [_tcap.attachedLayer sccpNUnidata:pdu
                                callingLayer:_tcap
                                     calling:_callingAddress
                                      called:_calledAddress
                            qualityOfService:_sccpQoS
                                       class:_sccpServiceClass
                                    handling:_sccpHandling
                                     options:_options];
        }
        if(_tcap.logLevel <= UMLOG_DEBUG)
        {
            [_tcap.logFeed debugText:[NSString stringWithFormat:@" done with sending tcapBegin for transaction %@",_transactionId]];
        }
    }
}

@end
