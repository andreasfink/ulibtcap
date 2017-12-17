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
@synthesize timeoutInSeconds;

- (UMTCAP_Transaction *)init
{
    self = [super init];
    if(self)
    {
        _lastActivity = [[UMAtomicDate alloc]init];
        _started = [NSDate new];
        [self touch];
    }
    return self;
}

- (void)touch
{
    [_lastActivity touch];
}

- (BOOL)isTimedOut
{
    BOOL r = NO;
    NSTimeInterval duration = [_lastActivity timeIntervalSinceNow];
    if(duration > self.timeoutInSeconds)
    {
        r = YES;
    }
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

- (void)dump:(NSFileHandle *)filehandler
{
    NSMutableString *s = [[NSMutableString alloc]init];
    [s appendFormat:@"    localTransactionId: %@\n",localTransactionId];
    [s appendFormat:@"    remoteTransactionId: %@\n",remoteTransactionId];
    [s appendFormat:@"    userDialogId: %@\n",userDialogId];
    [s appendFormat:@"    started: %@\n",[_started description]];
    [s appendFormat:@"    lastActivity: %@\n",[_lastActivity description]];
    [s appendFormat:@"    incoming: %@\n", (incoming ? @"YES" : @"NO")];
    [s appendFormat:@"    closed: %@\n",(transactionIsClosed ? @"YES" : @"NO")];
    [s appendFormat:@"    timeout: %8.2lfs\n",self.timeoutInSeconds];
    [filehandler writeData: [s dataUsingEncoding:NSUTF8StringEncoding]];
}
@end
