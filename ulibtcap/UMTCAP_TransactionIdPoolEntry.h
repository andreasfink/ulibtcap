//
//  UMTCAP_TransactionIdPoolEntry.h
//  ulibtcap
//
//  Created by Andreas Fink on 26.05.20.
//  Copyright © 2020 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>


@interface UMTCAP_TransactionIdPoolEntry : UMObject
{
    NSString *_transactionId;
    NSDate   *_lastUse;
    NSDate   *_lastFreed;
    NSDate   *_lastQuarantined;
    NSString *_instance;
}

@property(readwrite,strong,atomic)     NSString *transactionId;
@property(readwrite,strong,atomic)     NSDate *lastUse;
@property(readwrite,strong,atomic)     NSDate *lastFreed;
@property(readwrite,strong,atomic)     NSDate *lastQuarantined;
@property(readwrite,strong,atomic)     NSString *instance;

@end
