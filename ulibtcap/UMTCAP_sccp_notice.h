//
//  UMTCAP_sccp_notice.h
//  ulibtcap
//
//  Created by Andreas Fink on 25.03.16.
//  Copyright (c) 2016 Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>
#import <ulibsccp/ulibsccp.h>
#import <ulibgt/ulibgt.h>

@class UMLayerTCAP;

@interface UMTCAP_sccp_notice : UMTask
{
    UMLayerTCAP *tcapLayer;;
    UMLayerSCCP *sccpLayer;
    NSData      *data;
    SccpAddress *src;
    SccpAddress *dst;
    NSDictionary *options;
}

- (UMTCAP_sccp_notice *)initForTcapLayer:(UMLayer *)layer;

@property(readwrite,strong)   UMLayerSCCP *sccpLayer;
@property(readwrite,strong)   NSData      *data;
@property(readwrite,strong)   SccpAddress *src;
@property(readwrite,strong)   SccpAddress *dst;
@property(readwrite,strong)   NSDictionary *options;

@end
