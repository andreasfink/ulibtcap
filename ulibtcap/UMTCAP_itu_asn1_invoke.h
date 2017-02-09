//
//  UMTCAP_itu_asn1_invoke.h
//  ulibtcap
//
//  Created by Andreas Fink on 29/03/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_itu_asn1_componentPDU.h"
/*
 
 Invoke ::= SEQUENCE
 {
	invokeID 		InvokeIdType,
	linkedID 		[0] IMPLICIT InvokeIdType OPTIONAL,
	operationCode 	OperationCode,
	parameter 		ANY DEFINED BY operationCode OPTIONAL
 }
*/

@interface UMTCAP_itu_asn1_invoke : UMTCAP_itu_asn1_componentPDU
{
}


@end
