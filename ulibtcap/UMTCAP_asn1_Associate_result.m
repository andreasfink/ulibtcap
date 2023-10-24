//
//  UMTCAP_asn1_Associate_result.m
//  ulibtcap
//
//  Created by Andreas Fink on 03/05/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_asn1_Associate_result.h>

@implementation UMTCAP_asn1_Associate_result

- (NSString *)objectName
{
    return @"Associate-Result";
}

- (id)objectValue
{
    if(self.value == 0)
    {
        return @"accepted(0)";
    }
    else if(self.value==1)
    {
        return @"reject-permanent(0)";

    }
    return [NSString stringWithFormat:@"unknown(%ld)",(long)self.value];
}
@end
