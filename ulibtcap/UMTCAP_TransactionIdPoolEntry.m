//
//  UMTCAP_TransactionIdPoolEntry.m
//  ulibtcap
//
//  Created by Andreas Fink on 26.05.20.
//  Copyright © 2020 Andreas Fink (andreas@fink.org). All rights reserved.
//
/* wrapper around NSString so it can show up on UMObject statistics */

#import <ulibtcap/UMTCAP_TransactionIdPoolEntry.h>

@implementation UMTCAP_TransactionIdPoolEntry

- (NSString *)description
{
    return [NSString stringWithFormat:@"TransactionIdPoolEntry{tid=%@, instance=%@, lastUse=%@, lastFreed=%@, lastQuarantined=%@",
            _transactionId,_instance,_lastUse,_lastFreed,_lastQuarantined];
}
@end
