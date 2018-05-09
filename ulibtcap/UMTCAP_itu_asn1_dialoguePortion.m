//
//  UMTCAP_itu_asn1_dialoguePortion.m
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_dialoguePortion.h"
#import <ulibtcap/ulibtcap.h>

@implementation UMTCAP_itu_asn1_dialoguePortion


@synthesize dialogRequest;
@synthesize dialogResponse;
@synthesize dialogAbort;
@synthesize external;


- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagNumber = 11;
    asn1_tag.tagClass = UMASN1Class_Application;
    asn1_list = [[NSMutableArray alloc]init];
    
    external = [[UMTCAP_asn1_external alloc]init];
    external.asn1_tag.tagNumber = 8;
    external.asn1_tag.tagClass = UMASN1Class_Universal;
    external.objectIdentifier =  [[UMTCAP_asn1_objectIdentifier alloc]init];
    uint8_t oid[] = { 0x00,0x11,0x86,0x05,0x01,0x01,0x01 };
    external.objectIdentifier.asn1_data = [NSData dataWithBytes:oid length:sizeof(oid)];
    if(dialogRequest)
    {
        dialogRequest.asn1_tag.tagNumber = 0;
        dialogRequest.asn1_tag.tagClass = UMASN1Class_Application;
        external.externalObject = dialogRequest;
        
    }
    else if(dialogResponse)
    {
        dialogResponse.asn1_tag.tagNumber = 1;
        dialogResponse.asn1_tag.tagClass = UMASN1Class_Application;
        external.externalObject = dialogResponse;
    }
    /* dialogRLRQ = tag2 */
    /* dialogRLRE = tag3 */
    else if(dialogAbort)
    {
        dialogAbort.asn1_tag.tagNumber = 4;
        dialogAbort.asn1_tag.tagClass = UMASN1Class_Application;
        external.externalObject = dialogAbort;
    }
    [asn1_list addObject:external];
}

- (NSString *)objectName
{
    return @"dialoguePortion";
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    
    if(dialogRequest)
    {
        dict[@"dialogRequest"]= dialogRequest.objectValue;
    }
    else if(dialogResponse)
    {
        dict[@"dialogResponse"]= dialogResponse.objectValue;
    }
    else if(dialogAbort)
    {
        dict[@"dialogAbort"]= dialogAbort.objectValue;
    }

    return @{@"external" :
                 @{
                     @"objectIdentifier" :  external.objectIdentifier.objectValue,
                     @"asn1Type" : dict
                     } };
     return dict;
}


- (UMTCAP_itu_asn1_dialoguePortion *)processAfterDecodeWithContext:(id)context
{
    UMTCAP_sccpNUnitdata *task = NULL;
    UMTCAP_sccpNNotice *notice = NULL;
    if ([context isKindOfClass:[UMTCAP_sccpNUnitdata class ]])
    {
        task = (UMTCAP_sccpNUnitdata *)context;
        task.dialoguePortion = self;
    }
    else if ([context isKindOfClass:[UMTCAP_sccpNNotice class ]])
    {
        notice = (UMTCAP_sccpNNotice *)context;
        notice.dialoguePortion = self;

    }


    UMASN1Object *o = [self getObjectAtPosition:0];
    if(o)
    {
        external = [[UMTCAP_asn1_external alloc]initWithASN1Object:o context:context];
        o = external.externalObject;
        
        if((o) && (o.asn1_tag.tagClass == UMASN1Class_Application) && (o.asn1_tag.tagNumber == 0))
        {
            dialogRequest = [[UMTCAP_asn1_AARQ_apdu alloc]initWithASN1Object:o context:context];
        }
        else if((o) && (o.asn1_tag.tagClass == UMASN1Class_Application) && (o.asn1_tag.tagNumber == 1))
        {
            dialogResponse = [[UMTCAP_asn1_AARE_apdu alloc]initWithASN1Object:o context:context];
        }
        /* dialogRLRQ = tag2 */
        /* dialogRLRE = tag3 */

        else if((o) && (o.asn1_tag.tagClass == UMASN1Class_Application) && (o.asn1_tag.tagNumber == 4))
        {
            dialogAbort = [[UMTCAP_asn1_ABRT_apdu alloc]initWithASN1Object:o context:context];
        }
    }
    return self;
}
@end
