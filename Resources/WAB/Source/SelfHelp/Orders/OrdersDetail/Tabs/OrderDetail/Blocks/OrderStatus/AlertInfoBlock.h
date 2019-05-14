//
//  AlertInfoBlock.h
//  Walmart
//
//  Created by Bruno Delgado on 10/20/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingViewWithXib.h"

typedef NS_ENUM(NSUInteger, TrackingAlertType)
{
    TrackingAlertTypeNormal = 0,
    TrackingAlertTypePayment = 1,
    TrackingAlertTypeBoleto = 2
};

@class WMButton;

@interface AlertInfoBlock : TrackingViewWithXib

@property (nonatomic, weak) IBOutlet WMButton *actionButton;

- (void)updateWithMessage:(NSString *)message alertType:(TrackingAlertType)type;

@end
