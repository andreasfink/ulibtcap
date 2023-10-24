//
//  UMTCAP_ansi_asn1_response.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_ansi_asn1_response.h>
#import <ulibtcap/UMTCAP_sccpNUnitdata.h>
#import <ulibtcap/UMTCAP_sccpNNotice.h>

@implementation UMTCAP_ansi_asn1_response


- (UMASN1Object *)processAfterDecodeWithContext:(id)context
{
    [super processAfterDecodeWithContext:context];
    return self;
}


- (void)processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.tagClass = UMASN1Class_Private;
    _asn1_tag.tagNumber = 3;
}

- (NSString *)objectName
{
    return @"response";
}


@end
