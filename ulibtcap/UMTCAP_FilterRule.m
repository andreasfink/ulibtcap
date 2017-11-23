//
//  UMTCAP_FilterRule.m
//  ulibtcap
//
//  Created by Andreas Fink on 23.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_FilterRule.h"
#import "UMTCAP_Command.h"

@implementation UMTCAP_FilterRule

- (void)addApplicationContext:(NSString *)context
{
    [_applicationContexts addObject:context];
}

- (UMTCAP_FilterResult)filterPacket:(UMTCAP_Command)command
                 applicationContext:(NSString *)context
                      operationCode:(int64_t)opCode
                     callingAddress:(SccpAddress *)src
                      calledAddress:(SccpAddress *)dst
{

    /* does the command match ? */
    if(_command != command)
    {
        return UMTCAP_FilterResult_continue;
    }
    if((_calledAddress.address.length > 0) && (![src.address isEqualTo:_calledAddress.address]))
    {
        return UMTCAP_FilterResult_continue;
    }
    if((_callingAddress.address.length > 0) && (![dst.address isEqualTo:_callingAddress.address]))
    {
        return UMTCAP_FilterResult_continue;
    }
    /* does the operation match and is given */
    if((_operation >= 0) && (opCode >= 0) && (_operation!=opCode))
    {
        return UMTCAP_FilterResult_continue;
    }
    BOOL contextMatch = NO;
    if(context == NULL)
    {
        context = @"none";
    }
    NSArray *ctxs = [_applicationContexts copy];
    for(NSString *ctx in ctxs)
    {
        if([ctx isEqualToString:@"any"])
        {
            contextMatch = YES;
            break;
        }
        else if([ctx isEqualToString:context])
        {
            contextMatch = YES;
            break;
        }
    }
    if(contextMatch)
    {
        return _result;
    }
    return UMTCAP_FilterResult_continue;
}

@end
