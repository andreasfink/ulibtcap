//
//  UMTCAP_ansi_asn1_returnError.h
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_ansi_asn1_errorCode.h"
#import "UMTCAP_ansi_asn1_componentPDU.h"

@interface UMTCAP_ansi_asn1_returnError : UMTCAP_ansi_asn1_componentPDU
{
    UMTCAP_ansi_asn1_errorCode *_ansiErrorCode;
}


@property(readwrite,strong) UMTCAP_ansi_asn1_errorCode *ansiErrorCode;

@property(readwrite,assign) int64_t errorCodeInt;
@property(readwrite,assign) BOOL errorCodeIsPrivate;
@end
