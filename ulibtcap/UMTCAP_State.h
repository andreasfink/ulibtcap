//
//  UMTCAP_State.h
//  ulibtcap
//
//  Created by Andreas Fink on 27/04/16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibasn1/ulibasn1.h>
@class UMTCAP_Transaction;

@interface UMTCAP_State : UMObject
{
    
}

-(UMTCAP_State *)eventSend:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventReceiveWellFormedRRNL:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventReceiveWellFormedRRL:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventReceiveWellFormedRE:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventReceiveMalformedRRNL:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventReceiveMalformedRRL:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventReceiveMalformedRE:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventReceiveRJ:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventCancel:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventInvocationTimeout:(UMTCAP_Transaction *)t;
-(UMTCAP_State *)eventEndSituation:(UMTCAP_Transaction *)t;

@end
