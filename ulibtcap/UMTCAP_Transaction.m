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
#import "UMTCAP_TransactionStateIdle.h"
#import "UMTCAP_ComponentStateIdle.h"

@implementation UMTCAP_Transaction

@synthesize tcapDialogId;
@synthesize userDialogId;

@synthesize localTransactionId;
@synthesize remoteTransactionId;
@synthesize ansiTransactionId;

@synthesize incoming;
@synthesize withPermission;

@synthesize operationClass;
@synthesize user;
//@synthesize state;
@synthesize transactionIsClosed;

- (NSTimeInterval)timeoutInSeconds
{
    return _timeoutInSeconds;
}

- (void)setTimeoutInSeconds:(NSTimeInterval)to
{
    if(to <= 5.0)
    {
        NSLog(@"TCAP Transactiong Timeout is below 5s. Setting it to 5s");
        to = 5.0;
    }
    else if(to >=120.0)
    {
        NSLog(@"TCAP Transaction Timeout is above 120s. Setting it to 60s");
        to = 60.0;
    }
    _timeoutInSeconds = to;
}

- (UMTCAP_Transaction *)init
{
    self = [super init];
    if(self)
    {
        _lastActivity = [[UMAtomicDate alloc]init];
        _started = [NSDate new];
        _transactionState = [[UMTCAP_TransactionStateIdle alloc]init];
        _componentStates = [[UMSynchronizedDictionary alloc]init];
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
    NSTimeInterval duration = [_lastActivity age];
    if(duration > self.timeoutInSeconds)
    {
        r = YES;
    }
    return r;
}

- (void)timeOut
{
    NSLog(@"tcap-timeout:%@ (dialog=%@ last activity=%@,timeoutInSeconds: %8.2lfs)\n",localTransactionId,userDialogId,_lastActivity.description,(double)self.timeoutInSeconds);

    [user tcapPAbortIndication:userDialogId
             tcapTransactionId:localTransactionId
       tcapRemoteTransactionId:remoteTransactionId
                       variant:self.tcapVariant
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


- (void)tcUniRequest
{

}

- (void)tcBeginRequest
{

}


- (void)tcContinueRequest
{

}

- (void)tcEndRequest
{

}

- (void)tcUAbortRequest
{
}


- (void)setOptions:(NSDictionary *)options
{
    NSArray <NSString *> *tcap_options = options["tcap-options"];
    if(tcap_options.count > 0)
    {
        for(NSString *option in tcap_options)
        {
            if([option isEqualToString:@"start-with-continue"])
            {
                _startWithContinue = YES;
            }
            else if([option isEqualToString:@"no-dtid-in-continue"])
            {
                _noDestinationTransationIdInContinue = YES;
                remoteTransactionId = NULL;
            }
        }
    }
}


@end
