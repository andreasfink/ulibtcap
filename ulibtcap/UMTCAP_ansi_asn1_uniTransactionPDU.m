//
//  UMTCAP_ansi_asn1_uniTransactionPDU.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_asn1_uniTransactionPDU.h"
#import "UMTCAP_sccpNUnitdata.h"

@implementation UMTCAP_ansi_asn1_uniTransactionPDU
@synthesize identifier;
@synthesize dialogPortion;
@synthesize componentPortion;

- (UMTCAP_ansi_asn1_uniTransactionPDU *)processAfterDecodeWithContext:(id)context
{
    UMASN1Object *o = [self getObjectAtPosition:0];
    if(o==NULL)
    {
        @throw([NSException exceptionWithName:@"missing identifierID section" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    identifier = [[UMTCAP_ansi_asn1_transactionID alloc]initWithASN1Object:o  context:context];
    
    UMASN1Object *o1 = [self getObjectAtPosition:1];
    UMASN1Object *o2 = [self getObjectAtPosition:2];
    
    if(o2)
    {
        /* there is a dialogue and component section */
        dialogPortion = [[UMTCAP_ansi_asn1_dialoguePortion alloc]initWithASN1Object:o1  context:context];
        componentPortion = [[UMTCAP_ansi_asn1_componentSequence alloc]initWithASN1Object:o2  context:context];
    }
    else if (o1)
    {
        /* there is only a component section */
        componentPortion = [[UMTCAP_ansi_asn1_componentSequence alloc]initWithASN1Object:o1  context:context];
    }
    else
    {
        @throw([NSException exceptionWithName:@"missing mandatory component section" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    return self;
}

- (NSString *)objectName
{
    return @"uniTransactionPDU";
}


@end
