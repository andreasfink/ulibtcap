//
//  UMTCAP_StatisticDbRecord.h
//  ulibtcap
//
//  Created by Andreas Fink on 18.06.20.
//  Copyright © 2020 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>
#import <ulibdb/ulibdb.h>

@interface UMTCAP_StatisticDbRecord : UMObject
{
    NSString *_ymdh;
    NSString *_instance;
    NSString *_calling_prefix;
    NSString *_called_prefix;
    BOOL     _inbound;
    NSString *_tcap_command;
    int     _msu_count;
    int     _bytes_count;
    UMMutex *_recordLock;
}


@property(readwrite,strong,atomic)  NSString *ymdh;
@property(readwrite,strong,atomic)  NSString *instance;
@property(readwrite,strong,atomic)  NSString *calling_prefix;
@property(readwrite,strong,atomic)  NSString *called_prefix;
@property(readwrite,assign,atomic)  BOOL     inbound;
@property(readwrite,strong,atomic)  NSString *tcap_command;
@property(readwrite,assign,atomic)  int     msu_count;
@property(readwrite,assign,atomic)  int     bytes_count;


- (NSString *)keystring;
+ (NSString *)keystringFor:(NSString *)ymdh
             callingPrefix:(NSString *)callingPrefix
              calledPrefix:(NSString *)calledPrefix
                   inbound:(BOOL)inbound
               tcapCommand:(NSString *)tcapCommand
                  instance:(NSString *)instance;

- (void)increaseMsuCount:(int)msuCount byteCount:(int)byteCount;
- (void)flushToPool:(UMDbPool *)pool table:(UMDbTable *)table;

@end
