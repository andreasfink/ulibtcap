//
//  UMTCAP_TransactionIdPool.m
//  ulibtcap
//
//  Created by Andreas Fink on 17.02.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_TransactionIdPool.h"
#import "UMTCAP_TransactionIdPoolEntry.h"
#include <stdlib.h>

@implementation UMTCAP_TransactionIdPool

- (UMTCAP_TransactionIdPool *)init
{
    return [self initWithPrefabricatedIds:3276800];
}

- (UMTCAP_TransactionIdPool *)initWithPrefabricatedIds:(uint32_t)count
{
    return [self initWithPrefabricatedIds:count start:0 end:0x3FFFFFF0];
}

- (UMTCAP_TransactionIdPool *)initWithPrefabricatedIds:(uint32_t)count start:(uint32_t)start end:(uint32_t)end
{
    self = [super init];
    if(self)
    {
        _poolLock = [[UMMutex alloc]initWithName:@"transaction-id-pool-lock"];
        _freeTransactionIds = [[NSMutableDictionary alloc]init];
        _inUseTransactionIds = [[NSMutableDictionary alloc]init];

        _quarantineTransactionIds1 = [[NSMutableArray alloc]init];
        _quarantineTransactionIds2 = [[NSMutableArray alloc]init];
        _quarantineTransactionIds3 = [[NSMutableArray alloc]init];
        _isShared = NO;
        int sequential = 0;
        uint32_t max = end - start;
        if(count>max)
        {
            count = max;
            sequential=1;
        }
        if((count * 3) > max)
        {
            sequential = 1;
        }
        if(sequential)
        {
            uint32_t xstart = [UMUtil random:max];
            
            for(uint32_t i=0;i<count;i++)
            {
                u_int32_t tid = start + ((i + xstart) % max);
                NSString *tidString = [NSString stringWithFormat:@"%08lX",(long)tid];
                UMTCAP_TransactionIdPoolEntry *e = [[UMTCAP_TransactionIdPoolEntry alloc]init];
                e.transactionId = tidString;
                e.lastFreed = [NSDate date];
                _freeTransactionIds[tidString]=e;
            }
        }
        else
        {
            for(long i=0;i<count;i++)
            {
                /* generate TIDs */
                while(1)
                {
                    u_int32_t tid = start + [UMUtil random:max];
                    NSString *tidString = [NSString stringWithFormat:@"%08lX",(long)tid];
                    if(_freeTransactionIds[tidString] == NULL)
                    {
                        UMTCAP_TransactionIdPoolEntry *e = [[UMTCAP_TransactionIdPoolEntry alloc]init];
                        e.transactionId = tidString;
                        e.lastFreed = [NSDate date];
                        _freeTransactionIds[tidString]=e;
                        break;
                    }
                }
            }
        }
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
    [_poolLock lock];
    for(UMTCAP_TransactionIdPoolEntry *e in _quarantineTransactionIds3)
    {
        e.lastFreed = [NSDate date];
        _freeTransactionIds[e.transactionId]=e;
    }
    _quarantineTransactionIds3 = _quarantineTransactionIds2;
    _quarantineTransactionIds2 = _quarantineTransactionIds1;
    _quarantineTransactionIds1 = [[NSMutableArray alloc]init];
    [_poolLock unlock];
}

- (NSString *)newTransactionIdForInstance:(NSString *)instance
{
    UMAssert(_poolLock!=NULL,@"no locking in place");
    
    [_poolLock lock];
    NSString *tidString;
    @autoreleasepool
    {
        UMTCAP_TransactionIdPoolEntry *e;
        NSArray *keys = [_freeTransactionIds allKeys];
        if(keys.count > 0)
        {
            /* we pick a random transaction id out of the free ones */
            uint32_t k = [UMUtil random:(uint32_t)keys.count];
            NSString *key = keys[k];
            e = _freeTransactionIds[key];
            tidString = e.transactionId;
            [_freeTransactionIds removeObjectForKey:tidString];
        }
        else
        {
            int found = 0;
            int cnt=0;
            while(found == 0)
            {
                /* generate a random TIDs */
                u_int32_t tid = [UMUtil random:0x3FFFFFFF];
                tidString = [NSString stringWithFormat:@"%08lX",(long)tid];
                if(_freeTransactionIds[tidString] == NULL)
                {
                    e = [[UMTCAP_TransactionIdPoolEntry alloc]init];
                    e.transactionId = tidString;
                    e.lastFreed = [NSDate date];
                    found=1;
                }
                cnt++;
                if(cnt % 100)
                {
                    [_poolLock unlock];
                    sleep(1);
                    [_poolLock lock];
                }
            }
        }
        e.lastUse = [NSDate date];
        e.instance = instance;
        _inUseTransactionIds[tidString]=e;
    }
    [_poolLock unlock];
    UMAssert(tidString.length > 0,@"no transaction id to return");
    return tidString;
}

- (NSString *)findInstanceForTransaction:(NSString *)tidString
{
    [_poolLock lock];
    UMTCAP_TransactionIdPoolEntry *e = _inUseTransactionIds[tidString];
    NSString *instance = e.instance;
    [_poolLock unlock];
    return instance;
}

- (void)returnTransactionId:(NSString *)tidString
{
    [_poolLock lock];
    UMTCAP_TransactionIdPoolEntry *e = _inUseTransactionIds[tidString];
    if(e)
    {
        [_inUseTransactionIds removeObjectForKey:tidString];
        [_quarantineTransactionIds1 addObject:e];
    }
    [_poolLock unlock];
}

- (UMSynchronizedSortedDictionary *)objectValue
{
    UMSynchronizedSortedDictionary *d = [[UMSynchronizedSortedDictionary alloc]init];
    d[@"pool-type"]= @"standard";
    return d;
}

@end
