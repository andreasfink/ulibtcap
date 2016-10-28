//
//  UMTCAP_asn1_objectIdentifier.m
//  ulibtcap
//
//  Created by Andreas Fink on 26.04.16.
//  Copyright © 2016 Andreas Fink. All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import "UMTCAP_asn1_objectIdentifier.h"

@implementation UMTCAP_asn1_objectIdentifier


- (UMTCAP_asn1_objectIdentifier *)initWithString:(NSString *)context
{
    self = [super init];
    if(self)
    {
        if(context == NULL)
        {
            asn1_data = [NSData data];
        }
        else
        {
            asn1_data = [context unhexedData];
        }
        asn1_tag.tagNumber = 6;
        asn1_tag.tagClass = UMASN1Class_Universal;
    }
    return self;
}

- (NSString *)objectName
{
    return @"objectIdentifier";
}


- (id)objectValue
{
    UMSynchronizedSortedDictionary *dict = [[UMSynchronizedSortedDictionary alloc]init];
    dict[@"rawData"] = [asn1_data hexString];
    
    if(asn1_data.length == 7)
    {
        const uint8_t *bytes = asn1_data.bytes;
        if((bytes[0] == 4) &&
           (bytes[1] == 0) &&
           (bytes[2] == 0) &&
           (bytes[3] == 1) &&
           (bytes[4] == 0))
        {
            int a = bytes[5];
            int ver = bytes[6];
            NSString *s = NULL;
            switch(a)
            {
                case 1:
                    s = @"networkLocUpContext";
                    break;
                case 2:
                    s = @"locationCancellationContext";
                    break;
                case 3:
                    s = @"roamingNumberEnquiryContext";
                    break;
                case 4:
                    s = @"istAlertingContext";
                    break;
                case 5:
                    s = @"locationInfoRetrievalContext";
                    break;
                case 6:
                    s = @"callControlTransfer";
                    break;
                case 7:
                    s = @"reportingContext";
                    break;
                case 8:
                    s = @"callCompletionContext";
                    break;
                case 9:
                    s = @"serviceTerminationContext";
                    break;
                case 10:
                    s = @"resetContext";
                    break;
                case 11:
                    s = @"handoverControlContext";
                    break;
                case 12:
                    s = @"sIWFSAllocationContext";
                    break;
                case 13:
                    s = @"equipmentMngtContext";
                    break;
                case 14:
                    s = @"infoRetrievalContext";
                    break;
                case 15:
                    s = @"interVlrInfoRetrievalContext";
                    break;
                case 16:
                    s = @"subscriberDataMngtContext";
                    break;
                case 17:
                    s = @"tracingContext-v1";
                    break;
                case 18:
                    s = @"networkFunctionalSsContext";
                    break;
                case 19:
                    s = @"networkUnstructuredSsContext";
                    break;
                case 20:
                    s = @"shortMsgGatewayContext";
                    break;
                case 21:
                    s = @"shortMsgMO-RelayContext";
                    break;
                case 22:
                    s = @"subscriberDataModificationNotificationContext";
                    break;
                case 23:
                    s = @"shortMsgAlertContext";
                    break;
                case 24:
                    s = @"mwdMngtContext";
                    break;
                case 25:
                    s = @"shortMsgMT-RelayContext";
                    break;
                case 26:
                    s = @"imsiRetrievalContext";
                    break;
                case 27:
                    s = @"msPurgingContext-v2";
                    break;
                case 28:
                    s = @"subscriberInfoEnquiryContext";
                    break;
                case 29:
                    s = @"anyTimeInfoEnquiry";
                    break;
                case 31:
                    s = @"groupCallControlContext";
                    break;
                case 32:
                    s = @"gprsLocationUpdateContext";
                    break;
                case 33:
                    s = @"gprsLocationInfoRetrievalContext";
                    break;
                case 34:
                    s = @"failureReportContext";
                    break;
                case 35:
                    s = @"gprsNotifyContext";
                    break;
                case 36:
                    s = @"ss-InvocationNotification";
                    break;
                case 37:
                    s = @"locationSvcGatewayContext";
                    break;
                case 38:
                    s = @"locationSvcEnquiryContext";
                    break;
                case 41:
                    s = @"shortMsgMT-Relay-VGCS-Context";
                    break;
                case 42:
                    s = @"mm-EventReportingContext";
                    break;
                case 43:
                    s = @"anyTimeInfoHandlingContext";
                    break;
                case 44:
                    s = @"resourceManagementContext";
                    break;
                case 45:
                    s = @"groupCallInfoRetrievalContext";
                    break;
            }
            if(s)
            {
                dict[@"objectIdentifier"] = [NSString stringWithFormat:@"%@-v%d",s,ver];
            }
        }
    }
    return dict;
}

@end
