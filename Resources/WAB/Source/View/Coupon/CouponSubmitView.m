//
//  CouponSubmitView.m
//  Walmart
//
//  Created by Renan Cargnin on 29/09/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "CouponSubmitView.h"

@interface CouponSubmitView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *redempetionCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *warningLabelTopSpaceConstraint;

@end

@implementation CouponSubmitView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCouponSubmitView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCouponSubmitView];
    }
    return self;
}

- (NSString *)redemptionCode {
    return _redempetionCodeTextField.text;
}

- (void)setRedemptionCode:(NSString *)redemptionCode {
    _redempetionCodeTextField.text = redemptionCode;
}

- (void)setupCouponSubmitView {
    _redempetionCodeTextField.delegate = self;
    self.warningMessage = @"";
}

- (NSString *)warningMessage {
    return _warningLabel.text;
}

- (void)setWarningMessage:(NSString *)warningMessage {
    _warningLabel.text = warningMessage;
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.25f animations:^{
        self->_warningLabelTopSpaceConstraint.constant = warningMessage.length == 0 ? 0.0f : 15.0f;
        [self layoutIfNeeded];
    }];
}

- (void)submit {
    if ([_redempetionCodeTextField canResignFirstResponder]) {
        [_redempetionCodeTextField resignFirstResponder];
    }
    
    if (_submitBlock) _submitBlock([self redemptionCode]);
}

- (IBAction)pressedSubmit:(id)sender {
    [self submit];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self submit];
    return YES;
}

@end
