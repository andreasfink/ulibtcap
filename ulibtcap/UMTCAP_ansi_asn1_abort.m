//
//  UMTCAP_ansi_asn1_abort.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_abort.h"

@implementation UMTCAP_ansi_asn1_abort


- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagClass = UMASN1Class_Private;
    asn1_tag.tagNumber = 22;
}

- (NSString *)objectName
{
    return @"abort";
}


@end
