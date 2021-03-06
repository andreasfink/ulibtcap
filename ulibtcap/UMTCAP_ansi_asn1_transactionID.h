//
//  UMTCAP_ansi_asn1_transactionID.h
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

/* ::= [PRIVATE 7] IMPLICIT OCTET STRING */
@interface UMTCAP_ansi_asn1_transactionID : UMASN1OctetString
{
    NSString *tid;
}

@property(readwrite,strong)     NSString *tid;

@end
