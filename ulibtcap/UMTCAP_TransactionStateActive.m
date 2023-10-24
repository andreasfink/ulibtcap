//
//  UMTCAP_TransactionStateActive.m
//  ulibtcap
//
//  Created by Andreas Fink on 20.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibtcap/UMTCAP_TransactionStateActive.h>
#import <ulibtcap/UMTCAP_TransactionStateIdle.h>

@implementation UMTCAP_TransactionStateActive


- (UMTCAP_TransactionState *)eventContinueReceived:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_TransactionStateActive alloc]init];
}

- (UMTCAP_TransactionState *)eventContinueSent:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_TransactionStateActive alloc]init];
}

- (UMTCAP_TransactionState *)eventEndSent:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_TransactionStateIdle alloc]init];
}

- (UMTCAP_TransactionState *)eventEndReceived:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_TransactionStateIdle alloc]init];
}

- (NSString *)description
{
    return @"ACTIVE";
}

@end
