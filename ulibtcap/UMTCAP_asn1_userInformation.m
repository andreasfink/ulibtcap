//
//  UMTCAP_asn1_userInformation.m
//  ulibtcap
//
//  Created by Andreas Fink on 26.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_asn1_userInformation.h"
#import "UMTCAP_asn1_external.h"
#import "UMTCAP_asn1_userInformationIdentification.h"

@implementation UMTCAP_asn1_userInformation


- (UMTCAP_asn1_userInformation *)init
{
    self = [super init];
    if(self)
    {
        identifications = [[UMSynchronizedArray alloc]init];
    }
    return self;
}
- (void)addIdentification:(UMTCAP_asn1_external *)identification
{
    [identifications addObject:identification];
}

- (void) processBeforeEncode
{
    [super processBeforeEncode];
    [_asn1_tag setTagIsConstructed];
    _asn1_list = [[NSMutableArray alloc]init];
    NSUInteger n = [identifications count];
    if(n > 0)
    {
        for(NSUInteger i=0;i<n;i++)
        {
            [_asn1_list addObject:identifications[i]];
        }
    }
    _asn1_tag.tagClass = UMASN1Class_ContextSpecific;
    _asn1_tag.tagNumber = 30;
}

- (UMTCAP_asn1_userInformation *) processAfterDecodeWithContext:(id)context
{
    NSInteger pos=0;
    UMASN1Object *o = [self getObjectAtPosition:pos++];
    identifications = [[UMSynchronizedArray alloc]init];


    while(o)
    {
        UMTCAP_asn1_external *e = [[UMTCAP_asn1_external alloc]initWithASN1Object:o context:context];
        //UMTCAP_asn1_userInformationIdentification *ui = [[UMTCAP_asn1_userInformationIdentification alloc]initWithASN1Object:o context:context];
        [identifications addObject:e];
        o = [self getObjectAtPosition:pos++];
    }
    return self;
}

- (NSString *) objectName
{
    return @"userInformation";
}

- (id) objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    if(identifications)
    {
        UMSynchronizedArray *arr = [[UMSynchronizedArray alloc]init];
        NSUInteger n = identifications.count;
        for(NSUInteger i=0;i<n;i++)
        {
            UMTCAP_asn1_external *e = identifications[i];
            [arr addObject:e.objectValue];
        }
        dict[@"identifications"] = arr;
    }
    return dict;
}

- (NSInteger)getIdentificationCount
{
    return identifications.count;
}

- (UMTCAP_asn1_external *)getIdentificationNumber:(NSInteger)i
{
    return identifications[i];
}

@end
