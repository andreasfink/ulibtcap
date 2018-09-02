//
//  UMTCAP_itu_asn1_pAbortCause.m
//  ulibtcap
//
//  Created by Andreas Fink on 15.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_pAbortCause.h"

@implementation UMTCAP_itu_asn1_pAbortCause




- (UMTCAP_itu_asn1_pAbortCause *)processAfterDecodeWithContext:(id)context
{
    /* we are an implicit integer, so nothing to be done here really */
    return self;
}

- (void)processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.tagNumber = 10;
    _asn1_tag.tagClass = UMASN1Class_Application;
}


- (NSString *)objectName
{
    return @"pAbortCause";
}

- (id) objectValue
{
    switch(self.value)
    {
        case UMTCAP_pAbortCause_unrecognizedMessageType:
            return @"unrecognizedMessageType(0)";
            
        case UMTCAP_pAbortCause_unrecognizedTransactionID:
            return @"unrecognizedTransactionID(1)";
            
        case UMTCAP_pAbortCause_badlyFormattedTransactionPortion:
            return @"badlyFormattedTransactionPortion(2)";
            
        case UMTCAP_pAbortCause_incorrectTransactionPortion:
            return @"incorrectTransactionPortion(3)";
            
        case UMTCAP_pAbortCause_resourceLimitation:
            return @"resourceLimitation(4)";
        default:
            return [NSString stringWithFormat:@"unknown(%d)", (int)self.value];
    }
}

@end
