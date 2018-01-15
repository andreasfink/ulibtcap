//
//  UMTCAP_InvokeId.h
//  ulibtcap
//
//  Created by Andreas Fink on 22.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>

@interface UMTCAP_InvokeId : UMObject
{
    int _invokeId;
}

@property (readwrite,assign,atomic) int invokeId;

@end
