//
//  UMTCAP_asn1_dialogueAbort.h
//  ulibtcap
//
//  Created by Andreas Fink on 26.04.16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>
#import <ulibasn1/ulibasn1.h>

/*
 -- RLRQ PDU is currently not used.
 -- It is included for completeness only.
 RLRQ-apdu ::= [APPLICATION 2] IMPLICIT SEQUENCE {
 reason            [0] IMPLICIT Release-request-reason OPTIONAL,
 user-information  [30] IMPLICIT SEQUENCE OF [UNIVERSAL 8] IMPLICIT SEQUENCE {
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
 } OPTIONAL
 }

 */
@interface UMTCAP_asn1_ABRT_apdu : UMASN1ObjectConstructed

@end
