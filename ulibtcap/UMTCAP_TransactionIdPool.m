//
//  UMTCAP_TransactionIdPool.m
//  ulibtcap
//
//  Created by Andreas Fink on 17.02.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_TransactionIdPool.h"

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
        freeTransactionIds = [[UMSynchronizedSortedDictionary alloc]init];
        inUseTransactionIds = [[UMSynchronizedSortedDictionary alloc]init];
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
        u_int32_t tid = arc4random_uniform(0x3FFFFFFF);
        tidString = [NSString stringWithFormat:@"%08lX",(long)tid];
        if(freeTransactionIds[tidString] ==NULL)
        {
            if(inUseTransactionIds[tidString]==NULL)
            {
                break; /* found an unused one */
            }
        }
    } while(1);
    return tidString;
}

- (NSString *)newTransactionIdForInstance:(NSString *)instance
{
    @synchronized (self)
    {

        NSString *tidString;
        if(freeTransactionIds.count > 0)
        {
            tidString = [freeTransactionIds objectAtIndex:0];
            [freeTransactionIds removeObjectForKey:tidString];
        }
        else
        {
            tidString = [self _newId];
        }
        inUseTransactionIds[tidString]=instance;
        return tidString;
    }
}

- (void)returnTransactionId:(NSString *)tidString
{
    @synchronized (self)
    {
        [inUseTransactionIds removeObjectForKey:tidString];
        freeTransactionIds[tidString]=tidString;
    }
}

@end
