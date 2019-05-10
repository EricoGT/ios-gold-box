//
//  OFFreightBlock.h
//  Walmart
//
//  Created by Bruno Delgado on 8/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryType.h"

@interface OFFreightBlock : UIView

- (void)setupWithFreightOptionsArray:(NSArray<DeliveryType>*)deliveryTypes seller:(NSString *)seller;
+ (UIView *)viewWithXibName:(NSString *)xibName;

@end
