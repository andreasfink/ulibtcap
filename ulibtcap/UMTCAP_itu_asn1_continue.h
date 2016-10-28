//
//  UMTCAP_itu_asn1_continue.h
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_asn1.h"
#import "UMTCAP_itu_asn1_dialoguePortion.h"
#import "UMTCAP_itu_asn1_componentPortion.h"
#import "UMTCAP_itu_asn1_otid.h"
#import "UMTCAP_itu_asn1_dtid.h"

@interface UMTCAP_itu_asn1_continue : UMTCAP_asn1
{
    UMTCAP_itu_asn1_otid            *otid;
    UMTCAP_itu_asn1_dtid            *dtid;
    UMTCAP_itu_asn1_dialoguePortion *dialoguePortion;
    UMTCAP_itu_asn1_componentPortion *componentPortion;
}

@property(readwrite,strong) UMTCAP_itu_asn1_otid            *otid;
@property(readwrite,strong) UMTCAP_itu_asn1_dtid            *dtid;
@property(readwrite,strong) UMTCAP_itu_asn1_dialoguePortion *dialoguePortion;
@property(readwrite,strong) UMTCAP_itu_asn1_componentPortion *componentPortion;

@end
