//
//  UMTCAP_ansi_asn1_Invoke.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_invoke.h"
#import "UMTCAP_sccpNUnitdata.h"
#import "UMTCAP_sccpNNotice.h"
#import "UMTCAP_ansi_asn1_componentIDs.h"

@implementation UMTCAP_ansi_asn1_invoke


- (void)processBeforeEncode
{
    [super processBeforeEncode];
    if(isLast)
    {
        _asn1_tag.tagNumber = 9;
    }
    else
    {
        _asn1_tag.tagNumber = 13;
    }
    _asn1_list = [[NSMutableArray alloc]init];
    
    if(ansi_componentIDs)
    {
        ansi_componentIDs.asn1_tag.tagNumber = 15;
        [_asn1_list addObject:ansi_componentIDs];
    }
    if(ansi_operationCode)
    {
        ansi_operationCode.asn1_tag.tagNumber = 17;
        [_asn1_list addObject:ansi_operationCode];
    }
    else
    {
        @throw([NSException exceptionWithName:@"MANDATORY_PARAM_MISSING"
                                       reason:NULL
                                     userInfo:@{
                                                @"sysmsg" : @"operational code is mandatory in Invoke",
                                                @"func": @(__func__),
                                                @"backtrace": UMBacktrace(NULL,0)
                                                }
                ]);
    }
    if(params)
    {
        [_asn1_list addObject:params];
    }
}

- (NSString *)objectName
{
    if(isLast)
    {
        return @"invokeLast";
    }
    return @"invoke";
        
}


@end
