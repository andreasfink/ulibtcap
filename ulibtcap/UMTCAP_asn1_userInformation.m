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


- (void)setExternal:(UMTCAP_asn1_external *)external
{
    UMSynchronizedArray *e = [[UMSynchronizedArray alloc]init];
    [e addObject:external];
    externals = e;
}

- (UMTCAP_asn1_external *):external
{
    return externals[0];
}

- (void)addExternal:(UMTCAP_asn1_external *)external
{
    [externals addObject:external];
}

- (void) processBeforeEncode
{
    [super processBeforeEncode];
    [asn1_tag setTagIsConstructed];
    asn1_list = [[NSMutableArray alloc]init];
    if(externals)
    {
        NSInteger n = [externals count];
        for(NSInteger i=0;i<n;i++)
        {
            UMTCAP_asn1_external *external = externals[i];
            [asn1_list addObject:external];
        }
    }
    asn1_tag.tagClass = UMASN1Class_ContextSpecific;
    asn1_tag.tagNumber = 30;
}

- (UMTCAP_asn1_userInformation *) processAfterDecodeWithContext:(id)context
{
    for(NSInteger i=0;i<asn1_list.count;i++)
    {
        UMASN1Object *o = [self getObjectAtPosition:i];
        UMTCAP_asn1_external *external = [[UMTCAP_asn1_external alloc]initWithASN1Object:o context:context];
        if(external)
        {
            [externals addObject:external];
        }
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
    if(externals)
    {
        dict[@"externals"] = externals;
    }
    return dict;
}

@end
