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
    }
    return self;
}

#if unused
- (NSString *)_newId
{
    NSString *tidString = @"00000000";
    do
    {
        u_int32_t tid = [UMUtil random:0x3FFFFFFF];
        tidString = [NSString stringWithFormat:@"%08lX",(long)tid];
        if(_freeTransactionIds[tidString] ==NULL)
        {
            if(_inUseTransactionIds[tidString]==NULL)
            {
                break; /* found an unused one */
            }
        }
    } while(1);
    return tidString;
}
#endif

- (NSString *)newTransactionIdForInstance:(NSString *)instance
{
    NSString *tidString;
    @autoreleasepool
    {
        [_lock lock];
        @autoreleasepool
        {
            NSArray *keys = [_freeTransactionIds allKeys];
            if(keys.count > 0)
            {
                NSUInteger k = [UMUtil random:keys.count];
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
    _freeTransactionIds[tidString]=tidString;
    [_lock unlock];
}

@end
