//
//  UMTCAP_ansi_asn1_Reject.h
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_ansi_asn1_componentPDU.h"
@interface UMTCAP_ansi_asn1_reject : UMTCAP_ansi_asn1_componentPDU
{
    UMASN1Object *componentID;
    UMASN1Object *rejectProblem;
    UMASN1Object *paramSequence;
    UMASN1Object *paramSet;
}

@property(readwrite,strong) UMASN1Object *rejectProblem;
@property(readwrite,strong) UMASN1Object *paramSequence;
@property(readwrite,strong) UMASN1Object *paramSet;


@end
