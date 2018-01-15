//
//  UMTCAP_TransactionState.h
//  ulibtcap
//
//  Created by Andreas Fink on 20.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
@class UMTCAP_Transaction;

@interface UMTCAP_TransactionState : UMObject
{
}

- (UMTCAP_TransactionState *)eventContinueReceived:(UMTCAP_Transaction *)t;
- (UMTCAP_TransactionState *)eventContinueSent:(UMTCAP_Transaction *)t;
- (UMTCAP_TransactionState *)eventBeginRecieved:(UMTCAP_Transaction *)t;
- (UMTCAP_TransactionState *)eventBeginSent:(UMTCAP_Transaction *)t;
- (UMTCAP_TransactionState *)eventEndReceived:(UMTCAP_Transaction *)t;
- (UMTCAP_TransactionState *)eventAbortReceived:(UMTCAP_Transaction *)t;
- (UMTCAP_TransactionState *)eventEndSent:(UMTCAP_Transaction *)t;
- (UMTCAP_TransactionState *)eventAbortSent:(UMTCAP_Transaction *)t;
- (UMTCAP_TransactionState *)eventLocalDecision:(UMTCAP_Transaction *)t;
- (NSString *)description;

@end
