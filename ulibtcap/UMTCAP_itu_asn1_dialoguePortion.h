//
//  UMTCAP_itu_asn1_dialoguePortion.h
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_asn1_AARQ_apdu.h"
#import "UMTCAP_asn1_AARE_apdu.h"
#import "UMTCAP_asn1_ABRT_apdu.h"
#import "UMTCAP_asn1_external.h"
#import "UMTCAP_asn1_dialoguePortion.h"

@interface UMTCAP_itu_asn1_dialoguePortion : UMTCAP_asn1_dialoguePortion
{
    UMTCAP_asn1_AARQ_apdu *dialogRequest;
    UMTCAP_asn1_AARE_apdu *dialogResponse;
    UMTCAP_asn1_ABRT_apdu *dialogAbort;
    UMTCAP_asn1_external *external;
}

@property(readwrite,strong) UMTCAP_asn1_AARQ_apdu *dialogRequest;
@property(readwrite,strong) UMTCAP_asn1_AARE_apdu *dialogResponse;
@property(readwrite,strong) UMTCAP_asn1_ABRT_apdu *dialogAbort;
@property(readwrite,strong) UMTCAP_asn1_external *external;

@end
