//
//  UMTCAP_ansi_asn1_ReturnResult.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_returnResult.h"

@implementation UMTCAP_ansi_asn1_returnResult

/* TODO: we should decode it somehow...*/

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    if(isLast)
    {
        _asn1_tag.tagNumber = 10;
    }
    else
    {
        _asn1_tag.tagNumber = 14;
    }

    _asn1_list = [[NSMutableArray alloc]init];
    
    if(ansi_componentIDs)
    {
        ansi_componentIDs.asn1_tag.tagNumber = 15;
        [_asn1_list addObject:ansi_componentIDs];
    }
    if(params)
    {
        [_asn1_list addObject:params];
    }
}
- (NSString *)objectName
{
    return @"returnResult";
}


@end
