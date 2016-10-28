//
//  UMTCAP_itu_asn1_componentPDU.h
//  ulibtcap
//
//  Created by Andreas Fink on 16.04.16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_generic_asn1_componentPDU.h"

@class UMTCAP_itu_asn1_invoke;
@class UMTCAP_itu_asn1_returnResult;
@class UMTCAP_itu_asn1_returnError;
@class UMTCAP_itu_asn1_reject;

@interface UMTCAP_itu_asn1_componentPDU : UMTCAP_generic_asn1_componentPDU
{
    /* common used fields of all component variants */
    UMASN1Integer *itu_invokeId;
    UMASN1Integer *itu_linkedId;
    UMASN1Integer *itu_operationCode;
}

@property(readwrite,strong) UMASN1Integer *itu_invokeId;
@property(readwrite,strong) UMASN1Integer *itu_linkedId;
@property(readwrite,strong) UMASN1Integer *itu_operationCode;


@end

#define TCAP_ITU_COMPONENT_INVOKE                   1
#define TCAP_ITU_COMPONENT_RETURN_RESULT_LAST       2
#define TCAP_ITU_COMPONENT_RETURN_ERROR             3
#define TCAP_ITU_COMPONENT_REJECT                   4
#define TCAP_ITU_COMPONENT_RETURN_RESULT_NOT_LAST   7

/*
 
 ComponentPortion ::= [APPLICATION 12] IMPLICIT SEQUENCE SIZE (1..MAX) OF Component
Component ::= CHOICE
{
    invoke 				[1] IMPLICIT Invoke,
    returnResultLast 	[2] IMPLICIT ReturnResult,
    returnError			[3] IMPLICIT ReturnError,
    reject 				[4] IMPLICIT Reject,
    returnResultNotLast [7] IMPLICIT ReturnResult
} 

*/
