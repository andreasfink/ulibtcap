//
//  UMTCAP_asn1.m
//  ulibtcap
//
//  Created by Andreas Fink on 15/04/16.
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.

#import <ulibtcap/UMTCAP_asn1.h>

#import <ulibtcap/UMTCAP_ansi_asn1_unidirectional.h>
#import <ulibtcap/UMTCAP_ansi_asn1_queryWithPerm.h>
#import <ulibtcap/UMTCAP_ansi_asn1_queryWithoutPerm.h>
#import <ulibtcap/UMTCAP_ansi_asn1_response.h>
#import <ulibtcap/UMTCAP_ansi_asn1_conversationWithPerm.h>
#import <ulibtcap/UMTCAP_ansi_asn1_conversationWithoutPerm.h>
#import <ulibtcap/UMTCAP_ansi_asn1_abort.h>

#import <ulibtcap/UMTCAP_itu_asn1_unidirectional.h>
#import <ulibtcap/UMTCAP_itu_asn1_begin.h>
#import <ulibtcap/UMTCAP_itu_asn1_end.h>
#import <ulibtcap/UMTCAP_itu_asn1_continue.h>
#import <ulibtcap/UMTCAP_itu_asn1_abort.h>
#import <ulibtcap/UMTCAP_Command.h>
#import <ulibtcap/UMTCAP_sccpNUnitdata.h>
#import <ulibtcap/UMTCAP_sccpNNotice.h>

@implementation UMTCAP_asn1


- (UMASN1Object *)processAfterDecodeWithContext:(id)context
{
    UMTCAP_sccpNUnitdata *task = NULL;
    UMTCAP_sccpNNotice *notice = NULL;
    if ([context isKindOfClass:[UMTCAP_sccpNUnitdata class ]])
    {
        task = (UMTCAP_sccpNUnitdata *)context;
    }
    else if ([context isKindOfClass:[UMTCAP_sccpNNotice class ]])
    {
        notice = (UMTCAP_sccpNNotice *)context;
    }
#pragma unused(notice)


    if(_asn1_tag.tagClass ==UMASN1Class_Private)
    {
        task.tcapVariant = TCAP_VARIANT_ANSI;
        task.ansi_permission = YES;

        UMTCAP_Command tNumber = (int)_asn1_tag.tagNumber + 1000; /* the internal definition is off by 1000 for ANSI tags to not have number conflicts */
        /* all the ANSI STUFF */
        if((tNumber == TCAP_TAG_ANSI_UNIDIRECTIONAL) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            UMTCAP_ansi_asn1_unidirectional *r =  [[UMTCAP_ansi_asn1_unidirectional alloc]initWithASN1Object:self context:context];
            [task handleAnsiTransactionId:NULL];
            return r;
        }
        else if(    (tNumber == TCAP_TAG_ANSI_QUERY_WITH_PERM) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            task.ansi_permission = YES;
            UMTCAP_ansi_asn1_queryWithPerm *r = [[UMTCAP_ansi_asn1_queryWithPerm alloc]initWithASN1Object:self context:context];
            [task handleAnsiTransactionId:r.identifier.tid];
            return r;
        }
        else if(    (tNumber == TCAP_TAG_ANSI_QUERY_WITHOUT_PERM) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            task.ansi_permission = NO;
            UMTCAP_ansi_asn1_queryWithoutPerm *r = [[UMTCAP_ansi_asn1_queryWithoutPerm alloc]initWithASN1Object:self context:context];
            [task handleAnsiTransactionId:r.identifier.tid];
            return r;
        }
        else if(    (tNumber == TCAP_TAG_ANSI_RESPONSE) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            UMTCAP_ansi_asn1_response *r = [[UMTCAP_ansi_asn1_response alloc]initWithASN1Object:self context:context];
            [task handleAnsiTransactionId:r.identifier.tid];
            return r;
        }
        else if(    (tNumber == TCAP_TAG_ANSI_CONVERSATION_WITH_PERM) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            task.ansi_permission = YES;
            UMTCAP_ansi_asn1_conversationWithPerm *r =  [[UMTCAP_ansi_asn1_conversationWithPerm alloc]initWithASN1Object:self context:context];
            [task handleAnsiTransactionId:r.identifier.tid];
            return r;

        }
        else if(    (tNumber == TCAP_TAG_ANSI_CONVERSATION_WITHOUT_PERM) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            task.ansi_permission = NO;
            UMTCAP_ansi_asn1_conversationWithoutPerm *r = [[UMTCAP_ansi_asn1_conversationWithoutPerm alloc]initWithASN1Object:self context:context];
            [task handleAnsiTransactionId:r.identifier.tid];
            return r;

        }
        else if(    (tNumber == TCAP_TAG_ANSI_ABORT) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            UMTCAP_ansi_asn1_abort *r= [[UMTCAP_ansi_asn1_abort alloc]initWithASN1Object:self context:context];
            [task handleAnsiTransactionId:r.identifier.tid];
            return r;

        }
    }
    else if(_asn1_tag.tagClass == UMASN1Class_Application)
    {
        task.tcapVariant = TCAP_VARIANT_ITU;

        UMTCAP_Command tNumber = (int)_asn1_tag.tagNumber + 0; /* the internal definition maps ITU command to tag number */
        /* all the ITU STUFF */
        if((tNumber == TCAP_TAG_ITU_UNIDIRECTIONAL) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            UMTCAP_itu_asn1_unidirectional *r = [[UMTCAP_itu_asn1_unidirectional alloc]initWithASN1Object:self context:context];
            return r;
        }
        else if((tNumber == TCAP_TAG_ITU_BEGIN) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;

            UMTCAP_itu_asn1_begin *r = [[UMTCAP_itu_asn1_begin alloc]initWithASN1Object:self context:context];
            [task handleLocalTransactionId:NULL];
            [task handleRemoteTransactionId:r.otid.transactionId];
            [task handleItuDialogue:r.dialoguePortion];
            return r;
        }
        else if((tNumber == TCAP_TAG_ITU_END) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            UMTCAP_itu_asn1_end *r = [[UMTCAP_itu_asn1_end alloc]initWithASN1Object:self context:context];
            [task handleLocalTransactionId:r.dtid.transactionId];
            [task handleRemoteTransactionId:NULL];
            return r;
        }
        else if((tNumber == TCAP_TAG_ITU_CONTINUE) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            UMTCAP_itu_asn1_continue *r = [[UMTCAP_itu_asn1_continue alloc]initWithASN1Object:self context:context];
            [task handleLocalTransactionId:r.dtid.transactionId];
            [task handleRemoteTransactionId:r.otid.transactionId];
            return r;

        }
        else if((tNumber == TCAP_TAG_ITU_ABORT) && (_asn1_tag.isConstructed))
        {
            task.currentCommand = tNumber;
            UMTCAP_itu_asn1_abort *r = [[UMTCAP_itu_asn1_abort alloc]initWithASN1Object:self context:context];
            [task handleLocalTransactionId:r.dtid.transactionId];
            [task handleRemoteTransactionId:NULL];
            return r;
        }
    }
    return self;
}

- (NSString *)objectName
{
    if(_asn1_tag.tagClass ==UMASN1Class_Private)
    {
        return @"ansi_tcap";
    }
    return @"tcap";
}

@end

