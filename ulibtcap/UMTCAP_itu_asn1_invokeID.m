//
//  UMTCAP_itu_asn1_invokeID.m
//  ulibtcap
//
//  Created by Andreas Fink on 16.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_itu_asn1_invokeID.h>

@implementation UMTCAP_itu_asn1_invokeID

- (id)init
{
    return NULL;
}

- (UMTCAP_itu_asn1_invokeID *)processAfterDecodeWithContext:(id)context
{
    return self;
}

- (NSString *)objectName
{
    return @"invokeID";
}

@end
