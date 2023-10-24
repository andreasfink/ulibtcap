//
//  UMTCAP_ComponentState.m
//  ulibtcap
//
//  Created by Andreas Fink on 21.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibtcap/UMTCAP_ComponentState.h>

@implementation UMTCAP_ComponentState


- (UMTCAP_ComponentState *)init
{
    self = [super init];
    if(self)
    {
        _started = [NSDate new];
        _lastActivity = [[UMAtomicDate alloc]initWithDate:_started];
    }
    return self;
}

- (void)touch
{
    [_lastActivity touch];
}

- (NSString *)description
{
    return @"undefined";
}


- (UMTCAP_ComponentState *)eventTC_Begin_Request:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_End_Request:(UMTCAP_Transaction *)t
{
    return self;
}
- (UMTCAP_ComponentState *)eventTC_Continue_Request:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_Invoke_Request:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_U_Cancel_Request:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_U_Reject_Request:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_R_RejectIndication:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_U_Reject_Indication:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_L_Reject_Indication:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_L_Cancel_Indication:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_U_Error_Indication:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_Result_L_Indication:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_Result_NL_Indication:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_ComponentState *)eventTC_Uni_Request:(UMTCAP_Transaction *)t
{
    return self;
}

@end
