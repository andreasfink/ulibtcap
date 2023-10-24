//
//  UMTCAP_asn1_AARE_apdu
//  ulibtcap
//
//  Created by Andreas Fink on 26.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_asn1_AARE_apdu.h>

@implementation UMTCAP_asn1_AARE_apdu


@synthesize protocolVersion;
@synthesize user_information;
@synthesize objectIdentifier;
@synthesize result;
@synthesize result_source_diagnostic;


- (void)processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.tagNumber = 1;
    _asn1_tag.tagClass = UMASN1Class_Application;
    _asn1_list = [[NSMutableArray alloc]init];
    
    if(protocolVersion)
    {
        protocolVersion.asn1_tag.tagNumber = 0;
        protocolVersion.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        [_asn1_list addObject:protocolVersion];
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
        [_asn1_list addObject:application_context_name];
    }

    if(result)
    {
        UMASN1ObjectConstructed *r = [[UMASN1ObjectConstructed alloc]init];
        [r.asn1_list addObject:result];
        r.asn1_tag.tagNumber = 2;
        r.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        [_asn1_list addObject:r];
    }
    if(result_source_diagnostic)
    {
        UMASN1ObjectConstructed *r = [[UMASN1ObjectConstructed alloc]init];
        [r.asn1_list addObject:result_source_diagnostic];
        r.asn1_tag.tagNumber = 3;
        r.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        [_asn1_list addObject:r];
    }
    if(user_information)
    {
        UMASN1ObjectConstructed *r = [[UMASN1ObjectConstructed alloc]init];
        [r.asn1_list addObject:user_information];
        r.asn1_tag.tagNumber = 30;
        r.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        [_asn1_list addObject:r];
    }
}

- (NSString *)objectName
{
    return @"dialogResponse";
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
        dict[@"application_context_name" ] = @{ objectIdentifier.objectName : objectIdentifier.objectValue };
    }
    if(result)
    {
        dict[@"result"]= result.objectValue;
    }
    if(result_source_diagnostic)
    {
        dict[@"result-source-diagnostic"]= result_source_diagnostic.objectValue;
    }
    if(user_information)
    {
        dict[@"user-information"]= user_information.objectValue;
    }
    return dict;
}


- (UMTCAP_asn1_AARE_apdu *)processAfterDecodeWithContext:(id)context
{
    int pos = 0;
    UMASN1Object *o = [self getObjectAtPosition:pos++];
    
    if((o) && (o.asn1_tag.tagNumber ==0))
    {
        protocolVersion = [[UMASN1BitString alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:pos++];
    }
    if((o) && (o.asn1_tag.tagNumber == 1) && (o.asn1_tag.tagClass ==UMASN1Class_ContextSpecific))
    {
        UMASN1ObjectConstructed *application_context_name = [[UMASN1ObjectConstructed alloc]initWithASN1Object:o context:context];
        o = [application_context_name getObjectAtPosition:0];
        objectIdentifier = [[UMTCAP_asn1_objectIdentifier alloc]initWithASN1Object:o
                                                                           context:context];
        o = [self getObjectAtPosition:pos++];
    }
    if((o) && (o.asn1_tag.tagNumber == 2) && (o.asn1_tag.tagClass ==UMASN1Class_ContextSpecific))
    {
        result = [[UMTCAP_asn1_Associate_result alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:pos++];
    }
    if((o) && (o.asn1_tag.tagNumber == 3) && (o.asn1_tag.tagClass ==UMASN1Class_ContextSpecific))
    {
        result_source_diagnostic = [[UMTCAP_asn1_Associate_source_diagnostic alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:pos++];
    }
    if((o) && (o.asn1_tag.tagNumber == 30) && (o.asn1_tag.tagClass ==UMASN1Class_ContextSpecific))
    {
        user_information = [[UMTCAP_asn1_userInformation alloc]initWithASN1Object:o context:context];
    }
    return self;
}

@end
