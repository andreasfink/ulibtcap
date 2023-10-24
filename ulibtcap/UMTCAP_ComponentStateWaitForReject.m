//
//  UMTCAP_ComponentStateWaitForReject.m
//  ulibtcap
//
//  Created by Andreas Fink on 21.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibtcap/UMTCAP_ComponentStateWaitForReject.h>
#import <ulibtcap/UMTCAP_ComponentStateRejectPending.h>
#import <ulibtcap/UMTCAP_ComponentStateIdle.h>
#import <ulibtcap/UMTCAP_Transaction.h>

@implementation UMTCAP_ComponentStateWaitForReject


- (NSString *)description
{
    return @"COMPONENT-STATE-WAIT-FOR-REJECT";
}


- (UMTCAP_ComponentState *)eventTC_U_Reject_Request:(UMTCAP_Transaction *)t
{
    [self touch];
    switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_ComponentStateRejectPending alloc]init];
            break;
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            return [[UMTCAP_ComponentStateRejectPending alloc]init];
            break;
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            return [[UMTCAP_ComponentStateRejectPending alloc]init];
            break;
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            break;
    }
    return self;
}

@end
