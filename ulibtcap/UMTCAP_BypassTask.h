//
//  UMTCAP_BypassTask.h
//  ulibtcap
//
//  Created by Andreas Fink on 22.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import <ulibsccp/ulibsccp.h>

@interface UMTCAP_begin : UMLayerTask
{
    UMLayerTCAP             *tcap;

    NSString *transactionId;
    NSString *userDialogId;
    UMTCAP_Variant variant;
    id<UMLayerUserProtocol> user;
    SccpAddress *callingAddress;
    SccpAddress *calledAddress;
    TCAP_NSARRAY_OF_COMPONENT_PDU *components;
    NSDictionary *options;
    UMTCAP_asn1_dialoguePortion *dialoguePortion;
    NSData *pdu;
}

- (UMTCAP_begin *)initForTcap:(UMLayerTCAP *)xtcap
                transactionId:(NSString *)transactionId
                 userDialogId:(NSString *)userDialogId
                      variant:(UMTCAP_Variant)variant
                         user:(id<UMLayerUserProtocol>)xuser
               callingAddress:(SccpAddress *)xsrc
                calledAddress:(SccpAddress *)xdst
              dialoguePortion:(UMTCAP_asn1_dialoguePortion *)xdialoguePortion
                   components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                      options:(NSDictionary *)xoptions;
@end
