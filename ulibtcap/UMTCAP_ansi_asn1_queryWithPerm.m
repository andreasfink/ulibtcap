//
//  UMTCAP_ansi_asn1_queryWithPerm.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_queryWithPerm.h"
#import "UMTCAP_sccpNUnitdata.h"
#import "UMTCAP_sccpNNotice.h"

@implementation UMTCAP_ansi_asn1_queryWithPerm


- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagClass = UMASN1Class_Private;
    asn1_tag.tagNumber = 2;
}

- (NSString *)objectName
{
    return @"queryWithPerm";
}


@end
