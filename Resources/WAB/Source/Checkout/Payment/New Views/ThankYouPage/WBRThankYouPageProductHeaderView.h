//
//  WBRThankYouPageProductHeaderView.h
//  Walmart
//
//  Created by Rafael Valim on 22/09/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShippingDelivery.h"

@class WBRThankYouPageProductHeaderView;

@protocol WBRThankYouPageProductHeaderViewProtocol <NSObject>

- (void)WBRThankYouPageProductHeaderView:(WBRThankYouPageProductHeaderView *)thankYouPageProductHeader didChooseSeller:(ShippingDelivery *)shippingDelivery;

@end

@interface WBRThankYouPageProductHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) id <WBRThankYouPageProductHeaderViewProtocol> delegate;

@property (weak, nonatomic) IBOutlet UILabel *deliverSequenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryEstimateLabel;

+ (NSString *)reuseIdentifier;

- (void)setShippingDelivery:(ShippingDelivery *)shippingDelivery
                  onSection:(NSInteger)section
                    ofTotal:(NSInteger)sections
           withDeliveryInfo:(NSDictionary *)deliveryInformation;

@end
