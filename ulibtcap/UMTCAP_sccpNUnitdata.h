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
    UMLayerTCAP *_tcapLayer;     /* the layer who originally received the message */
    UMLayerTCAP *_handlingLayer; /* the layer who finally handles it */
    UMLayerSCCP *_sccpLayer;
    NSData      *_data;
    NSData      *_mtp3_pdu;
    SccpAddress *_src;
    SccpAddress *_dst;
    NSMutableDictionary *_options;
    BOOL _newTransaction;
    int _qos;
    BOOL _permission;
    SccpVariant _sccpVariant;
    UMTCAP_Variant _tcapVariant;
    NSString *_decodeError;
//    UMTCAP_ansi_asn1_invoke         *ansiInvoke;
//    UMTCAP_ansi_asn1_transactionPDU *ansiTransaction;
//    UMTCAP_ansi_asn1_transactionID  *ansiIdentifier;
    
    
    /* temporary variables used while parsing */
    UMTCAP_Transaction      *_currentTransaction;
    
  //  id<UMTCAP_UserProtocol> tcapUser;
    UMTCAP_Command          _currentCommand;         /* begin, continue,end abort, query with perm etc */
    UMTCAP_InternalOperation        _currentOperationType;  /* request/response/error/reject/unidirectional */
    NSMutableArray          *_currentComponents;
    int64_t                 _currentOperationCode;
    NSMutableDictionary     *_currentOptions;
    UMTCAP_asn1             *_asn1;
    BOOL                    _unidirectional;
    BOOL                    _ansi_permission;
    
    NSString                *_otid;
    NSString                *_dtid;
    UMTCAP_asn1_objectIdentifier *_applicationContext;
    UMTCAP_asn1_userInformation *_userInfo;
    UMASN1BitString *_dialogProtocolVersion;
    UMTCAP_asn1_dialoguePortion *_dialoguePortion;
    NSString                *_ansiTransactionId;

    NSString                *_currentLocalTransactionId;
    NSString                *_currentRemoteTransactionId;

    id<UMTCAP_UserProtocol> tcapUser;
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
@property(readwrite,strong) UMTCAP_asn1 *asn1;
@property(readwrite,assign) BOOL ansi_permission;

@property(readwrite,strong) NSString *otid;
@property(readwrite,strong) NSString *dtid;
@property(readwrite,strong) UMTCAP_asn1_objectIdentifier *applicationContext;
@property(readwrite,strong) UMTCAP_asn1_userInformation  *userInfo;

@property(readwrite,strong) NSString *ansiTransactionId;
@property(readwrite,strong) NSString *decodeError;

@property(readwrite,strong) UMTCAP_asn1_dialoguePortion *dialoguePortion;

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
- (UMTCAP_InternalOperation)operationType;
- (void)setOperationType:(UMTCAP_InternalOperation)op;

- (NSString *) errorCodeToErrorString:(int)err;

- (void) startDecodingOfPdu;
- (BOOL) endDecodingOfPdu; /* returns yes if processing should be done , no if PDU is redirected or fitlered away */
- (void) handlePdu;


@end

