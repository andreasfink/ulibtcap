//
//  UMTCAP_ansi_end.m
//  ulibtcap
//
//  Created by Andreas Fink on 10.10.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_ansi_end.h"

#import "UMLayerTCAP.h"

#import "UMTCAP_ansi_asn1_transactionPDU.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_ansi_asn1_dialoguePortion.h"

@implementation UMTCAP_ansi_end

- (UMTCAP_ansi_end *)initForTcap:(UMLayerTCAP *)xtcap
                  transactionId:(NSString *)xtransactionId
                   userDialogId:(UMTCAP_UserDialogIdentifier *)xuserDialogId
                        variant:(UMTCAP_Variant)xvariant
                           user:(id<UMLayerUserProtocol>)xuser
                 callingAddress:(SccpAddress *)xsrc
                  calledAddress:(SccpAddress *)xdst
             applicationContext:(UMTCAP_asn1_objectIdentifier *)xappContext
                       userInfo:(UMTCAP_asn1_userInformation *)xuserInfo
          dialogProtocolVersion:(UMASN1Object *)xdialogProtocolVersion
                     components:(TCAP_NSARRAY_OF_COMPONENT_PDU *)xcomponents
                     permission:(BOOL)xpermission /* only relevant for ANSI */
                        options:(NSDictionary *)xoptions
{
    UMTCAP_ansi_asn1_dialoguePortion *ansi_dialogPortion = NULL;
    if((xdialogProtocolVersion) || (xappContext) || (xuserInfo))
    {
        ansi_dialogPortion = [[UMTCAP_ansi_asn1_dialoguePortion alloc]init];
        ansi_dialogPortion.objectApplicationId = xappContext;
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
                   permission:xpermission
                      options:xoptions];
}

- (void)main
{
    UMTCAP_Transaction *t = [tcap findTransactionByLocalTransactionId:transactionId];

    UMTCAP_ansi_asn1_transactionPDU *q;
    if(options[@"ansi-without-permission"])
    {
        q = [[UMTCAP_ansi_asn1_conversationWithoutPerm alloc]init];
    }
    else
    {
        q = [[UMTCAP_ansi_asn1_conversationWithPerm alloc]init];
    }

    //UMTCAP_ansi_asn1_transactionID      *identifier;
    //UMTCAP_ansi_asn1_dialoguePortion    *dialogPortion;
    //UMTCAP_ansi_asn1_componentSequence  *componentPortion;

    UMTCAP_ansi_asn1_transactionID *transactionIdentifier = [[UMTCAP_ansi_asn1_transactionID alloc]init];
    transactionIdentifier.tid = t.remoteTransactionId;
    q.identifier = transactionIdentifier;

    /*
    if(applicationContext)
    {
        q.dialogPortion = [[UMTCAP_ansi_asn1_dialoguePortion alloc]init];
        q.dialogPortion.dialogRequest = [[UMTCAP_asn1_AARQ_apdu alloc]init];
        q.dialogPortion.dialogRequest.objectIdentifier = applicationContext;
    }
    else
    {
        q.dialoguePortion = NULL;
    }
     */
    if(components.count > 0)
    {
        UMTCAP_ansi_asn1_componentSequence *componentsPortion = [[UMTCAP_ansi_asn1_componentSequence alloc]init];
        for(id item in components)
        {
            [componentsPortion addComponent:(UMTCAP_ansi_asn1_componentPDU *)item];
        }
        q.componentPortion = componentsPortion;
    }

    NSData *pdu = [q berEncoded];

    [tcap.attachedLayer sccpNUnidata:pdu
                        callingLayer:tcap
                             calling:callingAddress
                              called:calledAddress
                    qualityOfService:0
                               class:SCCP_CLASS_BASIC
                            handling:SCCP_HANDLING_RETURN_ON_ERROR
                             options:options];
    t.transactionIsClosed = YES;
}

@end
