//
//  WMPopupView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/8/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@interface WMPopupView : WMView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet WMButton *cancelButton;
@property (weak, nonatomic) IBOutlet WMButton *actionButton;

@property (nonatomic, copy) void (^actionBlock)();
@property (nonatomic, copy) void (^cancelBlock)();

- (WMPopupView *)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(void (^)())cancelBlock actionButtonTitle:(NSString *)actionButtonTitle actionBlock:(void (^)())actionBlock;

- (void)setTitle:(NSString *)title;
- (void)setMessage:(NSString *)message;
- (void)setActionButtonTitle:(NSString *)actionButtonTitle;
- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle;

@end
