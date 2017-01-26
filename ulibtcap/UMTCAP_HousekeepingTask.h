//
//  UMTCAP_HousekeepingTask.h
//  ulibtcap
//
//  Created by Andreas Fink on 25.01.17.
//  Copyright © 2017 Andreas Fink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ulib/ulib.h>

@class UMLayerTCAP;

@interface UMTCAP_HousekeepingTask : UMLayerTask
{
    UMLayerTCAP *tcapLayer;
}

- (UMTCAP_HousekeepingTask *)initForTcap:(UMLayerTCAP *)tcap;
- (void)main;

@end
