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

#import <ulibtcap/UMTCAP_itu_asn1_abort.h>

#import <ulibtcap/UMTCAP_itu_asn1_dialoguePortion.h>
#import <ulibtcap/UMTCAP_itu_asn1_dtid.h>
#import <ulibtcap/UMTCAP_itu_asn1_pAbortCause.h>

@implementation UMTCAP_itu_asn1_abort


- (UMTCAP_itu_asn1_abort *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o0 = [self getObjectAtPosition:0];
    UMASN1Object *o1 = [self getObjectAtPosition:1];
    if(o0==NULL)
    {
        @throw([NSException exceptionWithName:@"destination tranation id is missing in tcap_abort" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    _dtid =  [[UMTCAP_itu_asn1_dtid alloc]initWithASN1Object:o0 context:context];
    if(o1)
    {
        if((o1.asn1_tag.tagNumber == 10 ) && (o1.asn1_tag.tagClass == UMASN1Class_Application))
        {
            _pAbortCause =  [[UMTCAP_itu_asn1_pAbortCause alloc]initWithASN1Object:o1 context:context];
        }
        else if((o1.asn1_tag.tagNumber == 11 ) && (o1.asn1_tag.tagClass == UMASN1Class_Application))
        {
            _uAbortCause =  [[UMTCAP_itu_asn1_dialoguePortion alloc]initWithASN1Object:o1 context:context];
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
    if(_dtid==NULL)
    {
        @throw([NSException exceptionWithName:@"destination tranation id is missing in tcap_abort" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    [_asn1_list addObject:_dtid];
    if(_pAbortCause)
    {
        [_asn1_list addObject:_pAbortCause];
    }
    else if(_uAbortCause)
    {
        [_asn1_list addObject:_uAbortCause];
    }
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict =[[UMSynchronizedSortedDictionary alloc]init];
    
    if(_dtid)
    {
        dict[@"dtid"] = _dtid.objectValue;
    }
    if(_pAbortCause)
    {
        dict[@"pAbortCause"] = _pAbortCause.objectValue;
    }
    if(_uAbortCause)
    {
        dict[@"uAbortCause"] = _uAbortCause.objectValue;
    }
    return dict;
}


- (NSString *)objectName
{
    return @"abort";
}



@end
