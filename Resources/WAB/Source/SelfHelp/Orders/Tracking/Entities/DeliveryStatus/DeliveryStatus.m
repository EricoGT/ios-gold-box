//
//  DeliveryStatus.m
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "DeliveryStatus.h"

@implementation DeliveryStatus

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"statusDescription" : @"description"}];
}

+ (UIImage *)imageForStatus:(NSString *)statusDescription
{
    UIImage *image = nil;
    
    if ([statusDescription isEqualToString:statusTypeWaitingPayment]) image =   [UIImage imageNamed:@"UICurrentstatus_aap"];
    if ([statusDescription isEqualToString:statusTypeProcessing]) image =       [UIImage imageNamed:@"ic_status_tramp"];
    if ([statusDescription isEqualToString:statusTypeFinished]) image =         [UIImage imageNamed:@"UICurrentstatus_ent"];
    if ([statusDescription isEqualToString:statusTypeCanceled]) image =         [UIImage imageNamed:@"ic_status_ARG"];
    if ([statusDescription isEqualToString:statusTypeDeclinedPayment]) image =  [UIImage imageNamed:@"UICurrentstatus_rev"];
    
    return image;
}

@end
