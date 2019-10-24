//
//  UMTCAP_itu_asn1_componentPortion.m
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_componentPortion.h"
#import "UMTCAP_itu_asn1_componentPDU.h"

@implementation UMTCAP_itu_asn1_componentPortion



- (UMTCAP_itu_asn1_componentPortion *)processAfterDecodeWithContext:(id)context
{
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for(UMASN1Object *o in _asn1_list)
    {
        UMTCAP_itu_asn1_componentPDU *c = [[UMTCAP_itu_asn1_componentPDU alloc]initWithASN1Object:o context:context];
        [list addObject:c];
    }
    _asn1_list = list;
    return self;
}

- (void)addComponent:(UMTCAP_itu_asn1_componentPDU *)component
{
    [_asn1_list addObject:component];
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.tagNumber = 12;
    _asn1_tag.tagClass = UMASN1Class_Application;
}

- (NSString *)objectName
{
    return @"componentPortion";
}

- (NSArray *)arrayOfComponents
{
    return [_asn1_list copy];
}

@end
