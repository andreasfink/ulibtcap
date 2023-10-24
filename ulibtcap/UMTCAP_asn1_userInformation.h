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
#import <ulibtcap/UMTCAP_asn1_userInformationIdentification.h>

/*

 user-information          [30] IMPLICIT SEQUENCE OF [UNIVERSAL 8] IMPLICIT SEQUENCE
 {
    identification CHOICE
    {
        syntax OBJECT IDENTIFIER,
        presentation-context-id INTEGER,
        context-negotiation SEQUENCE
        {
            presentation-context-id INTEGER,
            transfer-syntax OBJECT IDENTIFIER
        }
        data-value-descriptor ObjectDescriptor OPTIONAL,
        data-value OCTET STRING
    }
 } OPTIONAL
 */

#import <ulibtcap/UMTCAP_asn1_external.h>

@interface UMTCAP_asn1_userInformation : UMASN1Sequence
{
    UMSynchronizedArray *identifications; /* array of UMTCAP_asn1_external objects */
}

- (void) addIdentification:(UMTCAP_asn1_external *)identification;
- (NSInteger)getIdentificationCount;
- (UMTCAP_asn1_external *)getIdentificationNumber:(NSInteger)i;
@end
