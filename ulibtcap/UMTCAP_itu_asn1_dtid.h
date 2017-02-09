//
//  UMTCAP_itu_asn1_dtid.h
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

@interface UMTCAP_itu_asn1_dtid : UMASN1Object
{
    NSString *transactionId;
}

@property(readwrite,strong) NSString *transactionId;

@end
