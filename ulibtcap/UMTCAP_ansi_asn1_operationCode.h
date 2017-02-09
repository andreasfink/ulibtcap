//
//  UMTCAP_ansi_asn1_operationCode
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

@interface UMTCAP_ansi_asn1_operationCode : UMASN1ObjectPrimitive
{
    BOOL isNational;
    int64_t operationCode;
    int64_t family;
}

@property(readwrite,assign) BOOL isNational;
@property(readwrite,assign) int64_t operationCode;
@property(readwrite,assign) int64_t family;

@end
