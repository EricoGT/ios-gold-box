//
//  DeleteAddressAlert.h
//  Walmart
//
//  Created by Renan on 5/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@interface DeletePopupView : WMView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, copy) void (^cancelBlock)();
@property (nonatomic, copy) void (^deleteBlock)();

- (DeletePopupView *)initWithTitle:(NSString *)title message:(NSString *)message cancelBlock:(void (^)())cancelBlock deleteBlock:(void (^)())deleteBlock;

- (void)setTitle:(NSString *)title;
- (void)setMessage:(NSString *)message;

@end
