//
//  UMTCAP_ComponentState.h
//  ulibtcap
//
//  Created by Andreas Fink on 21.12.17.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import <ulib/ulib.h>

@class UMTCAP_Transaction;

@interface UMTCAP_ComponentState : UMObject
{
    NSDate *_started;
    UMAtomicDate *_lastActivity;
}
- (NSString *)description;
- (void)touch;
- (UMTCAP_ComponentState *)eventTC_Begin_Request:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_End_Request:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_Continue_Request:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_Invoke_Request:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_U_Cancel_Request:(UMTCAP_Transaction *)t; /* user request cancel */
- (UMTCAP_ComponentState *)eventTC_U_Reject_Request:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_R_RejectIndication:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_U_Reject_Indication:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_L_Reject_Indication:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_L_Cancel_Indication:(UMTCAP_Transaction *)t; /* invocation timeout */
- (UMTCAP_ComponentState *)eventTC_U_Error_Indication:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_Result_L_Indication:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_Result_NL_Indication:(UMTCAP_Transaction *)t;
- (UMTCAP_ComponentState *)eventTC_Uni_Request:(UMTCAP_Transaction *)t;


/* State transitions are triggered by:
 – a primitive received from the TC-user, causing a component to be built, and eventually sent;
 – receipt of a component from the peer entity;
 – a number of situations indicated on Figures 1 to 4, corresponding to the following situations:
 • Cancel – A timer is associated with an operation invocation. This invocation timer is started when the invoke component is passed to the transaction sub-layer. The TC-INVOKE request primitive indicates a timer value. A cancel situation occurs when the invoking TC-user decides to cancel the operation (TC-U-CANCEL request primitive) before either the final result (if any) is received, or a timeout situation occurs. On receipt of a TC-U-CANCEL request, the component sub-layer stops the timer; any further replies will not be delivered to the TC-user, and TCAP will react according to abnormal situations as described in 3.2.2.2.
 • End situation – When an End or Abort message is received, or when prearranged end is used, TCAP returns any pending operations to Idle.
 R d ti Q774 (06/97) 3
 • Invocation timeout – A timeout situation occurs when the timer associated with an operation invocation expires: the state machine returns to Idle, with notification to the TC-user by means of a TC-L-CANCEL indication (in the case of a class 1, 2 or 3 operation). This notification indicates an abnormal situation for a class 1 operation, or gives the definite outcome of a class 2 or 3 operation for which no result has been received (normal situation).
 • Reject timeout – A Reject timeout situation occurs when the timer associated with the Wait for Reject state expires. If this occurs, the component sub-layer assumes that the TC-user has accepted the component.

 */

@end
