//
//  UMTCAP_TransactionInvoke.h
//  ulibtcap
//
//  Created by Andreas Fink on 30.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_Variant.h"
#import "UMTCAP_UserProtocol.h"

@class UMTCAP_Transaction;

@interface UMTCAP_TransactionInvoke : UMObject
{
    NSString *dialogueId;
    NSString *userId;
    UMTCAP_Variant tcapVariant;
    UMTCAP_Transaction *transaction;
    int64_t invokeId;
    NSDate *started;
    NSDate *timeOutTime;
    BOOL nationalOperation;
    UMSynchronizedDictionary *options;
    UMTCAP_generic_asn1_componentPDU *pdu;
}

@property(readwrite,strong) NSString *dialogueId;
@property(readwrite,strong) NSString *userId;
@property(readwrite,assign) UMTCAP_Variant tcapVariant;
@property(readwrite,strong) UMTCAP_Transaction *transaction;
@property(readwrite,assign) int64_t invokeId;
@property(readwrite,strong) NSDate *started;
@property(readwrite,strong) NSDate *timeOutTime;
@property(readwrite,assign) BOOL nationalOperation;
@property(readwrite,strong) UMSynchronizedDictionary *options;
@property(readwrite,strong) UMTCAP_generic_asn1_componentPDU *pdu;





@end
