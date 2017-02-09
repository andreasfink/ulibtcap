//
//  UMTCAP_ansi_asn1_problem.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_problem.h"

@implementation UMTCAP_ansi_asn1_problem

- (void)setProblemCode:(UMTCAP_ansi_asn1_problem_code) code
{
    self.value = code;
}

- (UMTCAP_ansi_asn1_problem_code)problemCode
{
    return (int)self.value;
}

- (NSString *)stringValue
{
    int v = (int)self.value;
    NSString *d;
    switch(v)
    {
        case ProblemCode_general_unrecognisedComponentType:
            d = @"general_unrecognisedComponentType";
            break;
        case ProblemCode_general_incorrectComponentPortion:
            d = @"general_incorrectComponentPortion";
            break;
        case ProblemCode_general_badlyStructuredCompPortion:
            d = @"general_badlyStructuredCompPortion";
            break;
        case ProblemCode_general_incorrectComponentCoding:
            d = @"general_incorrectComponentCoding";
            break;
        case ProblemCode_invoke_duplicateInvocation:
            d = @"invoke_duplicateInvocation";
            break;
        case ProblemCode_invoke_unrecognisedOperation:
            d = @"invoke_unrecognisedOperation";
            break;
        case ProblemCode_invoke_incorrectParameter:
            d = @"invoke_incorrectParameter";
            break;
        case ProblemCode_invoke_unrecognisedCorrelationID:
            d = @"invoke_unrecognisedCorrelationID";
            break;
        case ProblemCode_returnResult_unrecognisedCorrelationID:
            d = @"returnResult_unrecognisedCorrelationID";
            break;
        case ProblemCode_returnResult_unexpectedReturnResult:
            d = @"returnResult_unexpectedReturnResult";
            break;
        case ProblemCode_returnResult_incorrectParameter:
            d = @"returnResult_incorrectParameter";
            break;
        case ProblemCode_returnError_unrecognisedCorrelationID:
            d = @"returnError_unrecognisedCorrelationID";
            break;
        case ProblemCode_returnError_unexpectedReturnError:
            d = @"returnError_unexpectedReturnError";
            break;
        case ProblemCode_returnError_unrecognisedError:
            d = @"returnError_unrecognisedError";
            break;
        case ProblemCode_returnError_unexpectedError:
            d = @"returnError_unexpectedError";
            break;
        case ProblemCode_returnError_incorrectParameter:
            d = @"returnError_incorrectParameter";
            break;
        case ProblemCode_transaction_unrecognizedPackageType:
            d = @"transaction_unrecognizedPackageType";
            break;
        case ProblemCode_transaction_incorrectTransPortion:
            d = @"transaction_incorrectTransPortion";
            break;
        case ProblemCode_transaction_badlyStructuredTransPortion:
            d = @"transaction_badlyStructuredTransPortion";
            break;
        case ProblemCode_transaction_unassignedRespondingTransID:
            d = @"transaction_unassignedRespondingTransID";
            break;
        case ProblemCode_transaction_permissionToReleaseProblem:
            d = @"transaction_permissionToReleaseProblem";
            break;
        case ProblemCode_transaction_resourceUnavailable:
            d = @"transaction_resourceUnavailable";
            break;
        default:
            d = @"(undefined)";
            break;
    }
    return [NSString stringWithFormat:@"%@ %@",super.stringValue,d];
}

- (NSString *)objectName
{
    return @"problem";
}

- (id)objectValue
{
    return [self stringValue];
}

@end
