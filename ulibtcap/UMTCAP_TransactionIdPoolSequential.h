//
//  UMTCAP_TransactionIdPoolSequential.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_TransactionIdPool.h"

@interface UMTCAP_TransactionIdPoolSequential : UMTCAP_TransactionIdPool
{
    u_int32_t _nextTransactionId;
}

@end


