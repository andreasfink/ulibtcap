//
//  UMTCAP_TransactionState.m
//  ulibtcap
//
//  Created by Andreas Fink on 20.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibtcap/UMTCAP_TransactionState.h>
#import <ulibtcap/UMTCAP_Transaction.h>

@implementation UMTCAP_TransactionState

- (UMTCAP_TransactionState *)eventContinueReceived:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_TransactionState *)eventContinueSent:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_TransactionState *)eventBeginRecieved:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_TransactionState *)eventBeginSent:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_TransactionState *)eventEndReceived:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_TransactionState *)eventEndSent:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_TransactionState *)eventAbortReceived:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_TransactionState *)eventAbortSent:(UMTCAP_Transaction *)t
{
    return self;
}

- (UMTCAP_TransactionState *)eventLocalDecision:(UMTCAP_Transaction *)t
{
    return self;
}

- (NSString *)description
{
    return @"undefined";
}

@end
