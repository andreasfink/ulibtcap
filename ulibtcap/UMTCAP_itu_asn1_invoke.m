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

- (UMTCAP_InternalOperation) operationType
{
   return UMTCAP_InternalOperation_Request;
}

- (void)setOperationType
{
}

- (UMTCAP_itu_asn1_invoke *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o0 = [self getObjectAtPosition:0];
    UMASN1Object *o1 = [self getObjectAtPosition:1];
    UMASN1Object *o2 = [self getObjectAtPosition:2];
    UMASN1Object *o3 = [self getObjectAtPosition:3];

    _itu_invokeId = [[UMASN1Integer alloc]initWithASN1Object:o0 context:context];
    if(o1 && o2 && o3)
    {
        _itu_invokeId = [[UMASN1Integer alloc]initWithASN1Object:o1 context:context];
        if(o2.asn1_tag.tagNumber == UMASN1Primitive_integer)
        {
            _itu_localOperationCode = [[UMASN1Integer alloc]initWithASN1Object:o2 context:context];
        }
        else if(o2.asn1_tag.tagNumber == UMASN1Primitive_object_identifier)
        {
            _itu_globalOperationCode = [[UMASN1ObjectIdentifier alloc]initWithASN1Object:o2 context:context];
        }
        params = o3;
    }
    else if(o1 && o2 && (o3==NULL))
    {
        _itu_linkedId = NULL;
        if(o1.asn1_tag.tagNumber == UMASN1Primitive_integer)
        {
            _itu_localOperationCode = [[UMASN1Integer alloc]initWithASN1Object:o1 context:context];
        }
        else if(o1.asn1_tag.tagNumber == UMASN1Primitive_object_identifier)
        {
            _itu_globalOperationCode = [[UMASN1ObjectIdentifier alloc]initWithASN1Object:o1 context:context];
        }
        params = o2;
    }
    else if(o1 && (o2==NULL) && (o3==NULL))
    {
        _itu_linkedId = NULL;
        if(o1.asn1_tag.tagNumber == UMASN1Primitive_integer)
        {
            _itu_localOperationCode = [[UMASN1Integer alloc]initWithASN1Object:o1 context:context];
        }
        else if(o1.asn1_tag.tagNumber == UMASN1Primitive_object_identifier)
        {
            _itu_globalOperationCode = [[UMASN1ObjectIdentifier alloc]initWithASN1Object:o1 context:context];
        }
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
    
    [_asn1_list addObject:_itu_invokeId];
    if(_itu_linkedId)
    {
        _itu_linkedId.asn1_tag.tagNumber = 0;
        [_asn1_list addObject:_itu_linkedId];
    }
    if(_useGlobalOperationCode==1)
    {
        if(_itu_globalOperationCode==NULL)
        {
            uint8_t b = (uint8_t)[_itu_localOperationCode value];
            _itu_globalOperationCode = [[UMASN1ObjectIdentifier alloc]initWithValue:[NSData dataWithBytes:&b length:1]];
        }
        [_asn1_list addObject:_itu_globalOperationCode];
    }
    else if(_useGlobalOperationCode==2)
    {
        if(_itu_globalOperationCode==NULL)
        {
            uint8_t b = (uint8_t)[_itu_localOperationCode value];
            _itu_globalOperationCode = [[UMASN1ObjectIdentifier alloc]initWithValue:[NSData dataWithBytes:&b length:1]];
        }
        [_asn1_list addObject:_itu_globalOperationCode];
        [_asn1_list addObject:_itu_localOperationCode];
    }
    else if(_useGlobalOperationCode==3)
    {
        [_asn1_list addObject:_itu_localOperationCode];
        if(_itu_globalOperationCode==NULL)
        {
            uint8_t b = (uint8_t)[_itu_localOperationCode value];
            _itu_globalOperationCode = [[UMASN1ObjectIdentifier alloc]initWithValue:[NSData dataWithBytes:&b length:1]];
        }
        [_asn1_list addObject:_itu_globalOperationCode];
    }

    else
    {
        if(_itu_localOperationCode)
        {
            [_asn1_list addObject:_itu_localOperationCode];
        }
    }
    if(params)
    {
        [_asn1_list addObject:params];
    }
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict =[[UMSynchronizedSortedDictionary alloc]init];
    
    if(_itu_invokeId)
    {
        dict[@"invokeId"] = _itu_invokeId.objectValue;
    }
    if(_itu_linkedId)
    {
        dict[@"linkedId"] = _itu_linkedId.objectValue;
    }
    if(_itu_localOperationCode)
    {
        dict[@"operationCode"] = _itu_localOperationCode.objectValue;
    }
    if(_itu_globalOperationCode)
    {
        dict[@"globalOperationCode"] = _itu_globalOperationCode.objectValue;
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
