//
//  UMTCAP_BypassTask.m
//  ulibtcap
//
//  Created by Andreas Fink on 22.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_BypassTask.h"
#import "UMLayerTCAP.h"
#import "UMTCAP_Transaction.h"

@implementation UMTCAP_BypassTask

- (UMTCAP_BypassTask *)initForTcap:(UMLayerTCAP *)xtcap
                     transactionId:(NSString *)xtransactionId
                      userDialogId:(NSString *)xuserDialogId
                           variant:(UMTCAP_Variant)xvariant
                              user:(id<UMLayerUserProtocol>)xuser
                    callingAddress:(SccpAddress *)xsrc
                     calledAddress:(SccpAddress *)xdst
                       sccpPayload:(NSData *)xsccpPayload
                           options:(NSDictionary *)xoptions
{
    NSAssert(xtcap != NULL,@"tcap is null");
    NSAssert(xuser != NULL,@"user can not be null");
    self = [super initWithName:@"UMTCAP_BypassTask"
                      receiver:xtcap
                        sender:xuser
           requiresSynchronisation:NO];
    if(self)
    {
        _tcap = xtcap;
        _transactionId = xtransactionId;
        _userDialogId = xuserDialogId;
        _variant = xvariant;
        _user =xuser;
        _callingAddress=xsrc;
        _calledAddress=xdst;
        _sccpPayload=xsccpPayload;
        _options=xoptions;
    }
    return self;
}

- (void) main
{
    if(_sccpPayload)
    {
        if(_tcap.logLevel <= UMLOG_DEBUG)
        {
            NSString *s = [NSString stringWithFormat:@"Sending PDU to %@: %@", _tcap.attachedLayer.layerName, _sccpPayload];
            [_tcap.logFeed debugText:s];
        }
        [_tcap.attachedLayer sccpNUnidata:_sccpPayload
                            callingLayer:_tcap
                                 calling:_callingAddress
                                  called:_calledAddress
                        qualityOfService:0
                                 options:_options];
    }
    if(_tcap.logLevel <= UMLOG_DEBUG)
    {
        [_tcap.logFeed debugText:[NSString stringWithFormat:@" done with transaction %@",_transactionId]];
    }
    UMTCAP_Transaction *t = [_tcap findTransactionByLocalTransactionId:_transactionId];
    t.transactionIsClosed = YES;
}
@end
