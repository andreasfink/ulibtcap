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
#import "UMTCAP_asn1.h"
#import "UMTCAP_itu_asn1_begin.h"
#import "UMTCAP_itu_asn1_invoke.h"
#import "UMTCAP_itu_asn1_returnResult.h"
#import "UMTCAP_itu_asn1_reject.h"
#import "UMTCAP_itu_asn1_returnError.h"
#import "UMTCAP_Variant.h"
#import "UMLayerTCAP.h"

@implementation UMTCAP_sccpNNotice

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
        _sccpLayer = sccp;
        _tcapLayer = tcap;
        _data = xdata;
        _src = xsrc;
        _dst = xdst;
        _options = xoptions;
        _reason = xreason;
    }
    return self;
}

- (void)main
{
    NSUInteger pos = 0;
    BOOL decodeOnly = [_options[@"decode-only"] boolValue];
    _mtp3_pdu =_options[@"mtp3-pdu"];

    if(_options)
    {
        NSMutableDictionary *o = [_options mutableCopy];
        o[@"tcap-pdu"] = [_data hexString];
        _options = o;
    }
    else
    {
        _options = @{@"tcap-pdu":[_data hexString]};
    }
    @try
    {
        [self startDecodingOfPdu];
        _asn1 = [[UMTCAP_asn1 alloc] initWithBerData:_data atPosition:&pos context:self];
        [self endDecodingOfPdu];
    }
    @catch(NSException *ex)
    {
        NSLog(@"Exception: %@",ex);
        [self errorDecodingPdu];
        if(decodeOnly)
        {
            _decodeError = [NSString stringWithFormat:@"Error while decoding: %@\r\n",ex];
        }
    }
}

- (void) startDecodingOfPdu
{
    _currentCommand = -1;
    _currentOperationType = -1;
    _currentComponents = [[NSMutableArray alloc]init];
    _currentOperationCode = 0;
}

- (void) endDecodingOfPdu
{
    id<UMTCAP_UserProtocol> tcapUser = [_tcapLayer tcapDefaultUser];
    
    /* as this is not an incoming packet but a packet we just sent and produced an error
     we have to swap local and remote transaction Id */

    NSString *remote = _currentLocalTransactionId;
    NSString *local = _currentRemoteTransactionId;
    _currentLocalTransactionId = remote;
    _currentRemoteTransactionId = local;
    
    _currentTransaction = [_tcapLayer findTransactionByLocalTransactionId:_currentLocalTransactionId];
    if(_currentTransaction.user)
    {
        tcapUser = _currentTransaction.user;
    }

    switch(_currentCommand)
    {
        case TCAP_TAG_ANSI_UNIDIRECTIONAL:
        case TCAP_TAG_ANSI_QUERY_WITHOUT_PERM:
        case TCAP_TAG_ANSI_QUERY_WITH_PERM:
        case TCAP_TAG_ANSI_RESPONSE:
        case TCAP_TAG_ANSI_CONVERSATION_WITH_PERM:
        case TCAP_TAG_ANSI_CONVERSATION_WITHOUT_PERM:
        case TCAP_TAG_ANSI_ABORT:
            _tcapVariant = TCAP_VARIANT_ANSI;
            break;
        case TCAP_TAG_ITU_BEGIN:
        case TCAP_TAG_ITU_END:
        case TCAP_TAG_ITU_CONTINUE:
        case TCAP_TAG_ITU_ABORT:
            _tcapVariant = TCAP_VARIANT_ITU;
            break;
        default:
            // NSLog(@"Ignoring unexpected pdu type in sccpNNotice. Can not decode %@->%@ %@",src.stringValueE164,dst.stringValueE164,data);
            break;
    }
    [tcapUser tcapNoticeIndication:_currentTransaction.userDialogId
                 tcapTransactionId:_currentLocalTransactionId
           tcapRemoteTransactionId:_currentRemoteTransactionId
                           variant:_tcapVariant
                    callingAddress:_src
                     calledAddress:_dst
                   dialoguePortion:NULL
                      callingLayer:_tcapLayer
                        components:_currentComponents
                            reason:_reason
                           options:_options];
    [_tcapLayer removeTransaction:_currentTransaction];
}


- (void)errorDecodingPdu
{
    [_sccpLayer.mtp3.problematicPacketDumper logRawPacket:_mtp3_pdu withComment:@"Can not decode UMTCAP_sccpNNotice"];
}

@end
