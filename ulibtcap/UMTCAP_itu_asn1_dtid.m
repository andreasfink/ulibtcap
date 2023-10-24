//
//  UMTCAP_itu_asn1_dtid.m
//  ulibtcap
//
//  Created by Andreas Fink on 29.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_itu_asn1_dtid.h>
#import <ulibtcap/UMTCAP_sccpNUnitdata.h>
#import <ulibtcap/UMTCAP_sccpNNotice.h>



@implementation UMTCAP_itu_asn1_dtid

@synthesize transactionId;

- (UMTCAP_itu_asn1_dtid *)processAfterDecodeWithContext:(id)context
{
    transactionId = [_asn1_data hexString];
    
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
    
    task.dtid = transactionId;
    notice.dtid = transactionId;

    if((_asn1_tag.tagNumber != 9) || (_asn1_tag.tagClass != UMASN1Class_Application))
    {
        @throw([NSException exceptionWithName:@"expecting [APPLICATION 8] IMPLICIT OCTET STRING (SIZE (1..4) ) but got something else " reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
        
    }
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.tagNumber = 9;
    _asn1_tag.tagClass = UMASN1Class_Application;
    self.asn1_data = [transactionId unhexedData];
}

- (NSString *)objectName
{
    return @"dtid";
}



@end
