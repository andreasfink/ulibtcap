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

- (UMTCAP_TransactionIdPoolSequential *)initWithPrefabricatedIds:(int)count
{
    self = [super init];
    if(self)
    {
        _nextTransactionId = 1;
        _freeTransactionIds = NULL;
        _inUseTransactionIds = [[NSMutableDictionary alloc]init];
        _lock = [[UMMutex alloc]init];
    }
    return self;
}

- (NSString *)newTransactionIdForInstance:(NSString *)instance
{
    uint32_t _currentTransactionId;

    [_lock lock];
    _currentTransactionId = _nextTransactionId;
    _nextTransactionId++;
    _nextTransactionId = _nextTransactionId % 0x3FFFFFFF;
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

@end

