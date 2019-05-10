//
//  WMAlertView.h
//  Walmart
//
//  Created by Renan Cargnin on 12/30/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMPinnedView.h"

@interface WMAlertView : WMPinnedView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet WMButton *dismissButton;

@property (nonatomic, copy) void (^dismissBlock)();

- (WMAlertView *)initWithImageName:(NSString *)imageName title:(NSString *)title message:(NSString *)message dismissButtonText:(NSString *)dismissButtonText dismissBlock:(void (^)())dismissBlock;
- (WMAlertView *)initWithImageName:(NSString *)imageName title:(NSString *)title attributedMessage:(NSAttributedString *)attributedMessage dismissButtonText:(NSString *)dismissButtonText dismissBlock:(void (^)())dismissBlock;

- (void)setImage:(UIImage *)image;
- (void)setImageWithImageName:(NSString *)imageName;

- (void)setMessage:(NSString *)message;
- (void)setAttributedMessage:(NSAttributedString *)attributedMessage;

@end
