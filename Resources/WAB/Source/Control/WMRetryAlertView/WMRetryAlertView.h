//
//  WMRetryAlertView.h
//  Walmart
//
//  Created by Renan Cargnin on 12/17/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMRetryAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (copy, nonatomic) void (^retryBlock)();
@property (copy, nonatomic) void (^cancelBlock)();

- (WMRetryAlertView *)initWithTitle:(NSString *)title message:(NSString *)message retryBlock:(void (^)())retryBlock;
- (WMRetryAlertView *)initWithTitle:(NSString *)title message:(NSString *)message retryBlock:(void (^)())retryBlock cancelBlock:(void (^)())cancelBlock;

@end
