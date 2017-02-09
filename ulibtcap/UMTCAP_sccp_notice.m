//
//  UMTCAP_sccp_notice.m
//  ulibtcap
//
//  Created by Andreas Fink on 25.03.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_sccp_notice.h"

@implementation UMTCAP_sccp_notice

@synthesize sccpLayer;
@synthesize data;
@synthesize src;
@synthesize dst;
@synthesize options;

- (UMTCAP_sccp_notice *)initForTcapLayer:(UMLayerTCAP *)layer
{
    self = [super init];
    if(self)
    {
        tcapLayer = layer;
    }
    return self;
}
@end
