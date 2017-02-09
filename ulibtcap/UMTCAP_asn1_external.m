//
//  UMTCAP_asn1_external.m
//  ulibtcap
//
//  Created by Andreas Fink on 26.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_asn1_external.h"

@implementation UMTCAP_asn1_external

@synthesize asn1Type;
@synthesize objectIdentifier;
@synthesize externalObject;

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagNumber = UMASN1Primitive_external;
    asn1_tag.tagClass = UMASN1Class_Universal;
    asn1_list = [[NSMutableArray alloc]init];
    

    if(externalObject)
    {
        asn1Type = [[UMASN1ObjectConstructed alloc]init];
        asn1Type.asn1_tag.tagNumber = 0;
        asn1Type.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        [asn1Type.asn1_list addObject:externalObject];
    }
    if(objectIdentifier)
    {
        objectIdentifier.asn1_tag.tagNumber = 6;
        objectIdentifier.asn1_tag.tagClass = UMASN1Class_Universal;
        [asn1_list addObject:objectIdentifier];
    }
    if(asn1Type)
    {
       [asn1_list addObject:asn1Type];
    }
}

- (NSString *)objectName
{
    return @"external";
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    
    if(objectIdentifier)
    {
        dict[@"objectIdentifier"]= objectIdentifier.objectValue;
    }
    if(asn1Type)
    {
        dict[@"asn1Type"]= asn1Type.objectValue;
    }
    return dict;
}

- (UMTCAP_asn1_external *)processAfterDecodeWithContext:(id)context
{
    
    int pos = 0;
    UMASN1Object *o = [self getObjectAtPosition:pos++];
    
    
    
    if((o) &&  (o.asn1_tag.tagClass == UMASN1Class_Universal) && (o.asn1_tag.tagNumber == 6))
    {
        objectIdentifier = [[UMTCAP_asn1_objectIdentifier alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:pos++];
    }
    
    if((o) &&  (o.asn1_tag.tagClass == UMASN1Class_ContextSpecific) && (o.asn1_tag.tagNumber == 0) && (o.asn1_tag.isConstructed))
    {
        asn1Type = (UMASN1ObjectConstructed *)o;
        if(asn1Type)
        {
            externalObject = [asn1Type getObjectAtPosition:0];
        }
    }
    return self;
}


@end
