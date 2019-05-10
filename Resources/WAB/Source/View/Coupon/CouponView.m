//
//  CouponView.m
//  Walmart
//
//  Created by Renan Cargnin on 03/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "CouponView.h"

#import "CouponInteractor.h"

@interface CouponView ()

@property (weak, nonatomic) IBOutlet UILabel *redemptionCodeLabel;

@end

@implementation CouponView

- (void)setRedemptionCode:(NSString *)redemptionCode {
    _redemptionCode = redemptionCode;
    _redemptionCodeLabel.text = [CouponInteractor maskedRedemptionCodeWithRedemptionCode:redemptionCode];
}

- (IBAction)pressedRemove:(id)sender {
    if (_removeBlock) _removeBlock(_redemptionCode);
}

@end
