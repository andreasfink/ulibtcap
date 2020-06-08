//
//  UMTCAP_TransactionIdFastPool.m
//  ulibtcap
//
//  Created by Andreas Fink on 17.02.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_TransactionIdFastPool.h"
#import "UMTCAP_TransactionIdPoolEntry.h"
#include <stdlib.h>

@implementation UMTCAP_TransactionIdFastPool

- (UMTCAP_TransactionIdFastPool *)init
{
    return [self initWithPrefabricatedIds:3276800];
}

- (UMTCAP_TransactionIdFastPool *)initWithPrefabricatedIds:(uint32_t)count
{
    return [self initWithPrefabricatedIds:count start:0 end:0x3FFFFFF0];
}

- (UMTCAP_TransactionIdFastPool *)initWithPrefabricatedIds:(uint32_t)count start:(uint32_t)start end:(uint32_t)end
{
    self = [super init];
    if(self)
    {
        _lock = [[UMMutex alloc]initWithName:@"transaction-id-fastpool-lock"];
        NSMutableArray *xfreeTransactionIds = [[NSMutableArray alloc]init];
        _inUseTransactionIds = [[NSMutableDictionary alloc]init];

        _quarantineTransactionIds1 = [[NSMutableArray alloc]init];
        _quarantineTransactionIds2 = [[NSMutableArray alloc]init];
        _quarantineTransactionIds3 = [[NSMutableArray alloc]init];

        uint32_t max = end - start;
        if(count>max)
        {
            count = max;
        }
        if((count * 3) > max)
        {
        }
        uint32_t xstart = [UMUtil random:max];
        
        for(uint32_t i=0;i<count;i++)
        {
            u_int32_t tid = start + ((i + xstart) % max);
            NSString *tidString = [NSString stringWithFormat:@"%08lX",(long)tid];
            UMTCAP_TransactionIdPoolEntry *e = [[UMTCAP_TransactionIdPoolEntry alloc]init];
            e.transactionId = tidString;
            e.lastFreed = [NSDate date];
            [xfreeTransactionIds addObject:e];
        }
        
        /* convert to a fast array */
        _freeTransactionIds = [[NSMutableArray alloc]init];
        
        NSArray *a = [xfreeTransactionIds sortedArrayUsingComparator: ^(UMTCAP_TransactionIdPoolEntry *a, UMTCAP_TransactionIdPoolEntry *b)
                      { if([UMUtil random] % 2) { return   NSOrderedAscending; } return NSOrderedDescending; }];
        _freeTransactionIds = [a mutableCopy];
        _quarantineRotateTimer = [[UMTimer alloc]initWithTarget:self
                                                       selector:@selector(quarantineRotate)
                                                         object:NULL
                                                        seconds:60 /* every 60 sec */
                                                           name:@"quarantine-rotate"
                                                        repeats:YES
                                                runInForeground:YES];
        [_quarantineRotateTimer start];
    }
    return self;
}


/* this gets called every minute. so old transaction ID's are being moved into the next group */
/* that way after 3 rotations they end up in the free pool again */
- (void)quarantineRotate
{
    [_lock lock];
    [_freeTransactionIds addObjectsFromArray:_quarantineTransactionIds3];
    _quarantineTransactionIds3 = _quarantineTransactionIds2;
    _quarantineTransactionIds2 = _quarantineTransactionIds1;
    _quarantineTransactionIds1 = [[NSMutableArray alloc]init];
    [_lock unlock];
}

- (NSString *)newTransactionIdForInstance:(NSString *)instance
{
    UMAssert(_lock!=NULL,@"no locking in place");
    
    UMTCAP_TransactionIdPoolEntry *e = NULL;
    [_lock lock];
    while(_freeTransactionIds.count <1)
    {
        [_lock unlock];
        usleep(1000);
        [_lock lock];
    }
    
    e = [_freeTransactionIds objectAtIndex:0];
    [_freeTransactionIds removeObjectAtIndex:0];
    [_lock unlock];
    e.lastUse = [NSDate date];
    e.instance = instance;
    NSString *tidString = e.transactionId;
    [_lock lock];
    _inUseTransactionIds[tidString]=e;
    [_lock unlock];
    return tidString;
}

- (NSString *)findInstanceForTransaction:(NSString *)tidString
{
    [_lock lock];
    UMTCAP_TransactionIdPoolEntry *e = _inUseTransactionIds[tidString];
    NSString *instance = e.instance;
    [_lock unlock];
    return instance;
}

- (void)returnTransactionId:(NSString *)tidString
{
    [_lock lock];
    UMTCAP_TransactionIdPoolEntry *e = _inUseTransactionIds[tidString];
    if(e)
    {
        [_inUseTransactionIds removeObjectForKey:tidString];
        [_quarantineTransactionIds1 addObject:e];
    }
    [_lock unlock];
}

- (UMSynchronizedSortedDictionary *)objectValue
{
    UMSynchronizedSortedDictionary *d = [[UMSynchronizedSortedDictionary alloc]init];
    d[@"pool-type"]= @"fast";
    [_lock lock];
    d[@"free-count"]= @(_freeTransactionIds.count);
    d[@"inuse-count"]= @(_inUseTransactionIds.count);
    d[@"quarantine1-count"]= @(_quarantineTransactionIds1.count);
    d[@"quarantine2-count"]= @(_quarantineTransactionIds2.count);
    d[@"quarantine3-count"]= @(_quarantineTransactionIds3.count);
    [_lock unlock];
    return d;
}

@end
