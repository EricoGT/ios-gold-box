//
//  DeliveryOptions.h
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryType.h"
@class DeliveryItemView;
@class NewShipmentCard;

@interface DeliveryOptions : UIView

@property (nonatomic, strong) NewShipmentCard *card;

+ (UIView *)viewWithXibName:(NSString *)xibName;
- (void)setupWithDeliveryTypes:(NSArray *)deliveryTypes;

- (void)deselectAllOptions;
- (void)showOptionsForDeliveryItemView:(DeliveryItemView *)item;
- (void)resetScheduleDate;

@end
