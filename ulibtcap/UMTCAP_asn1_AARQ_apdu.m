//
//  UMTCAP_asn1_dialogRequest.m
//  ulibtcap
//
//  Created by Andreas Fink on 26.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_asn1_AARQ_apdu.h"

@implementation UMTCAP_asn1_AARQ_apdu

@synthesize protocolVersion;
@synthesize user_information;
@synthesize objectIdentifier;

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagNumber = 0;
    asn1_tag.tagClass = UMASN1Class_Application;
    asn1_list = [[NSMutableArray alloc]init];

    if(protocolVersion)
    {
        protocolVersion.asn1_tag.tagNumber = 0;
        protocolVersion.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        [asn1_list addObject:protocolVersion];
    }
    UMASN1ObjectConstructed *application_context_name = [[UMASN1ObjectConstructed alloc]init];
    application_context_name.asn1_tag.tagNumber = 1;
    application_context_name.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
    application_context_name.asn1_list = [[NSMutableArray alloc]init];
    if(objectIdentifier)
    {
        [application_context_name.asn1_list addObject:objectIdentifier];
    }
    if(application_context_name)
    {
        [asn1_list addObject:application_context_name];
    }
    if(user_information)
    {
        user_information.asn1_tag.tagNumber = 30;
        user_information.asn1_tag.tagClass = UMASN1Class_ContextSpecific;        
        [asn1_list addObject:user_information];
    }
}

- (NSString *)objectName
{
    return @"dialogRequest";
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    if(protocolVersion)
    {
        dict[@"protocolVersion"] = protocolVersion.objectValue;
    }
    if(objectIdentifier)
    {
        dict[@"application-context-name" ] = @{ objectIdentifier.objectName : objectIdentifier.objectValue };
    }
    if(user_information)
    {
        dict[@"user-information"]= user_information.objectValue;
    }
    return dict;
}



- (UMTCAP_asn1_AARQ_apdu *)processAfterDecodeWithContext:(id)context
{
    int pos = 0;
    UMASN1Object *o = [self getObjectAtPosition:pos++];
    
    if((o) && (o.asn1_tag.tagNumber == 0) && (o.asn1_tag.tagClass = UMASN1Class_ContextSpecific))
    {
        protocolVersion = [[UMASN1BitString alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:pos++];
    }
    if((o) && (o.asn1_tag.tagNumber == 1) && (o.asn1_tag.tagClass = UMASN1Class_ContextSpecific))
    {
        UMASN1ObjectConstructed *application_context_name = [[UMASN1ObjectConstructed alloc]initWithASN1Object:o context:context];
        o = [application_context_name getObjectAtPosition:0];
        objectIdentifier = [[UMTCAP_asn1_objectIdentifier alloc]initWithASN1Object:o
    context:context];
        o = [self getObjectAtPosition:pos++];
    }
    if((o) && (o.asn1_tag.tagNumber == 30) && (o.asn1_tag.tagClass = UMASN1Class_ContextSpecific))
    {
        user_information = [[UMTCAP_asn1_userInformation alloc]initWithASN1Object:o context:context];
//        o = [self getObjectAtPosition:pos++];
    }
    return self;
}
@end

