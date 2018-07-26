//
//  UMTCAP_FilterRule.m
//  ulibtcap
//
//  Created by Andreas Fink on 23.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_FilterRule.h"
#import "UMTCAP_Command.h"

@implementation UMTCAP_FilterRule

- (UMTCAP_FilterRule *)init
{
    self = [super init];
    if(self)
    {
        _applicationContexts = [[UMSynchronizedArray alloc]init];
    }
    return self;
}

- (void)addApplicationContext:(NSString *)context
{
    [_applicationContexts addObject:context];
}

#define CONFIG_ERROR(s)     [NSException exceptionWithName:[NSString stringWithFormat:@"CONFIG_ERROR FILE %s line:%ld",__FILE__,(long)__LINE__] reason:s userInfo:@{@"backtrace": UMBacktrace(NULL,0) }]

- (void)setConfig:(NSDictionary *)dict
{
    NSString *command = dict[@"command"];
    NSString *operation = dict[@"operation"];
    NSString *contexts = dict[@"application-contexts"];
    NSString *result = dict[@"result"];

    NSString *callingAddress = dict[@"calling-address"];
    NSString *calledAddress = dict[@"called-address"];

    if([command isEqualToString:@"begin"])
    {
        _command = TCAP_TAG_ITU_BEGIN;
    }
    else if([command isEqualToString:@"continue"])
    {
        _command = TCAP_TAG_ITU_CONTINUE;
    }
    else if([command isEqualToString:@"end"])
    {
        _command = TCAP_TAG_ITU_END;
    }
    else if([command isEqualToString:@"abort"])
    {
        _command = TCAP_TAG_ITU_ABORT;
    }
    else if([command isEqualToString:@"unidirectional"])
    {
        _command = TCAP_TAG_ITU_UNIDIRECTIONAL;
    }
    else if([command isEqualToString:@"any"])
    {
        _command = TCAP_TAG_UNDEFINED;
    }

    if(([operation isEqualToString:@"any"]) || (operation==NULL))
    {
        _operation = -1;
    }
    if([operation isEqualToString:@"undefined"])
    {
        _operation = -2;
    }
    else
    {
        _operation = [operation intValue];
    }
    NSArray *contextsArray = [contexts componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    for(NSString *context in contextsArray)
    {
        [self addApplicationContext:context];
    }

    if([result isEqualToString:@"accept"])
    {
        _result = UMTCAP_FilterResult_accept;
    }
    else if([result isEqualToString:@"drop"])
    {
        _result = UMTCAP_FilterResult_drop;
    }
    else if([result isEqualToString:@"reject"])
    {
        _result = UMTCAP_FilterResult_reject;
    }
    else if([result isEqualToString:@"redirect"])
    {
        _result = UMTCAP_FilterResult_redirect;
    }
    else
    {
        NSString *s = [NSString stringWithFormat:@"unknown result '%@'. Should be accept,drop,reject or redirect",result];
        @throw(CONFIG_ERROR(s));
    }

    if(callingAddress.length > 0)
    {
        _callingAddress = [[SccpAddress alloc]initWithHumanReadableString:callingAddress variant:UMMTP3Variant_Undefined];
    }
    if(calledAddress.length > 0)
    {
        _calledAddress = [[SccpAddress alloc]initWithHumanReadableString:calledAddress variant:UMMTP3Variant_Undefined];
    }
}

- (UMTCAP_FilterResult)filterPacket:(UMTCAP_Command)command
                 applicationContext:(NSString *)context
                      operationCode:(int64_t)opCode
                     callingAddress:(SccpAddress *)src
                      calledAddress:(SccpAddress *)dst
                           debugLog:(NSMutableString *)s
{

    if(s)
    {
        [s appendFormat:@"\n\tverifying rule"];
        [s appendFormat:@"\n\t\tcommand:%d",_command];
        [s appendFormat:@"\n\t\toperationCode:%d",_operation];
        [s appendFormat:@"\n\t\tapplicationContexts:%@",_applicationContexts];
        [s appendFormat:@"\n\t\tcallingAddress:%@",_callingAddress];
        [s appendFormat:@"\n\t\tcalledAddress:%@",_calledAddress];
        [s appendFormat:@"\n\t\tresult:%d",_result];
    }
    /* does the command match ? */
    if((_command !=TCAP_TAG_UNDEFINED) && (_command != command))
    {
        if(s)
        {
            [s appendFormat:@"\tcommands do not match"];
        }
        return UMTCAP_FilterResult_continue;
    }
    if((_calledAddress.address.length > 0) && (![dst.address isEqualTo:_calledAddress.address]))
    {
        if(s)
        {
            [s appendFormat:@"\n\tcalled address do not match rule. skipping"];
        }
        return UMTCAP_FilterResult_continue;
    }
    if((_callingAddress.address.length > 0) && (![src.address isEqualTo:_callingAddress.address]))
    {
        if(s)
        {
            [s appendFormat:@"\tcalling address do not match rule. skipping"];
        }
        return UMTCAP_FilterResult_continue;
    }
    /* does the operation match and is given */
    if((_operation > 0) && (opCode >= 0) && (_operation!=opCode))
    {
        if(s)
        {
            [s appendFormat:@"\n\toperation code do not match rule. skipping"];
        }
        return UMTCAP_FilterResult_continue;
    }
    BOOL contextMatch = NO;
    if(context == NULL)
    {
        context = @"none";
    }
    NSArray *ctxs = [_applicationContexts arrayCopy];
    for(NSString *ctx in ctxs)
    {
        if([ctx isEqualToString:@"any"])
        {
            contextMatch = YES;
            if(s)
            {
                [s appendFormat:@"\n\tapplication context matches 'any'"];
            }
            break;
        }
        else if([ctx isEqualToString:context])
        {
            if(s)
            {
                [s appendFormat:@"\n\tapplication context matches '%@'",ctx];
            }
            contextMatch = YES;
            break;
        }
    }
    if(contextMatch)
    {
        if(s)
        {
            [s appendFormat:@"\n\tapplication context matched. returning result '%d'",_result];
        }
        return _result;
    }
    return UMTCAP_FilterResult_continue;
}

@end
