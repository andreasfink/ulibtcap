//
//  UMTCAP_TransactionStateIdle.m
//  ulibtcap
//
//  Created by Andreas Fink on 20.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibtcap/UMTCAP_TransactionStateIdle.h>
#import <ulibtcap/UMTCAP_TransactionStateInitReceived.h>
#import <ulibtcap/UMTCAP_TransactionStateInitSent.h>
#import <ulibtcap/UMTCAP_Transaction.h>

@implementation UMTCAP_TransactionStateIdle


- (UMTCAP_TransactionState *)eventBeginRecieved:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_TransactionStateInitReceived alloc]init];
}

- (UMTCAP_TransactionState *)eventBeginSent:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_TransactionStateInitSent alloc]init];
}


- (NSString *)description
{
    return @"IDLE";
}

@end
