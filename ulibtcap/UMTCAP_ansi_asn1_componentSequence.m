//
//  UMTCAP_ansi_asn1_componentSequence.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_ansi_asn1_componentSequence.h>
#import <ulibtcap/UMTCAP_ansi_asn1_componentPDU.h>

@implementation UMTCAP_ansi_asn1_componentSequence


- (void)addComponent:(UMTCAP_ansi_asn1_componentPDU *)component
{
    [_asn1_list addObject:component];
}

- (void)processBeforeEncode
{
    _asn1_tag.tagNumber = 8;
    _asn1_tag.tagClass = UMASN1Class_Private;
}



- (NSString *)objectName
{
    return @"componentSequence";
}


@end
