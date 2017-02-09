//
//  UMTCAP_ansi_asn1_componentPDU.h
//  ulibtcap
//
//  Created by Andreas Fink on 08/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_ansi_asn1_componentIDs.h"
#import "UMTCAP_ansi_asn1_operationCode.h"
#import "UMTCAP_generic_asn1_componentPDU.h"

@interface UMTCAP_ansi_asn1_componentPDU : UMTCAP_generic_asn1_componentPDU
{
    UMTCAP_ansi_asn1_componentIDs *ansi_componentIDs;
    UMTCAP_ansi_asn1_operationCode *ansi_operationCode;
}

/* those items are used in most PDUs so they are defined here instead of the individual items for pure convenience */

@property(readwrite,strong) UMTCAP_ansi_asn1_componentIDs *ansi_componentIDs;
@property(readwrite,strong) UMTCAP_ansi_asn1_operationCode *ansi_operationCode;


- (int64_t)invokeId;
- (void) setInvokeId:(int64_t)i;
- (int64_t)linkedId;
- (void) setLinkedId:(int64_t)i;
- (void) clearLinkedId;
- (BOOL) hasLinkedId;

- (int64_t)operationCode;
- (void) setOperationCode:(int64_t)i;

- (int64_t)operationCodeFamily;
- (void) setOperationCodeFamily:(int64_t)i;

- (BOOL)operationNational;
- (void) setOperationNational:(BOOL)i;


@end
