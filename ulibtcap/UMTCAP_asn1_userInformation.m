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

@implementation UMTCAP_asn1_userInformation
@synthesize external;


- (void) processBeforeEncode
{
    [super processBeforeEncode];
    [asn1_tag setTagIsConstructed];
    asn1_list = [[NSMutableArray alloc]init];
    if(external)
    {
        [asn1_list addObject:external];
    }
    asn1_tag.tagClass = UMASN1Class_ContextSpecific;
    asn1_tag.tagNumber = 30;
}

- (UMTCAP_asn1_userInformation *) processAfterDecodeWithContext:(id)context
{
    int p=0;
    UMASN1Object *o = [self getObjectAtPosition:p++];
    if(o)
    {
        external = [[UMTCAP_asn1_external alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:p++];
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
    if(external)
    {
        dict[@"external"] = external.objectValue;
    }
    return dict;
}

@end
