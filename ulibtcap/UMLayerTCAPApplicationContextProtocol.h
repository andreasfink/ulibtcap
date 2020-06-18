//
//  UMLayerTCAPApplicationContextProtocol.h
//  ulibtcap
//
//  Created by Andreas Fink on 25.01.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMLayerSCCP;
@class UMLayerTCAP;

@protocol UMLayerTCAPApplicationContextProtocol<NSObject>
- (UMLayerSCCP *)getSCCP:(NSString *)name;
- (UMLayerTCAP *)getTCAP:(NSString *)name;
- (UMSynchronizedDictionary *)dbPools;

@end
