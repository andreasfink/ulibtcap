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
#import "UMTCAP_sccpNNotice.h"

@implementation UMTCAP_itu_asn1_end

@synthesize dtid;
@synthesize dialoguePortion;
@synthesize componentPortion;

- (UMTCAP_itu_asn1_end *)processAfterDecodeWithContext:(id)context
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


    NSInteger p=0;

    UMASN1Object *o = [self getObjectAtPosition:p++];

    if((o==NULL) || (o.asn1_tag.tagClass != UMASN1Class_Application) || (o.asn1_tag.tagNumber!=9))
    {
        @throw([NSException exceptionWithName:@"destination transactin id is missing in tcap_end" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    dtid =  [[UMTCAP_itu_asn1_dtid alloc]initWithASN1Object:o context:context];
    o = [self getObjectAtPosition:p++];
    if((o.asn1_tag.tagClass == UMASN1Class_Application) && ( o.asn1_tag.tagNumber==11))
    {
        dialoguePortion = [[UMTCAP_itu_asn1_dialoguePortion alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:p++];
    }
    if((o.asn1_tag.tagClass == UMASN1Class_Application) && ( o.asn1_tag.tagNumber==12))
    {
        componentPortion = [[UMTCAP_itu_asn1_componentPortion alloc]initWithASN1Object:o context:context];
        //o = [self getObjectAtPosition:p++];
    }
    [task handleComponents:componentPortion];
    [notice setCurrentRemoteTransactionId:dtid.transactionId]; /* if its a reject, its the remote transaction ID we used to send the TC END out */
    return self;
}

- (void)processBeforeEncode
{
    
    [super processBeforeEncode];
    
    [_asn1_tag setTagIsConstructed];
    _asn1_tag.tagNumber = TCAP_TAG_ITU_END;
    _asn1_tag.tagClass = UMASN1Class_Application;

    _asn1_list = [[NSMutableArray alloc]init];
    if(dtid==NULL)
    {
        @throw([NSException exceptionWithName:@"destination transactin id is missing in tcap_end" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }

    [_asn1_list addObject:dtid];
    if(dialoguePortion)
    {
        [_asn1_list addObject:dialoguePortion];
    }
    if(componentPortion)
    {
        [_asn1_list addObject:componentPortion];
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
