//
//  UMTCAP_Transaction.m
//  ulibtcap
//
//  Created by Andreas Fink on 30.03.16.
//  Copyright (c) 2016 Andreas Fink
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

@synthesize started;

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
        started = [NSDate date];
        [self touch];
    }
    return self;
}

- (void)touch
{
    @synchronized(self)
    {
        if(timeoutValue==0)
        {
            timeoutValue=90;
        }
        timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutValue];
    }
}

- (BOOL)isTimedOut
{
    @synchronized(self)
    {
        if(timeoutDate == NULL)
        {
            return NO;
        }
        NSDate *now = [NSDate date];
        if([now compare:timeoutDate] == NSOrderedDescending)
        {
            return YES;
        }
        return NO;
    }
}

- (void)timeOut
{
    transactionIsClosed = YES;
}

@end
