//
//  WMAlertView.m
//  Walmart
//
//  Created by Renan Cargnin on 12/30/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMAlertView.h"

#import "WMButton.h"

@interface WMAlertView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertLeadingConstraint;

@end

@implementation WMAlertView

- (WMAlertView *)initWithImageName:(NSString *)imageName title:(NSString *)title dismissButtonText:(NSString *)dismissButtonText dismissBlock:(void (^)())dismissBlock {
    self = [super init];
    if (self)
    {
        [self setImageWithImageName:imageName];
        [self setTitle:title];
        
        [_dismissButton setTitle:dismissButtonText forState:UIControlStateNormal];
        _dismissBlock = dismissBlock;
        [self setupConstraints];
    }
    return self;
}

- (WMAlertView *)initWithImageName:(NSString *)imageName title:(NSString *)title message:(NSString *)message dismissButtonText:(NSString *)dismissButtonText dismissBlock:(void (^)())dismissBlock {
    self = [self initWithImageName:imageName title:title dismissButtonText:dismissButtonText dismissBlock:dismissBlock];
    if (self) {
        [self setMessage:message];
    }
    return self;
}

- (WMAlertView *)initWithImageName:(NSString *)imageName title:(NSString *)title attributedMessage:(NSAttributedString *)attributedMessage dismissButtonText:(NSString *)dismissButtonText dismissBlock:(void (^)())dismissBlock {
    self = [self initWithImageName:imageName title:title dismissButtonText:dismissButtonText dismissBlock:dismissBlock];
    if (self) {
        [self setAttributedMessage:attributedMessage];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    _titleLabelTopSpaceConstraint.constant = title.length > 0 ? 15.0f : 0.0f;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    
    _imageWidthConstraint.constant = image ? image.size.width : 0.0f;
    _imageHeightConstraint.constant = image ? image.size.height : 0.0f;
    _imageTopSpaceConstraint.constant = image ? 15.0f : 0.0f;
}

- (void)setImageWithImageName:(NSString *)imageName {
    [self setImage:imageName.length > 0 ? [UIImage imageNamed:imageName] : nil];
}

- (void)setMessage:(NSString *)message {
    _messageLabel.text = message;
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage {
    _messageLabel.attributedText = attributedMessage;
}

- (IBAction)pressedDismiss:(id)sender {
    [self removeFromSuperview];
    if (_dismissBlock) _dismissBlock();
}

- (void)setupConstraints
{
    if (IS_IPHONE_6)
    {
        _alertTrailingConstraint.constant = 30;
        _alertLeadingConstraint.constant = 30;
    }
    else if (IS_IPHONE_6P)
    {
        _alertTrailingConstraint.constant = 68;
        _alertLeadingConstraint.constant = 68;
    }
    
    [self layoutIfNeeded];
}

@end
