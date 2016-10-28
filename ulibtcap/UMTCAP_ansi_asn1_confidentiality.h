//
//  UMTCAP_ansi_an1_confidentiality.h
//  ulibtcap
//
//  Created by Andreas Fink on 05/04/16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

@interface UMTCAP_ansi_asn1_confidentiality : UMASN1ObjectConstructed
{
    UMASN1Integer *ci;
    UMASN1Object *co;
}
@end
