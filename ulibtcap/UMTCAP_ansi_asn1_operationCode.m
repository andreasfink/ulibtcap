//
//  UMTCAP_ansi_asn1_operationCode
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_operationCode.h"

@implementation UMTCAP_ansi_asn1_operationCode

@synthesize isNational;
@synthesize operationCode;
@synthesize family;

- (UMTCAP_ansi_asn1_operationCode *)processAfterDecodeWithContext:(id)context
{
    
    if(self.asn1_tag.tagNumber==16)
    {
        isNational=YES;
    }
    else if (self.asn1_tag.tagNumber==17)
    {
        isNational=NO;
    }
    return self;
}

- (void)processBeforeEncode
{
    if(isNational)
    {
        asn1_tag.tagNumber=16;
    }
    else
    {
        asn1_tag.tagNumber=17;
    }
    asn1_tag.tagClass = UMASN1Class_Private;
    unsigned char bytes[2];
    bytes[0] = family & 0xFF;
    bytes[1] = operationCode & 0xFF;
    asn1_data = [NSData dataWithBytes:&bytes  length:2];
}


- (NSString *)objectName
{
    return @"operationCode";
}


@end
