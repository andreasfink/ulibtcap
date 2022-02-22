//
//  UMTCAP_itu_continue.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_continue.h"
#import "UMTCAP_itu_asn1_componentPDU.h"

@interface UMTCAP_itu_continue : UMTCAP_continue
{
    UMTCAP_itu_operationCodeEncoding _operationEncoding;
    UMTCAP_itu_classEncoding         _classEncoding;
}

@property(readwrite,assign,atomic)  UMTCAP_itu_operationCodeEncoding operationEncoding;
@property(readwrite,assign,atomic)  UMTCAP_itu_classEncoding         classEncoding;

@end
