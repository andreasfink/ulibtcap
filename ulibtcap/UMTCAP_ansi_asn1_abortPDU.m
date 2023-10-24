//
//  UMTCAP_ansi_asn1_abortPDU.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_ansi_asn1_abortPDU.h>

@implementation UMTCAP_ansi_asn1_abortPDU

@synthesize identifier;
@synthesize dialogPortion;
@synthesize abortCause;
@synthesize userInformation;


- (UMTCAP_ansi_asn1_abortPDU *)processAfterDecodeWithContext:context
{
    UMASN1Object *causeChoice;
    UMASN1Object *o = [self getObjectAtPosition:0];
    if(o==NULL)
    {
        @throw([NSException exceptionWithName:@"missing identifierID section in AbortPDU" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    identifier = [[UMTCAP_ansi_asn1_transactionID alloc]initWithASN1Object:o context:context];
    
    UMASN1Object *o1 = [self getObjectAtPosition:1];
    UMASN1Object *o2 = [self getObjectAtPosition:2];
    
    if((o1==NULL) && (o2==NULL))
    {
        @throw([NSException exceptionWithName:@"dialog and causeInformation section are missing in AbortPDU. At least one of them is required" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
    }
    if(o2)
    {
        /* there is a dialogue and component section */
        dialogPortion = [[UMTCAP_ansi_asn1_dialoguePortion alloc]initWithASN1Object:o1 context:context];
        causeChoice = o2;
    }
    else if (o1)
    {
        /* there is only a component section */
        causeChoice = o1;
    }
    if(causeChoice.asn1_tag.tagNumber == 23)
    {
        abortCause = [[UMASN1Integer alloc]initWithASN1Object:causeChoice context:context];
    }
    return self;
}

- (NSString *)objectName
{
    return @"abortPDU";
}


@end
