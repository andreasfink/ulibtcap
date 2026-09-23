//
//  UMTCAP_TransactionIdPoolProtocol.h
//  ulibtcap
//
//  Created by Andreas Fink on 24.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibsccp/ulibsccp.h>

@protocol UMTCAP_TransactionIdPoolProtocol

- (NSString *)newTransactionIdForInstance:(NSString *)instance;
- (void)returnTransactionId:(NSString *)tidString;
- (NSString *)findInstanceForTransaction:(NSString *)tid;
- (UMSynchronizedSortedDictionary *)objectValue;
@property(readwrite,assign,atomic)  BOOL isShared;

@end
