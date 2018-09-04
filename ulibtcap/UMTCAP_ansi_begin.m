//
//  UMTCAP_ansi_begin.m
//  ulibtcap
//
//  Created by Andreas Fink on 05/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_begin.h"
#import "UMTCAP_ansi_asn1_transactionPDU.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_ansi_asn1_dialoguePortion.h"
@implementation UMTCAP_ansi_begin


- (UMTCAP_ansi_begin *)initForTcap:(UMLayerTCAP *)xtcap
                     transactionId:(NSString *)xtransactionId
                      userDialogId:(UMTCAP_UserDialogIdentifier *)xuserDialogId
                           variant:(UMTCAP_Variant)xvariant
                              user:(id<UMLayerUserProtocol>)xuser
                    callingAddress:(SccpAddress *)xsrc
                     calledAddress:(SccpAddress *)xdst
                applicationContext:(UMTCAP_asn1_objectIdentifier *)xapplicationContext
                          userInfo:(UMTCAP_asn1_external *)xuserInfo
             dialogProtocolVersion:(UMASN1Object *)xdialogProtocolVersion
                        components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                           options:(NSDictionary *)xoptions
{
    NSAssert(xtcap != NULL,@"tcap is null");
    NSAssert(xuser != NULL,@"user can not be null");
    
    
    UMTCAP_ansi_asn1_dialoguePortion *ansi_dialogPortion = NULL;
    if((xdialogProtocolVersion) || (xapplicationContext) || (xuserInfo))
    {
        ansi_dialogPortion = [[UMTCAP_ansi_asn1_dialoguePortion alloc]init];
        ansi_dialogPortion.objectApplicationId = xapplicationContext;
        ansi_dialogPortion.userInformation = xuserInfo;
        ansi_dialogPortion.version = xdialogProtocolVersion;
    }
    return [super initForTcap:xtcap
                transactionId:xtransactionId
                 userDialogId:xuserDialogId
                      variant:xvariant
                         user:xuser
               callingAddress:xsrc
                calledAddress:xdst
              dialoguePortion:ansi_dialogPortion
                   components:xcomponents
                      options:xoptions];
}

- (void)main
{
    UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];

    UMTCAP_ansi_asn1_transactionPDU *q;
    
    if(options[@"ansi-without-permission"])
    {
        q = [[UMTCAP_ansi_asn1_queryWithoutPerm alloc]init];
    }
    else
    {
        q = [[UMTCAP_ansi_asn1_queryWithPerm alloc]init];
    }

    UMTCAP_ansi_asn1_transactionID *tid = [[UMTCAP_ansi_asn1_transactionID alloc]init];
    tid.tid = transactionId;
    
    UMTCAP_ansi_asn1_componentSequence *compSequence = [[UMTCAP_ansi_asn1_componentSequence alloc]init];
    for(id item in components)
    {
        [compSequence addComponent:(UMTCAP_ansi_asn1_componentPDU *)item];
    }
    q.identifier = tid;
    q.componentPortion = compSequence;
    
    NSData *pdu = [q berEncoded];
    
    [tcap.attachedLayer sccpNUnidata:pdu
                        callingLayer:tcap
                             calling:callingAddress
                              called:calledAddress
                    qualityOfService:0
                               class:SCCP_CLASS_BASIC
                            handling:UMSCCP_HANDLING_RETURN_ON_ERROR
                             options:options];
    [t touch];
}

@end
