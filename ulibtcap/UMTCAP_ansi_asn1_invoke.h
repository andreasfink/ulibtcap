//
//  UMTCAP_ansi_asn1_Invoke.h
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import <ulibtcap/UMTCAP_ansi_asn1_componentPDU.h>

/*
 Invoke{ InvokeID: InvokeIdSet, OPERATION: Operations } ::= SEQUENCE { componentIDs [PRIVATE 15] IMPLICIT OCTET STRING SIZE(0..2)
T1.114.3-32
ATIS-1000114.2004
Chapter T1.114.3
– The invoke ID precedes the correlation id.  There may be no
-- identifier,only an invoke ID, or both invoke and correlation
-- ID’s.
(CONSTRAINED BY { -- must be unambiguous -- }
! RejectProblem : invoke–duplicateInvocation ),
(CONSTRAINED BY {   -- correlation ID must identify an
                    -- outstanding operation  -- }
! RejectProblem : invoke–unrecognisedCorrelationId )
       OPTIONAL,
operationCode
parameter
OPERATION.&operationCode
((Operations)
! RejectProblem : invoke–unrecognisedOperation),
OPERATION.&ParameterType
((Operations)(@Opcode)
! RejectProblem : invoke-mistypedArgument ) OPTIONAL
       }
       (CONSTRAINED BY { -- must conform to the above definition -- }
       ! RejectProblem : general–incorrectComponentPortion )
       (CONSTRAINED BY { -- must have consistent encoding  -- }
       ! RejectProblem : general–badlyStructuredCompPortion )
       (CONSTRAINED BY { -- must conform to ANSI T1.114.3 encoding rules  -- }
       ! RejectProblem : general–incorrectComponentCoding )
 
 */

@interface UMTCAP_ansi_asn1_invoke : UMTCAP_ansi_asn1_componentPDU
{
}


@end
