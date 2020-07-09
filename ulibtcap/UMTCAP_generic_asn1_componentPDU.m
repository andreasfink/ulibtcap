//
//  UMTCAP_generic_asn1_componentPDU.m
//  ulibtcap
//
//  Created by Andreas Fink on 18.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_generic_asn1_componentPDU.h"

@implementation UMTCAP_generic_asn1_componentPDU

@synthesize variant;
@synthesize params;
@synthesize isLast;

@synthesize operationName;
@synthesize operationType;
@synthesize operationUser;

#define NOT_IMPLEMENTED_EXCEPTION     [NSException exceptionWithName:[NSString stringWithFormat:@"NOT IMPLEMENTED FILE %s line:%ld",__FILE__,(long)__LINE__] reason:NULL userInfo:@{@"backtrace": UMBacktrace(NULL,0) }]

- (UMTCAP_generic_asn1_componentPDU *)init
{
    self = [super init];
    if(self)
    {
        //NSLog(@"debug");
    }
    return self;
}
- (int64_t)invokeId
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (void) setInvokeId:(int64_t)i
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (int64_t)linkedId
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (void) setLinkedId:(int64_t)i
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (void) clearLinkedId
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (BOOL) hasLinkedId
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (int64_t)operationCode
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (void) setOperationCode:(int64_t)i
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (int64_t)operationCodeFamilyOrEncoding
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (void) setOperationCodeFamilyOrEncoding:(int64_t)i
{
     @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (BOOL)operationNational
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (void) setOperationNational:(BOOL)i
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (UMASN1ObjectIdentifier *)operationCodeGlobal
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}

- (void)setOperationCodeGlobal:(UMASN1ObjectIdentifier *)op
{
    @throw(NOT_IMPLEMENTED_EXCEPTION);
}


- (BOOL)errorCodePrivate
{
    return _errPrivate;
}

- (void) setErrorCodePrivate:(BOOL)i
{
    _errPrivate = i;
}

- (NSString *)objectName
{
    return @"componentPDU";
}

- (int64_t)errorCode
{
    return err;
}

- (void) setErrorCode:(int64_t)i
{
    err = i;
}


@end
