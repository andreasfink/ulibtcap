//
//  UMTCAP_asn1_external.h
//  ulibtcap
//
//  Created by Andreas Fink on 26.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>
#import <ulibasn1/ulibasn1.h>
#import <ulibtcap/UMTCAP_asn1_objectIdentifier.h>

@interface UMTCAP_asn1_external : UMASN1Sequence
{
    UMTCAP_asn1_objectIdentifier    *objectIdentifier;
    UMASN1ObjectConstructed         *asn1Type;
    UMASN1Object *externalObject;
}

@property(readwrite,strong) UMTCAP_asn1_objectIdentifier   *objectIdentifier;
@property(readwrite,strong) UMASN1ObjectConstructed *asn1Type;
@property(readwrite,strong) UMASN1Object *externalObject;


@end
