//
//  UMTCAP_asn1_userInformationIdentification.h
//  ulibtcap
//
//  Created by Andreas Fink on 05.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibasn1/ulibasn1.h>
#import <ulibtcap/UMTCAP_asn1_contextNegotiation.h>
/*

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
 */

@interface UMTCAP_asn1_userInformationIdentification : UMASN1Choice
{
    UMASN1ObjectIdentifier          *_syntax;
    UMASN1Integer                   *_presentationContextId;
    UMTCAP_asn1_contextNegotiation  *_contextNegotiation;
    UMASN1ObjectDescriptor          *_dataValueDescriptor;
    UMASN1OctetString               *_dataValue;
}
@property(readwrite,strong)     UMASN1ObjectIdentifier          *syntax;
@property(readwrite,strong)     UMASN1Integer                   *presentationContextId;
@property(readwrite,strong)     UMTCAP_asn1_contextNegotiation  *contextNegotiation;
@property(readwrite,strong)     UMASN1ObjectDescriptor          *dataValueDescriptor;
@property(readwrite,strong)     UMASN1OctetString               *dataValue;

@end
