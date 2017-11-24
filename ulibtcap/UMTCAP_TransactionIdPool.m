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
        _lock = [[UMMutex alloc]init];
        _freeTransactionIds = [[NSMutableDictionary alloc]init];
        _inUseTransactionIds = [[NSMutableDictionary alloc]init];
        for(int i=0;i<count;i++)
        {
            [self returnTransactionId:[self _newId]];
        }
    }
    return self;
}


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

- (NSString *)newTransactionIdForInstance:(NSString *)instance
{
    [_lock lock];
    NSString *tidString;
    NSArray *keys = [_freeTransactionIds allKeys];
    if(keys.count > 0)
    {
        tidString = keys[0];
        [_freeTransactionIds removeObjectForKey:tidString];
    }
    else
    {
        tidString = [self _newId];
    }
    _inUseTransactionIds[tidString]=instance;
    [_lock unlock];
    return tidString;
}

- (NSString *)findInstanceForTransaction:(NSString *)tid
{
    [_lock lock];
    NSString *instance = _inUseTransactionIds[tid];
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
