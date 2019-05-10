//
//  UnavailableProductView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/26/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductUnavailableView.h"

#import "WBRProductManager.h"

@interface ProductUnavailableView ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property BOOL isMailError;
@property BOOL isNameError;

@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *nameView;

@end

@implementation ProductUnavailableView

- (ProductUnavailableView *)initWithSKU:(NSNumber *)sku delegate:(id<ProductUnavailableViewDelegate>)delegate {
    if (self = [super init]) {
        _sku = sku;
        _delegate = delegate;
        
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _nameTextField.superview.layer.borderColor = _emailTextField.superview.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    _nameTextField.superview.layer.borderWidth = _emailTextField.superview.layer.borderWidth = 0.5f;
    _nameTextField.superview.layer.cornerRadius = _emailTextField.superview.layer.cornerRadius = 3;
    _nameTextField.superview.clipsToBounds = _emailTextField.superview.clipsToBounds = YES;
    _nameTextField.superview.layer.masksToBounds = _emailTextField.layer.masksToBounds = YES;
    
    self.emailView.layer.borderColor = UIColor.clearColor.CGColor;
    self.nameView.layer.borderColor = UIColor.clearColor.CGColor;
}

- (BOOL)isFormValid {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (self.nameTextField.text.length == 0 && self.emailTextField.text.length ==0){
        self.isMailError = YES;
        self.isNameError = YES;
        
        return NO;
    }
    else if (self.nameTextField.text.length == 0) {
        
        self.isNameError = YES;
        self.isMailError = NO;
        
        return NO;
    }
    else if (self.emailTextField.text.length == 0 || ![emailTest evaluateWithObject:self.emailTextField.text]) {

        self.isNameError = NO;
        self.isMailError = YES;
        
        return NO;
    }
    else {
        
        self.isNameError = NO;
        self.isMailError = NO;
        
        return YES;
    }
}

- (void)sendNotify {
    
    NSString *name = self.nameTextField.text ?: @"";
    NSString *email = self.emailTextField.text ?: @"";
    NSString *sku = self.sku.stringValue ?: @"";
    
    [WBRProductManager notifyUser:name withEmail:email forProductSku:sku successBlock:nil];
    
    [self endEditing:YES];
}

- (IBAction)pressedSend {
    [self endEditing:YES];
    
    if ([self isFormValid]) {
        if (_delegate && [_delegate respondsToSelector:@selector(productUnavailablePressedSendWithInvalidFields:andMessageType:)]){
            [self.delegate productUnavailablePressedSendWithInvalidFields:UNAVAILABLE_SAVE_SUCCESS andMessageType:SuccessAlert];
        }
        
        [self sendNotify];
    }
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(productUnavailablePressedSendWithInvalidFields:andMessageType:)]) {
            if(self.isNameError && self.isMailError) {
                self.nameTextField.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
                self.emailTextField.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
                [self.delegate productUnavailablePressedSendWithInvalidFields:EMPTY_EMAIL_AND_NAME_NOTIFY andMessageType:WarningAlert];
            }
            else if (_isNameError) {
                self.nameTextField.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
                [self.delegate productUnavailablePressedSendWithInvalidFields:EMPTY_NAME andMessageType:WarningAlert];
            }
            else if (_isMailError) {
                self.emailTextField.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
                [self.delegate productUnavailablePressedSendWithInvalidFields:CHANGE_EMAIL_WARNING_INVALID andMessageType:WarningAlert];
            }

        }
    }
}

@end
