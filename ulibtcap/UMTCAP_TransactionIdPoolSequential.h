//
//  UMTCAP_TransactionIdPoolSequential.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMTCAP_TransactionIdPool.h"

@interface UMTCAP_TransactionIdPoolSequential : UMTCAP_TransactionIdPool
{

}

@property(readwrite,strong,atomic)  NSNumber *first;
@property(readwrite,strong,atomic)  NSNumber *last;
@property(readwrite,assign,atomic)  u_int32_t nextTransactionId;


- (UMTCAP_TransactionIdPoolSequential *)initWithStart:(NSNumber *)start end:(NSNumber *)end;


@end


