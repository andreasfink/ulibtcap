//
//  UMTCAP_ansi_asn1.m
//  ulibtcap
//
//  Created by Andreas Fink on 28.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#if 0
#import "UMTCAP_asn1.h"

#import "UMTCAP_ansi_asn1_unidirectional.h"
#import "UMTCAP_ansi_asn1_queryWithPerm.h"
#import "UMTCAP_ansi_asn1_queryWithoutPerm.h"
#import "UMTCAP_ansi_asn1_response.h"
#import "UMTCAP_ansi_asn1_conversationWithPerm.h"
#import "UMTCAP_ansi_asn1_conversationWithoutPerm.h"
#import "UMTCAP_ansi_asn1_abort.h"

@implementation UMTCAP_ansi_asn1


- (UMASN1Object *)processAfterDecodeWithContext:context
{
     if(    (asn1_tag.tagNumber == 1)
        && (asn1_tag.isConstructed)
        && (asn1_tag.tagClass ==UMASN1Class_Private))
     {
         return [[UMTCAP_ansi_asn1_unidirectional alloc]initWithASN1Object:self context:context];
     }
     else if(    (asn1_tag.tagNumber == 2)
         && (asn1_tag.isConstructed)
         && (asn1_tag.tagClass ==UMASN1Class_Private))
     {
        return [[UMTCAP_ansi_asn1_queryWithPerm alloc]initWithASN1Object:self context:context];
     }
     else if(    (asn1_tag.tagNumber == 3)
             && (asn1_tag.isConstructed)
             && (asn1_tag.tagClass ==UMASN1Class_Private))
     {
         return [[UMTCAP_ansi_asn1_queryWithoutPerm alloc]initWithASN1Object:self context:context];
     }
     else if(    (asn1_tag.tagNumber == 4)
             && (asn1_tag.isConstructed)
             && (asn1_tag.tagClass ==UMASN1Class_Private))
     {
         return [[UMTCAP_ansi_asn1_response alloc]initWithASN1Object:self context:context];
     }
     else if(    (asn1_tag.tagNumber == 5)
             && (asn1_tag.isConstructed)
             && (asn1_tag.tagClass ==UMASN1Class_Private))
     {
         return [[UMTCAP_ansi_asn1_conversationWithPerm alloc]initWithASN1Object:self context:context];
     }
     else if(    (asn1_tag.tagNumber == 6)
             && (asn1_tag.isConstructed)
             && (asn1_tag.tagClass ==UMASN1Class_Private))
     {
         return [[UMTCAP_ansi_asn1_conversationWithoutPerm alloc]initWithASN1Object:self context:context];
     }
     else if(    (asn1_tag.tagNumber == 22)
             && (asn1_tag.isConstructed)
             && (asn1_tag.tagClass ==UMASN1Class_Private))
     {
         return [[UMTCAP_ansi_asn1_abort alloc]initWithASN1Object:self context:context];
     }

     return self;
 }

    /*
 UMASN1Object *locationInformation              = [subscriberInfo getObjectWithTagNumber:0];
 UMASN1Object *subscriberState                  = [subscriberInfo getObjectWithTagNumber:1];
 UMASN1Object *extensionContainer               = [subscriberInfo getObjectWithTagNumber:2];
 UMASN1Object *locationInformationGPRS          = [subscriberInfo getObjectWithTagNumber:3];
 UMASN1Object *ps_SubscriberState               = [subscriberInfo getObjectWithTagNumber:4];
 UMASN1Object *imei                             = [subscriberInfo getObjectWithTagNumber:5];
 UMASN1Object *ms_Classmark2                    = [subscriberInfo getObjectWithTagNumber:6];
 UMASN1Object *gprs_MS_Class                    = [subscriberInfo getObjectWithTagNumber:7];
 UMASN1Object *mnpInfoRes                       = [subscriberInfo getObjectWithTagNumber:8];
 UMASN1Object *imsVoiceOverPS_SessionsIndication= [subscriberInfo getObjectWithTagNumber:9];
 UMASN1Object *lastUE_ActivityTime              = [subscriberInfo getObjectWithTagNumber:10];
 UMASN1Object *lastRAT_Type                     = [subscriberInfo getObjectWithTagNumber:11];
 UMASN1Object *eps_SubscriberState              = [subscriberInfo getObjectWithTagNumber:12];
 UMASN1Object *locationInformationEPS           = [subscriberInfo getObjectWithTagNumber:13];
 UMASN1Object *timeZone                         = [subscriberInfo getObjectWithTagNumber:14];
 UMASN1Object *daylightSavingTime               = [subscriberInfo getObjectWithTagNumber:15];
 
 NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
 if(locationInformation)
 {
 NSDictionary *locDict = extractLocationInformation(locationInformation);
 appendDictionaryToDictionaryWithKeyPrefix(dict,locDict,@"locationInformation.");
 }
 if(subscriberState)
 {
 switch(subscriberState.asn1_tag.tagNumber)
 {
 case 0:
 dict[@"subscriberState"]=@"assumedIdle";
 break;
 case 1:
 dict[@"subscriberState"]=@"camelBusy";
 break;
 case 2:
 dict[@"subscriberState"]=@"notProvidedFromVLR";
 break;
 default:
 dict[@"subscriberState"]=[NSString stringWithFormat:@"unknown %llu",(unsigned long long)subscriberState.asn1_tag.tagNumber];
 dict[@"subscriberState.rawData"]=[ps_SubscriberState rawDataAsStringValue];
 break;
 }
 }
 if(extensionContainer)
 {
 dict[@"extensionContainer"]=[extensionContainer stringValue];
 }
 if(locationInformationGPRS)
 {
 dict[@"locationInformationGPRS"]=[locationInformationGPRS stringValue];
 }
 if(ps_SubscriberState)
 {
 switch(ps_SubscriberState.asn1_tag.tagNumber)
 {
 case 0:
 dict[@"ps-subscriberState"]=@"notProvidedFromSGSN";
 break;
 case 1:
 dict[@"ps-subscriberState"]=@"ps-Detached";
 break;
 case 2:
 dict[@"ps-subscriberState"]=@"ps-AttachedNotReachableForPaging";
 break;
 case 3:
 dict[@"ps-subscriberState"]=@"ps-AttachedReachableForPaging";
 break;
 case 4:
 dict[@"ps-subscriberState"]=@"ps-PDP-ActiveNotReachableForPaging";
 break;
 case 5:
 dict[@"ps-subscriberState"]=@"ps-PDP-ActiveReachableForPaging";
 break;
 default:
 dict[@"ps-subscriberState"]=[NSString stringWithFormat:@"unknown %llu",(unsigned long long)ps_SubscriberState.asn1_tag.tagNumber];
 dict[@"ps-SubscriberState.rawData"]=[ps_SubscriberState rawDataAsStringValue];
 break;
 }
 }
 if(imei)
 {
 dict[@"imei"]=[imei stringValue];
 }
 if(ms_Classmark2)
 {
 dict[@"ms-Classmark2"]=[ms_Classmark2 stringValue];
 }
 if(gprs_MS_Class)
 {
 dict[@"gprs-MS-Class"]=[gprs_MS_Class stringValue];
 }
 if(mnpInfoRes)
 {
 dict[@"mnpInfoRes"]=[mnpInfoRes stringValue];
 }
 if(imsVoiceOverPS_SessionsIndication)
 {
 dict[@"imsVoiceOverPS-SessionsIndication"]=[imsVoiceOverPS_SessionsIndication stringValue];
 }
 if(lastUE_ActivityTime)
 {
 dict[@"lastUE-ActivityTime"]=[lastUE_ActivityTime stringValue];
 }
 if(lastRAT_Type)
 {
 dict[@"lastRAT-Type"]=[lastRAT_Type stringValue];
 }
 if(eps_SubscriberState)
 {
 dict[@"eps-SubscriberState"]=[eps_SubscriberState stringValue];
 }
 if(locationInformationEPS)
 {
 dict[@"locationInformationEPS"]=[locationInformationEPS stringValue];
 }
 if(timeZone)
 {
 dict[@"timeZone"]=[timeZone stringValue];
 }
 if(daylightSavingTime)
 {
 dict[@"daylightSavingTime"]=[daylightSavingTime stringValue];
 }
 return dict;
 }
 */
     
     
@end
#endif

