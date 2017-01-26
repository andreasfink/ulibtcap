//
//  UMTCAP_TimeoutTask.h
//  ulibtcap
//
//  Created by Andreas Fink on 25.01.17.
//  Copyright © 2017 Andreas Fink. All rights reserved.
//

#import <ulib/ulib.h>

@class UMLayerTCAP;
@class UMTCAP_Transaction;

@interface UMTCAP_TimeoutTask : UMLayerTask
{
    UMLayerTCAP *tcap;
    UMTCAP_Transaction *transaction;
}

- (UMTCAP_TimeoutTask *)initForTCAP:(UMLayerTCAP *)g transaction:(UMTCAP_Transaction *)t;
- (void)main;

@end
