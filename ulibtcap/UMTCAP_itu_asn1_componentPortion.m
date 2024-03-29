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

#import <ulibtcap/UMTCAP_itu_asn1_componentPortion.h>
#import <ulibtcap/UMTCAP_itu_asn1_componentPDU.h>

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

- (NSArray *)arrayOfOperationCodes;
{
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for(UMASN1Object *o in _asn1_list)
    {
        UMTCAP_itu_asn1_componentPDU *c = [[UMTCAP_itu_asn1_componentPDU alloc]initWithASN1Object:o context:NULL];
        UMASN1Integer *i = c.itu_localOperationCode;
        UMASN1ObjectIdentifier *g = c.itu_globalOperationCode;
        if(i)
        {
            [list addObject: @(i.value)];
        }
        else if(g)
        {
            NSData *d = g.value;
            if(d.length ==1)
            {
                int j = *(uint8_t *)d.bytes;
                [list addObject:@(j)];
            }
        }
    }
    return list;
}
@end
