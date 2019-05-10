//
//  OFFreightItemView.h
//  Walmart
//
//  Created by Bruno Delgado on 8/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFFreightItemView : UIView

- (void)setupWithDeliveryType:(DeliveryType *)deliveryType;
+ (UIView *)viewWithXibName:(NSString *)xibName;

@end
