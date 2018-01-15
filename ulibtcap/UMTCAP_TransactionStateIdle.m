//
//  UMTCAP_TransactionStateIdle.m
//  ulibtcap
//
//  Created by Andreas Fink on 20.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_TransactionStateIdle.h"
#import "UMTCAP_TransactionStateInitReceived.h"
#import "UMTCAP_TransactionStateInitSent.h"
#import "UMTCAP_Transaction.h"

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
