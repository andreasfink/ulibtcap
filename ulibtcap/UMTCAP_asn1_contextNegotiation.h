//
//  UMTCAP_asn1_contextNegotiation.h
//  ulibtcap
//
//  Created by Andreas Fink on 05.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibasn1/ulibasn1.h>

/*

 context-negotiation SEQUENCE
 {
    presentation-context-id INTEGER,
    transfer-syntax OBJECT IDENTIFIER
 }
*/

@interface UMTCAP_asn1_contextNegotiation : UMASN1Sequence
{
    UMASN1Integer           *_presentationContextId;
    UMASN1ObjectIdentifier  *_transferSyntax;
}

@property(readwrite,strong) UMASN1Integer           *presentationContextId;
@property(readwrite,strong) UMASN1ObjectIdentifier  *transferSyntax;

@end
