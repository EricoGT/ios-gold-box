//
//  ShippingDeliveryCell.h
//  Walmart
//
//  Created by Renan on 5/2/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeliveryType;

@interface ShippingDeliveryCell : UITableViewCell

- (void)setupWithDeliveryType:(DeliveryType *)deliveryType;

@end
