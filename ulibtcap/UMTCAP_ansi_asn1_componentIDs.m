//
//  UMTCAP_ansi_asn1_componentIDs.m
//  ulibtcap
//
//  Created by Andreas Fink on 06/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_componentIDs.h"

@implementation UMTCAP_ansi_asn1_componentIDs

@synthesize hasCorrelationId;

- (int64_t)invokeIdInt
{
    return invokeId;
}

- (void)setInvokeIdInt:(int64_t)inv
{
    invokeId = inv;
    hasInvokeId = YES;

}

- (int64_t)correlationIdInt
{
    return correlationId;
}

- (void)setCorrelationIdInt:(int64_t)i
{
    correlationId = i;
    hasCorrelationId = YES;
}

- (void)clearCorrelationId
{
    correlationId = 0;
    hasCorrelationId = NO;
}

- (void)processBeforeEncode
{
    uint8_t comp[2];
    int len = 0;
    if(hasInvokeId)
    {
        comp[len++] = (invokeId)& 0xFF;
    }
    if(hasCorrelationId)
    {
        comp[len++] = (correlationId)& 0xFF;
    }
    _asn1_data = [NSData dataWithBytes:comp length:len];
    _asn1_tag.tagNumber = 15;
    _asn1_tag.tagClass = UMASN1Class_Private;
}

- (NSString *)objectName
{
    return @"componentIDs";
}
@end
