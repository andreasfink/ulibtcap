//
//  UMTCAP_ansi_asn1_conversationWithoutPerm.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>

#import "UMTCAP_ansi_asn1_conversationWithoutPerm.h"
#import "UMTCAP_sccpNUnitdata.h"
#import "UMTCAP_sccpNNotice.h"
#import "UMTCAP_Transaction.h"

@implementation UMTCAP_ansi_asn1_conversationWithoutPerm


- (void)processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.tagClass = UMASN1Class_Private;
    _asn1_tag.tagNumber = 6;
}

- (NSString *)objectName
{
    return @"conversationWithoutPerm";
}

@end
