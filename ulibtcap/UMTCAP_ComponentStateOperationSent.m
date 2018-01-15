//
//  UMTCAP_ComponentStateOperationSent.m
//  ulibtcap
//
//  Created by Andreas Fink on 21.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_ComponentStateOperationSent.h"
#import "UMTCAP_Transaction.h"
#import "UMTCAP_ComponentStateIdle.h"
#import "UMTCAP_ComponentStateWaitForReject.h"
#import "UMTCAP_ComponentStateRejectPending.h"

@implementation UMTCAP_ComponentStateOperationSent

- (NSString *)description
{
    return @"COMPONENT-STATE-OPERATION-SENT";
}




- (UMTCAP_ComponentState *)eventTC_U_Reject_Request:(UMTCAP_Transaction *)t
{
    [self touch];
    switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            break;
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            break;
    }
    return self;
}

- (UMTCAP_ComponentState *)eventTC_R_Reject_Indication:(UMTCAP_Transaction *)t
{
    [self touch];
   switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
    }
    return self;
}

- (UMTCAP_ComponentState *)eventTC_U_Reject_Indication:(UMTCAP_Transaction *)t
{
    [self touch];
    switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
    }
    return self;
}


- (UMTCAP_ComponentState *)eventTC_L_Cancel_Indication:(UMTCAP_Transaction *)t
{
    [self touch];
    switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            break;
    }
    return self;    return self;
}


- (UMTCAP_ComponentState *)eventTC_U_Cancel_Request:(UMTCAP_Transaction *)t
{
    [self touch];
   switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            return [[UMTCAP_ComponentStateIdle alloc]init];
            break;
    }
    return self;
}

- (UMTCAP_ComponentState *)eventTC_Result_NL_Indication:(UMTCAP_Transaction *)t
{
    [self touch];
    switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_ComponentStateOperationSent alloc]init];
            break;
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            break;
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            return [[UMTCAP_ComponentStateOperationSent alloc]init];
            break;
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            break;
    }
    return self;
}


- (UMTCAP_ComponentState *)eventTC_Result_L_Indication:(UMTCAP_Transaction *)t
{
    [self touch];
    switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_ComponentStateWaitForReject alloc]init];
            break;
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            break;
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            return [[UMTCAP_ComponentStateWaitForReject alloc]init];
            break;
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            break;
    }
    return self;
}



- (UMTCAP_ComponentState *)eventTC_U_Error_Indication:(UMTCAP_Transaction *)t
{
    [self touch];
    switch(t.operationClass)
    {
        case TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE:
            return [[UMTCAP_ComponentStateWaitForReject alloc]init];
            break;
        case TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY:
            return [[UMTCAP_ComponentStateWaitForReject alloc]init];
            break;
        case TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY:
            break;
        case TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED:
            break;
    }
    return self;
}

- (UMTCAP_ComponentState *)eventTC_L_Reject_Indication:(UMTCAP_Transaction *)t
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
            return [[UMTCAP_ComponentStateRejectPending alloc]init];
            break;
    }
    return self;
}


@end
