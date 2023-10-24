//
//  UMTCAP_ansi_asn1_componentPDU.m
//  ulibtcap
//
//  Created by Andreas Fink on 08/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_ansi_asn1_componentPDU.h>
#import <ulibtcap/UMTCAP_ansi_asn1_componentIDs.h>
#import <ulibtcap/UMTCAP_ansi_asn1_operationCode.h>
#import <ulibtcap/UMTCAP_ansi_asn1_invoke.h>
#import <ulibtcap/UMTCAP_ansi_asn1_returnResult.h>
#import <ulibtcap/UMTCAP_ansi_asn1_returnError.h>
#import <ulibtcap/UMTCAP_ansi_asn1_reject.h>
#import <ulibtcap/UMTCAP_ansi_asn1_invoke.h>
#import <ulibtcap/UMTCAP_ansi_asn1_returnResult.h>

#import <ulibtcap/UMTCAP_ansi_asn1_operationCode.h>
#import <ulibtcap/UMTCAP_ansi_asn1_componentIDs.h>

@implementation UMTCAP_ansi_asn1_componentPDU

@synthesize ansi_componentIDs;
@synthesize ansi_operationCode;

- (void)readComponentPartsInContext:(id)context
{
    UMASN1Object *o = [self getObjectAtPosition:0];
	ansi_componentIDs = [[UMTCAP_ansi_asn1_componentIDs alloc]initWithASN1Object:o  context:context];
    o = [self getObjectAtPosition:1];
    ansi_operationCode = [[UMTCAP_ansi_asn1_operationCode alloc]initWithASN1Object:o  context:context];
    params = [self getObjectAtPosition:2];
}


- (UMTCAP_ansi_asn1_componentPDU *)processAfterDecodeWithContext:(id)context
{
    UMTCAP_ansi_asn1_componentPDU *r =NULL;
    variant = TCAP_VARIANT_ANSI;
    switch(_asn1_tag.tagNumber)
    {
        case TCAP_ANSI_COMPONENT_INVOKE_LAST:  /* invokeLast */
        {
            r = [[UMTCAP_ansi_asn1_invoke alloc]initWithASN1Object:self context:context];
            [r readComponentPartsInContext:context];
            isLast=YES;
            break;
        }
        case TCAP_ANSI_COMPONENT_RETURN_RESULT_LAST: /* returnResultLast */
        {
            r = [[UMTCAP_ansi_asn1_returnResult alloc]initWithASN1Object:self context:context];
            [r readComponentPartsInContext:context];
            isLast=YES;
            break;
        }
        case TCAP_ANSI_COMPONENT_RETURN_ERROR: /* returnError */
        {
            r = [[UMTCAP_ansi_asn1_returnError alloc]initWithASN1Object:self context:context];
            [r readComponentPartsInContext:context];
            isLast=YES;
            break;
        }
        case TCAP_ANSI_COMPONENT_REJECT: /* reject */
        {
            r = [[UMTCAP_ansi_asn1_reject alloc]initWithASN1Object:self context:context];
            [r readComponentPartsInContext:context];
            isLast=YES;
            break;
        }
            
        case TCAP_ANSI_COMPONENT_INVOKE_NOT_LAST: /* invokeNotLast */
        {
            r = [[UMTCAP_ansi_asn1_invoke alloc]initWithASN1Object:self context:context];
            [r readComponentPartsInContext:context];
            isLast=NO;
            break;
        }
        case TCAP_ANSI_COMPONENT_RETURN_RESULT_NOT_LAST: /* returnResultNotLast */
        {
            r = [[UMTCAP_ansi_asn1_returnResult alloc]initWithASN1Object:self context:context];
            [r readComponentPartsInContext:context];
            isLast=NO;
            break;
        }
        default:
        {
            @throw([NSException exceptionWithName:@"unknown choice in ComponentSequence" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
        }
    }
    return r;
}


/* assumption:
 as componentIDs can be 0...2 bytes, we assume that byte 0 is the
 invoke ID and byte 1 corresponds to the linked id if used like ITU
 to be verified if this is the correct assumption */


- (int64_t)invokeId
{
    if(ansi_componentIDs==NULL)
    {
        ansi_componentIDs= [[UMTCAP_ansi_asn1_componentIDs alloc]init];
    }
    return ansi_componentIDs.invokeIdInt;
}

- (void)setInvokeId:(int64_t)i
{
    if(ansi_componentIDs==NULL)
    {
        ansi_componentIDs= [[UMTCAP_ansi_asn1_componentIDs alloc]init];
    }
    ansi_componentIDs.invokeIdInt = i;
}

- (int64_t)linkedId
{
    if(ansi_componentIDs==NULL)
    {
        ansi_componentIDs= [[UMTCAP_ansi_asn1_componentIDs alloc]init];
    }
    if(ansi_componentIDs.hasCorrelationId)
    {
        return ansi_componentIDs.correlationIdInt;
    }
    return TCAP_UNDEFINED_LINKED_ID;
}

- (void)setLinkedId:(int64_t)i
{
    if(ansi_componentIDs==NULL)
    {
        ansi_componentIDs= [[UMTCAP_ansi_asn1_componentIDs alloc]init];
    }
    if(i == TCAP_UNDEFINED_LINKED_ID)
    {
        [ansi_componentIDs clearCorrelationId];
    }
    else
    {
        ansi_componentIDs.correlationIdInt = i;
    }
}

- (void) clearLinkedId
{
    if(ansi_componentIDs==NULL)
    {
        ansi_componentIDs= [[UMTCAP_ansi_asn1_componentIDs alloc]init];
    }
    ansi_componentIDs.hasCorrelationId = NO;
}

- (BOOL)hasLinkedId
{
    if(ansi_componentIDs)
    {
        return ansi_componentIDs.hasCorrelationId;
    }
    return NO;
}

- (void) processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.tagClass = UMASN1Class_Private;
}

- (int64_t)operationCode
{
    return ansi_operationCode.operationCode;
}

- (void) setOperationCode:(int64_t)i
{
    if(ansi_operationCode == NULL)
    {
        ansi_operationCode = [[UMTCAP_ansi_asn1_operationCode alloc]init];
    }
    ansi_operationCode.operationCode = i;
}

- (int64_t)operationCodeFamilyOrEncoding
{
    if(ansi_operationCode == NULL)
    {
        ansi_operationCode = [[UMTCAP_ansi_asn1_operationCode alloc]init];
    }
    return ansi_operationCode.family;
}

- (void) setOperationCodeFamilyOrEncoding:(int64_t)i
{
    if(ansi_operationCode == NULL)
    {
        ansi_operationCode = [[UMTCAP_ansi_asn1_operationCode alloc]init];
    }
    ansi_operationCode.family = i;
}


- (BOOL)operationNational
{
    if(ansi_operationCode == NULL)
    {
        ansi_operationCode = [[UMTCAP_ansi_asn1_operationCode alloc]init];
    }
    return ansi_operationCode.isNational;
}

- (void) setOperationNational:(BOOL)i
{
    if(ansi_operationCode == NULL)
    {
        ansi_operationCode = [[UMTCAP_ansi_asn1_operationCode alloc]init];
    }
    ansi_operationCode.isNational = i;
}

- (NSString *)objectName
{
    return @"comonentPDU";
}



@end
