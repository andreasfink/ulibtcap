//
//  UMTCAP_TransactionIdPool.m
//  ulibtcap
//
//  Created by Andreas Fink on 17.02.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_TransactionIdPool.h"
#include <stdlib.h>

@implementation UMTCAP_TransactionIdPool

- (UMTCAP_TransactionIdPool *)init
{
    return [self initWithPrefabricatedIds:32768];
}

- (UMTCAP_TransactionIdPool *)initWithPrefabricatedIds:(int)count
{
    self = [super init];
    if(self)
    {
        _lock = [[UMMutex alloc]initWithName:@"transaction-id-pool-lock"];
        _freeTransactionIds = [[NSMutableDictionary alloc]init];
        _inUseTransactionIds = [[NSMutableDictionary alloc]init];

        _quarantineTransactionIds1 = [[NSMutableArray alloc]init];
        _quarantineTransactionIds2 = [[NSMutableArray alloc]init];
        _quarantineTransactionIds3 = [[NSMutableArray alloc]init];

        while(count > 0)
        {
            /* generate TIDs */
            u_int32_t tid = [UMUtil random:0x3FFFFFFF];
            NSString *tidString = [NSString stringWithFormat:@"%08lX",(long)tid];
            if(_freeTransactionIds[tidString] == NULL)
            {
                _freeTransactionIds[tidString]=tidString;
                count--;
            }
        }
        if(count>0) /* if we are not a dumb sequential transaction ID pool */
        {
            _quarantineRotateTimer = [[UMTimer alloc]initWithTarget:self
                                                           selector:@selector(quarantineRotate)
                                                             object:NULL
                                                            seconds:60 /* every 60 sec */
                                                               name:@"quarantine-rotate"
                                                            repeats:YES
                                                    runInForeground:YES];
            [_quarantineRotateTimer start];
        }
    }
    return self;
}


/* this gets called every minute. so old transaction ID's are being moved into the next group */
/* that way after 3 rotations they end up in the free pool again */
- (void)quarantineRotate
{
    [_lock lock];
    for(NSString *tidString in _quarantineTransactionIds3)
    {
        _freeTransactionIds[tidString]=tidString;
    }
    _quarantineTransactionIds3 = _quarantineTransactionIds2;
    _quarantineTransactionIds2 = _quarantineTransactionIds1;
    _quarantineTransactionIds1 = [[NSMutableArray alloc]init];
    [_lock unlock];
}

- (NSString *)newTransactionIdForInstance:(NSString *)instance
{
    UMAssert(_lock!=NULL,@"no locking in place");
    NSString *tidString;
    @autoreleasepool
    {
        [_lock lock];
        @autoreleasepool
        {
            NSArray *keys = [_freeTransactionIds allKeys];
            if(keys.count > 0)
            {
                uint32_t k = [UMUtil random:(uint32_t)keys.count];
                tidString = keys[k];
                [_freeTransactionIds removeObjectForKey:tidString];
            }
            else
            {
                int found = 0;
                while(found == 0)
                {
                    /* generate TIDs */
                    u_int32_t tid = [UMUtil random:0x3FFFFFFF];
                    tidString = [NSString stringWithFormat:@"%08lX",(long)tid];
                    if(_freeTransactionIds[tidString] == NULL)
                    {
                        _freeTransactionIds[tidString]=tidString;
                        found=1;
                    }
                }
            }
            _inUseTransactionIds[tidString]=instance;
        }
        [_lock unlock];
    }
    return tidString;
}

- (NSString *)findInstanceForTransaction:(NSString *)tidString
{
    NSString *instance;
    [_lock lock];
    instance = _inUseTransactionIds[tidString];
    [_lock unlock];
    return instance;
}

- (void)returnTransactionId:(NSString *)tidString
{
    [_lock lock];
    [_inUseTransactionIds removeObjectForKey:tidString];
    [_quarantineTransactionIds1 addObject:tidString];
    [_lock unlock];
}

- (UMSynchronizedSortedDictionary *)objectValue
{
    UMSynchronizedSortedDictionary *d = [[UMSynchronizedSortedDictionary alloc]init];
    d[@"pool-type"]= @"standard";
    return d;
}


@end
