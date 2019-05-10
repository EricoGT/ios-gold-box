//
//  CouponSubmitView.h
//  Walmart
//
//  Created by Renan Cargnin on 29/09/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"

IB_DESIGNABLE
@interface CouponSubmitView : WMView

@property (copy, nonatomic) void (^submitBlock)(NSString *redemptionCode);

@property (weak, nonatomic) NSString *redemptionCode;
@property (weak, nonatomic) NSString *warningMessage;

@end
