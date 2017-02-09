//
//  UMTCAP_ansi_asn1_problem.h
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>



typedef    enum UMTCAP_ansi_asn1_problem_code
{
    ProblemCode_general_unrecognisedComponentType = 257,
    ProblemCode_general_incorrectComponentPortion = 258,
    ProblemCode_general_badlyStructuredCompPortion = 259,
    ProblemCode_general_incorrectComponentCoding = 260,
    ProblemCode_invoke_duplicateInvocation = 513,
    ProblemCode_invoke_unrecognisedOperation = 514,
    ProblemCode_invoke_incorrectParameter = 515,
    ProblemCode_invoke_unrecognisedCorrelationID = 516,
    ProblemCode_returnResult_unrecognisedCorrelationID = 769,
    ProblemCode_returnResult_unexpectedReturnResult = 770,
    ProblemCode_returnResult_incorrectParameter = 771,
    ProblemCode_returnError_unrecognisedCorrelationID = 1025,
    ProblemCode_returnError_unexpectedReturnError = 1026,
    ProblemCode_returnError_unrecognisedError = 1027,
    ProblemCode_returnError_unexpectedError = 1028,
    ProblemCode_returnError_incorrectParameter = 1029,
    ProblemCode_transaction_unrecognizedPackageType = 1281,
    ProblemCode_transaction_incorrectTransPortion = 1282,
    ProblemCode_transaction_badlyStructuredTransPortion = 1283,
    ProblemCode_transaction_unassignedRespondingTransID = 1284,
    ProblemCode_transaction_permissionToReleaseProblem = 1285,
    ProblemCode_transaction_resourceUnavailable = 1286,
} UMTCAP_ansi_asn1_problem_code;

@interface UMTCAP_ansi_asn1_problem : UMASN1Integer

- (void)setProblemCode:(UMTCAP_ansi_asn1_problem_code) code;
- (UMTCAP_ansi_asn1_problem_code)problemCode;

@end
