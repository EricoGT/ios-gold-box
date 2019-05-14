//
//  WBRContactDeliveryViewController.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRContactRequestDeliveryModel.h"

@protocol WBRContactDeliveryViewControllerDelegate <NSObject>
- (void)contactDeliveryDidSelect:(WBRContactRequestDeliveryModel *)delivery;
@end

@interface WBRContactDeliveryViewController : WMBaseViewController

@property (weak, nonatomic) id<WBRContactDeliveryViewControllerDelegate> delegate;

- (instancetype)initWithDeliveries:(NSArray *)deliveries;

@end
