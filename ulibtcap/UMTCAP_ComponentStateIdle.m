//
//  UMTCAP_ComponentStateIdle.m
//  ulibtcap
//
//  Created by Andreas Fink on 21.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibtcap/UMTCAP_ComponentStateIdle.h>
#import <ulibtcap/UMTCAP_ComponentStateOperationPending.h>
#import <ulibtcap/UMTCAP_Transaction.h>

@implementation UMTCAP_ComponentStateIdle


- (NSString *)description
{
    return @"COMPONENT-STATE-IDLE";
}


- (UMTCAP_ComponentState *)eventTC_Invoke_Request:(UMTCAP_Transaction *)t
{
    [self touch];
    switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            return [[UMTCAP_ComponentStateOperationPending alloc]init];
            break;
    }
    return self;
}

@end
