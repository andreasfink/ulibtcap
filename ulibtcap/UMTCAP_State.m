//
//  UMTCAP_State.m
//  ulibtcap
//
//  Created by Andreas Fink on 27/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_State.h"
#import "UMTCAP_Transaction.h"

@implementation UMTCAP_State

- (NSString *)description
{
    return @"UMTCAP_State_undefined";
}


-(UMTCAP_State *)eventSend:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventReceiveWellFormedRRNL:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventReceiveWellFormedRRL:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventReceiveWellFormedRE:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventReceiveMalformedRRNL:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventReceiveMalformedRRL:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventReceiveMalformedRE:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventReceiveRJ:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventCancel:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventInvocationTimeout:(UMTCAP_Transaction *)t
{
    return self;
}
-(UMTCAP_State *)eventEndSituation:(UMTCAP_Transaction *)t
{
    return self;
}

@end
