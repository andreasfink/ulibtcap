//
//  UMTCAP_UserDialogIdentifier.m
//  ulibtcap
//
//  Created by Andreas Fink on 14.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_UserDialogIdentifier.h"

@implementation UMTCAP_UserDialogIdentifier

- (NSString *)description
{
    return _dialogId;
}

- (UMTCAP_UserDialogIdentifier *)initWithString:(NSString *)str
{
    self = [super init];
    if(self)
    {
        _dialogId = str;
    }
    return self;
}


-(UMTCAP_UserDialogIdentifier *)copyWithZone:(NSZone *)zone
{
    UMTCAP_UserDialogIdentifier *cpy = [[UMTCAP_UserDialogIdentifier allocWithZone:zone]init];
    cpy.dialogId = _dialogId;
    return cpy;
}

- (id)proxyForJson
{
    return _dialogId;
}

@end
