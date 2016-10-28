//
//  UMTCAP_State_idle.m
//  ulibtcap
//
//  Created by Andreas Fink on 27/04/16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_State_operation_sent.h"
#import "UMTCAP_State_wait_for_reject.h"
#import "UMTCAP_State_idle.h"

@implementation UMTCAP_State_idle

- (NSString *)description
{
    return @"UMTCAP_State_idle";
}

-(UMTCAP_State *)eventSend:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_State_operation_sent alloc]init];
}


@end
