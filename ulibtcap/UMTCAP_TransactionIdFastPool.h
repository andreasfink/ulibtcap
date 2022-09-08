//
//  UMTCAP_TransactionIdFastPool.h
//  ulibtcap
//
//  Created by Andreas Fink on 29.05.20.
//  Copyright © 2020 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import "UMTCAP_TransactionIdPoolProtocol.h"
#import "UMTCAP_TransactionIdPoolEntry.h"


@interface UMTCAP_TransactionIdFastPool : UMObject<UMTCAP_TransactionIdPoolProtocol>
{
    NSMutableArray<UMTCAP_TransactionIdPoolEntry *> *_quarantineTransactionIds1;
    NSMutableArray<UMTCAP_TransactionIdPoolEntry *> *_quarantineTransactionIds2;
    NSMutableArray<UMTCAP_TransactionIdPoolEntry *> *_quarantineTransactionIds3;

    NSMutableArray<UMTCAP_TransactionIdPoolEntry *> *_freeTransactionIds; /* key is transaction ID in hex, content is UMTCAP_TransactionIdPoolEntry object */
    NSMutableDictionary<NSString *,UMTCAP_TransactionIdPoolEntry *> *_inUseTransactionIds; /* key is transaction ID in hex,  content is UMTCAP_TransactionIdPoolEntry */
    UMMutex             *_fastPoolLock;
    UMTimer             *_quarantineRotateTimer;
    BOOL                _isShared;
}


- (UMTCAP_TransactionIdFastPool *)init;
- (UMTCAP_TransactionIdFastPool *)initWithPrefabricatedIds:(uint32_t)count start:(uint32_t)start end:(uint32_t)end;
- (NSString *)newTransactionIdForInstance:(NSString *)instance;
- (void)returnTransactionId:(NSString *)tidString;
- (NSString *)findInstanceForTransaction:(NSString *)tid;
- (void)quarantineRotate;
@property(readwrite,assign,atomic)  BOOL isShared;

@end
