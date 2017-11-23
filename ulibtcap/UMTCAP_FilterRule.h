//
//  UMTCAP_FilterRule.h
//  ulibtcap
//
//  Created by Andreas Fink on 23.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import <ulibgt/ulibgt.h>
#import "UMTCAP_Command.h"
#import "UMTCAP_FilterResult.h"

@interface UMTCAP_FilterRule : UMObject
{
    UMTCAP_Command  _command; /* -1 = any, -2 = undefined */
    UMSynchronizedArray *_applicationContexts;
    int     _operation; /* MAP operation code. -1 stands for "any", 0 stands for "undefined" (meaning there is no operation code in the packet) */
    UMTCAP_FilterResult _result;
    SccpAddress *_callingAddress;
    SccpAddress *_calledAddress;
}

@property(readwrite,assign,atomic)  UMTCAP_Command  command;
@property(readwrite,assign,atomic)  int     operation;
@property(readwrite,assign,atomic)  UMTCAP_FilterResult result;
@property(readwrite,strong,atomic)  SccpAddress *callingAddress;
@property(readwrite,strong,atomic)  SccpAddress *calledAddress;

- (void)addApplicationContext:(NSString *)context;

- (UMTCAP_FilterResult)filterPacket:(UMTCAP_Command)command
                 applicationContext:(NSString *)context
                      operationCode:(int64_t)opCode
                     callingAddress:(SccpAddress *)src
                      calledAddress:(SccpAddress *)dst
                           debugLog:(NSMutableString *)s;

@end
