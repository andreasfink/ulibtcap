//
//  UMTCAP_ansi_asn1_Reject.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_reject.h"
/*
 
 Reject ::= SEQUENCE
 {
    componentID [PRIVATE 15] IMPLICIT OCTET STRING SIZE(0..1),
    rejectProblem[PRIVATE 21] IMPLICIT Problem,
    parameter  CHOICE 
    {
        paramSequence[PRIVATE 16] IMPLICIT SEQUENCE { },
        paramSet [PRIVATE 18] IMPLICIT SET { }
    }   ––The choice between paramSequence and paramSet is
        -- implementation dependent, however paramSequence
        -- is preferred.
 }
 (CONSTRAINED BY { -- must conform to the above definition  -- }
 ! RejectProblem : general–incorrectComponentPortion )
 (CONSTRAINED BY { -- must have consistent encoding  -- }
 ! RejectProblem : general–badlyStructuredCompPortion )
 (CONSTRAINED BY { -- must conform to ANSI T1.114.3 encoding rules  -- }
 ! RejectProblem : general–incorrectComponentCoding )
*/

@implementation UMTCAP_ansi_asn1_reject

@synthesize rejectProblem;
@synthesize paramSequence;
@synthesize paramSet;


- (UMTCAP_ansi_asn1_reject *)processAfterDecodeWithContext:(id)context
{

    componentID = [self getPrivateObjectWithTagNumber:15];
    rejectProblem = [self getPrivateObjectWithTagNumber:21];
    paramSequence = [self getPrivateObjectWithTagNumber:16];
    paramSet = [self getPrivateObjectWithTagNumber:18];
    
    if(paramSet && paramSequence)
    {
        @throw([NSException exceptionWithName:@"Reject can only contain a choice between  paramSequence and paramSet but not both" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagNumber = 12;
    
    asn1_list = [[NSMutableArray alloc]init];
    
    if(ansi_componentIDs)
    {
        ansi_componentIDs.asn1_tag.tagNumber = 15;
        [asn1_list addObject:ansi_componentIDs];
    }
    else
    {
        @throw([NSException exceptionWithName:@"MANDATORY_PARAM_MISSING"
                                       reason:NULL
                                     userInfo:@{
                                                @"sysmsg" : @"componentID is mandatory in returnError",
                                                @"func": @(__func__),
                                                @"backtrace": UMBacktrace(NULL,0)
                                                }
                ]);
    }
    if(rejectProblem)
    {
        rejectProblem.asn1_tag.tagNumber = 21;
        [asn1_list addObject:rejectProblem];
    }
    else
    {
        @throw([NSException exceptionWithName:@"MANDATORY_PARAM_MISSING"
                                       reason:NULL
                                     userInfo:@{
                                                @"sysmsg" : @"errorCode is mandatory in returnError",
                                                @"func": @(__func__),
                                                @"backtrace": UMBacktrace(NULL,0)
                                                }
                ]);
    }
    if(paramSequence)
    {
        paramSequence.asn1_tag.tagNumber = 16;
        [asn1_list addObject:paramSequence];
    }
    else if(paramSet)
    {
        paramSet.asn1_tag.tagNumber = 16;
        [asn1_list addObject:paramSet];
    }
    else
    {
        @throw([NSException exceptionWithName:@"MANDATORY_PARAM_MISSING"
                                       reason:NULL
                                     userInfo:@{
                                                @"sysmsg" : @"paramSequence or paramSet are mandatory in reject",
                                                @"func": @(__func__),
                                                @"backtrace": UMBacktrace(NULL,0)
                                                }
                ]);
    }
}

- (NSString *)objectName
{
    return @"reject";
}

@end
