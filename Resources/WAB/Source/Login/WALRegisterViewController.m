//
//  OFSimpleRegister.m
//  Ofertas
//
//  Created by Marcelo Santos on 12/11/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "WALRegisterViewController.h"
#import "WMBaseNavigationController.h"
#import "WMWebViewController.h"
#import "UITapGestureRecognizer+DetectTap.h"
#import "WBRLoginManager.h"
#import "NSString+Validation.h"
#import "UITextField+MaskValidation.h"
#import "WMFloatLabelMaskedTextField.h"
#import "WMPwdStrengthView.h"
#import "FeedbackColor.h"
#import "WMButtonRounded.h"
#import "WMBFaceHeaderViewController.h"
#import "WMBFaceInfoViewController.h"
#import "WMBFaceLinkViewController.h"
#import "WBRFacebookLoginManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface WALRegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (strong, nonatomic) IBOutletCollection(WMFloatLabelMaskedTextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *nameTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *documentTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *mobilePhoneTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *emailTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *passTextField;

@property (weak, nonatomic) IBOutlet WMPwdStrengthView *pwdStrengthView;

@property (weak, nonatomic) IBOutlet WMButtonRounded *registerButton;
@property (weak, nonatomic) IBOutlet WMButtonRounded *faceButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property (weak, nonatomic) IBOutlet UILabel *termsLabel;

@property (weak, nonatomic) IBOutlet UIView *viewFaceHeader;
@property (weak, nonatomic) IBOutlet UIView *viewFaceInfo;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewInScrollHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightFaceHeaderConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *posYNameTextFieldConstraint;

@property (nonatomic, weak) IBOutlet UIImageView *imgFaceMail;

@property (nonatomic, strong) UIImageView *screenCacheImageView;
@property (nonatomic, strong) UIImageView *imgLogo;

- (IBAction)loginFaceButtonClicked:(id)sender;

@end

@implementation WALRegisterViewController

- (WALRegisterViewController *)initWithDelegate:(id <WALRegisterViewControllerDelegate>)delegate
{
    self = [super initWithTitle:@"Cadastrar" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if(_screenCacheImageView != nil) {
        
        _imgLogo = nil;
        
        [_screenCacheImageView removeFromSuperview];
        _screenCacheImageView = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WMOmniture trackRegisterPage];
    
    //Background Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEnteredBackgroundRegister:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleActiveRegister:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    if (_isFacebook) {
        [self addHeaderFacebook];
    }
    
    [FlurryWM logEvent_signup_entering];
    [FlurryWM logEvent_signup_completeAccountEntering];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_contentScrollView addGestureRecognizer:singleTap];
    
    _documentTextField.delegate = self;
    
    _phoneTextField.mask = @"(##) ####-####";
    _phoneTextField.delegate = self;
    
    _mobilePhoneTextField.mask = @"(##) #####-####";
    _mobilePhoneTextField.delegate = self;
    
    [_faceButton setIconImage:[UIImage imageNamed:@"ic_facebook_button"]];
    
    NSString *useTermsString = REGISTER_TERMS_TEXT;
    NSString *privacyTermsString = REGISTER_PRIVACY_TEXT;
    NSString *fullMessage = [NSString stringWithFormat:REGISTER_TERMS_MESSAGE, useTermsString, privacyTermsString];
    
    NSRange fullRange = NSMakeRange(0, fullMessage.length);
    NSRange termsRange = [fullMessage rangeOfString:useTermsString];
    NSRange policyRange = [fullMessage rangeOfString:privacyTermsString];
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:fullMessage];
    [message addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:fullRange];
    [message addAttribute:NSForegroundColorAttributeName value:RGBA(33, 150, 243, 1) range:termsRange];
    [message addAttribute:NSForegroundColorAttributeName value:RGBA(33, 150, 243, 1) range:policyRange];
    
    _nameTextField.tag = 1;
    _emailTextField.tag = 2;
    _documentTextField.tag = 3;
    _phoneTextField.tag = 4;
    _mobilePhoneTextField.tag = 5;
    _passTextField.tag = 6;
    
    _termsLabel.attributedText = message.copy;
    _termsLabel.userInteractionEnabled = YES;
    [_termsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnTermsLabel:)]];
}

- (void) addHeaderFacebook {
    
    _heightFaceHeaderConstraint.constant = 110;
    _posYNameTextFieldConstraint.constant = 215;
    
    UIImageView *imgFace=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    imgFace.image = [UIImage imageNamed:@"ic_facebook_email"];
    [imgFace setContentMode:UIViewContentModeCenter];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 24)];
    [paddingView addSubview:imgFace];
    _emailTextField.rightView = paddingView;
    _emailTextField.rightViewMode = UITextFieldViewModeAlways;
    
    [_emailTextField setEnabled:NO];
    
    WMBFaceHeaderViewController *wmh = [[WMBFaceHeaderViewController alloc] initWithNibName:@"WMBFaceHeaderViewController" bundle:nil];
    
    [WBRFacebookLoginManager getFacebookUserInformationsWithSuccess:^(FaceUser *facebookUser, NSHTTPURLResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [wmh setContent:facebookUser];
            
            //Content texfields
            self->_nameTextField.text = facebookUser.name;
            self->_emailTextField.text = facebookUser.email;
        });
    } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
        LogErro(@"[FACEBOOK] Error: %@", [error description]);
    }];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    result = CGSizeMake(result.width , result.height);
    
    float widthScreen = result.width;
    
    [_viewFaceHeader setNeedsLayout];
    [_viewFaceHeader layoutIfNeeded];
    
    _viewFaceHeader.frame = CGRectMake(0, 0, widthScreen, 110);
    
    [_viewFaceHeader addSubview:wmh.view];
    
    
    
    //Add Info below Face Panel
    
    [_viewFaceInfo setNeedsLayout];
    [_viewFaceInfo layoutIfNeeded];
    
    _viewFaceInfo.frame = CGRectMake(0, 0, widthScreen, 80);
    
    WMBFaceInfoViewController *wmi = [[WMBFaceInfoViewController alloc] initWithNibName:@"WMBFaceInfoViewController" bundle:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [wmi setLabelContent:@"Preencha os campos abaixo para criar uma nova conta no Walmart.com com seu email do Facebook."];
    });
    
    [_viewFaceInfo addSubview:wmi.view];
     
    //hidden facebook button
    _faceButton.hidden = YES;
    
    
    //Changing textfield name position Y
    [_nameTextField setNeedsLayout];
    [_nameTextField layoutIfNeeded];
    
    _nameTextField.frame = CGRectMake(0, 0, widthScreen, 110);
    
    _viewFaceHeader.alpha = 1;
    _viewFaceHeader.hidden = NO;
    
    _viewFaceInfo.alpha = 1;
    _viewFaceInfo.hidden = NO;
}

- (IBAction)loginFaceButtonClicked:(id)sender {
    
    [self.navigationController.view showModalLoading];
    
    [WBRFacebookLoginManager loginWithFacebookSuccess:^(FaceUser *facebookUser, NSHTTPURLResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_faceButton setTitle:FACEBOOK_MSG_LOGIN forState:UIControlStateNormal];
            [self.navigationController.view hideModalLoading];
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        });

    } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_faceButton setTitle:FACEBOOK_MSG_LOGIN forState:UIControlStateNormal];
            if (error.code == 400) {
                NSDictionary *dictHeader = failResponse.allHeaderFields;
                
                if ([dictHeader objectForKey:@"snId"]) {
                    
                    WMBFaceLinkViewController *wml = [[WMBFaceLinkViewController alloc] initWithNibName:@"WMBFaceLinkViewController" bundle:nil];
                    wml.strSnId = [dictHeader objectForKey:@"snId"];
                    wml.isFacebookWithLink = YES;
                    [self.navigationController pushViewController:wml animated:YES];
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LogInfo(@"[FACE] No snId");
                        
                        [self.navigationController.view hideModalLoading];
                        [self.view showAlertWithMessage:FACEBOOK_MSG_ERROR_NO_TOKEN];
                    });
                }
            } else {
                if (error.description) {
                    [self.navigationController.view showAlertWithMessage:FACEBOOK_MSG_ERROR_UNKNOW];
                }
            }
            [self.navigationController.view hideModalLoading];
        });

    }];
}

- (void) showAlertErrorWithMessage:(NSString *) msgError {
    [self.navigationController.view hideModalLoading];
    [self.view showFeedbackAlertOfKind:ErrorAlert message:msgError];
}

#pragma mark - Validation
- (IBAction)registerPressed
{
    [self hideKeyboard];
    
    for (WMFloatLabelMaskedTextField *textField in _textFields) {
        [textField removeError];
    }
    
    NSMutableArray *warningFields = [NSMutableArray new];
    
    NSString *errorMessage;

    if (_nameTextField.text.length == 0) {
        errorMessage = errorMessage ?: EMPTY_COMPLETE_NAME;
        [warningFields addObject:_nameTextField];
    }
    else if (![_nameTextField.text isName]) {
        errorMessage = errorMessage ?: INVALID_NAME;
        [warningFields addObject:_nameTextField];
    }
    if (_emailTextField.text.length == 0) {
        errorMessage = errorMessage ?: EMPTY_EMAIL;
        [warningFields addObject:_emailTextField];
    }
    else if (![_emailTextField.text isEmail]) {
        errorMessage = errorMessage ?: INVALID_EMAIL;
        [warningFields addObject:_emailTextField];
    }
    if (_documentTextField.text.length == 0) {
        errorMessage = errorMessage ?: EMPTY_DOCUMENT;
        [warningFields addObject:_documentTextField];
    }
    else if (![_documentTextField.text isCPF] && ![_documentTextField.text isCNPJ]) {
        errorMessage = errorMessage ?: INVALID_DOCUMENT_REGISTER;
        [warningFields addObject:_documentTextField];
    }
    if (_phoneTextField.text.length == 0 && _mobilePhoneTextField.text.length == 0) {
        errorMessage = errorMessage ?: EMPTY_PHONE;
        [warningFields addObject:_phoneTextField];
        [warningFields addObject:_mobilePhoneTextField];
    }
    if (_phoneTextField.text.length > 0 && ![_phoneTextField.raw isPhone]) {
        errorMessage = errorMessage ?: INVALID_TELEPHONE_NUMBER;
        [warningFields addObject:_phoneTextField];
    }
    if (_mobilePhoneTextField.text.length > 0 && ![_mobilePhoneTextField.raw isMobilePhone]) {
        errorMessage = errorMessage ?: INVALID_MOBILE_NUMBER;
        [warningFields addObject:_mobilePhoneTextField];
    }
    if (_passTextField.text.length == 0) {
        errorMessage = errorMessage ?: LOGIN_EMPTY_PASS;
        [warningFields addObject:_passTextField];
    }
    else if (_passTextField.text.length < 8) {
        errorMessage = errorMessage ?: REGISTER_INVALID_SIZE_PWD;
        [warningFields addObject:_passTextField];
    }
    
    for (WMFloatLabelMaskedTextField *textField in warningFields) {
        [textField setErrorWithColor:[FeedbackColor warningColor]];
    }
    
    if (errorMessage.length > 0) {
        [FlurryWM logEvent_signup_err:@{@"error" : errorMessage}];
        [self.view showFeedbackAlertOfKind:WarningAlert message:errorMessage];
    }
    else {
        NSMutableArray *fullNameComponents = [_nameTextField.text componentsSeparatedByString:@" "].mutableCopy;
        NSString *firstName = fullNameComponents[0];
        
        [fullNameComponents removeObjectAtIndex:0];
        NSString *lastName = [fullNameComponents componentsJoinedByString:@" "];
        
        NSMutableArray *phones = [NSMutableArray new];
        if (_phoneTextField.text.length > 0) {
            NSString *phoneString = [_phoneTextField raw];
            NSString *areaCode = [phoneString substringWithRange:NSMakeRange(0, 2)];
            NSString *phoneNumber = [phoneString substringWithRange:NSMakeRange(2, phoneString.length - 2)];
            [phones addObject:@{@"areaCode" : areaCode, @"number" : phoneNumber, @"type" : @"RESIDENTIAL"}];
        }
        
        if (_mobilePhoneTextField.text.length > 0) {
            NSString *phoneString = [_mobilePhoneTextField raw];
            NSString *areaCode = [phoneString substringWithRange:NSMakeRange(0, 2)];
            NSString *phoneNumber = [phoneString substringWithRange:NSMakeRange(2, phoneString.length - 2)];
            [phones addObject:@{@"areaCode" : areaCode, @"number" : phoneNumber, @"type" : @"MOBILE"}];
        }
        
        NSDictionary *infos = @{@"firstName" : firstName,
                                @"lastName" : lastName,
                                @"email" : _emailTextField.text,
                                @"emailCheck" : _emailTextField.text,
                                @"password" : _passTextField.text,
                                @"passwordCheck" : _passTextField.text,
                                @"document" : [_documentTextField.text stringWithoutPuntuaction],
                                @"phones" : phones.copy};
        [self registerUserWithUserInfoDict:infos];
    }
}

#pragma mark - Connection
- (void)registerUserWithUserInfoDict:(NSDictionary *)userInfoDict {
    [self setLoading:YES];
   
    BOOL isFacebook;
    BOOL isFacebookWithLink;
    NSString *snID;
    
    if (_isFacebook) {
        isFacebook = YES;
        snID = _strSnId;
        isFacebookWithLink = _isFacebookWithLink;
    } else {
        isFacebook = NO;
        isFacebookWithLink = NO;
    }
    
    [WBRLoginManager registerUserWithUserInfoDict:userInfoDict withFacebook:isFacebook andSnId:snID success:^{
        [self setLoading:NO];
        [self.navigationController popViewControllerAnimated:YES];
        
        if ([self->_delegate respondsToSelector:@selector(walRegisterViewControllerRegisteredUserWithEmail:pass:)]) {
            [self->_delegate walRegisterViewControllerRegisteredUserWithEmail:self->_emailTextField.text pass:self->_passTextField.text];
        }
    } failure:^(NSError *error) {
        [self setLoading:NO];
        [FlurryWM logEvent_signup_err:@{@"error" : error.localizedDescription}];
        [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
    }];
}



#pragma mark - Loading
- (void)setLoading:(BOOL)loading
{
    [_loader setHidden:!loading];
    loading ? [_loader startAnimating] : [_loader stopAnimating];
    
    [_nameTextField setEnabled:!loading];
    [_emailTextField setEnabled:!loading];
    [_documentTextField setEnabled:!loading];
    [_phoneTextField setEnabled:!loading];
    [_mobilePhoneTextField setEnabled:!loading];
    [_passTextField setEnabled:!loading];
    [_registerButton setEnabled:!loading];
}

#pragma mark - UIGestureRecognizer
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self hideKeyboard];
}

- (void)handleTapOnTermsLabel:(UITapGestureRecognizer *)tapGesture
{
    [self hideKeyboard];
    
    NSString *fullMessage = _termsLabel.attributedText.string;
    NSString *useTermsString = REGISTER_TERMS_TEXT;
    NSRange termsRange = [fullMessage rangeOfString:useTermsString];
    
    if ([tapGesture didTapAttributedTextInLabel:_termsLabel inRange:termsRange]) {
        WMWebViewController *terms = [[WMWebViewController alloc] initWithLocalHTMLFile:@"termosUsoIOS" title:@"Termos de uso"];
        WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:terms];
        [self presentViewController:container animated:YES completion:nil];
    }
    else {
        NSString *privacyTermsString = REGISTER_PRIVACY_TEXT;
        NSRange policyRange = [fullMessage rangeOfString:privacyTermsString];
        if ([tapGesture didTapAttributedTextInLabel:_termsLabel inRange:policyRange]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[OFUrls new] getURLPrivacy]]];
        }
    }
}

//#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _documentTextField) {
        return [textField maskDocumentInRange:range forReplacementString:string];
    }
    
    if ([textField isKindOfClass:[WMFloatLabelMaskedTextField class]]) {
        return [(WMFloatLabelMaskedTextField *) textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

#pragma mark - Keyboard
- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat bottomInsetCorrection = [_passTextField isFirstResponder] ? _pwdStrengthView.bounds.size.height + 4.0f : 0.0f;
    
    UIEdgeInsets contentInset = _contentScrollView.contentInset;
    contentInset.bottom = kbSize.height + bottomInsetCorrection;
    _contentScrollView.contentInset = contentInset;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInset = _contentScrollView.contentInset;
    contentInset.bottom = 0.0f;
    _contentScrollView.contentInset = contentInset;
}

#pragma mark - Background

- (void)handleEnteredBackgroundRegister:(NSNotification *)notification
{
    _screenCacheImageView = [[UIImageView alloc]initWithFrame:
                             [self.view.window frame]];
    
    [_screenCacheImageView setTintColor:[UIColor blackColor]];
    
    [_screenCacheImageView setBackgroundColor:RGBA(2, 123, 195, 1)];
    
    
    _imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_walmart_home"]];
    
    float posX = (self.view.window.frame.size.width - _imgLogo.frame.size.width)/2;
    float posY = (self.view.window.frame.size.height - _imgLogo.frame.size.height)/2;
    
    _imgLogo.frame = CGRectMake(posX, posY, _imgLogo.frame.size.width, _imgLogo.frame.size.height);
    
    [_screenCacheImageView addSubview:_imgLogo];
    
    [self.view.window addSubview:_screenCacheImageView];
}


- (void)handleActiveRegister:(NSNotification *)notification {
    
    if(_screenCacheImageView != nil) {
        
        [_screenCacheImageView removeFromSuperview];
        _screenCacheImageView = nil;
    }
}

@end
