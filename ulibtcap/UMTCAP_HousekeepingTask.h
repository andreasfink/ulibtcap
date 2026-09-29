//
//  UMTCAP_HousekeepingTask.h
//  ulibtcap
//
//  Created by Andreas Fink on 25.01.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibsccp/ulibsccp.h>

@class UMLayerTCAP;

@interface UMTCAP_HousekeepingTask : UMLayerTask
{
    UMLayerTCAP *tcapLayer;
}

- (UMTCAP_HousekeepingTask *)initForTcap:(UMLayerTCAP *)tcap;
- (void)main;

@end
