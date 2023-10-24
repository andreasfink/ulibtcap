//
//  UMTCAP_ansi_asn1_uniTransactionPDU.h
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

#import <ulibtcap/UMTCAP_ansi_asn1_transactionID.h>
#import <ulibtcap/UMTCAP_ansi_asn1_componentSequence.h>
#import <ulibtcap/UMTCAP_ansi_asn1_dialoguePortion.h>

@interface UMTCAP_ansi_asn1_uniTransactionPDU : UMASN1ObjectConstructed
{
    UMTCAP_ansi_asn1_transactionID  *identifier;
    UMTCAP_ansi_asn1_dialoguePortion  *dialogPortion;
    UMTCAP_ansi_asn1_componentSequence *componentPortion;
}

@property(readwrite,strong)     UMTCAP_ansi_asn1_transactionID  *identifier;
@property(readwrite,strong)     UMTCAP_ansi_asn1_dialoguePortion  *dialogPortion;
@property(readwrite,strong)     UMTCAP_ansi_asn1_componentSequence *componentPortion;


@end
