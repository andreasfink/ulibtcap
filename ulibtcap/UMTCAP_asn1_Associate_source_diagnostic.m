//
//  UMTCAP_asn1_Associate_source_diagnostic.m
//  ulibtcap
//
//  Created by Andreas Fink on 03/05/16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_asn1_Associate_source_diagnostic.h"

/*
 Associate-source-diagnostic ::= CHOICE {
 dialogue-service-user
 [1]  INTEGER {null(0), no-reason-given(1),
 application-context-name-not-supported(2)},
 dialogue-service-provider
 [2]  INTEGER {null(0), no-reason-given(1), no-common-dialogue-portion(2)}
 }
 
 */

@implementation UMTCAP_asn1_Associate_source_diagnostic

@synthesize dialogue_service_user;
@synthesize dialogue_service_provider;


- (void) processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.isConstructed=YES;
    asn1_list = [[NSMutableArray alloc]init];
    if(dialogue_service_user)
    {
        self.asn1_tag.tagNumber = 1;
        self.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        [asn1_list addObject:dialogue_service_user];
    }
    else if(dialogue_service_provider)
    {
        self.asn1_tag.tagNumber = 2;
        self.asn1_tag.tagClass = UMASN1Class_ContextSpecific;
        [asn1_list addObject:dialogue_service_provider];
    }
    else
    {
        @throw([NSException exceptionWithName:@"PARAMETER_MISSING"
                                       reason:@"UMGSMMAP_Associate_source_diagnostic choice missing"
                                     userInfo:@{    @"backtrace": UMBacktrace(NULL,0)}]);
    }
}


- (NSString *)objectName
{
    return @"Associate-source-diagnostic";
}

- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    
    if(dialogue_service_user)
    {
        NSString *v;
        switch(dialogue_service_user.value)
        {
            case 0:
                v = @"null(0)";
                break;
            case 1:
                v = @"no-reason-given(1)";
                break;
            case 2:
                v = @"application-context-name-not-supported(2)";
                break;
            default:
                v = [NSString stringWithFormat:@"Unknown(%ld)",(long)dialogue_service_user.value];
        }
        dict[@"dialogue-service-user" ] = v;
    }
    if(dialogue_service_provider)
    {
        NSString *v;
        switch(dialogue_service_user.value)
        {
            case 0:
                v = @"null(0)";
                break;
            case 1:
                v = @"no-reason-given(1)";
                break;
            case 2:
                v = @"no-common-dialogue-portion(2)";
                break;
            default:
                v = [NSString stringWithFormat:@"Unknown(%ld)",(long)dialogue_service_user.value];
                break;
        }
        dict[@"dialogue-service-provider" ] = v;
    }
    return dict;
}

- (UMTCAP_asn1_Associate_source_diagnostic *) processAfterDecodeWithContext:(id)context
{
    int p=0;
    UMASN1Object *o = [self getObjectAtPosition:p++];

    if(self.asn1_tag.tagNumber = 1)
    {
        dialogue_service_user = [[UMASN1Integer alloc]initWithASN1Object:o context:context];
    }
    else if(self.asn1_tag.tagNumber = 2)
    {
        dialogue_service_provider = [[UMASN1Integer alloc]initWithASN1Object:o context:context];
    }
    return self;
}

- (UMTCAP_asn1_Associate_source_diagnostic *)processAfterDecodeWithContextOld:(id)context
{    
    int pos = 0;
    UMASN1Object *o = [self getObjectAtPosition:pos++];
    
    if((o) && (o.asn1_tag.tagNumber ==1) && (o.asn1_tag.isConstructed) && (o.asn1_tag.tagClass == UMASN1Class_ContextSpecific))
    {
        UMASN1ObjectConstructed *c = (UMASN1ObjectConstructed *)o;
        UMASN1Object *o2 = [c getObjectAtPosition:0];
        
        if((o2) && (o2.asn1_tag.tagNumber ==UMASN1Primitive_integer) && (o2.asn1_tag.tagIsPrimitive) && (o2.asn1_tag.tagClass == UMASN1Class_Universal))
        {
            dialogue_service_user = [[UMASN1Integer alloc]initWithASN1Object:o2 context:context];
        }
        o = [self getObjectAtPosition:pos++];
    }
    if((o) && (o.asn1_tag.tagNumber ==2))
    {
        
        UMASN1ObjectConstructed *c = (UMASN1ObjectConstructed *)o;
        UMASN1Object *o2 = [c getObjectAtPosition:0];
        
        if((o2) && (o2.asn1_tag.tagNumber ==UMASN1Primitive_integer) && (o2.asn1_tag.tagIsPrimitive) && (o2.asn1_tag.tagClass == UMASN1Class_Universal))
        {
            dialogue_service_provider = [[UMASN1Integer alloc]initWithASN1Object:o2 context:context];
        }
        o = [self getObjectAtPosition:pos++];
    }
    return self;
}

@end
