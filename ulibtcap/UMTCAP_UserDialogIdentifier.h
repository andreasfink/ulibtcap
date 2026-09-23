//
//  UMTCAP_UserDialogIdentifier.h
//  ulibtcap
//
//  Created by Andreas Fink on 14.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibsccp/ulibsccp.h>

@interface UMTCAP_UserDialogIdentifier : UMObject
{
    NSString *_dialogId;
}

@property (readwrite,strong) NSString *dialogId;

- (UMTCAP_UserDialogIdentifier *)initWithString:(NSString *)str;
- (id)proxyForJson;

@end
