//
//  UMTCAP_StatisticDb.m
//  ulibtcap
//
//  Created by Andreas Fink on 18.06.20.
//  Copyright © 2020 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMTCAP_StatisticDb.h"
#import "UMTCAP_StatisticDbRecord.h"
#import "UMLayerTCAPApplicationContextProtocol.h"
#import "UMLayerTCAP.h"

@implementation UMTCAP_StatisticDb


// #define UMTCAP_STATISTICS_DEBUG 1

static dbFieldDef UMSCCP_StatisticDb_fields[] =
{
    {"dbkey",               NULL,       NO,     DB_PRIMARY_INDEX,   DB_FIELD_TYPE_VARCHAR,             255,   0,NULL,NULL,1},
    {"ymdh",                NULL,       NO,     DB_INDEXED,         DB_FIELD_TYPE_VARCHAR,             10,    0,NULL,NULL,2},
    {"instance",            NULL,       NO,     DB_INDEXED,         DB_FIELD_TYPE_VARCHAR,             32,    0,NULL,NULL,3},
    {"calling_prefix",      NULL,       NO,     DB_INDEXED,         DB_FIELD_TYPE_VARCHAR,             32,    0,NULL,NULL,4},
    {"called_prefix",       NULL,       NO,     DB_INDEXED,         DB_FIELD_TYPE_VARCHAR,             32,    0,NULL,NULL,5},
    {"direction",           NULL,       NO,     DB_INDEXED,         DB_FIELD_TYPE_VARCHAR,             3,     0,NULL,NULL,6},
    {"tcap_command"  ,      NULL,       NO,     DB_INDEXED,         DB_FIELD_TYPE_VARCHAR,             32,    0,NULL,NULL,7},
    {"msu_count",           NULL,       NO,     DB_NOT_INDEXED,     DB_FIELD_TYPE_INTEGER,             0,     0,NULL,NULL,8},
    {"bytes_count",         NULL,       NO,     DB_NOT_INDEXED,     DB_FIELD_TYPE_INTEGER,             0,     0,NULL,NULL,9},
    { "",                   NULL,       NO,     DB_NOT_INDEXED,     DB_FIELD_TYPE_END,                 0,     0,NULL,NULL,255},
};

- (UMTCAP_StatisticDb *)initWithPoolName:(NSString *)poolName
                              tableName:(NSString *)table
                             appContext:(id<UMLayerTCAPApplicationContextProtocol>)appContext
                             autocreate:(BOOL)autocreate
                               instance:(NSString *)instance
{
    self = [super init];
    if(self)
    {
        NSDictionary *config =@{ @"enable"     : @(YES),
                                   @"table-name" : table,
                                   @"autocreate" : @(autocreate),
                                   @"pool-name"  : poolName };
        _poolName = poolName;
        _pool = [appContext dbPools][_poolName];
        _table = [[UMDbTable alloc]initWithConfig:config andPools:appContext.dbPools];
        _lock = [[UMMutex alloc]initWithName:@"UMMTP3StatisticDb-lock"];
        _entries = [[UMSynchronizedDictionary alloc]init];
        _instance = instance;
        NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"UTC"];
        _ymdhDateFormatter= [[NSDateFormatter alloc]init];
        NSLocale *ukLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [_ymdhDateFormatter setLocale:ukLocale];
        [_ymdhDateFormatter setDateFormat:@"yyyyMMddHH"];
        [_ymdhDateFormatter setTimeZone:tz];
    }
    return self;
}

- (void)doAutocreate
{
    if(_pool==NULL)
    {
        _pool = _table.pools[_poolName];
    }

    UMDbSession *session = [_pool grabSession:__FILE__ line:__LINE__ func:__func__];
    [_table autoCreate:UMSCCP_StatisticDb_fields session:session];
    [_pool returnSession:session file:__FILE__ line:__LINE__ func:__func__];
}


- (void)addByteCount:(int)byteCount
       callingPrefix:callingPrefix
        calledPrefix:calledPrefix
         tcapCommand:(UMTCAP_Command)cmd
             inbound:(BOOL)inbound
{
    NSString *cmdString = [UMLayerTCAP tcapCommandAsString:cmd];

    @autoreleasepool
    {
#if defined (UMSTCAP_STATISTICS_DEBUG)
            NSLog(@"UMSTCAP_STATISTICS_DEBUG: addByteCount:%d\n"
                  @"                        callingPrefix:%@\n"
                  @"                         calledPrefix:%@\n"
                  @"                          tcapCommand:%@\n"
                  ,byteCount,callingPrefix,calledPrefix,cmdString);
#endif
        NSString *ymdh = [_ymdhDateFormatter stringFromDate:[NSDate date]];
        NSString *key = [UMTCAP_StatisticDbRecord keystringFor:ymdh
                                                 callingPrefix:callingPrefix
                                                  calledPrefix:calledPrefix
                                                       inbound:inbound
                                                   tcapCommand:cmdString
                                                      instance:_instance];
        [_lock lock];
        UMTCAP_StatisticDbRecord *rec = _entries[key];
        if(rec == NULL)
        {
            rec = [[UMTCAP_StatisticDbRecord alloc]init];
            rec.ymdh = ymdh;
            rec.calling_prefix = callingPrefix;
            rec.called_prefix = calledPrefix;
            rec.inbound = inbound;
            rec.tcap_command = cmdString;
            rec.instance = _instance;
            _entries[key] = rec;
        }
        [_lock unlock];
        [rec increaseMsuCount:1 byteCount:byteCount];
    }
}

- (void)flush
{
    @autoreleasepool
    {
        [_lock lock];
        UMSynchronizedDictionary *tmp = _entries;
        _entries = [[UMSynchronizedDictionary alloc]init];
        [_lock unlock];
        
        NSArray *keys = [tmp allKeys];
        for(NSString *key in keys)
        {
            UMSCCP_StatisticDbRecord *rec = tmp[key];
            [rec flushToPool:_pool table:_table];
        }
    }
}
 
@end
