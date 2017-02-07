//
//  UMTCAP_TimeoutTask.m
//  ulibtcap
//
//  Created by Andreas Fink on 25.01.17.
//  Copyright © 2017 Andreas Fink. All rights reserved.
//

#import "UMTCAP_TimeoutTask.h"

#import "UMLayerTCAP.h"
#import "UMTCAP_Transaction.h"

@implementation UMTCAP_TimeoutTask


- (UMTCAP_TimeoutTask *)initForTCAP:(UMLayerTCAP *)g transaction:(UMTCAP_Transaction *)t
{
    self = [super initWithName:@"UMTCAP_TimeoutTask"
                      receiver:g
                        sender:NULL
       requiresSynchronisation:NO];
    if(self)
    {
        tcap = g;
        transaction = t;
    }
    return self;
}

- (void) main
{
    [transaction timeOut];
}

@end
