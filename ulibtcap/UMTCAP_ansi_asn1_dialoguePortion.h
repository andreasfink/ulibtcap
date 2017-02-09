//
//  UMTCAP_ansi_asn1_dialoguePortion.h
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import "UMTCAP_asn1_dialoguePortion.h"
/*
DialoguePortion
ATIS-1000114.2004
Chapter T1.114.3
::= [PRIVATE 25] IMPLICIT SEQUENCE {
version ProtocolVersion OPTIONAL, 
 ApplicationContext CHOICE {
               integerApplicationId  IntegerApplicationContext,
               objectApplicationId   ObjectIDApplicationContext
               } OPTIONAL,
        userInformation     UserInformation OPTIONAL,
        securityContext     CHOICE {
integerSecurityId [0] IMPLICIT INTEGER, objectSecurityId [1] IMPLICIT OBJECT IDENTIFIER } OPTIONAL,
confidentiality IMPLICIT Confidentiality OPTIONAL, }
 
  */
@class UMTCAP_ansi_asn1_confidentiality;

@interface UMTCAP_ansi_asn1_dialoguePortion : UMTCAP_asn1_dialoguePortion
{
    UMASN1Object *version;
    UMASN1Integer *integerApplicationId;
    UMASN1Object *objectApplicationId;
    UMASN1Object *userInformation;
    UMASN1Integer *integerSecurityId;
    UMASN1Object *objectSecurityId;
    UMTCAP_ansi_asn1_confidentiality *confidentiality;
}

@property(readwrite,strong) UMASN1Object *version;
@property(readwrite,strong) UMASN1Integer *integerApplicationId;
@property(readwrite,strong) UMASN1Object *objectApplicationId;
@property(readwrite,strong) UMASN1Object *userInformation;
@property(readwrite,strong) UMASN1Integer *integerSecurityId;
@property(readwrite,strong) UMASN1Object *objectSecurityId;
@property(readwrite,strong) UMTCAP_ansi_asn1_confidentiality *confidentiality;

@end
