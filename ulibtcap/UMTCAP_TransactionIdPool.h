//
//  UMTCAP_TransactionIdPool.h
//  ulibtcap
//
//  Created by Andreas Fink on 17.02.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMTCAP_TransactionIdPoolProtocol.h"

@interface UMTCAP_TransactionIdPool : UMObject<UMTCAP_TransactionIdPoolProtocol>
{
    NSMutableArray *_quarantineTransactionIds1;
    NSMutableArray *_quarantineTransactionIds2;
    NSMutableArray *_quarantineTransactionIds3;

    NSMutableDictionary *_freeTransactionIds;
    NSMutableDictionary *_inUseTransactionIds;
    UMMutex             *_lock;
    UMTimer             *_quarantineRotateTimer;

}


- (UMTCAP_TransactionIdPool *)init;
- (UMTCAP_TransactionIdPool *)initWithPrefabricatedIds:(long)count;
- (NSString *)newTransactionIdForInstance:(NSString *)instance;
- (void)returnTransactionId:(NSString *)tidString;
- (NSString *)findInstanceForTransaction:(NSString *)tid;
- (void)quarantineRotate;

@end
