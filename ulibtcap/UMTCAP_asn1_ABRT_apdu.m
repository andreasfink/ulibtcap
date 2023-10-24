//
//  UMTCAP_asn1_dialogueAbort.m
//  ulibtcap
//
//  Created by Andreas Fink on 26.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_asn1_ABRT_apdu.h>

@implementation UMTCAP_asn1_ABRT_apdu

- (void) processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.isConstructed=YES;
    _asn1_tag.tagNumber = 4;
    _asn1_tag.tagClass = UMASN1Class_Application;
    
    _asn1_list = [[NSMutableArray alloc]init];

    if(_abortSource)
    {
        _abortSource.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        _abortSource.asn1_tag.tagNumber = 0;
        [_asn1_list addObject:_abortSource];
    }
    if(_userInformation)
    {
        _userInformation.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        _userInformation.asn1_tag.tagNumber = 0;
        [_asn1_list addObject:_userInformation];
    }
}


- (UMTCAP_asn1_ABRT_apdu *) processAfterDecodeWithContext:(id)context
{
    int p=0;
    UMASN1Object *o = [self getObjectAtPosition:p++];
    if((o) && (o.asn1_tag.tagNumber == 0) && (o.asn1_tag.tagClass == UMASN1Class_ContextSpecific))
    {
        _abortSource = [[UMTCAP_asn1_AbortSource alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:p++];
    }
    if((o) && (o.asn1_tag.tagNumber == 30) && (o.asn1_tag.tagClass == UMASN1Class_ContextSpecific))
    {
        _userInformation = [[UMTCAP_asn1_userInformation alloc]initWithASN1Object:o context:context];
//        o = [self getObjectAtPosition:p++];
    }
    return self;
}

- (NSString *) objectName
{
    return @"ABRT-apdu";
}
- (id) objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    if(_abortSource)
    {
        dict[@"abort-source"] = _abortSource.objectValue;
        dict[@"abort-source-description"] = _abortSource.objectValueDescription;
    }
    if(_userInformation)
    {
        dict[@"user-information"] = _userInformation.objectValue;
    }
    return dict;
}


@end
