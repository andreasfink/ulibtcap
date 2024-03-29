//
//  UMTCAP_ansi_asn1_transactionID.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_ansi_asn1_transactionID.h>

@implementation UMTCAP_ansi_asn1_transactionID

@synthesize  tid;

- (UMTCAP_ansi_asn1_transactionID *)processAfterDecodeWithContext:(id)context
{
    NSData *d = self.value;
    tid = d.hexString;
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];

    _asn1_tag.tagClass =UMASN1Class_Private;
    _asn1_tag.tagNumber = 7;
    [_asn1_tag setTagIsPrimitive];
    _asn1_data = [tid unhexedData];
}

- (NSString *)objectName
{
    return @"transactionID";
}


@end
