//
//  UMTCAP_scccpNNotice.h
//  ulibtcap
//
//  Created by Andreas Fink on 30.04.16.
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


@interface UMTCAP_sccpNNotice : UMLayerTask
{
    UMLayerTCAP *t_capLayer;
    UMLayerSCCP *_sccpLayer;
    NSData      *_data;
    NSData      *_mtp3_pdu;
    
    SccpAddress *_src;
    SccpAddress *_dst;
    NSDictionary *_options;
    BOOL _newTransaction;
    int _reason;
    BOOL _permission;
    SccpVariant _sccpVariant;
    UMTCAP_Variant _tcapVariant;

    /* temporary variables used while parsing */
    UMTCAP_Transaction      *_currentTransaction;
    UMTCAP_Command          _currentCommand;
    UMTCAP_InternalOperation        _currentOperationType;
    NSMutableArray          *_currentComponents;
    int64_t                 _currentOperationCode;
    NSMutableDictionary     *_currentOptions;
    UMTCAP_asn1             *_asn1;
    BOOL                    _unidirectional;
    BOOL                    _ansi_permission;
    NSString                *_otid;
    NSString                *_dtid;
    UMTCAP_asn1_objectIdentifier *a_pplicationContext;
    NSString                *a_nsiTransactionId;
    NSString                *_currentLocalTransactionId;
    NSString                *_currentRemoteTransactionId;
    NSString *_decodeError;

    UMTCAP_asn1_dialoguePortion *_dialoguePortion;

}


@property(readwrite,strong)    UMLayerTCAP *tcapLayer;
@property(readwrite,strong)    UMLayerSCCP *sccpLayer;
@property(readwrite,strong)    NSData      *data;
@property(readwrite,strong)    SccpAddress *src;
@property(readwrite,strong)    SccpAddress *dst;
@property(readwrite,strong)    NSDictionary *options;
@property(readwrite,assign)    BOOL newTransaction;
@property(readwrite,assign)    int reason;
@property(readwrite,assign)    BOOL permission;
@property(readwrite,assign)    SccpVariant sccpVariant;
@property(readwrite,assign)    UMTCAP_Variant tcapVariant;

/* temporary variables used while parsing */
@property(readwrite,strong)    UMTCAP_Transaction      *currentTransaction;
@property(readwrite,assign)    UMTCAP_Command          currentCommand;
@property(readwrite,assign)    UMTCAP_InternalOperation        currentOperationType;
@property(readwrite,strong)    NSMutableArray          *currentComponents;
@property(readwrite,assign)    int64_t                 currentOperationCode;
@property(readwrite,strong)    NSMutableDictionary     *currentOptions;
@property(readwrite,strong)    UMTCAP_asn1             *asn1;
@property(readwrite,assign)    BOOL                    unidirectional;
@property(readwrite,assign)    BOOL                    ansi_permission;
@property(readwrite,strong)    NSString                *otid;
@property(readwrite,strong)    NSString                *dtid;
@property(readwrite,strong)    UMTCAP_asn1_objectIdentifier *applicationContext;
@property(readwrite,strong)    NSString                *ansiTransactionId;
@property(readwrite,strong)    NSString                *currentLocalTransactionId;
@property(readwrite,strong)    NSString                *currentRemoteTransactionId;
@property(readwrite,strong)    UMTCAP_asn1_dialoguePortion *dialoguePortion;


- (UMTCAP_sccpNNotice *)initForTcap:(UMLayerTCAP *)tcap
                               sccp:(UMLayerSCCP *)sccp
                           userData:(NSData *)xdata
                            calling:(SccpAddress *)xsrc
                             called:(SccpAddress *)xdst
                             reason:(int)reason
                            options:(NSDictionary *)xoptions;

@end
