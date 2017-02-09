//
//  UMTCAP_HousekeepingTask.m
//  ulibtcap
//
//  Created by Andreas Fink on 25.01.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_HousekeepingTask.h"
#import "UMLayerTCAP.h"

@implementation UMTCAP_HousekeepingTask


- (UMTCAP_HousekeepingTask *)initForTcap:(UMLayerTCAP *)tcap
{
    self = [super initWithName:@"UMTCAP_HousekeepingTask"
                      receiver:tcap
                        sender:NULL
       requiresSynchronisation:NO];
    if(self)
    {
        tcapLayer = tcap;
    }
    return self;
}

- (void)main
{
    [tcapLayer housekeeping];
}

@end
