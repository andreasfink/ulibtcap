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

- (UMTCAP_InternalOperation) operationType
{
   return UMTCAP_InternalOperation_Response;
}

- (void)setOperationType
{
}

- (UMTCAP_itu_asn1_returnResult *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o0 = [self getObjectAtPosition:0];
    _itu_invokeId = [[UMASN1Integer alloc]initWithASN1Object:o0 context:context];

    UMASN1Object *o1 = [self getObjectAtPosition:1];
    if(o1)
    {
        UMASN1Sequence *result = [[UMASN1Sequence alloc]initWithASN1Object:o1 context:context];
        if(result)
        {
            UMASN1Object *op = [result getObjectAtPosition:0];
            if(op.asn1_tag.tagNumber==UMASN1Primitive_object_identifier)
            {
                _itu_globalOperationCode = [[UMASN1ObjectIdentifier alloc]initWithASN1Object:op context:context];
            }
            else if(op.asn1_tag.tagNumber==UMASN1Primitive_integer)
            {
                _itu_localOperationCode = [[UMASN1Integer alloc]initWithASN1Object:op context:context];
            }
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
        _asn1_tag.tagNumber = 2;
    }
    else
    {
        _asn1_tag.tagNumber = 7;
    }
    _asn1_tag.tagClass  = UMASN1Class_ContextSpecific;
    
    _asn1_list = [[NSMutableArray alloc]init];
    
    //itu_invokeId.asn1_tag.tagNumber = UMASN1Primitive_integer;
    [_asn1_list addObject:_itu_invokeId];

    if(params)
    {
        UMASN1Sequence *seq = [[UMASN1Sequence alloc]init];
        if(_itu_localOperationCode)
        {
            [seq appendValue:_itu_localOperationCode];
        }
        else if(_itu_globalOperationCode)
        {
            [seq appendValue:_itu_globalOperationCode];
        }
        [seq appendValue:params];
        [_asn1_list addObject:seq];
    }
}

- (NSString *)objectName
{
    if(isLast)
    {
        return @"returnResultLast";

    }
    else
    {
        return @"returnResultNotLast";
    }
}


@end
