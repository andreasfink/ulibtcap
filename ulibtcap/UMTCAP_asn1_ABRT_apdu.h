//
//  UMTCAP_asn1_dialogueAbort.h
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
#import "UMTCAP_asn1_AbortSource.h"
#import "UMTCAP_asn1_userInformation.h"

/*
 ABRT-apdu ::= [APPLICATION 4] IMPLICIT SEQUENCE {
 abort-source      [0] IMPLICIT ABRT-source,
 user-information  [30] IMPLICIT SEQUENCE OF EXTERNAL OPTIONAL
 }

 ABRT-source ::= INTEGER {dialogue-service-user(0), dialogue-service-provider(1)
 }

 */
@interface UMTCAP_asn1_ABRT_apdu : UMASN1Sequence
{
    UMTCAP_asn1_AbortSource     *_abortSource;
    UMTCAP_asn1_userInformation *_userInformation;
}

@property(readwrite,strong,atomic)  UMTCAP_asn1_AbortSource     *abortSource;
@property(readwrite,strong,atomic)  UMTCAP_asn1_userInformation *userInformation;

@end
