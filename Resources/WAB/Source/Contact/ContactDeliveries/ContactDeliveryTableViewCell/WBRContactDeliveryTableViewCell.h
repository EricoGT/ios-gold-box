//
//  WBRContactDeliveryTableViewCell.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRContactRequestDeliveryModel.h"

@interface WBRContactDeliveryTableViewCell : UITableViewCell

+ (NSString *)reusableIdentifier;

- (void)setupCellWithDelivery:(WBRContactRequestDeliveryModel *)delivery andDeliveryNumber:(NSInteger)deliveryNumber;

@end
