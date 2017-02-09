//
//  UMTCAP_itu_asn1_end.m
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_end.h"
#import "UMTCAP_sccpNUnitdata.h"
@implementation UMTCAP_itu_asn1_end

@synthesize dtid;
@synthesize dialoguePortion;
@synthesize componentPortion;

- (UMTCAP_itu_asn1_end *)processAfterDecodeWithContext:(id)context
{
    UMTCAP_sccpNUnitdata *task = NULL;
    if ([context isKindOfClass:[UMTCAP_sccpNUnitdata class ]])
    {
        task = (UMTCAP_sccpNUnitdata *)context;
    }
    
    UMASN1Object *o0 = [self getObjectAtPosition:0];
    UMASN1Object *o1 = [self getObjectAtPosition:1];
    UMASN1Object *o2 = [self getObjectAtPosition:2];
    
    if(o0==NULL)
    {
        @throw([NSException exceptionWithName:@"destination transactin id is missing in tcap_end" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    dtid =  [[UMTCAP_itu_asn1_dtid alloc]initWithASN1Object:o0 context:context];
    if(o2)
    {
        dialoguePortion = [[UMTCAP_itu_asn1_dialoguePortion alloc]initWithASN1Object:o1 context:context];
        componentPortion = [[UMTCAP_itu_asn1_componentPortion alloc]initWithASN1Object:o2 context:context];
    }
    else
    {
        componentPortion = [[UMTCAP_itu_asn1_componentPortion alloc]initWithASN1Object:o1 context:context];
    }
    
    [task handleComponents:componentPortion];
    return self;
}

- (void)processBeforeEncode
{
    
    [super processBeforeEncode];
    
    [asn1_tag setTagIsConstructed];
    asn1_tag.tagNumber = TCAP_TAG_ITU_END;
    asn1_tag.tagClass = UMASN1Class_Application;

    asn1_list = [[NSMutableArray alloc]init];
    if(dtid==NULL)
    {
        @throw([NSException exceptionWithName:@"destination transactin id is missing in tcap_end" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }

    [asn1_list addObject:dtid];
    if(dialoguePortion)
    {
        [asn1_list addObject:dialoguePortion];
    }
    if(componentPortion)
    {
        [asn1_list addObject:componentPortion];
    }
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict =[[UMSynchronizedSortedDictionary alloc]init];
    
    if(dtid)
    {
        dict[@"dtid"] = dtid.objectValue;
    }
    if(dialoguePortion)
    {
        dict[@"dialoguePortion"] = dialoguePortion.objectValue;
    }
    if(componentPortion)
    {
        dict[@"componentPortion"] = componentPortion.objectValue;
    }
    return dict;
}


- (NSString *)objectName
{
    return @"end";
}


@end
