//
//  UMTCAP_itu_asn1_returnResult.m
//  ulibtcap
//
//  Created by Andreas Fink on 29/03/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_returnResult.h"
#import "UMTCAP_sccpNUnitdata.h"
@implementation UMTCAP_itu_asn1_returnResult

- (UMTCAP_itu_asn1_returnResult *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o0 = [self getObjectAtPosition:0];
    itu_invokeId = [[UMASN1Integer alloc]initWithASN1Object:o0 context:context];

    UMASN1Object *o1 = [self getObjectAtPosition:1];
    if(o1)
    {
        UMASN1Sequence *result = [[UMASN1Sequence alloc]initWithASN1Object:o1 context:context];
        if(result)
        {
            UMASN1Object *op = [result getObjectAtPosition:0];
            itu_operationCode = [[UMASN1Integer alloc]initWithASN1Object:op context:context];
            //self.operationCode = itu_operationCode;

            params = [result getObjectAtPosition:1];
        }
    }
    return self;
}


- (void)processBeforeEncode
{
    [super processBeforeEncode];
    
    if(isLast)
    {
        asn1_tag.tagNumber = 2;
    }
    else
    {
        asn1_tag.tagNumber = 7;
    }
    asn1_tag.tagClass  = UMASN1Class_ContextSpecific;
    
    asn1_list = [[NSMutableArray alloc]init];
    
    //itu_invokeId.asn1_tag.tagNumber = UMASN1Primitive_integer;
    [asn1_list addObject:itu_invokeId];

    if(params)
    {
        UMASN1Sequence *seq = [[UMASN1Sequence alloc]init];
        [seq appendValue:itu_operationCode];
        [seq appendValue:params];
        [asn1_list addObject:seq];
    }
}

- (NSString *)objectName
{
    return @"returnResult";
}


@end
