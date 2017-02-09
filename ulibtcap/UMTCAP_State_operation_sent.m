//
//  UMTCAP_State_operation_sent.m
//  ulibtcap
//
//  Created by Andreas Fink on 27/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_State_operation_sent.h"
#import "UMTCAP_State_wait_for_reject.h"
#import "UMTCAP_State_idle.h"

#import "UMTCAP_Transaction.h"
@implementation UMTCAP_State_operation_sent

- (NSString *)description
{
    return @"UMTCAP_State_operation_sent";
}

-(UMTCAP_State *)eventSend:(UMTCAP_Transaction *)t
{
    NSLog(@"UMTCAP_State_operation_sen: eventSend unexpected");
    return self;
}

-(UMTCAP_State *)eventReceiveWellFormedRRNL:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventReceiveWellFormedRRL:(UMTCAP_Transaction *)t
{
    switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_State_wait_for_reject alloc]init];

        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            return [[UMTCAP_State_idle alloc]init];

        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            return [[UMTCAP_State_wait_for_reject alloc]init];
            
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            return [[UMTCAP_State_idle alloc]init];
    }

}
-(UMTCAP_State *)eventReceiveWellFormedRE:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_State_wait_for_reject alloc]init];
}

-(UMTCAP_State *)eventReceiveMalformedRRNL:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_State_idle alloc]init];
}

-(UMTCAP_State *)eventReceiveMalformedRRL:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_State_idle alloc]init];
}

-(UMTCAP_State *)eventReceiveMalformedRE:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_State_idle alloc]init];
}

-(UMTCAP_State *)eventReceiveRJ:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_State_idle alloc]init];
}

-(UMTCAP_State *)eventCancel:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_State_idle alloc]init];
}

-(UMTCAP_State *)eventInvocationTimeout:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_State_idle alloc]init];
}

-(UMTCAP_State *)eventEndSituation:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_State_idle alloc]init];
}

@end
