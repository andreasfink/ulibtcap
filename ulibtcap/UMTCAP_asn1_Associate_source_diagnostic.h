//
//  UMTCAP_asn1_Associate_source_diagnostic.h
//  ulibtcap
//
//  Created by Andreas Fink on 03/05/16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

/*
 Associate-source-diagnostic ::= CHOICE {
 dialogue-service-user
 [1]  INTEGER {null(0), no-reason-given(1),
 application-context-name-not-supported(2)},
 dialogue-service-provider
 [2]  INTEGER {null(0), no-reason-given(1), no-common-dialogue-portion(2)}
 }
 
 */

@interface UMTCAP_asn1_Associate_source_diagnostic : UMASN1ObjectConstructed
{
    UMASN1Integer *dialogue_service_user;
    UMASN1Integer *dialogue_service_provider;
}

@property(readwrite,strong) UMASN1Integer * dialogue_service_user;
@property(readwrite,strong) UMASN1Integer * dialogue_service_provider;

@end
