//
//  DeliveryItemView.h
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryOptions.h"
#import "DeliveryType.h"

@interface DeliveryItemView : UIView

@property (nonatomic, strong) DeliveryOptions *optionsBlock;
@property (nonatomic, strong) DeliveryType *currentDeliveryType;

+ (UIView *)viewWithXibName:(NSString *)xibName;
- (void)setupWithDeliveryType:(DeliveryType *)deliveryType;

- (void)selectItem;
- (void)deselectItem;
- (void)updateScheduledDeliverSelectedDate:(NSString *)date period:(NSString *)period;
- (void)resetSchedule;

@end
