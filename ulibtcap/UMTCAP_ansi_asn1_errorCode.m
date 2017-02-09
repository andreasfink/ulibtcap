//
//  UMTCAP_ansi_asn1_errorCode.m
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_errorCode.h"

@implementation UMTCAP_ansi_asn1_errorCode

@synthesize code;
@synthesize isPrivate;

- (UMTCAP_ansi_asn1_errorCode *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *choice = [self getObjectAtPosition:0];
    
    if(choice.asn1_tag.tagNumber==19)
    {
        code = [[UMASN1Integer alloc]initWithASN1Object:choice context:context];
        isPrivate = NO;
    }
    else if (choice.asn1_tag.tagNumber==20)
    {
        code = [[UMASN1Integer alloc]initWithASN1Object:choice  context:context];
        isPrivate = YES;
    }
    return self;
}

-(void)processBeforeEncode
{
    [asn1_tag setTagIsConstructed];
    asn1_list = [[NSMutableArray alloc]init];
    
    if(isPrivate)
    {
        code.asn1_tag.tagNumber = 20;
    }
    else
    {
        code.asn1_tag.tagNumber = 19;
    }
    [asn1_list addObject:code];
}


- (NSString *)objectName
{
    return @"errorCOde";
}


@end
