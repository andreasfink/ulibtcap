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


- (UMTCAP_FilterResult)filterPacket:(UMTCAP_Command)command
                 applicationContext:(NSString *)context
                      operationCode:(int64_t)opCode
                     callingAddress:(SccpAddress *)src
                      calledAddress:(SccpAddress *)dst
{
    NSMutableString *s;
    if(logFeed)
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
                 _name,context,cmd,(int)opCode];
        }
    }
    UMTCAP_FilterResult r = UMTCAP_FilterResult_continue;
    NSArray *rules = [_rules copy];
    int i = 0;
    for(UMTCAP_FilterRule *rule in rules)
    {
        i++;
        r = [rule filterPacket:command
            applicationContext:context
                 operationCode:opCode
                callingAddress:src
                 calledAddress:dst];
        if(s)
        {
            NSString *resultText;
            switch(r)
            {
                case UMTCAP_FilterResult_allow:
                    resultText = @"allow";
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
    if(s)
    {
        [logFeed debugText:s];
    }
    return r;
}
@end
