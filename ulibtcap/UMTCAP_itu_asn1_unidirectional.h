//
//  UMTCAP_itu_asn1_unidirectional.h
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

#import <ulibtcap/UMTCAP_asn1.h>
#import <ulibtcap/UMTCAP_itu_asn1_dialoguePortion.h>
#import <ulibtcap/UMTCAP_itu_asn1_componentPortion.h>
#import <ulibtcap/UMTCAP_itu_asn1_componentPDU.h>

@interface UMTCAP_itu_asn1_unidirectional : UMTCAP_asn1
{
    UMTCAP_itu_classEncoding        _classEncoding;
    UMTCAP_itu_asn1_dialoguePortion *dialoguePortion;
    UMTCAP_itu_asn1_componentPortion *componentPortion;
}


@property(readwrite,strong) UMTCAP_itu_asn1_dialoguePortion *dialoguePortion;
@property(readwrite,strong) UMTCAP_itu_asn1_componentPortion *componentPortion;

@end
