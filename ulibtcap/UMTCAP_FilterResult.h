//
//  UMTCAP_FilterResult.h
//  ulibtcap
//
//  Created by Andreas Fink on 23.11.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

typedef enum UMTCAP_FilterResult
{
    UMTCAP_FilterResult_accept = 0,
    UMTCAP_FilterResult_drop = 1,
    UMTCAP_FilterResult_reject = 2,
    UMTCAP_FilterResult_redirect = 3,
    UMTCAP_FilterResult_continue = 4,
} UMTCAP_FilterResult;



