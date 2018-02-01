//
//  UMTCAP_Operation.h
//  ulibtcap
//
//  Created by Andreas Fink on 20.04.16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulib/ulib.h>


typedef enum UMTCAP_InternalOperation
{
    UMTCAP_InternalOperation_Response = 0,
    UMTCAP_InternalOperation_Request = 1,
    UMTCAP_InternalOperation_Error = 3,
    UMTCAP_InternalOperation_Reject = 4,
    UMTCAP_InternalOperation_Unidirectional = 5,
} UMTCAP_InternalOperation;


@interface UMTCAP_Operation : UMObject
{
    int _operationId;
}

@property (readwrite,assign,atomic) int operationId;

@end
