//
//  UMTCAP_asn1_userInformation.h
//  ulibtcap
//
//  Created by Andreas Fink on 26.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>
#import <ulibasn1/ulibasn1.h>

/*
 {
	identification CHOICE {
 syntax OBJECT IDENTIFIER,
 presentation-context-id INTEGER,
 context-negotiation SEQUENCE {
 presentation-context-id INTEGER,
 transfer-syntax OBJECT IDENTIFIER
 }
	},
	data-value-descriptor ObjectDescriptor OPTIONAL,
	data-value OCTET STRING
 }
 */

#import "UMTCAP_asn1_external.h"

@interface UMTCAP_asn1_userInformation : UMTCAP_asn1_external //UMASN1Sequence
{
    UMTCAP_asn1_external *external;
}

@property(readwrite,strong)    UMTCAP_asn1_external *external;

@end
