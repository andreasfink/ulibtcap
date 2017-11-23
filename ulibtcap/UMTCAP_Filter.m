//
//  UMTCAP_Filter.m
//  ulibtcap
//
//  Created by Andreas Fink on 23.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_Filter.h"
#import "UMTCAP_FilterRule.h"
#import "UMTCAP_FilterResult.h"

@implementation UMTCAP_Filter

- (UMTCAP_Filter *)init
{
    self = [super init];
    if(self)
    {
        _rules = [[UMSynchronizedArray alloc]init];
    }
    return self;
}

- (void)removeAllRules
{
    _rules = [[UMSynchronizedArray alloc]init];
}

- (void)addRule:(UMTCAP_FilterRule *)rule
{
    [_rules addObject:rule];
}


- (UMTCAP_FilterResult)filterPacket:(UMTCAP_Command)command
                 applicationContext:(NSString *)context
                      operationCode:(int64_t)opCode
{
    UMTCAP_FilterResult r = UMTCAP_FilterResult_continue;
    NSArray *rules = [_rules copy];
    for(UMTCAP_FilterRule *rule in rules)
    {
        r = [rule filterPacket:command
            applicationContext:context
                 operationCode:opCode];
        if(r != UMTCAP_FilterResult_continue)
        {
            return r;
        }
    }
    return r;
}
@end
