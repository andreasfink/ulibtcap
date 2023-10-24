//
//  UMTCAP_ansi_asn1_transactionPDU.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_ansi_asn1_transactionPDU.h>
#import <ulibtcap/UMTCAP_sccpNUnitdata.h>
#import <ulibtcap/UMTCAP_sccpNNotice.h>

@implementation UMTCAP_ansi_asn1_transactionPDU

@synthesize identifier;
@synthesize dialogPortion;
@synthesize componentPortion;

- (UMTCAP_ansi_asn1_transactionPDU *)processAfterDecodeWithContext:(id)context
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
#pragma unused(notice)
/* FIMXE */
    }

    UMASN1Object *o = [self getObjectAtPosition:0];
    if(o==NULL)
    {
        @throw([NSException exceptionWithName:@"missing identifierID section in TransactionPDU" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    identifier = [[UMTCAP_ansi_asn1_transactionID alloc]initWithASN1Object:o context:context];

    task.ansiTransactionId = identifier.tid;

    UMASN1Object *o1 = [self getObjectAtPosition:1];
    UMASN1Object *o2 = [self getObjectAtPosition:2];
    
    if((o1==NULL) && (o2==NULL))
    {
        @throw([NSException exceptionWithName:@"dialog and component section are missing in TransactionPDU At least one of them is required" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    if(o2)
    {
        /* there is a dialogue and component section */
        dialogPortion = [[UMTCAP_ansi_asn1_dialoguePortion alloc]initWithASN1Object:o1 context:context];
        componentPortion = [[UMTCAP_ansi_asn1_componentSequence alloc]initWithASN1Object:o2 context:context];
    }
    else if (o1)
    {
        /* there is only a component section */
        componentPortion = [[UMTCAP_ansi_asn1_componentSequence alloc]initWithASN1Object:o1 context:context];
    }
    return self;
}


- (void)processBeforeEncode
{
    [super processBeforeEncode];

   	[_asn1_tag setTagIsConstructed];
    _asn1_list = [[NSMutableArray alloc]init];
    [_asn1_list addObject:identifier];
    if(dialogPortion)
    {
        [_asn1_list addObject:dialogPortion];
    }
    if(componentPortion)
    {
        [_asn1_list addObject:componentPortion];
    }
}

- (NSString *)objectName
{
    return @"transactionPDU";
}


@end
