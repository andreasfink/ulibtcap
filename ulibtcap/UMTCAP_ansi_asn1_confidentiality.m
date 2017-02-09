//
//  UMTCAP_ansi_asn1_confidentiality.m
//  ulibtcap
//
//  Created by Andreas Fink on 05/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_confidentiality.h"

@implementation UMTCAP_ansi_asn1_confidentiality


- (UMTCAP_ansi_asn1_confidentiality *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *choice = [self getObjectAtPosition:0];

    if(choice.asn1_tag.tagNumber == 0)
    {
        ci = [[UMASN1Integer alloc]initWithASN1Object: choice context:context];
    }
    else if(choice.asn1_tag.tagNumber == 1)
    {
        co = choice;
    }    
    return self;
}


- (void)processBeforeEncode
{
    [super processBeforeEncode];

    [asn1_tag setTagIsConstructed];
    asn1_list = [[NSMutableArray alloc]init];
    if(ci)
    {
        ci.asn1_tag.tagNumber = 0;
        [asn1_list addObject:ci];
    }
    else if(co)
    {
        co.asn1_tag.tagNumber = 1;
        [asn1_list addObject:co];
    }
}

- (NSString *)objectName
{
    return @"confidentiality";
}

@end
