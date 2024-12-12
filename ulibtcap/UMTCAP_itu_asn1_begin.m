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

#import <ulibtcap/UMTCAP_asn1.h>
#import <ulibtcap/UMTCAP_itu_asn1_begin.h>
#import <ulibtcap/UMTCAP_sccpNUnitdata.h>
#import <ulibtcap/UMTCAP_sccpNNotice.h>

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
    if((o) && (o.asn1_tag.tagNumber ==8) && (o.asn1_tag.tagClass == UMASN1Class_Application))
    {
        _otid =  [[UMTCAP_itu_asn1_otid alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:p++];
    }
    if((o) && (o.asn1_tag.tagNumber ==9) && (o.asn1_tag.tagClass == UMASN1Class_Application))
    {
        _dtid =  [[UMTCAP_itu_asn1_dtid alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:p++];
    }
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
    switch(_classEncoding)
    {
        case UMTCAP_itu_classEncoding_Universal:
            _asn1_tag.tagClass = UMASN1Class_Universal;
            break;
        case UMTCAP_itu_classEncoding_ContextSpecific:
            _asn1_tag.tagClass = UMASN1Class_ContextSpecific;
            break;
        case UMTCAP_itu_classEncoding_Private:
            _asn1_tag.tagClass = UMASN1Class_Private;
            break;
        case UMTCAP_itu_classEncoding_default:
        case UMTCAP_itu_classEncoding_Application:
        default:
            _asn1_tag.tagClass = UMASN1Class_Application;
    }
    
    _asn1_list = [[NSMutableArray alloc]init];
    if(_encodingOption == 1)
    {
        if(_componentPortion)
        {
            [_asn1_list addObject:_componentPortion];
        }
        if(_otid!=NULL)
        {
            [_asn1_list addObject:_otid];
        }
        if(_dtid!=NULL)
        {
            [_asn1_list addObject:_dtid];
        }
        if(_dialoguePortion)
        {
            [_asn1_list addObject:_dialoguePortion];
        }
    }
    else if(_encodingOption == 2)
    {
        if(_dialoguePortion)
        {
            [_asn1_list addObject:_dialoguePortion];
        }
        if(_otid!=NULL)
        {
            [_asn1_list addObject:_otid];
        }
        if(_dtid!=NULL)
        {
            [_asn1_list addObject:_dtid];
        }
        if(_componentPortion)
        {
            [_asn1_list addObject:_componentPortion];
        }
    }
    else
    {
        if(_otid!=NULL)
        {
            [_asn1_list addObject:_otid];
        }
        if(_dtid!=NULL)
        {
            [_asn1_list addObject:_dtid];
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
    if(_dtid)
    {
        dict[@"dtid"] = _dtid.objectValue;
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
