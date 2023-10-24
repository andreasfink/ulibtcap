//
//  UMTCAP_StatisticDbRecord.m
//  ulibtcap
//
//  Created by Andreas Fink on 18.06.20.
//  Copyright © 2020 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulibtcap/UMTCAP_StatisticDbRecord.h>
#import <ulibdb/ulibdb.h>

@implementation UMTCAP_StatisticDbRecord



- (UMTCAP_StatisticDbRecord *)init
{
    self = [super init];
    if(self)
    {
        _recordLock = [[UMMutex alloc]initWithName:@"UMTCAP_StatisticDbRecord-lock"];
    }
    return self;
}

- (NSString *)keystring
{
    return [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",_ymdh,_calling_prefix,_called_prefix,_inbound ? @"IN" : @"OUT", _tcap_command,_instance];
}


+ (NSString *)keystringFor:(NSString *)ymdh
             callingPrefix:(NSString *)callingPrefix
              calledPrefix:(NSString *)calledPrefix
                   inbound:(BOOL)inbound
               tcapCommand:(NSString *)tcapCommand
                  instance:(NSString *)instance
{
    return [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",ymdh,callingPrefix,calledPrefix,inbound ? @"IN" : @"OUT", tcapCommand,instance];
}


- (BOOL)insertIntoDb:(UMDbPool *)pool table:(UMDbTable *)dbt /* returns YES on success */
{
    BOOL success = NO;
    @autoreleasepool
    {
        @try
        {
            [_recordLock lock];
            UMDbQuery *query = [UMDbQuery queryForFile:__FILE__ line: __LINE__];
            if(!query.isInCache)
            {
                NSArray *fields = @[
                                    @"dbkey",
                                    @"ymdh",
                                    @"instance",
                                    @"calling_prefix",
                                    @"called_prefix",
                                    @"direction",
                                    @"tcap_command",
                                    @"msu_count",
                                    @"bytes_count"];
                [query setType:UMDBQUERYTYPE_INSERT];
                [query setTable:dbt];
                [query setFields:fields];
                [query addToCache];
            }
            NSString *key = [self keystring];
            NSArray *params  = [NSArray arrayWithObjects:
                                STRING_NONEMPTY(key),
                                STRING_NONEMPTY(_ymdh),
                                STRING_NONEMPTY(_instance),
                                STRING_NONEMPTY(_calling_prefix),
                                STRING_NONEMPTY(_called_prefix),
                                _inbound ? @"IN" : @"OUT",
                                STRING_NONEMPTY(_tcap_command),
                                STRING_FROM_INT(_msu_count),
                                STRING_FROM_INT(_bytes_count),
                                NULL];
            UMDbSession *session = [pool grabSession:FLF];
            unsigned long long affectedRows = 0;
            success = [session cachedQueryWithNoResult:query parameters:params allowFail:YES primaryKeyValue:key affectedRows:&affectedRows];

            if(success==NO)
            {
                NSLog(@"SQL-FAIL: %@",query.lastSql);
            }
            [session.pool returnSession:session file:FLF];
        }
        @catch (NSException *e)
        {
            NSLog(@"Exception: %@",e);
        }
        @finally
        {
            [_recordLock unlock];
        }
    }
    return success;
}

- (BOOL)updateDb:(UMDbPool *)pool table:(UMDbTable *)dbt /* returns YES on success */
{
    BOOL success = NO;
    @autoreleasepool
    {
        @try
        {
            [_recordLock lock];
            UMDbQuery *query = [UMDbQuery queryForFile:__FILE__ line: __LINE__];
            if(!query.isInCache)
            {
                [query setType:UMDBQUERYTYPE_INCREASE_BY_KEY];
                [query setTable:dbt];
                [query setFields:@[@"msu_count",@"bytes_count"]];
                [query setPrimaryKeyName:@"dbkey"];
                [query addToCache];
            }
            NSArray *params = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:_msu_count],
                                [NSNumber numberWithInt:_bytes_count],
                                 NULL];
            NSString *key = [self keystring];
            UMDbSession *session = [pool grabSession:FLF];
            unsigned long long rowCount=0;
            success = [session cachedQueryWithNoResult:query
                                            parameters:params
                                             allowFail:YES
                                       primaryKeyValue:key
                                          affectedRows:&rowCount];
            if(rowCount==0)
            {
                success = NO;
            }
            [session.pool returnSession:session file:FLF];
        }
        @catch (NSException *e)
        {
            NSLog(@"Exception: %@",e);
        }
        @finally
        {
            [_recordLock unlock];
        }
    }
    return success;
}

- (void)increaseMsuCount:(int)msuCount byteCount:(int)byteCount
{
    [_recordLock lock];
    _msu_count   += msuCount;
    _bytes_count += byteCount;
    [_recordLock unlock];
}

- (void)flushToPool:(UMDbPool *)pool table:(UMDbTable *)table
{
    NSLog(@"TCAP Statistic: %@",self.description);

    [_recordLock lock];
    BOOL success = [self updateDb:pool table:table];
    if(success == NO)
    {
        success = [self insertIntoDb:pool table:table];
        if(success==YES)
        {
            _msu_count = 0;
            _bytes_count = 0;
        }
        else
        {
            NSLog(@"TCAP Statistics: insert into DB failed");
        }
    }
    [_recordLock unlock];
}


- (id)proxyForJson
{
    UMSynchronizedSortedDictionary *d = [[UMSynchronizedSortedDictionary alloc]init];
    d[@"_ymdh"]             = _ymdh ? _ymdh : @"(null)";
    d[@"_instance"]         = _instance ? _instance : @"(null)";
    d[@"_calling_prefix"]   = _calling_prefix ? _calling_prefix : @"(null)";
    d[@"_called_prefix"]    = _called_prefix ? _called_prefix : @"(null)";
    d[@"_tcap_command"]     = _tcap_command ? _tcap_command : @"(null)";
    d[@"_direction"]        = _inbound ? @"IN" : @"OUT";
    d[@"_msu_count"]        = @(_msu_count);
    d[@"_bytes_count"]      = @(_bytes_count);
    return d;
}

@end
