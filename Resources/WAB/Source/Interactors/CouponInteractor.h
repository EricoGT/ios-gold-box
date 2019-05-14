//
//  CouponInteractor.h
//  Walmart
//
//  Created by Renan Cargnin on 07/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponInteractor : NSObject

+ (NSString *)maskedRedemptionCodeWithRedemptionCode:(NSString *)redemptionCode;
+ (NSString *)warningMessageForRemovedCoupons:(NSArray *)removedCoupons;

@end
