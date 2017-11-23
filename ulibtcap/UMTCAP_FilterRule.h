//
//  UMTCAP_FilterRule.h
//  ulibtcap
//
//  Created by Andreas Fink on 23.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMTCAP_Command.h"
#import "UMTCAP_FilterResult.h"

@interface UMTCAP_FilterRule : UMObject
{
    UMTCAP_Command  _command;
    UMSynchronizedArray *_applicationContexts;
    int     _operation; /* MAP operation code. -1 stands for "any", 0 stands for "undefined" (meaning there is no operation code in the packet) */
    BOOL    _drop;      /* drop the packet */
    BOOL    _reject;    /* send back UDTS */
    BOOL    _allow;     /* immediately go to parsing upper layers */
    BOOL    _redirect;  /* send packet back cout */
}

@property(readwrite,assign,atomic)  UMTCAP_Command  command;
@property(readwrite,assign,atomic)  int     operation;
@property(readwrite,assign,atomic)  BOOL    drop;
@property(readwrite,assign,atomic)  BOOL    allow;
@property(readwrite,assign,atomic)  BOOL    redirect;
@property(readwrite,assign,atomic)  BOOL    reject;

- (void)addApplicationContext:(NSString *)context;

- (UMTCAP_FilterResult)filterPacket:(UMTCAP_Command)command
                 applicationContext:(NSString *)context
                      operationCode:(int64_t)opCode;
@end
