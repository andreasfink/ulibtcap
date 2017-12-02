//
//  UMTCAP_Transaction.m
//  ulibtcap
//
//  Created by Andreas Fink on 30.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_Transaction.h"

@implementation UMTCAP_Transaction

@synthesize tcapVariant;

@synthesize tcapDialogId;
@synthesize userDialogId;

@synthesize localTransactionId;
@synthesize remoteTransactionId;
@synthesize ansiTransactionId;

@synthesize incoming;
@synthesize withPermission;

@synthesize operationClass;
@synthesize user;
@synthesize state;
@synthesize transactionIsClosed;
@synthesize timeoutValue;
@synthesize timeoutDate;

- (UMTCAP_Transaction *)init
{
    self = [super init];
    if(self)
    {
        _started = [NSDate date];
        _lastActivity = _started;
        _transactionLock = [[UMMutex alloc] init];
        [self touch];
    }
    return self;
}

- (void)touch
{
    [_transactionLock lock];
    _lastActivity = [NSDate date];
    [_transactionLock unlock];
}

- (BOOL)isTimedOut
{
    BOOL r = NO;
    [_transactionLock lock];

    NSTimeInterval duration = [[NSDate date]timeIntervalSinceDate:_lastActivity];
    if(duration > timeoutValue)
    {
        r = YES;
    }
    [_transactionLock unlock];
    return r;
}

- (void)timeOut
{
    [user tcapPAbortIndication:userDialogId
             tcapTransactionId:localTransactionId
       tcapRemoteTransactionId:remoteTransactionId
                       variant:tcapVariant
                callingAddress:NULL
                 calledAddress:NULL
               dialoguePortion:NULL
                  callingLayer:NULL
                          asn1:NULL
                       options:NULL];
    transactionIsClosed = YES;
}

@end
