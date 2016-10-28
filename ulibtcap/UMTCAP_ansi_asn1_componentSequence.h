//
//  UMTCAP_ansi_asn1_componentSequence.h
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

@class UMTCAP_ansi_asn1_componentPDU;

@interface UMTCAP_ansi_asn1_componentSequence : UMASN1ObjectConstructed

- (void)addComponent:(UMTCAP_ansi_asn1_componentPDU *)component;

@end
