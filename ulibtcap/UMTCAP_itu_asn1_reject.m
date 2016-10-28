//
//  UMTCAP_itu_asn1_reject.m
//  ulibtcap
//
//  Created by Andreas Fink on 29/03/16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_reject.h"
#import "UMTCAP_sccpNUnitdata.h"

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
 }
*/

@implementation UMTCAP_itu_asn1_reject

- (UMTCAP_itu_asn1_reject *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o0 = [self getObjectAtPosition:0];
    UMASN1Object *o1 = [self getObjectAtPosition:1];
    
    if(!o0)
    {
        @throw([NSException exceptionWithName:@"missing invokeId section in UMTCAP_itu_asn1_returnError" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    if(o0.asn1_length == 0)
    {
        notDerivable=YES;
    }
    else
    {
        itu_invokeId = [[UMASN1Integer alloc]initWithASN1Object:o0 context:context];
    }
    if(!o1)
    {
        @throw([NSException exceptionWithName:@"problem section missing in reject" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    problem = o1;
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    
    asn1_tag.tagNumber = 4;
    asn1_tag.tagClass  = UMASN1Class_Universal;
    
    asn1_list = [[NSMutableArray alloc]init];
    
    if(notDerivable)
    {
        UMASN1Object *o = [[UMASN1Object alloc]init];
        asn1_tag.tagNumber = 0;
        asn1_tag.tagClass= UMASN1Class_Application;
        [asn1_tag setTagIsPrimitive];
        [asn1_list addObject:o];
    }
    else
    {
        [asn1_list addObject:itu_invokeId];
    }
    if(problem==NULL)
    {
        @throw([NSException exceptionWithName:@"missing problem section in reject" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    [asn1_list addObject:problem];
}

- (NSString *)objectName
{
    return @"reject";
}
@end
