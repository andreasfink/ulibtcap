//
//  UMTCAP_ansi_asn1_abortPDU.h
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>


#import "UMTCAP_ansi_asn1_transactionID.h"
#import "UMTCAP_ansi_asn1_dialoguePortion.h"


@interface UMTCAP_ansi_asn1_abortPDU : UMASN1ObjectConstructed
{
    UMTCAP_ansi_asn1_transactionID          *identifier;
    UMTCAP_ansi_asn1_dialoguePortion        *dialogPortion;
    UMASN1Integer                           *abortCause;
    UMASN1Object                            *userInformation;
}


@property(readwrite,strong) UMTCAP_ansi_asn1_transactionID *identifier;
@property(readwrite,strong) UMTCAP_ansi_asn1_dialoguePortion *dialogPortion;
@property(readwrite,strong) UMASN1Integer *abortCause;
@property(readwrite,strong) UMASN1Object *userInformation;

@end

