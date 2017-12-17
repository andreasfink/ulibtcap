//
//  UMTCAP_itu_asn1_componentPDU.m
//  ulibtcap
//
//  Created by Andreas Fink on 16.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_itu_asn1_componentPDU.h"

#import "UMTCAP_itu_asn1_invoke.h"
#import "UMTCAP_itu_asn1_returnResult.h"
#import "UMTCAP_itu_asn1_returnError.h"
#import "UMTCAP_itu_asn1_reject.h"

@implementation UMTCAP_itu_asn1_componentPDU

@synthesize itu_invokeId;
@synthesize itu_linkedId;
@synthesize itu_operationCode;


- (UMTCAP_itu_asn1_componentPDU *)processAfterDecodeWithContext:(id)context
{
    UMTCAP_itu_asn1_componentPDU *r =NULL;

    variant = TCAP_VARIANT_ITU;
    switch(asn1_tag.tagNumber)
    {
        case TCAP_ITU_COMPONENT_INVOKE:  /* invoke */
        {
            r = [[UMTCAP_itu_asn1_invoke alloc]initWithASN1Object:self context:context];
            r.isLast=YES;
            break;
        }
        case TCAP_ITU_COMPONENT_RETURN_RESULT_LAST: /* returnResultLast */
        {
            r = [[UMTCAP_itu_asn1_returnResult alloc]initWithASN1Object:self context:context];
            break;
        }
        case TCAP_ITU_COMPONENT_RETURN_ERROR: /* returnError */
        {
            r = [[UMTCAP_itu_asn1_returnError alloc]initWithASN1Object:self context:context];
            r.isLast=YES;
            break;
        }
        case TCAP_ITU_COMPONENT_REJECT: /* reject */
        {
            r = [[UMTCAP_itu_asn1_reject alloc]initWithASN1Object:self context:context];
            r.isLast=YES;
            break;
        }
            
        case TCAP_ITU_COMPONENT_RETURN_RESULT_NOT_LAST: /* returnResultNotLast */
        {
            r = [[UMTCAP_itu_asn1_returnResult alloc]initWithASN1Object:self context:context];
            r.isLast=NO;
            break;
        }
        default:
        {
            NSLog(@"I don't know how to process this tcap component %d packet\n%@\n",(int)asn1_tag.tagNumber,[self.objectValue jsonString]);
            @throw([NSException exceptionWithName:@"unknown choice in ComponentSequence" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
        }
    }
    return r;
}



- (void) processBeforeEncode
{
    [super processBeforeEncode];
    asn1_tag.tagClass = UMASN1Class_ContextSpecific;

}

- (void) setInvokeId:(int64_t)i
{
    if(itu_invokeId==NULL)
    {
        itu_invokeId= [[UMASN1Integer alloc]init];
    }
    itu_invokeId.value = i;
}

- (int64_t)invokeId
{
    if(itu_invokeId==NULL)
    {
        itu_invokeId= [[UMASN1Integer alloc]init];
    }
    return itu_invokeId.value;
}

- (void)setLinkedId:(int64_t)i
{
    if(i==TCAP_UNDEFINED_LINKED_ID)
    {
        itu_linkedId = NULL;
    }
    else
    {
        if(itu_linkedId==NULL)
        {
            itu_linkedId= [[UMASN1Integer alloc]init];
        }
        itu_linkedId.value = i;
    }
}

- (int64_t)linkedId
{
    if(itu_linkedId==NULL)
    {
        return TCAP_UNDEFINED_LINKED_ID;
    }
    return itu_linkedId.value;
}

- (void) clearLinkedId
{
    itu_linkedId = NULL;
}
- (BOOL) hasLinkedId
{
    if(itu_linkedId)
    {
        if(itu_linkedId.value != TCAP_UNDEFINED_LINKED_ID)
        {
            return YES;
        }
    }
    return NO;
}

- (int64_t)operationCode
{
    if(itu_operationCode==NULL)
    {
        itu_operationCode= [[UMASN1Integer alloc]init];
    }
    return itu_operationCode.value;
}

- (void) setOperationCode:(int64_t)i
{
    if(itu_operationCode==NULL)
    {
        itu_operationCode= [[UMASN1Integer alloc]init];
    }
    itu_operationCode.value = i;
}

- (int64_t)operationCodeFamily
{
    return 0;
}

- (void) setOperationCodeFamily:(int64_t)i
{
    
}


- (BOOL)operationNational
{
    return NO;
}

- (void) setOperationNational:(BOOL)i
{
    
}


- (NSString *)objectName
{
    return @"componentPDU";
}


- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict =[[UMSynchronizedSortedDictionary alloc]init];
    
    if(itu_invokeId)
    {
        dict[@"invokeId"] = itu_invokeId.objectValue;
    }
    if(itu_linkedId)
    {
        dict[@"linkedId"] = itu_linkedId.objectValue;
    }
    if(itu_operationCode)
    {
        dict[@"operationCode"] = itu_operationCode.objectValue;
    }
    if(params)
    {
        dict[@"params"] = params.objectValue;
    }
    
    return dict;
}


@end
