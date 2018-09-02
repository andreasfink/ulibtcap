//
//  UMTCAP_itu_asn1_invoke.m
//  ulibtcap
//
//  Created by Andreas Fink on 29/03/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_invoke.h"
#import "UMTCAP_sccpNUnitdata.h"

@implementation UMTCAP_itu_asn1_invoke


- (UMTCAP_itu_asn1_invoke *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o0 = [self getObjectAtPosition:0];
    UMASN1Object *o1 = [self getObjectAtPosition:1];
    UMASN1Object *o2 = [self getObjectAtPosition:2];
    UMASN1Object *o3 = [self getObjectAtPosition:3];

    itu_invokeId = [[UMASN1Integer alloc]initWithASN1Object:o0 context:context];
    if(o1 && o2 && o3)
    {
        itu_linkedId = [[UMASN1Integer alloc]initWithASN1Object:o1 context:context];
        itu_operationCode = [[UMASN1Integer alloc]initWithASN1Object:o2 context:context];
        params = o3;
    }
    else if(o1 && o2 && (o3==NULL))
    {
        itu_linkedId = NULL;
        itu_operationCode = [[UMASN1Integer alloc]initWithASN1Object:o1 context:context];
        params = o2;
    }
    else if(o1 && (o2==NULL) && (o3==NULL))
    {
        itu_linkedId = NULL;
        itu_operationCode = [[UMASN1Integer alloc]initWithASN1Object:o1 context:context];
        params = NULL;
    }
    else
    {
        @throw([NSException exceptionWithName:@"missing mandatory sections in UMTCAP_itu_asn1_invoke" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    return self;
}


- (void)processBeforeEncode
{
    [super processBeforeEncode];

    _asn1_tag.tagNumber = 1;
    _asn1_tag.tagClass  = UMASN1Class_ContextSpecific;
    
    _asn1_list = [[NSMutableArray alloc]init];
    
    [_asn1_list addObject:itu_invokeId];
    if(itu_linkedId)
    {
        itu_linkedId.asn1_tag.tagNumber = 0;
        [_asn1_list addObject:itu_linkedId];
    }
    [_asn1_list addObject:itu_operationCode];
    if(params)
    {
        [_asn1_list addObject:params];
    }
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict =[[UMSynchronizedSortedDictionary alloc]init];
    
    if(itu_invokeId)
    {
        dict[@"invokeId"] = itu_invokeId.objectValue;
    }
    if(itu_linkedId)
    {
        dict[@"linkedId"] = itu_linkedId.objectValue;
    }
    if(itu_operationCode)
    {
        dict[@"operationCode"] = itu_operationCode.objectValue;
    }

    if(params)
    {
        dict[@"params"] = params.objectValue;
        dict[@"paramsType"] = params.objectName;
        NSString *op = params.objectOperation;
        if(op)
        {
            dict[@"operationName"] = op;
        }
    }
    return dict;
}

- (NSString *)objectName
{
    return @"invoke";
}


@end
