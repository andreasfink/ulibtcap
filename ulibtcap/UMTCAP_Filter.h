//
//  UMTCAP_Filter.h
//  ulibtcap
//
//  Created by Andreas Fink on 23.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMTCAP_Command.h"
#import "UMTCAP_FilterResult.h"

#define UMTCAP_FILTER_OPCODE_ANY        -1
#define UMTCAP_FILTER_OPCODE_MISSING    0; //equal to UMGSMMAP_Opcode_noOpcode

@class  UMTCAP_FilterRule;
@interface UMTCAP_Filter : UMObject
{
    NSString            *_name;
    BOOL                _active;
    UMSynchronizedArray *_rules;
    int                 _bypass_translation_type;
}

@property(readwrite,strong,atomic)  NSString *name;
@property(readwrite,assign,atomic)  BOOL    active;
@property(readwrite,assign,atomic)  int     bypass_translation_type;


- (void)removeAllRules;
- (void)addRule:(UMTCAP_FilterRule *)rule;
- (UMTCAP_FilterResult)filterPacket:(UMTCAP_Command)command applicationContext:(NSString *)context operationCode:(int64_t)opCode;

@end
