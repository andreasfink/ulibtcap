//
//  UMTCAP_StatisticsDb.h
//  ulibtcap
//
//  Created by Andreas Fink on 18.06.20.
//  Copyright © 2020 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import <ulibdb/ulibdb.h>
#import <ulibtcap/UMLayerTCAPApplicationContextProtocol.h>
#import <ulibtcap/UMTCAP_Command.h>

@interface UMTCAP_StatisticDb : UMObject
{
    UMDbPool    *_pool;
    UMDbTable   *_table;
    UMMutex     *_mtp3StatisticDbLock;
    UMSynchronizedDictionary *_entries;
    NSDateFormatter *_ymdhDateFormatter;
    NSString *_instance;
    NSString *_poolName;
}

- (UMTCAP_StatisticDb *)initWithPoolName:(NSString *)pool
                              tableName:(NSString *)table
                             appContext:(id<UMLayerTCAPApplicationContextProtocol>)appContext
                             autocreate:(BOOL)autocreate
                               instance:(NSString *)instance;
- (void)addByteCount:(int)byteCount
       callingPrefix:callingPrefix
        calledPrefix:calledPrefix
         tcapCommand:(UMTCAP_Command)cmd
             inbound:(BOOL)inbound;

- (void)doAutocreate;
- (void)flush;

@end

