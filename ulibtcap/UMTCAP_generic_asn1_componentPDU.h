//
//  UMTCAP_generic_asn1_componentPDU.h
//  ulibtcap
//
//  Created by Andreas Fink on 18.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
#import <ulibasn1/ulibasn1.h>
#import <ulibtcap/UMTCAP_Variant.h>
#import <ulibtcap/UMTCAP_Operation.h>
#import <ulibtcap/UMTCAP_UserProtocol.h>

#define TCAP_UNDEFINED_LINKED_ID    INT_MAX

@interface UMTCAP_generic_asn1_componentPDU : UMASN1ObjectConstructed
{
    UMTCAP_Variant variant;
    UMASN1Object *params;
    BOOL isLast;

    NSString                *operationName;
    UMTCAP_InternalOperation operationType;
    id                      operationUser;
    int64_t                 err;
    BOOL                    _errPrivate;
    UMASN1ObjectIdentifier *_operationCodeGlobal;
}

- (UMASN1ObjectIdentifier *)operationCodeGlobal;
- (void)setOperationCodeGlobal:(UMASN1ObjectIdentifier *)op;


@property(readwrite,assign) UMTCAP_Variant variant;
@property(readwrite,strong) UMASN1Object *params;
@property(readwrite,assign) BOOL isLast;

@property(readwrite,strong) NSString *operationName;
@property(readwrite,assign) UMTCAP_InternalOperation operationType;

@property(readwrite,strong) id operationUser;



- (int64_t)invokeId;
- (void) setInvokeId:(int64_t)i;
- (int64_t)linkedId;
- (void) setLinkedId:(int64_t)i;
- (void) clearLinkedId;
- (BOOL) hasLinkedId;


- (int64_t)errorCode;
- (void) setErrorCode:(int64_t)i;


- (BOOL)errorCodePrivate;
- (void) setErrorCodePrivate:(BOOL)i;

- (int64_t)operationCode;
- (void) setOperationCode:(int64_t)i;

- (int64_t)operationCodeFamilyOrEncoding;
- (void) setOperationCodeFamilyOrEncoding:(int64_t)i;

- (BOOL)operationNational;
- (void) setOperationNational:(BOOL)i;

- (BOOL)hasGlobalOperationCode;
- (BOOL)hasLocalOperationCode;

@end


#define TCAP_ITU_COMPONENT_INVOKE                   1
#define TCAP_ITU_COMPONENT_RETURN_RESULT_LAST       2
#define TCAP_ITU_COMPONENT_RETURN_ERROR             3
#define TCAP_ITU_COMPONENT_REJECT                   4
#define TCAP_ITU_COMPONENT_RETURN_RESULT_NOT_LAST   7

#define	TCAP_ANSI_COMPONENT_INVOKE_LAST				9
#define	TCAP_ANSI_COMPONENT_RETURN_RESULT_LAST		10
#define	TCAP_ANSI_COMPONENT_RETURN_ERROR			11
#define	TCAP_ANSI_COMPONENT_REJECT					12
#define	TCAP_ANSI_COMPONENT_INVOKE_NOT_LAST			13
#define	TCAP_ANSI_COMPONENT_RETURN_RESULT_NOT_LAST	14
