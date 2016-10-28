//
//  UMTCAP_itu_asn1_reject.h
//  ulibtcap
//
//  Created by Andreas Fink on 29/03/16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

/*
 Reject ::= SEQUENCE
 {
	invokeID CHOICE
	{
 derivable InvokeIdType,
 not-derivable NULL
	},
	problem CHOICE
	{
 generalProblem [0] IMPLICIT GeneralProblem,
 invokeProblem [1] IMPLICIT InvokeProblem,
 returnResultProblem [2] IMPLICIT ReturnResultProblem,
 returnErrorProblem [3] IMPLICIT ReturnErrorProblem
	}
 }*/

#import "UMTCAP_itu_asn1_componentPDU.h"

@interface UMTCAP_itu_asn1_reject : UMTCAP_itu_asn1_componentPDU
{
    BOOL notDerivable;
    UMASN1Object *problem;
}
@end
