//
//  ResetPasswordView.m
//  Walmart
//
//  Created by Renan Cargnin on 3/3/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ResetPasswordView.h"

#import "NSString+Validation.h"
#import "WMFloatLabelMaskedTextField.h"
#import "WMButtonRounded.h"
#import "WBRLoginManager.h"

@interface ResetPasswordView ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet WMButtonRounded *sendButton;
@property (weak, nonatomic) IBOutlet WMButtonRounded *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertLeadingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterYConstraint;
@property (nonatomic, copy) void (^successBlock)(NSString *maskedEmail);

@end

@implementation ResetPasswordView

- (ResetPasswordView *)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _containerView.layer.cornerRadius = 4.0f;
    _containerView.layer.masksToBounds = YES;
    
    _textFieldContainerView.layer.cornerRadius = 4.0f;
    _textFieldContainerView.layer.masksToBounds = YES;
    _textFieldContainerView.layer.borderColor = RGBA(221, 221, 221, 1).CGColor;
    _textFieldContainerView.layer.borderWidth = 1.0f;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tapGesture];
    
    [self setupConstraints];
}

- (void)setRecoverPasswordSuccessBlock:(void (^)(NSString *))successBlock
{
    self.successBlock = successBlock;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self layoutIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [_emailTextField becomeFirstResponder];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Connection
- (void)prepareForRecoverPasswordRequest {
    [_sendButton setEnabled:NO];
    [_activityIndicator startAnimating];
    [_emailTextField resignFirstResponder];
}

- (void)resetPasswordWithEmail:(NSString *)email {
    [self prepareForRecoverPasswordRequest];
    
    [WBRLoginManager resetPasswordWithEmail:email success:^(NSString *maskedEmail) {
        [self resetPasswordSuccessWithMaskedEmail:maskedEmail];
    } failure:^(NSError *error) {
        [self resetPasswordError:error];
    }];
}

- (void)resetPasswordWithDocument:(NSString *)document {
    [self prepareForRecoverPasswordRequest];

    [WBRLoginManager resetPasswordWithDocument:document success:^(NSString *maskedEmail) {
        [self resetPasswordSuccessWithMaskedEmail:maskedEmail];
    } failure:^(NSError *error) {
        [self resetPasswordError:error];
    }];
}

- (void)resetPasswordSuccessWithMaskedEmail:(NSString *)maskedEmail {
    [_sendButton setEnabled:YES];
    [_activityIndicator stopAnimating];
    
    if (_successBlock) _successBlock(maskedEmail);
    [self removeFromSuperview];
}

- (void)resetPasswordError:(NSError *)error {
    [_sendButton setEnabled:YES];
    [_activityIndicator stopAnimating];
    [self showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
}

#pragma mark - UIGestureRecognizer
- (void)handleTap {
    [_emailTextField resignFirstResponder];
}

#pragma mark - IBAction
- (IBAction)pressedCancelButton {
    [self removeFromSuperview];
}

- (IBAction)pressedSendButton {
    [_emailTextField resignFirstResponder];
    
    NSString *userInfoString = _emailTextField.text;
    
    if (userInfoString.length == 0) {
        [self showFeedbackAlertOfKind:WarningAlert message:RESET_PASSWORD_EMPTY];
    }
    else if ([userInfoString isEmail]) {
        [self resetPasswordWithEmail:userInfoString];
    }
    else if ([userInfoString isCPF] || [userInfoString isCNPJ]) {
        [self resetPasswordWithDocument:userInfoString];
    }
    else {
        [self showFeedbackAlertOfKind:WarningAlert message:LOGIN_INVALID_DATA];
    }
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

#pragma mark - Keyboard
- (void)keyboardWillHide:(NSNotification *)notification {
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.25f animations:^{
        self->_containerViewCenterYConstraint.constant = 0.0f;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.25f animations:^{
        self->_containerViewCenterYConstraint.constant = keyboardHeight / (-2);
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}

@end
