//
//  UMTCAP_ansi_asn1_unidirectional.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_ansi_asn1_unidirectional.h>
#import <ulibtcap/UMTCAP_sccpNUnitdata.h>
#import <ulibtcap/UMTCAP_sccpNNotice.h>

@implementation UMTCAP_ansi_asn1_unidirectional


- (UMASN1Object *)processAfterDecodeWithContext:(id)context
{
    UMTCAP_sccpNUnitdata *task = NULL;
    UMTCAP_sccpNNotice *notice = NULL;
    if ([context isKindOfClass:[UMTCAP_sccpNUnitdata class ]])
    {
        task = (UMTCAP_sccpNUnitdata *)context;
    }
    else if ([context isKindOfClass:[UMTCAP_sccpNNotice class ]])
    {
        notice = (UMTCAP_sccpNNotice *)context;
    }

/* FIXME: maybe we should implemented it one day */
/* silence warnings for now */

#pragma unused(notice)
#pragma unused(task)

    [super processAfterDecodeWithContext:context];
    return self;
}


- (void)processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.tagClass = UMASN1Class_Private;
    _asn1_tag.tagNumber = 1;
}


- (NSString *)objectName
{
    return @"unidirectional";
}

@end
