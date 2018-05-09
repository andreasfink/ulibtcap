//
//  UMTCAP_asn1_AbortSource.m
//  ulibtcap
//
//  Created by Andreas Fink on 09.05.18.
//  Copyright © 2018 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_asn1_AbortSource.h"

@implementation UMTCAP_asn1_AbortSource


- (UMTCAP_asn1_AbortSource *)initWithString:(NSString *)s
{
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([s isEqualToString:@"dialogue-service-user"])
    {
        return [super initWithValue:0];
    }
    if([s isEqualToString:@"dialogue-service-provider"])
    {
        return [super initWithValue:1];
    }
    return [super initWithValue:(int64_t)[s integerValue]];
}

- (NSString *) objectName
{
    return @"abort-source";
}

- (id) objectValueDescription
{
    switch(self.value)
    {
        case(0):
            return @"dialogue-service-user(0)";
            break;
        case(1):
            return @"dialogue-service-provider(1)";
            break;
        default:
            return [NSNumber numberWithInteger:(NSInteger)self.value];
    }
}

- (id) objectValue
{
    return [NSNumber numberWithInteger:(NSInteger)self.value];
}

@end

