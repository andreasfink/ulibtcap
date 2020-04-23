//
//  UMTCAP_TransactionIdPoolSequential.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMTCAP_TransactionIdPoolProtocol.h"

@interface UMTCAP_TransactionIdPoolSequential : UMObject<UMTCAP_TransactionIdPoolProtocol>
{
    NSNumber *_first;
    NSNumber *_last;
    u_int32_t _nextTransactionId;
    NSMutableDictionary *_inUseTransactionIds;
    UMMutex *_lock;
}

@property(readwrite,strong,atomic)  NSNumber *first;
@property(readwrite,strong,atomic)  NSNumber *last;

@end


