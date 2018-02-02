//
//  UMTCAP_itu_asn1_pAbortCause.h
//  ulibtcap
//
//  Created by Andreas Fink on 15.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>

#define UMTCAP_pAbortCause_unrecognizedMessageType              0
#define UMTCAP_pAbortCause_unrecognizedTransactionID            1
#define UMTCAP_pAbortCause_badlyFormattedTransactionPortion     2
#define UMTCAP_pAbortCause_incorrectTransactionPortion          3
#define UMTCAP_pAbortCause_resourceLimitation                   4


#define UMTCAP_pAbortCause_abnormalDialogue                     5
#define UMTCAP_pAbortCause_noCommonDialoguePortion              6

@interface UMTCAP_itu_asn1_pAbortCause : UMASN1Integer

@end
