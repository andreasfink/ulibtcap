//
//  UMTCAP_Operation.m
//  ulibtcap
//
//  Created by Andreas Fink on 22.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibtcap/UMTCAP_Operation.h>

@implementation UMTCAP_Operation

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d",self.operationId];
}

@end
