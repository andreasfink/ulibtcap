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
#import <ulibtcap/UMTCAP_Variant.h>
#import <ulibtcap/UMTCAP_operationClass.h>
#import <ulibtcap/UMTCAP_UserProtocol.h>

#import <ulibtcap/UMTCAP_TransactionState.h>
#import <ulibtcap/UMTCAP_ComponentState.h>
#import <ulibtcap/UMTCAP_itu_asn1_componentPDU.h>
/* see Q.774 Figure 1 page 10 */

@interface UMTCAP_Transaction : UMObject
{
    UMMutex                     *_incomingLock;
    UMMutex                     *_outgoingLock;
    UMTCAP_Variant              _tcapVariant;
    //UMTCAP_TransactionState     *_transactionState;
    UMSynchronizedDictionary    *_componentStates; /* dictionary of UMTCAP_ComponentState object. The key is an InvokeID's description value (string of integer) */
    UMTCAP_operationClass       operationClass;
    
    NSString                    *localTransactionId; /* these are hex strings of whats exactly sent in the PDU */
    NSString                    *remoteTransactionId;
    NSString                    *ansiTransactionId;
    UMTCAP_UserDialogIdentifier *userDialogId;

    NSDate                      *_started;

    BOOL                        incoming;
    BOOL                        withPermission;
    id<UMTCAP_UserProtocol>     user;

    BOOL                        _transactionIsClosed;
    BOOL                        _transactionIsEnding;
    NSTimeInterval              _timeoutInSeconds;
    UMAtomicDate                *_lastActivity;
    
    BOOL _startWithContinue;
    BOOL _noDestinationTransationIdInContinue;
    BOOL _doubleOriginationTransationIdInContinue;
    BOOL    _useHandshake;
    UMTCAP_itu_operationCodeEncoding    _operationEncoding;
    UMTCAP_itu_classEncoding            _classEncoding;

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
@property(readwrite,assign) BOOL transactionIsEnding;
@property(readwrite,assign) BOOL useHandshake;
@property(readwrite,assign,atomic) NSTimeInterval timeoutInSeconds;

@property(readwrite,strong) NSDate *timeoutDate;

@property(readwrite,assign) BOOL startWithContinue;
@property(readwrite,assign) BOOL noDestinationTransationIdInContinue;
@property(readwrite,assign) BOOL doubleOriginationTransationIdInContinue;
@property(readwrite,assign) UMTCAP_itu_operationCodeEncoding operationEncoding;
@property(readwrite,assign) UMTCAP_itu_classEncoding classEncoding;
@property(readwrite,strong) UMMutex *incomingLock;
@property(readwrite,strong) UMMutex *outgoingLock;


- (void)touch;
- (BOOL)isTimedOut;
- (void)timeOut;
- (void)dump:(NSFileHandle *)fh;
- (void)setOptions:(NSDictionary *)options;

@end
