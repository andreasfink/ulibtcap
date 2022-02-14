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

- (NSTimeInterval)timeoutInSeconds
{
    return _timeoutInSeconds;
}

- (void)setTimeoutInSeconds:(NSTimeInterval)to
{
    if(to < 5.0)
    {
        NSLog(@"TCAP Transactiong Timeout is below 5s. Setting it to 5s");
        to = 5.0;
    }
    else if(to >90.0)
    {
        NSLog(@"TCAP Transaction Timeout is above 90. Setting it to 90s");
        to = 90.0;
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
        //_transactionState = [[UMTCAP_TransactionStateIdle alloc]init];
        _componentStates = [[UMSynchronizedDictionary alloc]init];
        _operationEncoding = UMTCAP_itu_operationCodeEncoding_default;
        _classEncoding = UMTCAP_itu_classEncoding_default;
        _incomingLock = [[UMMutex alloc]initWithName:@"tcap-incoming"];
        _outgoingLock = [[UMMutex alloc]initWithName:@"tcap-outgoing"];
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
    _transactionIsClosed = YES;
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
    [s appendFormat:@"    closed: %@\n",(_transactionIsClosed ? @"YES" : @"NO")];
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
    NSArray <NSString *> *tcap_options = options[@"tcap-options"];
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
            else if([option isEqualToString:@"dtid-is-otid-in-continue"])
            {
                remoteTransactionId = localTransactionId;
            }
            else if([option isEqualToString:@"double-otid-in-continue"])
            {
                _doubleOriginationTransationIdInContinue = YES;
                remoteTransactionId = localTransactionId;
            }
            if([option hasPrefix:@"class-encoding="])
            {
                NSArray *a = [option componentsSeparatedByString:@"="];
                if(a.count==2)
                {
                    NSString *classEncoding = a[1];
                    if([classEncoding isEqualToString:@"default"])
                    {
                        _classEncoding = UMTCAP_itu_classEncoding_default;
                    }
                    else if([classEncoding isEqualToString:@"application"])
                    {
                        _classEncoding = UMTCAP_itu_classEncoding_Application;
                    }
                    else if([classEncoding isEqualToString:@"universal"])
                    {
                        _classEncoding = UMTCAP_itu_classEncoding_Universal;
                    }
                    else if([classEncoding isEqualToString:@"context-specific"])
                    {
                        _classEncoding = UMTCAP_itu_classEncoding_ContextSpecific;
                    }
                    else if([classEncoding isEqualToString:@"private"])
                    {
                        _classEncoding = UMTCAP_itu_classEncoding_Private;
                    }
                }

            }
            if(([option hasPrefix:@"encoding="]) || ([option hasPrefix:@"op-encoding="]))
            {
                NSArray *a = [option componentsSeparatedByString:@"="];
                if(a.count==2)
                {
                    NSString *encoding = a[1];
                    if([encoding isEqualToString:@"default"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_default;
                    }
                    if([encoding isEqualToString:@"local"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_Local;
                    }
                    else if([encoding isEqualToString:@"global"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_Global;
                    }
                    else if([encoding isEqualToString:@"global-local"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_GlobalAndLocal;
                    }
                    else if([encoding isEqualToString:@"local-glocal"])
                    {
                     _operationEncoding = UMTCAP_itu_operationCodeEncoding_LocalAndGlobal;
                    }
                    else if([encoding isEqualToString:@"boolean"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_AsBoolean;
                    }
                    else if([encoding isEqualToString:@"enumerated"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_AsEnumerated;
                    }
                    else if([encoding isEqualToString:@"primitive-sequence"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_AsPrimitiveSequence;
                    }
                    else if([encoding isEqualToString:@"null"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_AsNull;
                    }
                    else if([encoding isEqualToString:@"private"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_AsPrivate;
                    }
                    else if([encoding isEqualToString:@"context-specific"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_AsContextSpecific;
                    }
                    else if([encoding isEqualToString:@"application"])
                    {
                        _operationEncoding = UMTCAP_itu_operationCodeEncoding_AsApplication;
                    }
                    else
                    {
                        _operationEncoding = (UMTCAP_itu_operationCodeEncoding) [encoding intValue];
                    }
                }
            }
        }
    }
}

@end
