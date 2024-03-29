//
//  UMTCAP_itu_asn1_dialoguePortion.h
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import <ulibtcap/UMTCAP_asn1_AARQ_apdu.h>
#import <ulibtcap/UMTCAP_asn1_AARE_apdu.h>
#import <ulibtcap/UMTCAP_asn1_ABRT_apdu.h>
#import <ulibtcap/UMTCAP_asn1_external.h>
#import <ulibtcap/UMTCAP_asn1_dialoguePortion.h>
/*

 DialoguePDU ::= CHOICE {
 dialogueRequest   AARQ-apdu,
 dialogueResponse  AARE-apdu,
 dialogueAbort     ABRT-apdu
 }

AARQ-apdu ::= [APPLICATION 0] IMPLICIT SEQUENCE {
  protocol-version
    [0] IMPLICIT BIT STRING {version1(0)} DEFAULT {version1},
  application-context-name  [1]  OBJECT IDENTIFIER,
  user-information          [30] IMPLICIT SEQUENCE OF EXTERNAL OPTIONAL
}

AARE-apdu ::= [APPLICATION 1] IMPLICIT SEQUENCE {
  protocol-version
    [0] IMPLICIT BIT STRING {version1(0)} DEFAULT {version1},
  application-context-name  [1]  OBJECT IDENTIFIER,
  result                    [2]  Associate-result,
  result-source-diagnostic  [3]  Associate-source-diagnostic,
  user-information          [30] IMPLICIT SEQUENCE OF EXTERNAL OPTIONAL
}

-- RLRQ PDU is currently not used.
-- It is included for completeness only.
RLRQ-apdu ::= [APPLICATION 2] IMPLICIT SEQUENCE {
  reason            [0] IMPLICIT Release-request-reason OPTIONAL,
  user-information  [30] IMPLICIT SEQUENCE OF EXTERNAL OPTIONAL
}

-- RLRE PDU is currently not used.
-- It is included for completeness only
RLRE-apdu ::= [APPLICATION 3] IMPLICIT SEQUENCE {
  reason            [0] IMPLICIT Release-response-reason OPTIONAL,
  user-information  [30] IMPLICIT SEQUENCE OF EXTERNAL OPTIONAL
}

ABRT-apdu ::= [APPLICATION 4] IMPLICIT SEQUENCE {
  abort-source      [0] IMPLICIT ABRT-source,
  user-information  [30] IMPLICIT SEQUENCE OF EXTERNAL OPTIONAL
}

ABRT-source ::= INTEGER {dialogue-service-user(0), dialogue-service-provider(1)
}

Associate-result ::= INTEGER {accepted(0), reject-permanent(1)}

Associate-source-diagnostic ::= CHOICE {
  dialogue-service-user
    [1]  INTEGER {null(0), no-reason-given(1),
                  application-context-name-not-supported(2)},
  dialogue-service-provider
    [2]  INTEGER {null(0), no-reason-given(1), no-common-dialogue-portion(2)}
}

*/

@interface UMTCAP_itu_asn1_dialoguePortion : UMTCAP_asn1_dialoguePortion
{
    UMTCAP_asn1_AARQ_apdu *dialogRequest;
    UMTCAP_asn1_AARE_apdu *dialogResponse;
    UMTCAP_asn1_ABRT_apdu *dialogAbort;
    UMTCAP_asn1_external *external;
}

@property(readwrite,strong) UMTCAP_asn1_AARQ_apdu *dialogRequest;
@property(readwrite,strong) UMTCAP_asn1_AARE_apdu *dialogResponse;
@property(readwrite,strong) UMTCAP_asn1_ABRT_apdu *dialogAbort;
@property(readwrite,strong) UMTCAP_asn1_external *external;

@end
