//
//  UMTCAP_Operation.h
//  ulibtcap
//
//  Created by Andreas Fink on 20.04.16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

typedef enum UMTCAP_Operation
{
    UMTCAP_Operation_Response = 0,
    UMTCAP_Operation_Request = 1,
    UMTCAP_Operation_Error = 3,
    UMTCAP_Operation_Reject = 4,
    UMTCAP_Operation_Unidirectional = 5,
} UMTCAP_Operation;
