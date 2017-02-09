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

#import "UMTCAP_itu_asn1_returnError.h"
#import "UMTCAP_sccpNUnitdata.h"
#import "UMTCAP_itu_asn1_errorCode.h"

@implementation UMTCAP_itu_asn1_returnError

@synthesize errorDescription;

- (UMTCAP_itu_asn1_returnError *)processAfterDecodeWithContext:(id)context
{    
    int p = 0;
    UMASN1Object *o = [self getObjectAtPosition:p++];
    if(!o)
    {
        @throw([NSException exceptionWithName:@"missing invokeId section in UMTCAP_itu_asn1_returnError" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    itu_invokeId = [[UMASN1Integer alloc]initWithASN1Object:o context:context];

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
    
    asn1_tag.tagNumber = 3;
    asn1_tag.tagClass  = UMASN1Class_Universal;
    
    asn1_list = [[NSMutableArray alloc]init];
    
    itu_invokeId.asn1_tag.tagNumber = 1;
    if(itu_invokeId==NULL)
    {
        @throw([NSException exceptionWithName:@"missing invokeId section in UMTCAP_itu_asn1_returnError" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    [asn1_list addObject:itu_invokeId];

    UMASN1Integer *e = [[UMASN1Integer alloc]initWithValue:self.errorCode];
    [asn1_list addObject:e];
    if(params)
    {
        [asn1_list addObject:params];
    }
}

- (NSString *)objectName
{
    return @"returnError";
}


- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    
    dict[@"invokeId"] = itu_invokeId.objectValue;
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
