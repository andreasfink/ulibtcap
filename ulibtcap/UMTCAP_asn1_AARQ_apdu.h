//
//  UMTCAP_asn1_dialogRequest.h
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

#import <ulibtcap/UMTCAP_asn1_objectIdentifier.h>
#import <ulibtcap/UMTCAP_asn1_userInformation.h>
/*
 AARQ-apdu ::= [APPLICATION 0] IMPLICIT SEQUENCE {
 protocol-version
 [0] IMPLICIT BIT STRING {version1(0)} DEFAULT {version1},
 application-context-name  [1]  OBJECT IDENTIFIER,
 user-information          [30] IMPLICIT SEQUENCE OF [UNIVERSAL 8] IMPLICIT SEQUENCE {
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
 */

@interface UMTCAP_asn1_AARQ_apdu : UMASN1ObjectConstructed
{
    UMASN1BitString *protocolVersion;
    UMTCAP_asn1_objectIdentifier *objectIdentifier;
    UMTCAP_asn1_userInformation  *user_information;
}

@property(readwrite,strong) UMASN1BitString *protocolVersion;
@property(readwrite,strong) UMTCAP_asn1_objectIdentifier *objectIdentifier;
@property(readwrite,strong) UMTCAP_asn1_userInformation  *user_information;

@end
