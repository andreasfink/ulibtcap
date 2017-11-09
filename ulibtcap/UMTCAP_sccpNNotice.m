//
//  UMTCAP_scccpNNotice.m
//  ulibtcap
//
//  Created by Andreas Fink on 30.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_sccpNNotice.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_Operation.h"
#import "UMTCAP_Transaction.h"
#import "UMTCAP_TransactionInvoke.h"
#import "UMTCAP_asn1.h"
#import "UMTCAP_ansi_asn1_queryWithPerm.h"
#import "UMTCAP_ansi_asn1_queryWithoutPerm.h"
#import "UMTCAP_ansi_asn1_conversationWithPerm.h"
#import "UMTCAP_ansi_asn1_conversationWithoutPerm.h"
#import "UMTCAP_ansi_asn1_invoke.h"
#import "UMTCAP_ansi_asn1_transactionPDU.h"
#import "UMTCAP_ansi_asn1_uniTransactionPDU.h"
#import "UMTCAP_ansi_asn1_transactionID.h"
#import "UMTCAP_Transaction.h"
#import "UMTCAP_TransactionInvoke.h"
#import "UMTCAP_asn1.h"
#import "UMTCAP_itu_asn1_begin.h"
#import "UMTCAP_itu_asn1_invoke.h"
#import "UMTCAP_itu_asn1_returnResult.h"
#import "UMTCAP_itu_asn1_reject.h"
#import "UMTCAP_itu_asn1_returnError.h"
#import "UMTCAP_TransactionInvoke.h"
#import "UMTCAP_Variant.h"
#import "UMLayerTCAP.h"

@implementation UMTCAP_sccpNNotice
@synthesize tcapLayer;
@synthesize sccpLayer;
@synthesize data;
@synthesize src;
@synthesize dst;
@synthesize options;
@synthesize newTransaction;
@synthesize reason;
@synthesize permission;
@synthesize sccpVariant;
@synthesize tcapVariant;
@synthesize asn1;
@synthesize currentCommand;
@synthesize ansi_permission;
@synthesize ansiTransactionId;
@synthesize otid;
@synthesize dtid;
@synthesize applicationContext;



/* temporary variables used while parsing */
@synthesize currentTransaction;
@synthesize currentOperationType;
@synthesize currentComponents;
@synthesize currentOperationCode;
@synthesize currentOptions;
@synthesize unidirectional;
@synthesize currentLocalTransactionId;
@synthesize currentRemoteTransactionId;



- (UMTCAP_sccpNNotice *)initForTcap:(UMLayerTCAP *)tcap
                               sccp:(UMLayerSCCP *)sccp
                           userData:(NSData *)xdata
                            calling:(SccpAddress *)xsrc
                             called:(SccpAddress *)xdst
                             reason:(int)xreason
                            options:(NSDictionary *)xoptions
{
    self = [super initWithName:@"UMTCAP_sccpNNotice"
                      receiver:tcap
                        sender:sccp
       requiresSynchronisation:NO];
    if(self)
    {
        sccpLayer = sccp;
        tcapLayer = tcap;
        data = xdata;
        src = xsrc;
        dst = xdst;
        options = xoptions;
        reason = xreason;
    }
    return self;
}

- (void)main
{
    NSUInteger pos = 0;
    
    if(options)
    {
        NSMutableDictionary *o = [options mutableCopy];
        o[@"tcap-pdu"] = [data hexString];
        options = o;
    }
    else
    {
        options = @{@"tcap-pdu":[data hexString]};
    }
    [self startDecodingOfPdu];
    @try
    {
        asn1 = [[UMTCAP_asn1 alloc] initWithBerData:data atPosition:&pos context:self];
    }
    @catch(NSException *ex)
    {
        NSLog(@"Exception: %@",ex);
        [self errorDecodingPdu];
        
    }
    [self endDecodingOfPdu];
}

- (void) startDecodingOfPdu
{
    currentCommand = 0;
    currentOperationType = 0;
    currentComponents = [[NSMutableArray alloc]init];
    currentOperationCode = 0;
}

- (void) endDecodingOfPdu
{
    id<UMTCAP_UserProtocol> tcapUser = [tcapLayer tcapDefaultUser];
    
    currentTransaction = [tcapLayer findTransactionByLocalTransactionId:currentLocalTransactionId];
    if(currentTransaction.user)
    {
        tcapUser = currentTransaction.user;
    }

    switch(currentCommand)
    {
        case TCAP_TAG_ANSI_UNIDIRECTIONAL:
        case TCAP_TAG_ANSI_QUERY_WITHOUT_PERM:
        case TCAP_TAG_ANSI_QUERY_WITH_PERM:
        case TCAP_TAG_ANSI_RESPONSE:
        case TCAP_TAG_ANSI_CONVERSATION_WITH_PERM:
        case TCAP_TAG_ANSI_CONVERSATION_WITHOUT_PERM:
        case TCAP_TAG_ANSI_ABORT:
            tcapVariant = TCAP_VARIANT_ANSI;
            break;
        case TCAP_TAG_ITU_BEGIN:
        case TCAP_TAG_ITU_END:
        case TCAP_TAG_ITU_CONTINUE:
        case TCAP_TAG_ITU_ABORT:
            tcapVariant = TCAP_VARIANT_ITU;
            break;
        default:
            NSLog(@"Ignoring unexpected pdu type in sccpNNotice. Can not decode %@->%@ %@",src.stringValueE164,dst.stringValueE164,data);
            break;
    }
    [tcapUser tcapNoticeIndication:currentTransaction.userDialogId
                 tcapTransactionId:currentLocalTransactionId
           tcapRemoteTransactionId:currentRemoteTransactionId
                           variant:tcapVariant
                    callingAddress:src
                     calledAddress:dst
                   dialoguePortion:NULL
                      callingLayer:tcapLayer
                        components:currentComponents
                            reason:reason
                           options:options];
    [tcapLayer removeTransaction:currentTransaction];
}


- (void)errorDecodingPdu
{
    
}

@end
