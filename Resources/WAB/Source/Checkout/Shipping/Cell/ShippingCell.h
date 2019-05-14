//
//  ShippingCell.h
//  Walmart
//
//  Created by Renan on 5/2/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScheduleDeliveryDateViewController.h"

@class ShippingDelivery, ShippingCell;

@protocol ShippingCellDelegate <NSObject>
@optional
- (void)shippingCellTappedSellerLabel:(ShippingCell *)shippingCell;
- (void)shippingCellPressedScheduledDeliveryButton:(ShippingCell *)shippingCell;
- (void)shippingCellPressedDeleteDeliveryButton:(ShippingCell *)shippingCell;
@end

@interface ShippingCell : UITableViewCell <ScheduleDeliveryDateViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *deliveryIndexLabel;

@property (weak, nonatomic) id <ShippingCellDelegate> delegate;
@property (strong, nonatomic) ShippingDelivery *shippingDelivery;

+ (NSString *)reuseIdentifier;

- (void)setDeliveryIndex:(NSInteger)index total:(NSInteger)total;

@end
