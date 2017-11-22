//
//  UMTCAP_BypassTask.m
//  ulibtcap
//
//  Created by Andreas Fink on 22.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_BypassTask.h"

@implementation UMTCAP_BypassTask


- (void) main
{
    if(pdu)
    {
        if(tcap.logLevel <= UMLOG_DEBUG)
        {
            NSString *s = [NSString stringWithFormat:@"Sending PDU to %@: %@", tcap.attachedLayer.layerName, pdu];
            [tcap.logFeed debugText:s];
        }
        [tcap.attachedLayer sccpNUnidata:pdu
                            callingLayer:tcap
                                 calling:callingAddress
                                  called:calledAddress
                        qualityOfService:0
                                 options:options];
    }
    if(tcap.logLevel <= UMLOG_DEBUG)
    {
        [tcap.logFeed debugText:[NSString stringWithFormat:@" done with transaction %@",transactionId]];
    }

}
@end
