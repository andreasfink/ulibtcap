//
//  UMTCAP_ansi_asn1_returnError.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_returnError.h"
#import "UMTCAP_ansi_asn1_errorCode.h"

@implementation UMTCAP_ansi_asn1_returnError


@synthesize errorCode;

- (UMTCAP_ansi_asn1_returnError *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o = [self getObjectAtPosition:0];
    ansi_componentIDs = [[UMTCAP_ansi_asn1_componentIDs alloc]initWithASN1Object:o context:context];

    o = [self getObjectAtPosition:1];
    errorCode = [[UMTCAP_ansi_asn1_errorCode alloc]initWithASN1Object:o context:context];
    params = [self getObjectAtPosition:2];
    return self;
}


- (int64_t)errorCodeInt
{
    return errorCode.code.value;
}

- (void)setErrorCodeInt:(int64_t)i
{
    if(!errorCode)
    {
        errorCode = [[UMTCAP_ansi_asn1_errorCode alloc]init];
    }
    errorCode.code.value = i;
}

-(BOOL)errorCodeIsPrivate
{
    return errorCode.isPrivate;
}

-(void)setErrorCodeIsPrivate:(BOOL)priv
{
    if(!errorCode)
    {
        errorCode = [[UMTCAP_ansi_asn1_errorCode alloc]init];
    }
    errorCode.isPrivate = priv;

}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagNumber = 11;
    
    asn1_list = [[NSMutableArray alloc]init];
    
    if(ansi_componentIDs)
    {
        ansi_componentIDs.asn1_tag.tagNumber = 15;
        [asn1_list addObject:ansi_componentIDs];
    }
    else
    {
        @throw([NSException exceptionWithName:@"MANDATORY_PARAM_MISSING"
                                       reason:NULL
                                     userInfo:@{
                                                @"sysmsg" : @"componentID is mandatory in returnError",
                                                @"func": @(__func__),
                                                @"backtrace": UMBacktrace(NULL,0)}
                ]);
    }
    if(errorCode)
    {
        [asn1_list addObject:errorCode];
    }
    else
    {
        @throw([NSException exceptionWithName:@"MANDATORY_PARAM_MISSING"
                                       reason:NULL
                                     userInfo:@{
                                                @"sysmsg" : @"errorCode is mandatory in returnError",
                                                @"func": @(__func__),
                                                @"backtrace": UMBacktrace(NULL,0)}
                ]);
    }
    if(params)
    {
        [asn1_list addObject:params];
    }
}

- (NSString *)objectName
{
    return @"returnError";
}

@end
