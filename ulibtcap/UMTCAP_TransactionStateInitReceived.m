//
//  UMTCAP_TransactionStateInitReceived.m
//  ulibtcap
//
//  Created by Andreas Fink on 20.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_TransactionStateInitReceived.h"
#import "UMTCAP_TransactionStateActive.h"
#import "UMTCAP_Transaction.h"
#import "UMTCAP_TransactionStateIdle.h"

@implementation UMTCAP_TransactionStateInitReceived



- (UMTCAP_TransactionState *)eventContinueSent:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_TransactionStateActive alloc]init];
}


- (UMTCAP_TransactionState *)eventEndSent:(UMTCAP_Transaction *)t
{
    return [[UMTCAP_TransactionStateIdle alloc]init];
}



- (NSString *)description
{
    return @"INIT-RECEIVED";
}

@end
