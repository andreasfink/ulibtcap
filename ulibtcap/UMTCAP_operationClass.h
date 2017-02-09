//
//  UMTCAP_operationClass.h
//  ulibtcap
//
//  Created by Andreas Fink on 31/03/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.


typedef enum UMTCAP_operationClass
{
    TCAP_OPERATION_CLASS1_REPORT_SUCCESS_OR_FAILURE  = 1,
    TCAP_OPERATION_CLASS2_REPORT_FAILURE_ONLY        = 2,
    TCAP_OPERATION_CLASS3_REPORT_SUCCESS_ONLY        = 3,
    TCAP_OPERATION_CLASS4_OUTCOME_NOT_REPORTED       = 4,
} UMTCAP_operationClass;

