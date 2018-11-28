//
//  UMTCAP_Filter.m
//  ulibtcap
//
//  Created by Andreas Fink on 23.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_Filter.h"
#import "UMTCAP_FilterRule.h"
#import "UMTCAP_FilterResult.h"

@implementation UMTCAP_Filter

- (UMTCAP_Filter *)init
{
    self = [super init];
    if(self)
    {
        _rules = [[UMSynchronizedArray alloc]init];
        _logLevel = UMLOG_MAJOR;
    }
    return self;
}

- (void)removeAllRules
{
    _rules = [[UMSynchronizedArray alloc]init];
}

- (void)addRule:(UMTCAP_FilterRule *)rule
{
    [_rules addObject:rule];
}

#define CONFIG_ERROR(s)     [NSException exceptionWithName:[NSString stringWithFormat:@"CONFIG_ERROR FILE %s line:%ld",__FILE__,(long)__LINE__] reason:s userInfo:@{@"backtrace": UMBacktrace(NULL,0) }]

- (void)setConfig:(NSDictionary *)dict
{
    if(dict[@"name"])
    {
        _name = [dict[@"name"] stringValue];
        _active = [dict configEnabledWithYesDefault];
        NSString *ll = dict[@"log-level"];
        if(ll)
        {
            _logLevel = [ll intValue];
        }
        NSString *tt = dict[@"bypass-translation-type"];
        if(tt)
        {
            int ttInt = [tt intValue];
            if((ttInt <0) || (ttInt>255))
            {
                NSString *s = [NSString stringWithFormat:@"bypass-translation-type has invalid value '%@'",tt];
                @throw(CONFIG_ERROR(s));
            }
            _bypass_translation_type = ttInt;
        }

        NSString *defaultResult = dict[@"default-result"];
        if([defaultResult isEqualToString:@"accept"])
        {
            _defaultResult = UMTCAP_FilterResult_accept;
        }
        else if([defaultResult isEqualToString:@"drop"])
        {
            _defaultResult = UMTCAP_FilterResult_drop;
        }
        else if([defaultResult isEqualToString:@"reject"])
        {
            _defaultResult = UMTCAP_FilterResult_reject;
        }
        else if([defaultResult isEqualToString:@"redirect"])
        {
            _defaultResult = UMTCAP_FilterResult_redirect;
        }
        else
        {
            NSString *s = [NSString stringWithFormat:@"unknown default-result '%@'. Should be accept,drop,reject or redirect",defaultResult];
            @throw(CONFIG_ERROR(s));
        }
    }
}

- (UMTCAP_FilterResult)filterPacket:(UMTCAP_Command)command
                 applicationContext:(NSString *)context
                      operationCode:(int64_t)opCode
                     callingAddress:(SccpAddress *)src
                      calledAddress:(SccpAddress *)dst
{
    NSMutableString *s;
    if(self.logFeed)
    {
        if(_logLevel <=UMLOG_DEBUG)
        {
            NSString *cmd;
            switch(command)
            {
                case TCAP_TAG_ANSI_UNIDIRECTIONAL:
                    cmd = @"ansi-unidirectional";
                    break;
                case TCAP_TAG_ANSI_QUERY_WITH_PERM:
                    cmd = @"ansi-query-with-perm";
                    break;
                case TCAP_TAG_ANSI_QUERY_WITHOUT_PERM:
                    cmd = @"ansi-query-without-perm";
                    break;
                case TCAP_TAG_ANSI_RESPONSE:
                    cmd = @"ansi-response";
                    break;
                case TCAP_TAG_ANSI_CONVERSATION_WITH_PERM:
                    cmd = @"ansi-conversation-with-perm";
                    break;
                case TCAP_TAG_ANSI_CONVERSATION_WITHOUT_PERM:
                    cmd = @"ansi-conversation-without-perm";
                    break;
                case TCAP_TAG_ANSI_ABORT:
                    cmd = @"abort";
                    break;
                case TCAP_TAG_ITU_UNIDIRECTIONAL:
                    cmd = @"unidirectional";
                    break;
                case TCAP_TAG_ITU_BEGIN:
                    cmd = @"begin";
                    break;
                case TCAP_TAG_ITU_END:
                    cmd = @"end";
                    break;
                case TCAP_TAG_ITU_CONTINUE:
                    cmd = @"continue";
                    break;
                case TCAP_TAG_ITU_ABORT:
                    cmd = @"abort";
                    break;
                default:
                    cmd=@"undefined";
                    break;
            }
            s = [NSMutableString stringWithFormat:@"checking tcap-filter '%@' for command '%@' context='%@', opcode=%d",
                 _name,cmd,context,(int)opCode];
        }
    }
    UMTCAP_FilterResult r = UMTCAP_FilterResult_continue;
    NSArray *rules = [_rules arrayCopy];
    int i = 0;
    for(UMTCAP_FilterRule *rule in rules)
    {
        i++;
        r = [rule filterPacket:command
            applicationContext:context
                 operationCode:opCode
                callingAddress:src
                 calledAddress:dst
                      debugLog:s];
        if(s)
        {
            NSString *resultText;
            switch(r)
            {
                case UMTCAP_FilterResult_accept:
                    resultText = @"accept";
                    break;
                case UMTCAP_FilterResult_drop:
                    resultText = @"drop";
                    break;
                case UMTCAP_FilterResult_reject:
                    resultText = @"reject";
                    break;
                case UMTCAP_FilterResult_redirect:
                    resultText = @"redirect";
                    break;
                case UMTCAP_FilterResult_continue:
                    resultText = @"continue";
                    break;
            }
            [s appendFormat:@"\n\trule %d returns %@",i,resultText];
        }
        if(r != UMTCAP_FilterResult_continue)
        {
            break;
        }
    }
    if(r == UMTCAP_FilterResult_continue)
    {
        r = _defaultResult;
        if(s)
        {
            NSString *resultText;
            switch(r)
            {
                case UMTCAP_FilterResult_accept:
                    resultText = @"accept";
                    break;
                case UMTCAP_FilterResult_drop:
                    resultText = @"drop";
                    break;
                case UMTCAP_FilterResult_reject:
                    resultText = @"reject";
                    break;
                case UMTCAP_FilterResult_redirect:
                    resultText = @"redirect";
                    break;
                case UMTCAP_FilterResult_continue:
                    resultText = @"continue";
                    break;
            }
            [s appendFormat:@"\n\tdefault rule %@",resultText];
        }
    }
    if(s)
    {
        [self.logFeed debugText:s];
    }
    return r;
}
@end
