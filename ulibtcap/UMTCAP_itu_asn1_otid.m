//
//  UMTCAP_itu_asn1_otid.m
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_otid.h"
#import "UMTCAP_sccpNUnitdata.h"
#import "UMTCAP_sccpNNotice.h"
@implementation UMTCAP_itu_asn1_otid

@synthesize transactionId;


- (UMTCAP_itu_asn1_otid *)processAfterDecodeWithContext:(id)context
{
    transactionId = [asn1_data hexString];
    
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
    
    task.otid = transactionId;
    notice.otid = transactionId;

    if((asn1_tag.tagNumber != 8) || (asn1_tag.tagClass != UMASN1Class_Application))
    {
        @throw([NSException exceptionWithName:@"expecting [APPLICATION 8] IMPLICIT OCTET STRING (SIZE (1..4) ) but got something else " reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );

    }
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagNumber = 8;
    asn1_tag.tagClass = UMASN1Class_Application;
    asn1_data = [transactionId unhexedData];
}

- (NSString *)objectName
{
    return @"otid";
}


@end
