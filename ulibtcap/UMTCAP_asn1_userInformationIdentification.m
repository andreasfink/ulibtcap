//
//  UMTCAP_asn1_userInformationIdentification.m
//  ulibtcap
//
//  Created by Andreas Fink on 05.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_asn1_userInformationIdentification.h"


/*

    identification CHOICE
    {
        syntax OBJECT IDENTIFIER,
        presentation-context-id INTEGER,
        context-negotiation SEQUENCE
        {
            presentation-context-id INTEGER,
            transfer-syntax OBJECT IDENTIFIER
        }
        data-value-descriptor ObjectDescriptor OPTIONAL,
        data-value OCTET STRING
    }
 */

//    UMASN1ObjectIdentifier          *_identifier;
//    UMASN1Integer                   *_presentationContextId;
//    UMTCAP_asn1_contextNegotiation  *_contextNegotiation;

@implementation UMTCAP_asn1_userInformationIdentification

- (void) processBeforeEncode
{
    [super processBeforeEncode];
    [_asn1_tag setTagIsConstructed];
    _asn1_list = [[NSMutableArray alloc]init];

    if(_syntax)
    {
        _syntax.asn1_tag.tagNumber = UMASN1Primitive_object_identifier;
        _syntax.asn1_tag.tagClass = UMASN1Class_Universal;
        [_asn1_list addObject:_syntax];
    }
    else if(_presentationContextId)
    {
        _presentationContextId.asn1_tag.tagNumber = UMASN1Primitive_integer;
        _presentationContextId.asn1_tag.tagClass = UMASN1Class_Universal;
        [_asn1_list addObject:_presentationContextId];
    }
    else if(_contextNegotiation)
    {
        _contextNegotiation.asn1_tag.tagNumber = UMASN1Primitive_sequence;
        _contextNegotiation.asn1_tag.tagClass = UMASN1Class_Universal;
        [_asn1_list addObject:_contextNegotiation];
    }
    else if(_dataValueDescriptor)
    {
        _dataValueDescriptor.asn1_tag.tagNumber = UMASN1Primitive_object_descriptor;
        _dataValueDescriptor.asn1_tag.tagClass = UMASN1Class_Universal;
        [_asn1_list addObject:_dataValueDescriptor];
    }
    else if(_dataValue)
    {
        _dataValue.asn1_tag.tagNumber = UMASN1Primitive_octetstring;
        _dataValue.asn1_tag.tagClass = UMASN1Class_Universal;
        [_asn1_list addObject:_dataValue];
    }
    else
    {
        NSLog(@"Warning Choice userInformationIdentificatoin with no selected choice");
    }
}

- (UMTCAP_asn1_userInformationIdentification *) processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o = self;

    if(o.asn1_tag.tagNumber == UMASN1Primitive_object_identifier && o.asn1_tag.tagClass == UMASN1Class_Universal)
    {
        _syntax = [[UMASN1ObjectIdentifier alloc]initWithASN1Object:o context:context];
        //o = [self getObjectAtPosition:pos++];
    }
    else if(o && o.asn1_tag.tagNumber == UMASN1Primitive_integer && o.asn1_tag.tagClass == UMASN1Class_Universal)
    {
        _presentationContextId = [[UMASN1Integer alloc]initWithASN1Object:o context:context];
        //o = [self getObjectAtPosition:pos++];
    }
    else if(o && o.asn1_tag.tagNumber == UMASN1Primitive_sequence && o.asn1_tag.tagClass == UMASN1Class_Universal)
    {
        _contextNegotiation = [[UMTCAP_asn1_contextNegotiation alloc]initWithASN1Object:o context:context];
        //o = [self getObjectAtPosition:pos++];
    }
    else if(o && o.asn1_tag.tagNumber == UMASN1Primitive_object_descriptor && o.asn1_tag.tagClass == UMASN1Class_Universal)
    {
        _dataValueDescriptor = [[UMASN1ObjectDescriptor alloc]initWithASN1Object:o context:context];
        //o = [self getObjectAtPosition:pos++];
    }
    else if(o && o.asn1_tag.tagNumber == UMASN1Primitive_octetstring && o.asn1_tag.tagClass == UMASN1Class_Universal)
    {
        _dataValue = [[UMASN1OctetString alloc]initWithASN1Object:o context:context];
        //o = [self getObjectAtPosition:pos++];
    }
    return self;
}

- (NSString *) objectName
{
    return @"userInformationIdentification";
}

- (id) objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    if(_syntax)
    {
        dict[@"syntax"] = _syntax;
    }
    if(_presentationContextId)
    {
        dict[@"presentation-context-id"] = _presentationContextId;
    }
    if(_contextNegotiation)
    {
        dict[@"context-negotiation"] = _contextNegotiation;
    }
    if(_dataValueDescriptor)
    {
        dict[@"data-value-descriptor"] = _dataValueDescriptor;
    }
    if(_dataValue)
    {
        dict[@"data-value"] = _dataValue;
    }
    return dict;
}

@end

