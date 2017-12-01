//
//  UMTCAP_sccpNUnitdata.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>
#import <ulibsccp/ulibsccp.h>
#import <ulibgt/ulibgt.h>
#import "UMTCAP_Variant.h"
#import "UMTCAP_UserProtocol.h"
#import "UMTCAP_Operation.h"
#import "UMTCAP_asn1.h"
#import "UMTCAP_Command.h"

@class UMLayerTCAP;
@class UMLayerSCCP;
@class UMTCAP_Transaction;
@class UMTCAP_TransactionInvoke;
@class UMTCAP_itu_asn1_begin;
@class UMTCAP_ansi_asn1_invoke;
@class UMTCAP_ansi_asn1_transactionPDU;
@class UMTCAP_ansi_asn1_transactionID;
@class UMTCAP_ansi_asn1_uniTransactionPDU;
@class UMTCAP_itu_asn1_dialoguePortion;
@class UMTCAP_itu_asn1_invoke;
@class UMTCAP_itu_asn1_returnError;
@class UMTCAP_itu_asn1_returnResult;
@class UMTCAP_itu_asn1_reject;
@class UMTCAP_asn1_dialoguePortion;

@interface UMTCAP_sccpNUnitdata : UMLayerTask
{
    UMLayerTCAP *tcapLayer;
    UMLayerSCCP *sccpLayer;
    NSData      *data;
    SccpAddress *src;
    SccpAddress *dst;
    NSMutableDictionary *options;
    BOOL newTransaction;
    int qos;
    BOOL permission;
    SccpVariant sccpVariant;
    UMTCAP_Variant tcapVariant;
    NSString *decodeError;
//    UMTCAP_ansi_asn1_invoke         *ansiInvoke;
//    UMTCAP_ansi_asn1_transactionPDU *ansiTransaction;
//    UMTCAP_ansi_asn1_transactionID  *ansiIdentifier;
    
    
    /* temporary variables used while parsing */
    UMTCAP_Transaction      *currentTransaction;
    
  //  id<UMTCAP_UserProtocol> tcapUser;
    UMTCAP_Command          currentCommand;         /* begin, continue,end abort, query with perm etc */
    UMTCAP_Operation        currentOperationType;  /* request/response/error/reject/unidirectional */
    NSMutableArray          *currentComponents;
    int64_t                 currentOperationCode;
    NSMutableDictionary     *currentOptions;
    UMTCAP_asn1             *asn1;
    BOOL                    unidirectional;
    BOOL                    ansi_permission;
    
    NSString                *otid;
    NSString                *dtid;
    UMTCAP_asn1_objectIdentifier *applicationContext;
    UMTCAP_asn1_userInformation *userInfo;
    UMASN1BitString *dialogProtocolVersion;
    UMTCAP_asn1_dialoguePortion *dialoguePortion;
    NSString                *ansiTransactionId;

    NSString                *currentLocalTransactionId;
    NSString                *currentRemoteTransactionId;
}

@property(readwrite,strong) UMLayerSCCP *sccpLayer;
@property(readwrite,strong) NSData      *data;
@property(readwrite,strong) SccpAddress *src;
@property(readwrite,strong) SccpAddress *dst;
@property(readwrite,strong) NSDictionary *options;
@property(readwrite,strong) UMTCAP_Transaction *currentTransaction;
@property(readwrite,assign) BOOL newTransaction;
@property(readwrite,assign) int qos;
@property(readwrite,assign) UMTCAP_Variant tcapVariant;
@property(readwrite,assign) SccpVariant sccpVariant;
//@property(readwrite,strong) id<UMTCAP_UserProtocol> tcapUser;
@property(readwrite,strong) UMTCAP_asn1 *asn1;
@property(readwrite,assign) BOOL ansi_permission;

@property(readwrite,strong) NSString *otid;
@property(readwrite,strong) NSString *dtid;
@property(readwrite,strong) UMTCAP_asn1_objectIdentifier *applicationContext;
@property(readwrite,strong) UMTCAP_asn1_userInformation  *userInfo;

@property(readwrite,strong) NSString *ansiTransactionId;
@property(readwrite,strong) NSString *decodeError;


@property(readwrite,assign) UMTCAP_Command  currentCommand;


- (UMTCAP_sccpNUnitdata *)initForTcap:(UMLayerTCAP *)tcap
                                 sccp:(UMLayerSCCP *)sccp
                             userData:(NSData *)xdata
                              calling:(SccpAddress *)xsrc
                               called:(SccpAddress *)xdst
                     qualityOfService:(int)xqos
                              options:(NSDictionary *)xoptions;

- (void)handleItuDialogue:(UMTCAP_itu_asn1_dialoguePortion *)d;

- (void)handleComponent:(UMTCAP_generic_asn1_componentPDU *)component;
- (void)handleComponents:(UMASN1ObjectConstructed *)componets;

- (void)handleLocalTransactionId:(NSString *)otid;
- (void)handleRemoteTransactionId:(NSString *)dtid;
- (void)handleAnsiTransactionId:(NSString *)dtid;

- (int64_t)operationCode;
- (UMTCAP_Operation)operationType;
- (void)setOperationType:(UMTCAP_Operation)op;

- (NSString *) errorCodeToErrorString:(int)err;

@end

