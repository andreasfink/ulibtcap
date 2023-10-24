//
//  UMTCAP_itu_asn1_returnError.m
//  ulibtcap
//
//  Created by Andreas Fink on 29/03/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_itu_asn1_returnError.h>
#import <ulibtcap/UMTCAP_sccpNUnitdata.h>
#import <ulibtcap/UMTCAP_itu_asn1_errorCode.h>

@implementation UMTCAP_itu_asn1_returnError

@synthesize errorDescription;

- (UMTCAP_InternalOperation) operationType
{
   return UMTCAP_InternalOperation_Error;
}

- (void)setOperationType
{
}

- (UMTCAP_itu_asn1_returnError *)processAfterDecodeWithContext:(id)context
{    
    int p = 0;
    UMASN1Object *o = [self getObjectAtPosition:p++];
    if(!o)
    {
        @throw([NSException exceptionWithName:@"missing invokeId section in UMTCAP_itu_asn1_returnError" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    _itu_invokeId = [[UMASN1Integer alloc]initWithASN1Object:o context:context];

    o = [self getObjectAtPosition:p++];
    if(!o)
    {
        @throw([NSException exceptionWithName:@"missing errorCode section in UMTCAP_itu_asn1_returnError" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    UMTCAP_itu_asn1_errorCode *e = [[UMTCAP_itu_asn1_errorCode alloc]initWithASN1Object:o context:context];
    [self setErrorCode:e.value];

    o = [self getObjectAtPosition:p++];
    params = o;
    
    
    UMTCAP_sccpNUnitdata *task = NULL;
    if ([context isKindOfClass:[UMTCAP_sccpNUnitdata class ]])
    {
        task = (UMTCAP_sccpNUnitdata *)context;
        if(e)
        {
            errorDescription = [task errorCodeToErrorString:(int)e.value];
        }
    }
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    
    _asn1_tag.tagNumber = 3;
    _asn1_tag.tagClass  = UMASN1Class_ContextSpecific;
    
    _asn1_list = [[NSMutableArray alloc]init];
    
    _itu_invokeId.asn1_tag.tagNumber = 2;
    if(_itu_invokeId==NULL)
    {
        @throw([NSException exceptionWithName:@"missing invokeId section in UMTCAP_itu_asn1_returnError" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    [_asn1_list addObject:_itu_invokeId];

    UMASN1Integer *e = [[UMASN1Integer alloc]initWithValue:self.errorCode];
    [_asn1_list addObject:e];
    if(params)
    {
        [_asn1_list addObject:params];
    }
}

- (NSString *)objectName
{
    return @"returnError";
}


- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    
    dict[@"invokeId"] = _itu_invokeId.objectValue;
    dict[@"errorCode"] = @(self.errorCode);
    if(errorDescription)
    {
        dict[@"errorDescription"] = errorDescription;
    }
    if(params)
    {
        dict[@"parameter"] = params.objectValue;
    }
    return dict;
}
@end
