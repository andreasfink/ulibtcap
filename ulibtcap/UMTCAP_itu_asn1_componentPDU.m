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



- (UMTCAP_itu_asn1_componentPDU *)processAfterDecodeWithContext:(id)context
{
    UMTCAP_itu_asn1_componentPDU *r =NULL;

    variant = TCAP_VARIANT_ITU;
    switch(_asn1_tag.tagNumber)
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
            r.isLast=YES;
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
            NSLog(@"I don't know how to process this tcap component %d packet\n%@\n",(int)_asn1_tag.tagNumber,[self.objectValue jsonString]);
            @throw([NSException exceptionWithName:@"unknown choice in ComponentSequence" reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0)}] );
        }
    }
    return r;
}



- (void) processBeforeEncode
{
    [super processBeforeEncode];
    _asn1_tag.tagClass = UMASN1Class_ContextSpecific;

}

- (void) setInvokeId:(int64_t)i
{
    if(_itu_invokeId==NULL)
    {
        _itu_invokeId= [[UMASN1Integer alloc]init];
    }
    _itu_invokeId.value = i;
}

- (int64_t)invokeId
{
    if(_itu_invokeId==NULL)
    {
        _itu_invokeId= [[UMASN1Integer alloc]init];
    }
    return _itu_invokeId.value;
}

- (void)setLinkedId:(int64_t)i
{
    if(i==TCAP_UNDEFINED_LINKED_ID)
    {
        _itu_linkedId = NULL;
    }
    else
    {
        if(_itu_linkedId==NULL)
        {
            _itu_linkedId= [[UMASN1Integer alloc]init];
        }
        _itu_linkedId.value = i;
    }
}

- (int64_t)linkedId
{
    if(_itu_linkedId==NULL)
    {
        return TCAP_UNDEFINED_LINKED_ID;
    }
    return _itu_linkedId.value;
}

- (void) clearLinkedId
{
    _itu_linkedId = NULL;
}
- (BOOL) hasLinkedId
{
    if(_itu_linkedId)
    {
        if(_itu_linkedId.value != TCAP_UNDEFINED_LINKED_ID)
        {
            return YES;
        }
    }
    return NO;
}

- (int64_t)operationCode
{
    if(_itu_localOperationCode==NULL)
    {
        _itu_localOperationCode= [[UMASN1Integer alloc]init];
    }
    return _itu_localOperationCode.value;
}

- (void) setOperationCode:(int64_t)i
{
    if(_itu_localOperationCode==NULL)
    {
        _itu_localOperationCode= [[UMASN1Integer alloc]init];
    }
    _itu_localOperationCode.value = i;
}

- (NSData *)globalOperationCode
{
    if(_itu_globalOperationCode==NULL)
    {
        _itu_globalOperationCode= [[UMASN1ObjectIdentifier alloc]init];
    }
    return _itu_globalOperationCode.value;
}

- (void) setGlobalOperationCode:(NSData *)d
{
    _itu_globalOperationCode= [[UMASN1ObjectIdentifier alloc]initWithValue:d];
}

- (int64_t)operationCodeFamily
{
    if(_useGlobalOperationCode==3)
    {
        return UMTCAP_itu_operationCodeFamily_LocalAndGlobal;
    }
    if(_useGlobalOperationCode==2)
    {
        return UMTCAP_itu_operationCodeFamily_GlobalAndLocal;
    }
    if(_useGlobalOperationCode==1)
    {
        return UMTCAP_itu_operationCodeFamily_Global;
    }
    return UMTCAP_itu_operationCodeFamily_Local;
}

- (void) setOperationCodeFamily:(int64_t)i
{
    if(i==UMTCAP_itu_operationCodeFamily_LocalAndGlobal)
    {
        _useGlobalOperationCode = 3;
    }
    else if(i==UMTCAP_itu_operationCodeFamily_GlobalAndLocal)
    {
        _useGlobalOperationCode = 2;
    }
    else if(i==UMTCAP_itu_operationCodeFamily_Global)
    {
        _useGlobalOperationCode = 1;
    }
    else
    {
        _useGlobalOperationCode = 0;
    }
}

- (UMASN1ObjectIdentifier *)operationCodeGlobal
{
    return _operationCodeGlobal;
}

- (void)setOperationCodeGlobal:(UMASN1ObjectIdentifier *)op
{
    _itu_globalOperationCode = op;
    if(op!=NULL)
    {
        if(_useGlobalOperationCode==0)
        {
            _useGlobalOperationCode = 1;
        }
    }
    else
    {
        _useGlobalOperationCode = 0;
    }
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
    
    if(_itu_invokeId)
    {
        dict[@"invokeId"] = _itu_invokeId.objectValue;
    }
    if(_itu_linkedId)
    {
        dict[@"linkedId"] = _itu_linkedId.objectValue;
    }
    if(_itu_localOperationCode)
    {
        dict[@"operationCode"] = _itu_localOperationCode.objectValue;
    }
    if(_itu_globalOperationCode)
    {
        dict[@"globalOperationCode"] = _itu_globalOperationCode.objectValue;
    }
    if(params)
    {
        dict[@"params"] = params.objectValue;
    }
    return dict;
}


@end
