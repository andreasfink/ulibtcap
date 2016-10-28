//
//  UMTCAP_ansi_asn1_componentIDs.h
//  ulibtcap
//
//  Created by Andreas Fink on 06/04/16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

@interface UMTCAP_ansi_asn1_componentIDs : UMASN1ObjectPrimitive
{
    int64_t invokeId;
    BOOL hasInvokeId;
    
    int64_t correlationId;
    BOOL hasCorrelationId;
}

@property(readwrite,assign) BOOL hasCorrelationId;

- (int64_t)invokeIdInt;
- (void)setInvokeIdInt:(int64_t)inv;

- (int64_t)correlationIdInt;
- (void)setCorrelationIdInt:(int64_t)i;

- (void)clearCorrelationId;

@end
