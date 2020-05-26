//
//  UMTCAP_TransactionIdPool.h
//  ulibtcap
//
//  Created by Andreas Fink on 17.02.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMTCAP_TransactionIdPoolProtocol.h"
#import "UMTCAP_TransactionIdPoolEntry.h"

@interface UMTCAP_TransactionIdPool : UMObject<UMTCAP_TransactionIdPoolProtocol>
{
    NSMutableArray<UMTCAP_TransactionIdPoolEntry *> *_quarantineTransactionIds1;
    NSMutableArray<UMTCAP_TransactionIdPoolEntry *> *_quarantineTransactionIds2;
    NSMutableArray<UMTCAP_TransactionIdPoolEntry *> *_quarantineTransactionIds3;

    NSMutableDictionary<NSString *,UMTCAP_TransactionIdPoolEntry *> *_freeTransactionIds; /* key is transaction ID in hex, content is UMTCAP_TransactionIdPoolEntry object */
    NSMutableDictionary<NSString *,UMTCAP_TransactionIdPoolEntry *> *_inUseTransactionIds; /* key is transaction ID in hex,  content is instance name */
    UMMutex             *_lock;
    UMTimer             *_quarantineRotateTimer;

}


- (UMTCAP_TransactionIdPool *)init;
- (UMTCAP_TransactionIdPool *)initWithPrefabricatedIds:(uint32_t)count;
- (UMTCAP_TransactionIdPool *)initWithPrefabricatedIds:(uint32_t)count start:(uint32_t)start end:(uint32_t)end;
- (NSString *)newTransactionIdForInstance:(NSString *)instance;
- (void)returnTransactionId:(NSString *)tidString;
- (NSString *)findInstanceForTransaction:(NSString *)tid;
- (void)quarantineRotate;

@end
