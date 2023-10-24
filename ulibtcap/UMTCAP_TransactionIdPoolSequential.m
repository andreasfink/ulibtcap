//
//  UMTCAP_TransactionIdPoolSequential.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibtcap/UMTCAP_TransactionIdPoolSequential.h>

@implementation UMTCAP_TransactionIdPoolSequential

- (UMTCAP_TransactionIdPoolSequential *)initWithStart:(NSNumber *)start end:(NSNumber *)end;
{
    uint32_t istart = [start unsignedIntValue];
    uint32_t iend = [start unsignedIntValue];
    uint32_t icount = iend - istart;

    return [super initWithPrefabricatedIds:icount start:istart end:iend];
}


- (UMSynchronizedSortedDictionary *)objectValue
{
    UMSynchronizedSortedDictionary *d = [[UMSynchronizedSortedDictionary alloc]init];
    d[@"pool-type"]= @"sequential";
    return d;
}

@end

