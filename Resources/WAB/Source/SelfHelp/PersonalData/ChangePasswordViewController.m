//
//  ChangePwdViewController.m
//  Walmart
//
//  Created by Renan on 4/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "WMButtonRounded.h"
#import "WMFloatLabelMaskedTextField.h"
#import "FeedbackAlertView.h"
#import "PersonalDataViewController.h"
#import "WALTouchIDManager.h"
#import "WMPwdStrengthView.h"

#import "WBRUserManager.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UITapGestureRecognizer *singleFingerTap;

@property (nonatomic, strong) NSString *alertMsg;

@end

@implementation ChangePasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.scrollView addGestureRecognizer:_singleFingerTap];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (_singleFingerTap) {
        [self.scrollView removeGestureRecognizer:_singleFingerTap];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Alterar Senha";
}

- (IBAction)saveChangesPressed:(id)sender {
    //Remove keyboard
    [self.view endEditing:YES];
    
    //Clean alerts
    self.txtCurrentPass.layer.borderColor = [self.txtCurrentPass defaultBorderColor];
    self.txtNewPass.layer.borderColor = [self.txtNewPass defaultBorderColor];
    self.txtNewPassConfirmation.layer.borderColor = [self.txtNewPassConfirmation defaultBorderColor];
    
    NSArray *invalidFields = [self validateAndGetInvalidFields];
    if (invalidFields.count == 0) {
        [self updatePassword];
    }
    else {
        [self.view showFeedbackAlertOfKind:WarningAlert message:_alertMsg];
        
        for (UIView *view in invalidFields) {
            view.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        }
    }
}

- (NSArray *)validateAndGetInvalidFields {
    self.alertMsg = nil;
    NSMutableArray *invalidFields = [NSMutableArray new];
    
    if (self.txtCurrentPass.text.length == 0) {
        if (!self.alertMsg) self.alertMsg = CHANGE_PASSWORD_WARNING_CURRENT_PASS;
        [invalidFields addObject:self.txtCurrentPass];
    }
    
    if (self.txtNewPass.text.length == 0) {
        if (!self.alertMsg) self.alertMsg = CHANGE_PASSWORD_WARNING_NEW_PASS;
        [invalidFields addObject:self.txtNewPass];
    }
    else if (self.txtNewPass.text.length < 8) {
        if (!self.alertMsg) self.alertMsg = CHANGE_PASSWORD_WARNING_MIN_LENGTH;
        [invalidFields addObject:self.txtNewPass];
    }
    
    if (self.txtNewPassConfirmation.text.length == 0) {
        if (!self.alertMsg) self.alertMsg = CHANGE_PASSWORD_WARNING_CONFIRM_PASS;
        [invalidFields addObject:self.txtNewPassConfirmation];
    }
    else if (![self.txtNewPass.text isEqualToString:self.txtNewPassConfirmation.text]) {
        if (!self.alertMsg) self.alertMsg = CHANGE_PASSWORD_WARNING_DISTINCT_PASS;
        [invalidFields addObject:self.txtNewPass];
        [invalidFields addObject:self.txtNewPassConfirmation];
    }
    
    return invalidFields.copy;
}

- (void)updatePassword
{
    [self.navigationController.view showModalLoading];
    
    [WBRUserManager changeUserPasswordWithNewPassword:self.txtNewPass.text oldPassword:self.txtCurrentPass.text successBlock:^{
        [WALTouchIDManager updatePassword:self.txtNewPass.text];
        
        [self.navigationController.view hideModalLoading];
        [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:CHANGE_PASSWORD_SUCCESS];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        if (error.code == 401 || error.code == -1012) {
            [self presentLoginWithCompletionBlock:^{
                [self.navigationController.view hideModalLoading];
            } successBlock:^{
                [self updatePassword];
            } dismissBlock:^{
                [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
            }];
        }
        else {
            [self.navigationController.view hideModalLoading];
            [self.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
        }
    }];
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.scrollView.contentInset = contentInset;
}

#pragma mark - Gesture Notification
- (void)handleSingleTap:(UITapGestureRecognizer *)recognize {
    [self.view endEditing:YES];
}

@end
