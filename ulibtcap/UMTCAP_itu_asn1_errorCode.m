//
//  UMTCAP_itu_asn1_errorCode.m
//  ulibtcap
//
//  Created by Andreas Fink on 17.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_itu_asn1_errorCode.h>

@implementation UMTCAP_itu_asn1_errorCode


- (UMTCAP_itu_asn1_errorCode *)processAfterDecodeWithContext:(id)context
{
    return self;
}

- (NSString *)objectName
{
    return @"errorCode";
}

- (id)objectValue
{
    return @(self.value);
}

@end
