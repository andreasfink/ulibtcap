//
//  UMTCAP_itu_asn1_begin.m
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_asn1.h"
#import "UMTCAP_itu_asn1_begin.h"
#import "UMTCAP_sccpNUnitdata.h"
#import "UMTCAP_sccpNNotice.h"

@implementation UMTCAP_itu_asn1_begin


- (UMTCAP_itu_asn1_begin *)processAfterDecodeWithContext:(id)context
{    
    UMTCAP_sccpNUnitdata *task = NULL;
    UMTCAP_sccpNNotice *notice = NULL;
    if ([context isKindOfClass:[UMTCAP_sccpNUnitdata class ]])
    {
        task = (UMTCAP_sccpNUnitdata *)context;
    }
    else if ([context isKindOfClass:[UMTCAP_sccpNNotice class ]])
    {
        notice = (UMTCAP_sccpNNotice *)context;
    }

    int p=0;
    UMASN1Object *o = [self getObjectAtPosition:p++];

    if(o==NULL)
    {
        @throw([NSException exceptionWithName:@"identifier section is missing in tcap_begin" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    _otid =  [[UMTCAP_itu_asn1_otid alloc]initWithASN1Object:o context:context];
    o = [self getObjectAtPosition:p++];
    if((o) && (o.asn1_tag.tagNumber ==11) && (o.asn1_tag.tagClass == UMASN1Class_Application))
    {
        _dialoguePortion = [[UMTCAP_itu_asn1_dialoguePortion alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:p++];
    }
    if(o)
    {
        _componentPortion = [[UMTCAP_itu_asn1_componentPortion alloc]initWithASN1Object:o context:context];
    }
    [task handleComponents:_componentPortion];
    [notice setCurrentLocalTransactionId:_otid.transactionId];
    return self;
}

- (void)processBeforeEncode
{
    
    [super processBeforeEncode];
    
   	[_asn1_tag setTagIsConstructed];
    _asn1_tag.tagNumber = TCAP_TAG_ITU_BEGIN;
    _asn1_tag.tagClass = UMASN1Class_Application;
    
    _asn1_list = [[NSMutableArray alloc]init];
    if(_otid!=NULL)
    {
        [_asn1_list addObject:_otid];
    }
    if(_dialoguePortion)
    {
        [_asn1_list addObject:_dialoguePortion];
    }
    if(_componentPortion)
    {
        [_asn1_list addObject:_componentPortion];
    }
}


- (NSString *)objectName
{
    return @"begin";
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict =[[UMSynchronizedSortedDictionary alloc]init];
    
    if(_otid)
    {
        dict[@"otid"] = _otid.objectValue;
    }
    if(_dialoguePortion)
    {
        dict[@"dialoguePortion"] = _dialoguePortion.objectValue;
    }
    if(_componentPortion)
    {
        dict[@"componentPortion"] = _componentPortion.objectValue;
    }
    return dict;
}

@end
