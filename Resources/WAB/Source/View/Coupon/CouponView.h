//
//  CouponView.h
//  Walmart
//
//  Created by Renan Cargnin on 03/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"

IB_DESIGNABLE
@interface CouponView : WMView

@property (weak, nonatomic) NSString *redemptionCode;

@property (copy, nonatomic) void (^removeBlock)(NSString *redemptionCode);

@end
