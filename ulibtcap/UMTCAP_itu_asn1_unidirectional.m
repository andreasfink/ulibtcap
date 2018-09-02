//
//  UMTCAP_itu_asn1_unidirectional.m
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_unidirectional.h"

@implementation UMTCAP_itu_asn1_unidirectional

@synthesize dialoguePortion;
@synthesize componentPortion;



- (UMTCAP_itu_asn1_unidirectional *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o0 = [self getObjectAtPosition:0];
    UMASN1Object *o1 = [self getObjectAtPosition:1];
    
    if(o1)
    {
        dialoguePortion = [[UMTCAP_itu_asn1_dialoguePortion alloc]initWithASN1Object:o0 context:context];
        componentPortion = [[UMTCAP_itu_asn1_componentPortion alloc]initWithASN1Object:o1 context:context];
    }
    else if(o0)
    {
        componentPortion = [[UMTCAP_itu_asn1_componentPortion alloc]initWithASN1Object:o0 context:context];
    }
    else
    {
        @throw([NSException exceptionWithName:@"component portion is missing in tcap_unidirectional" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    
    _asn1_tag.tagNumber=1;
    _asn1_tag.tagClass = UMASN1Class_Application;
    
   	[_asn1_tag setTagIsConstructed];
    _asn1_list = [[NSMutableArray alloc]init];
    if(dialoguePortion)
    {
        [_asn1_list addObject:dialoguePortion];
    }
    if(componentPortion==NULL)
    {
        @throw([NSException exceptionWithName:@"component portion is missing in tcap_unidirectional" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    [_asn1_list addObject:componentPortion];
}

- (NSString *)objectName
{
    return @"unidirectional";
}


@end
