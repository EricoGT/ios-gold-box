//
//  OFLoginViewController.m
//  Ofertas
//
//  Created by Marcelo Santos on 8/23/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFLoginViewController.h"
#import "OFMessages.h"
#import "OFUrls.h"
#import "WMTokens.h"
#import "WMBaseNavigationController.h"
#import "WALHomeViewController.h"
#import "WMFloatLabelMaskedTextField.h"
#import "ResetPasswordView.h"
#import "WBRLoginManager.h"
#import "WALRegisterViewController.h"
#import "WMButtonRounded.h"

#import "UIViewController+Login.h"
#import "UITapGestureRecognizer+DetectTap.h"
#import "NSString+Validation.h"
#import "FeedbackColor.h"

#import "WBRFacebookLoginManager.h"

#import "WMBFaceLinkViewController.h"
#import "WMBFaceInfoViewController.h"
#import "WMBFaceHeaderViewController.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "WALWishlistViewController.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "WALHomeCache.h"
#import "TimeManager.h"
#import "WBRUser.h"
#import "WMPwdTextField.h"
#import "WBRLoginManager.h"
#import "WBRFacebookLoginManager.h"

@interface OFLoginViewController () <WALRegisterViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutletCollection(WMFloatLabelMaskedTextField) NSArray *textFields;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *loginTextField;
@property (nonatomic, weak) IBOutlet WMPwdTextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *recoverPasswordButton;
@property (nonatomic, weak) IBOutlet WMButtonRounded *registerButton;
@property (nonatomic, weak) IBOutlet WMButtonRounded *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *termsAndPrivacyLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *customLoader;

@property (nonatomic, copy) void (^loginSuccessBlock)();

@property (weak, nonatomic) IBOutlet WMButtonRounded *faceButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewInScrollHeightConstraint;

//Facebook Connect
@property (weak, nonatomic) IBOutlet UIView *viewFaceHeader;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *loginPosYConstraint;
@property (weak, nonatomic) IBOutlet UIView *viewFaceInfo;
@property (weak, nonatomic) IBOutlet UIView *lineOr;
@property (weak, nonatomic) IBOutlet UILabel *optionOr;
@property (weak, nonatomic) IBOutlet UILabel *userNew;

@property (nonatomic, strong) UIImageView *screenCacheImageView;
@property (nonatomic, strong) UIImageView *imgLogo;

@end

@implementation OFLoginViewController

#pragma mark - Inits
- (OFLoginViewController *)init
{
    NSString *title = @"Entrar";
    
    self = [super initWithTitle:title isModal:YES searchButton:NO cartButton:NO wishlistButton:NO];
    return self;
}

- (OFLoginViewController *)initWithLoginSuccessBlock:(void (^)())loginSuccessBlock
{
    if (self = [self init]) {
        
        _loginSuccessBlock = loginSuccessBlock;
    }
    return self;
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

//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LogInfo(@"From Class Login: %@", _strScreen);
    
    [WMOmniture trackLoginPage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDismiss:) name:@"faceLoginDismiss" object:nil];
    
    //Background Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEnteredBackgroundLogin:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleActiveLogin:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [FlurryWM logEvent_login_entering];
    
    if ([OFSetup enableFacebookButton]) {
        
        [self showFacebookButton];
    }
    else {
        _faceButton.hidden = YES;
    }
    
    _loginTextField.tag = 1;
    _passwordTextField.tag = 2;
    
    [self setupLayout];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    if (_isFacebook) {
        [self addHeaderFacebook];
    }
}

- (void) addHeaderFacebook {
    
    _loginPosYConstraint.constant = 160;
    
    _lineOr.hidden = YES;
    _optionOr.hidden = YES;
    _userNew.hidden = YES;
    _registerButton.hidden = YES;
    _faceButton.hidden = YES;
    
    WMBFaceHeaderViewController *wmh = [[WMBFaceHeaderViewController alloc] initWithNibName:@"WMBFaceHeaderViewController" bundle:nil];
    
    [WBRFacebookLoginManager getFacebookUserInformationsWithSuccess:^(FaceUser *facebookUser, NSHTTPURLResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wmh setContent:facebookUser];
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
        
        [wmi setLabelContent:@"Preencha os campos de E-mail, CPF ou CNPJ e senha para vincular suas contas de e-mail."];
    });
    
    [_viewFaceInfo addSubview:wmi.view];
    
    _faceButton.hidden = YES;
    
    _viewFaceHeader.alpha = 1;
    _viewFaceHeader.hidden = NO;
    
    _viewFaceInfo.alpha = 1;
    _viewFaceInfo.hidden = NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.loginTextField == textField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder]; // Dismiss the keyboard.
        
        // Execute any additional code
        LogInfo(@"Textfield: %i", (int) textField.tag);
        [self login];
    }
    return YES;
}

- (void) showFacebookButton {
    _faceButton.hidden = NO;
}

- (IBAction)loginFaceButtonClicked:(id)sender {
    
    [self.navigationController.view showModalLoading];
    
    [WBRFacebookLoginManager loginWithFacebookSuccess:^(FaceUser *facebookUser, NSHTTPURLResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_faceButton setTitle:FACEBOOK_MSG_LOGIN forState:UIControlStateNormal];
            [self.navigationController.view hideModalLoading];
            [self facebookLinkAccount];
        });
    } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self->_faceButton setTitle:FACEBOOK_MSG_LOGIN forState:UIControlStateNormal];
            
            if (error.code == 400) {
                
                LogInfo(@"[FACE] Headers (400): %@", failResponse.allHeaderFields);
                NSDictionary *dictHeader = failResponse.allHeaderFields;
                
                if ([dictHeader objectForKey:@"snId"]) {
                    
                    WMBFaceLinkViewController *wml = [[WMBFaceLinkViewController alloc] initWithNibName:@"WMBFaceLinkViewController" bundle:nil];
                    wml.strSnId = [dictHeader objectForKey:@"snId"];
                    wml.isFacebookWithLink = YES;
                    wml.fromClass = self->_strScreen;
                    [self.navigationController pushViewController:wml animated:YES];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view showFaceFeedbackAlertOfKind:ErrorAlert message:FACEBOOK_MSG_ERROR_NO_TOKEN];
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

#pragma mark - Facebook Link Account

- (void) facebookLinkAccount {
    
    if ([_strScreen isEqualToString:@"NewCartViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceBuyOrder" object:self];
    }
    else if ([_strScreen isEqualToString:@"WMContactViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceContact" object:self];
    }
    else if ([_strScreen isEqualToString:@"WALWishlistViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([_strScreen isEqualToString:@"WALProductDetailViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceFavoriteDetail" object:self];
    }
    else if ([_strScreen isEqualToString:@"OFSearchProductsViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceFavoriteSearch" object:self];
    }
    else {
        
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isFacebook) {
        self.navigationItem.title = @"Vincular Conta";
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dismiss {
    [super dismiss];
    if (_dismissBlock) _dismissBlock();
}

#pragma mark - Login action
- (IBAction)login
{
    
    [WALHomeCache setCustomRefreshTime:0];
    
    [FlurryWM logEvent_login_btn];
    [self dismissKeyboard];
    
    [WBRFacebookLoginManager logoutFacebook];
    
    NSString *errorMessage;
    NSMutableArray *warningFields = [NSMutableArray new];
    
    if (_loginTextField.text.length == 0 && _passwordTextField.text.length == 0) {
        errorMessage = errorMessage ?: LOGIN_EMPTY_EMAIL_AND_PASS;
        [warningFields addObjectsFromArray:@[_loginTextField, _passwordTextField]];
    }
    else {
        if (_loginTextField.text.length == 0) {
            errorMessage = errorMessage ?: LOGIN_EMPTY_EMAIL;
            [warningFields addObject:_loginTextField];
        }
        else if (![_loginTextField.text isEmail] && ![_loginTextField.text isCPF] && ![_loginTextField.text isCNPJ]) {
            errorMessage = errorMessage ?: LOGIN_INVALID_DATA;
            [warningFields addObject:_loginTextField];
        }
        
        if (_passwordTextField.text.length == 0) {
            errorMessage = errorMessage ?: LOGIN_EMPTY_PASS;
            [warningFields addObject:_passwordTextField];
        }
    }
    
    if (errorMessage.length > 0) {
        for (WMFloatLabelMaskedTextField *textField in warningFields) {
            [textField setErrorWithColor:[FeedbackColor warningColor]];
        }
        [self.view showFeedbackAlertOfKind:WarningAlert message:errorMessage];
        return;
    }
    
    [self setLoading:YES];
    
    void (^successBlock)() = ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            if (self->_loginSuccessBlock) self->_loginSuccessBlock();
        }];
    };
    
    void (^errorBlock)(NSError *error) = ^void(NSError *error) {
        NSString *errorMessage = error.localizedDescription;
        [FlurryWM logEvent_login_err:errorMessage];
        self->_passwordTextField.text = @"";
        [self setLoading:NO];
        [self.view showFeedbackAlertOfKind:ErrorAlert message:errorMessage];
        LogInfo(@"Login Error Message: %@", errorMessage);
    };

    BOOL isFacebook;
    BOOL isFacebookWithLink;
    NSString *snID;

    NSString *username = _loginTextField.text;
    if ([username isEmail]) {
        

        if (_isFacebook) {
            isFacebook = YES;
            isFacebookWithLink = self.isFacebookWithLink;
            snID = self.strSnId;
        } else {
            isFacebook = NO;
            isFacebookWithLink = NO;
        }
        
        LogInfo(@"From Class Login face: %@", _strScreen);
        [WBRLoginManager loginWithUser:username pass:self.passwordTextField.text isFacebook:isFacebook isFacebookWithLink:isFacebookWithLink snId:snID successBlock:^{

            if (self->_isFacebook) {
                
                [Answers logLoginWithMethod:@"login - username - facebook"
                                    success:@YES
                           customAttributes:@{}];
                
                [self facebookMergeAccount];
            }
            else {
                
                [Answers logLoginWithMethod:@"login - username"
                                    success:@YES
                           customAttributes:@{}];
            }
            
            if (successBlock) successBlock();
            
        } failureBlock:^(NSError *error) {
            
            if (self->_isFacebook) {
                
                [Answers logLoginWithMethod:@"login - username - facebook"
                                    success:@NO
                           customAttributes:@{}];
                
                [self facebookMergeAccount];
            }
            else {
                
                [Answers logLoginWithMethod:@"login - username"
                                    success:@NO
                           customAttributes:@{}];
            }
            
            if (errorBlock) errorBlock(error);
        }];
    
    } else if ([username isCPF] || [username isCNPJ]) {
        if (_isFacebook) {
            isFacebook = YES;
            snID = _strSnId;
            isFacebookWithLink = _isFacebookWithLink;
        } else {
            isFacebook = NO;
            isFacebookWithLink = NO;
        }
        
        [WBRLoginManager loginWithDocument:username pass:self.passwordTextField.text isFacebook:isFacebook isFacebookWithLink:isFacebookWithLink snId:snID successBlock:^{
            if (self->_isFacebook) {
                [Answers logLoginWithMethod:@"login - document - facebook"
                                    success:@YES
                           customAttributes:@{}];
                [self facebookMergeAccount];
            } else {
                [Answers logLoginWithMethod:@"login - document"
                                    success:@YES
                           customAttributes:@{}];
            }
            if (successBlock) {
                successBlock();
            }
        } failureBlock:^(NSError *error) {
            if (self->_isFacebook) {
                [Answers logLoginWithMethod:@"login - document - facebook"
                                    success:@NO
                           customAttributes:@{}];
                
                [self facebookMergeAccount];
            } else {
                [Answers logLoginWithMethod:@"login - document"
                                    success:@NO
                           customAttributes:@{}];
            }
            if (errorBlock) {
                errorBlock(error);
            }
        }];
    }
}

#pragma mark - Facebook Merge Account

- (void) facebookMergeAccount {
    
    //Search by pre favorited product
    NSData *wishlistProductData = [[NSUserDefaults standardUserDefaults] objectForKey:@"showcaseHeart"];
    if (wishlistProductData) {
        ShowcaseProductModel *spm = [NSKeyedUnarchiver unarchiveObjectWithData:wishlistProductData];
        [[WALHomeViewController new] favoriteProduct:spm completionBlock:nil];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"showcaseHeart"];
    }
    
    if ([_strScreen isEqualToString:@"NewCartViewController"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceBuyOrder" object:self];
    }
    else if ([_strScreen isEqualToString:@"WMContactViewController"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceContact" object:self];
    }
    else if ([_strScreen isEqualToString:@"WALWishlistViewController"]) {
        LogInfo(@"WishList Login");
    }
    else if ([_strScreen isEqualToString:@"WALProductDetailViewController"]) {
        LogInfo(@"Product Detail Login");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceFavoriteDetail" object:self];
    }
    else if ([_strScreen isEqualToString:@"OFSearchProductsViewController"]) {
        LogInfo(@"Search Login");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"faceFavoriteSearch" object:self];
    }
    else {
        
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -

- (void) loginDismiss:(NSNotification *)notification {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Forget Password
- (IBAction)recoverPassword
{
    [FlurryWM logEvent_login_forgot_pwd];
    [self dismissKeyboard];
    
    ResetPasswordView *resetPasswordView = [ResetPasswordView new];
    self.navigationController ? [self.navigationController.view addSubview:resetPasswordView] : [self.view addSubview:resetPasswordView];
    [resetPasswordView setRecoverPasswordSuccessBlock:^(NSString *maskedEmail) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (maskedEmail.length > 0) {
                [self.view showFeedbackAlertOfKind:SuccessAlert message:[NSString stringWithFormat:PWD_RECOVER_SUCCESS_FORMAT, maskedEmail]];
            } else {
                [self.view showFeedbackAlertOfKind:SuccessAlert message:SUCCESS_PASSWORD_RECOVER];
            }
        });
    }];
}

#pragma mark - Register
- (IBAction)registerNewUser
{
    [FlurryWM logEvent_login_signup];
    [self dismissKeyboard];
    
    WALRegisterViewController *registerViewController = [[WALRegisterViewController alloc] initWithDelegate:self];
    registerViewController.isFacebook = NO;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)walRegisterViewControllerRegisteredUserWithEmail:(NSString *)email pass:(NSString *)pass
{
    _loginTextField.text = email;
    _passwordTextField.text = pass;
    [self login];
}

#pragma mark - Layout
- (void)setupLayout
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    result = CGSizeMake(result.width, result.height);
    float heightScreen = result.height;
    
    //Verify if iPhone 6 or Plus or iPhone X
    if (heightScreen >= 812) {
        _viewInScrollHeightConstraint.constant = _viewInScrollHeightConstraint.constant+20;
    }
    else if (heightScreen >= 667) {
        _viewInScrollHeightConstraint.constant = heightScreen-64;
    }
    else if (heightScreen >= 568) {
        _viewInScrollHeightConstraint.constant = heightScreen*1.1;
    }
    else if (heightScreen >= 480) {
        _viewInScrollHeightConstraint.constant = heightScreen*1.3;
    }
    
    [_faceButton setIconImage:[UIImage imageNamed:@"ic_facebook_button"]];

    NSString *storedLogin = [[NSUserDefaults standardUserDefaults] stringForKey:@"lgUs"];
    if (!_isFacebook) {
        _loginTextField.text = storedLogin.length > 0 ? storedLogin : @"";
    }
}

- (CGSize)get_visible_size {
    CGSize result;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    result.width = size.width;
    result.height = size.height;
    
    size = [[UIApplication sharedApplication] statusBarFrame].size;
    result.height -= MIN(size.width, size.height);
    
    if (self.navigationController != nil) {
        size = self.navigationController.navigationBar.frame.size;
        result.height -= MIN(size.width, size.height);
    }
    
    if (self.tabBarController != nil) {
        size = self.tabBarController.tabBar.frame.size;
        result.height -= MIN(size.width, size.height);
    }
    
    return result;
}

#pragma mark - Privacy Message and actions
- (void)setupPrivacyMessage
{
    OFMessages *messagesInstance =  [OFMessages new];
    NSString *privacyTermsString = messagesInstance.loginPrivacyTerms;
    NSString *fullMessage = [NSString stringWithFormat:messagesInstance.privacyLoginMessage,privacyTermsString];
    
    NSRange fullRange = NSMakeRange(0, fullMessage.length);
    NSRange policyRange = [fullMessage rangeOfString:privacyTermsString];
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:fullMessage];
    [message addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans" size:12] range:fullRange];
    [message addAttribute:NSForegroundColorAttributeName value:RGBA(26, 117, 207, 1) range:policyRange];
    self.termsAndPrivacyLabel.attributedText = message.copy;
    self.termsAndPrivacyLabel.userInteractionEnabled = YES;
    [self.termsAndPrivacyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
}

- (void)handleTapOnLabel:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
    OFMessages *messagesInstance =  [OFMessages new];
    NSString *privacyTermsString = messagesInstance.loginPrivacyTerms;
    NSString *fullMessage = self.termsAndPrivacyLabel.attributedText.string;
    NSRange policyRange = [fullMessage rangeOfString:privacyTermsString];
    
    BOOL didTapPrivacy = [tapGesture didTapAttributedTextInLabel:self.termsAndPrivacyLabel inRange:policyRange];
    if (didTapPrivacy) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[OFUrls new] getURLPrivacy]]];
    }
}

#pragma mark - Loading
- (void)setLoading:(BOOL)loading
{
    _loginTextField.enabled = !loading;
    _passwordTextField.enabled = !loading;
    _loginButton.enabled = !loading;
    _recoverPasswordButton.enabled = !loading;
    _registerButton.enabled = !loading;
    _customLoader.hidden = !loading;
}

#pragma mark - Keyboard
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView animateWithDuration:.25 animations:^{
        self->_contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0);
        self->_contentScrollView.scrollIndicatorInsets = self->_contentScrollView.contentInset;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.25 animations:^{
        self->_contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self->_contentScrollView.scrollIndicatorInsets = self->_contentScrollView.contentInset;
    }];
}

#pragma mark - UTMI
- (NSString *)UTMIIdentifier {
    return @"login";
}

#pragma mark - Background
- (void)handleEnteredBackgroundLogin:(NSNotification *)notification
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


- (void)handleActiveLogin:(NSNotification *)notification {
    
    if(_screenCacheImageView != nil) {
        
        [_screenCacheImageView removeFromSuperview];
        _screenCacheImageView = nil;
    }
}

@end
