//
//  UMTCAP_asn1_contextNegotiation.m
//  ulibtcap
//
//  Created by Andreas Fink on 05.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_asn1_contextNegotiation.h"

/*

 context-negotiation SEQUENCE
 {
    presentation-context-id INTEGER,
    transfer-syntax OBJECT IDENTIFIER
 }
*/


@implementation UMTCAP_asn1_contextNegotiation


- (void) processBeforeEncode
{
    [super processBeforeEncode];
    [asn1_tag setTagIsConstructed];
    asn1_list = [[NSMutableArray alloc]init];

    if((!_presentationContextId) || (!_transferSyntax ))
    {

        @throw([NSException exceptionWithName:@"MISSING_PARAM" reason:@"Pamater presentationContextId and transferSyntax os object type contextNegotioation must be set"
                                     userInfo:NULL]);
    }
    [asn1_list addObject:_presentationContextId];
    [asn1_list addObject:_transferSyntax];
}

- (UMTCAP_asn1_contextNegotiation *) processAfterDecodeWithContext:(id)context
{
    NSInteger pos=0;
    UMASN1Object *o = [self getObjectAtPosition:pos++];

    if(o && o.asn1_tag.tagNumber == UMASN1Primitive_integer && o.asn1_tag.tagClass == UMASN1Class_Universal)
    {
        _presentationContextId = [[UMASN1Integer alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:pos++];
    }
    if(o && o.asn1_tag.tagNumber == UMASN1Primitive_object_identifier && o.asn1_tag.tagClass == UMASN1Class_Universal)
    {
        _transferSyntax = [[UMASN1ObjectIdentifier alloc]initWithASN1Object:o context:context];
        o = [self getObjectAtPosition:pos++];
    }
    return self;
}

- (NSString *) objectName
{
    return @"context-negotiation";
}

- (id) objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    if(_presentationContextId)
    {
        dict[@"presentation-context-id"] = _presentationContextId;
    }
    if(_transferSyntax)
    {
        dict[@"transfer-syntax"] = _transferSyntax;
    }
    return dict;
}

@end

