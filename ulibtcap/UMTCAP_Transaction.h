//
//  UMTCAP_Transaction.h
//  ulibtcap
//
//  Created by Andreas Fink on 30.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_Variant.h"
#import "UMTCAP_operationClass.h"
#import "UMTCAP_UserProtocol.h"

#import "UMTCAP_TransactionState.h"
#import "UMTCAP_ComponentState.h"

/* see Q.774 Figure 1 page 10 */

@interface UMTCAP_Transaction : UMObject
{
    UMTCAP_Variant          _tcapVariant;
    UMTCAP_TransactionState            *_transactionState;
    UMSynchronizedDictionary *_componentStates; /* dictionary of UMTCAP_ComponentState object. The key is an InvokeID's description value (string of integer) */
    UMTCAP_operationClass   operationClass;
    
    NSString *localTransactionId; /* these are hex strings of whats exactly sent in the PDU */
    NSString *remoteTransactionId;
    NSString *ansiTransactionId;
    UMTCAP_UserDialogIdentifier *userDialogId;

    NSDate *_started;

    BOOL    incoming;
    BOOL    withPermission;
    id<UMTCAP_UserProtocol> user;

    BOOL            transactionIsClosed;
    NSTimeInterval  _timeoutInSeconds;
    UMAtomicDate    *_lastActivity;
}

@property(readwrite,assign) UMTCAP_Variant          tcapVariant;
@property(readwrite,strong) UMTCAP_TransactionState            *transactionState;

@property(readwrite,strong) NSString *tcapDialogId;
@property(readwrite,strong) UMTCAP_UserDialogIdentifier *userDialogId;

@property(readwrite,strong) NSString *localTransactionId;
@property(readwrite,strong) NSString *remoteTransactionId;
@property(readwrite,strong) NSString *ansiTransactionId;

@property(readwrite,strong) NSDate *started;

@property(readwrite,assign) BOOL incoming;
@property(readwrite,assign) BOOL withPermission;

@property(readwrite,assign) UMTCAP_operationClass operationClass;
@property(readwrite,strong) id<UMTCAP_UserProtocol> user;
//@property(readwrite,strong) UMTCAP_TransactionState *state;

@property(readwrite,assign) BOOL transactionIsClosed;
@property(readwrite,assign,atomic) NSTimeInterval timeoutInSeconds;

@property(readwrite,strong) NSDate *timeoutDate;



- (void)touch;
- (BOOL)isTimedOut;
- (void)timeOut;
- (void)dump:(NSFileHandle *)fh;
@end
