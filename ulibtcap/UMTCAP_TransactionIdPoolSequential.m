//
//  UMTCAP_TransactionIdPoolSequential.m
//  ulibtcap
//
//  Created by Andreas Fink on 24.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_TransactionIdPoolSequential.h"

@implementation UMTCAP_TransactionIdPoolSequential


- (UMTCAP_TransactionIdPoolSequential *)init
{
    return [self initWithPrefabricatedIds:0];
}



- (UMTCAP_TransactionIdPoolSequential *)initWithStart:(NSNumber *)start end:(NSNumber *)end;
{
    self = [super init];
    if(self)
    {
        _lock = [[UMMutex alloc]initWithName:@"transaction-id-pool-sequential"];
        _inUseTransactionIds = [[NSMutableDictionary alloc]init];
        _nextTransactionId = start.intValue;
        _first = start;
        _last = end;
    }
    return self;
}

- (UMTCAP_TransactionIdPoolSequential *)initWithPrefabricatedIds:(int)count
{
    self = [super init];
    if(self)
    {
        _lock = [[UMMutex alloc]initWithName:@"transaction-id-pool-sequential"];
        _nextTransactionId = 1;
        _inUseTransactionIds = [[NSMutableDictionary alloc]init];
        _first = @(1);
        _last = @(0x3FFFFFFF);
    }
    return self;
}

- (NSString *)newTransactionIdForInstance:(NSString *)instance
{
    UMAssert(_lock!=NULL,@"no locking in place");

    uint32_t _currentTransactionId;

    [_lock lock];
    _currentTransactionId = _nextTransactionId;
    _nextTransactionId++;
    _nextTransactionId = _nextTransactionId % 0x3FFFFFFF;
    if(_last)
    {
        if(_nextTransactionId > _last.unsignedIntValue)
        {
            _nextTransactionId = _first.unsignedIntValue;
        }
    }
    if(_first)
    {
        if(_nextTransactionId < _first.unsignedIntValue)
        {
            _nextTransactionId = _first.unsignedIntValue;
        }
    }

    NSString *tidString = [NSString stringWithFormat:@"%08lX",(long)_currentTransactionId];
    _inUseTransactionIds[tidString] = instance;
    [_lock unlock];
    return tidString;
}

- (NSString *)findInstanceForTransaction:(NSString *)tid
{
    NSString *instance;
    [_lock lock];
    instance = _inUseTransactionIds[tid];
    [_lock unlock];
    return instance;
}

- (void)returnTransactionId:(NSString *)tidString
{
    [_lock lock];
    [_inUseTransactionIds removeObjectForKey:tidString];
    [_lock unlock];
}

- (UMSynchronizedSortedDictionary *)objectValue
{
    UMSynchronizedSortedDictionary *d = [[UMSynchronizedSortedDictionary alloc]init];
    d[@"pool-type"]= @"sequential";
    return d;
}


@end

