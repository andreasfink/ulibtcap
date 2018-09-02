//
//  UMTCAP_itu_asn1_abort.m
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_abort.h"

#import "UMTCAP_itu_asn1_dialoguePortion.h"
#import "UMTCAP_itu_asn1_dtid.h"
#import "UMTCAP_itu_asn1_pAbortCause.h"

@implementation UMTCAP_itu_asn1_abort

@synthesize dtid;
@synthesize pAbortCause;
@synthesize uAbortCause;

- (UMTCAP_itu_asn1_abort *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o0 = [self getObjectAtPosition:0];
    UMASN1Object *o1 = [self getObjectAtPosition:1];
    if(o0==NULL)
    {
        @throw([NSException exceptionWithName:@"destination tranation id is missing in tcap_abort" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    dtid =  [[UMTCAP_itu_asn1_dtid alloc]initWithASN1Object:o0 context:context];
    if(o1)
    {
        if((o1.asn1_tag.tagNumber == 10 ) && (o1.asn1_tag.tagClass == UMASN1Class_Application))
        {
            pAbortCause =  [[UMTCAP_itu_asn1_pAbortCause alloc]initWithASN1Object:o1 context:context];
        }
        else if((o1.asn1_tag.tagNumber == 11 ) && (o1.asn1_tag.tagClass == UMASN1Class_Application))
        {
            uAbortCause =  [[UMTCAP_itu_asn1_dialoguePortion alloc]initWithASN1Object:o1 context:context];
        }
    }
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
   	[_asn1_tag setTagIsConstructed];
    _asn1_tag.tagNumber = 7;
    _asn1_tag.tagClass = UMASN1Class_Application;
    
    _asn1_list = [[NSMutableArray alloc]init];
    if(dtid==NULL)
    {
        @throw([NSException exceptionWithName:@"destination tranation id is missing in tcap_abort" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    [_asn1_list addObject:dtid];
    if(pAbortCause)
    {
        [_asn1_list addObject:pAbortCause];
    }
    else if(uAbortCause)
    {
        [_asn1_list addObject:uAbortCause];
    }
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict =[[UMSynchronizedSortedDictionary alloc]init];
    
    if(dtid)
    {
        dict[@"dtid"] = dtid.objectValue;
    }
    if(pAbortCause)
    {
        dict[@"pAbortCause"] = pAbortCause.objectValue;
    }
    if(uAbortCause)
    {
        dict[@"uAbortCause"] = uAbortCause.objectValue;
    }
    return dict;
}


- (NSString *)objectName
{
    return @"abort";
}



@end
