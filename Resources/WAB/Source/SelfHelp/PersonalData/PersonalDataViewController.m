//
//  PersonalDataViewController.m
//  Walmart
//
//  Created by Renan on 4/16/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "WMFloatLabelMaskedTextField.h"
#import "WMButton.h"
#import "ChangePasswordViewController.h"
#import "User.h"
#import "NSDate+DateTools.h"
#import "FeedbackAlertView.h"
#import "RetryErrorView.h"
#import "WMMyAccountViewController.h"
#import "FeedbackColor.h"
#import "WBRFacebookLoginManager.h"

#import "WBRLoginManager.h"

#import "WMBFaceUnlinkViewController.h"
#import "WMBFaceLinkViewController.h"

#import "WBRUserManager.h"


@interface PersonalDataViewController () <UITextFieldDelegate, faceUnlinkDelegate>

@property (nonatomic, assign) BOOL offsetScroll;
@property (nonatomic, strong) IBOutlet WMButtonRounded *faceButton;
@property (nonatomic, weak) IBOutlet UIImageView *logoFacebook;
@property (nonatomic, weak) IBOutlet UIImageView *unlinkFacebook;
@property (nonatomic, strong) WMBFaceUnlinkViewController *wmu;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

@property (nonatomic, strong) UIImageView *screenCacheImageView;
@property (nonatomic, strong) UIImageView *imgLogo;

@property BOOL isFacebookConnected;

- (IBAction)linkUnlinkFacebook:(id)sender;

@end

@implementation PersonalDataViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [WMOmniture trackPersonalDataEnter];
    
    self.title = @"Dados Pessoais";
    
    // Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    //Background Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEnteredBackgroundPersonalData:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleActivePersonalData:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    
    self.loader.center = CGPointMake(self.navigationController.view.center.x, self.navigationController.view.center.y - self.navigationController.navigationBar.bounds.size.height);
    
    [self.scrollView setContentSize:CGSizeMake(320, 528)];
    self.scrollView.hidden = YES;
    
    self.txtName.delegate = self;
    
    self.txtDocument.mask = @"###.###.###-##";
    self.txtDocument.delegate = self;
    
    self.txtTelephone.mask = @"(##) #### ####";
    self.txtTelephone.delegate = self;
    
    self.txtCelphone.mask = @"(##) ##### ####";
    self.txtCelphone.delegate = self;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.date = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [formatter dateFromString:@"1900-01-01"];
    datePicker.maximumDate = [NSDate date];
    datePicker.backgroundColor = RGBA(255, 255, 255, 1);
    [datePicker addTarget:self action:@selector(updateBirthDate:) forControlEvents:UIControlEventValueChanged];
    [self.txtBirthDate setInputView:datePicker];
    self.txtBirthDate.pastingEnabled = @NO;
    self.txtBirthDate.cuttingEnabled = @NO;
    
    [self formatButtonGender:_btMale];
    [self formatButtonGender:_btFemale];
    
//    [_faceButton setTitle:FACEBOOK_MSG_LOGIN_SIMPLE forState:UIControlStateNormal];
//    [_faceButton setIconImage:[UIImage imageNamed:@"ic_facebook_button"]];
    
    [self loadUserPersonalData];
}

- (void) formatButtonGender:(UIButton *) button {
    
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    button.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    button.exclusiveTouch = YES;
}

#pragma mark - DatePicker
- (void)updateBirthDate:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)self.txtBirthDate.inputView;
    self.txtBirthDate.text = [picker.date formattedDateWithFormat:@"dd/MM/yyyy"];
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.txtName) {
        if (self.txtName.text.length + string.length > 150) {
            return NO;
        }
        
        NSMutableCharacterSet *filteredChars = [NSMutableCharacterSet letterCharacterSet];
        [filteredChars formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
        NSCharacterSet *blockedCharSet = [filteredChars invertedSet];
        return [string rangeOfCharacterFromSet:blockedCharSet].location == NSNotFound;
    }
    
    if ([textField isKindOfClass:[WMFloatLabelMaskedTextField class]]) {
        WMFloatLabelMaskedTextField *floatLabelTextField = (WMFloatLabelMaskedTextField *)textField;
        if (floatLabelTextField.mask.length > 0) {
            return [floatLabelTextField shouldChangeCharactersInRange:range replacementString:string];
        }
    }
    return YES;
}

#pragma mark - Gender Buttons

- (IBAction)malePressed:(id)sender {
//    self.btMale.layer.borderWidth = 0.0f;
    self.btMale.enabled = NO;
    self.btFemale.enabled = YES;
}

- (IBAction)femalePressed:(id)sender {
//    self.btFemale.layer.borderWidth = 0.0f;
    self.btFemale.enabled = NO;
    self.btMale.enabled = YES;
}

- (IBAction)highlightGenderButton:(UIButton *)sender {
    sender.layer.borderWidth = 1.0f;
    sender.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
}

- (IBAction)unhighlightGenderButton:(UIButton *)sender {
//    sender.layer.borderWidth = 0.0f;
}

#pragma mark - Load

- (void)loadUserPersonalData {
    [self.loader startAnimating];
    
    [WBRLoginManager loadUserInfoDataWithSuccessBlock:^(User *user) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadUserPersonalDataSuccess:user];
        });

    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loader stopAnimating];
            if ((error.code == 400) || (error.code == 401)) {
                LogErro(@"401 or 400");
                [self presentLoginWithLoginSuccessBlock:^{
                    [self loadUserPersonalData];
                } dismissBlock:^{
                    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                }];
            }
            else {
                [self loadUserPersonalDataFailure:error.localizedDescription];
            }
        });
    }];
}

- (void)loadUserPersonalDataSuccess:(User *)userPersonalData {
    [self.loader stopAnimating];
    self.scrollView.hidden = NO;
    [self setupWithPersonalData:userPersonalData];
}

- (void)loadUserPersonalDataFailure:(NSString *)error {
    self.scrollView.hidden = YES;
    
    [self.view showRetryViewWithMessage:error retryBlock:^{
        [self loadUserPersonalData];
    }];
}

- (void)setupWithPersonalData:(User *)userPersonalData {
    self.userPersonalData = userPersonalData;
    
    NSMutableString *fullNameStr = [NSMutableString new];
    [fullNameStr appendString:self.userPersonalData.firstName];
    
    if (self.userPersonalData.lastName.length > 0) {
        if (fullNameStr.length == 0) {
            [fullNameStr appendString:self.userPersonalData.lastName];
        }
        else {
            [fullNameStr appendFormat:@" %@", self.userPersonalData.lastName];
        }
    }
    self.txtName.text = fullNameStr.copy;
    
    [self.txtDocument insertTextPreservingMask:userPersonalData.document];
    self.txtEmail.text = userPersonalData.email;
    
    self.btMale.enabled = ![userPersonalData.gender isEqualToString:@"MALE"];
    self.btFemale.enabled = ![userPersonalData.gender isEqualToString:@"FEMALE"];
    self.switchReceiveNews.on = [[userPersonalData.preferences objectForKey:@"email"] boolValue];
    
    for (PhoneModel *phone in userPersonalData.phones) {
        WMFloatLabelMaskedTextField *textField = [phone.type isEqualToString:@"MOBILE"] ? self.txtCelphone : self.txtTelephone;
        NSString *fullNumber = [NSString stringWithFormat:@"%@%@", phone.areaCode, phone.number];
        [textField insertTextPreservingMask:fullNumber];
    }
    
    NSString *birthDateStr = userPersonalData.dateBirth;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *birthDate = [formatter dateFromString:birthDateStr];
    if (birthDate) {
        
        self.txtBirthDate.text = [birthDate formattedDateWithFormat:@"dd/MM/yyyy"];
        
        UIDatePicker *picker = (UIDatePicker *) self.txtBirthDate.inputView;
        picker.date = birthDate;
    }
    
    if ([userPersonalData.social objectForKey:@"id"]) {
        
        [self changeStatusFacebookButton:YES];
        _isFacebookConnected = YES;
    }
    else {
        [self changeStatusFacebookButton:NO];
        _isFacebookConnected = NO;
    }
}

- (void) closeWarning {
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    result = CGSizeMake(result.width , result.height);
    
    float heightScreen = result.height;
    float widthScreen = result.width;
    
    [UIView animateWithDuration:.25 animations:^{
        self->_wmu.view.frame = CGRectMake(0, heightScreen, widthScreen, heightScreen);
    }];
}

- (void) dismissKeyboard {
    
    [_txtName resignFirstResponder];
    [_txtDocument resignFirstResponder];
    [_txtBirthDate resignFirstResponder];
    [_txtEmail resignFirstResponder];
    [_txtTelephone resignFirstResponder];
    [_txtCelphone resignFirstResponder];
}

- (void) linkUnlinkFacebook:(id)sender {
    
    _actInd.hidden = NO;
    
    [self dismissKeyboard];
    
    if (_isFacebookConnected) {
        
        User *user = [User sharedUser];
        
        LogInfo(@"Disconnect Facebook with GUID: %@", user.guid);
        
        _wmu = [[WMBFaceUnlinkViewController alloc] initWithNibName:@"WMBFaceUnlinkViewController" bundle:nil];
        _wmu.delegate = self;
        _wmu.strGuid = user.guid;
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        result = CGSizeMake(result.width , result.height);
        
        float heightScreen = result.height;
        float widthScreen = result.width;
        
        [_wmu.view setNeedsLayout];
        [_wmu.view layoutIfNeeded];
        
        self.navigationController ? [self.navigationController.view addSubview:_wmu.view] : [self.view addSubview:_wmu.view];
        
        _wmu.view.frame = CGRectMake(0, heightScreen, widthScreen, heightScreen);
        
        [UIView animateWithDuration:.25 animations:^{
            self->_wmu.view.frame = CGRectMake(0, 0, widthScreen, heightScreen);
        }];
        
        _actInd.hidden = YES;
    }
    else {
        
        LogInfo(@"Connect Facebook");
        
        _actInd.hidden = NO;
        
        [WBRFacebookLoginManager loginWithPermissions:nil success:^(FaceUser *facebookUser, NSHTTPURLResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                User *userWm = [User sharedUser];
                
                [WBRFacebookLoginManager linkFacebookWithGuid:userWm.guid andFacebookAccessToken:facebookUser.tokenFacebook success:^{
                    [self changeStatusFacebookButton:YES];
                    self->_isFacebookConnected = YES;
                    [userWm setValue:@{@"id" : facebookUser.picture_url} forKey:@"social"];
                    
                    self->_actInd.hidden = YES;
                } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
                    LogErro(@"Link Error: %@ | %i", [error description], (int) error.code);
                    NSString *msgError = ERROR_CONNECTION_UNKNOWN;
                    int errorCode = (int)error.code;
                    
                    if  (errorCode == 401) {
                        //The connection failed because the user cancelled required authentication
                    } else if (errorCode == 408) {
                        msgError = ERROR_CONNECTION_TIMEOUT;
                    } else if (errorCode == 1009) {
                        //-1009: The connection failed because the device is not connected to the internet
                        msgError = ERROR_CONNECTION_INTERNET;
                    } else if (errorCode == 0) {
                        msgError = ERROR_CONNECTION_DATA;
                    }
                    self->_isFacebookConnected = NO;
                    [userWm setValue:nil forKey:@"social"];
                    [self.view showFaceFeedbackAlertOfKind:ErrorAlert message:msgError];
                    self->_actInd.hidden = YES;
                }];
            });
        } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeStatusFacebookButton:NO];
                [self.navigationController.view hideModalLoading];
                [self.view showFaceFeedbackAlertOfKind:ErrorAlert message:FACEBOOK_MSG_ERROR_NO_TOKEN];
                self->_isFacebookConnected = NO;
                self->_actInd.hidden = YES;
            });
        }];
    }
}

- (void) unlinkFace {
    
    _actInd.hidden = NO;
    _unlinkFacebook.hidden = YES;
    
    User *user = [User sharedUser];
    
    if (user.guid) {
        [WBRFacebookLoginManager unlinkFacebookWithGuid:user.guid success:^{
            [self->_faceButton setTitle:FACEBOOK_MSG_LOGIN_SIMPLE forState:UIControlStateNormal];
            [self->_faceButton setIconImage:[UIImage imageNamed:@"ic_facebook_button"]];
            self->_logoFacebook.hidden = YES;
            self->_unlinkFacebook.hidden = YES;
            
            [user setValue:nil forKey:@"social"];
            
            self->_isFacebookConnected = NO;
            
            self->_actInd.hidden = YES;

        } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
            NSString *msgError = ERROR_CONNECTION_UNKNOWN;
            int errorCode = (int)error.code;
            if (errorCode == 408) {
                msgError = ERROR_CONNECTION_TIMEOUT;
            } else if (errorCode == 1009) {
                msgError = ERROR_CONNECTION_INTERNET;
            } else if (errorCode == 0) {
                msgError = ERROR_CONNECTION_DATA;
            }
            self->_isFacebookConnected = YES;
            self->_actInd.hidden = YES;
            self->_unlinkFacebook.hidden = NO;
            [self.view showFaceFeedbackAlertOfKind:ErrorAlert message:msgError];
        }];
    }
}

- (void) changeStatusFacebookButton:(BOOL) connected {
    
    if (connected) {
        
        [_faceButton setTitle:FACEBOOK_MSG_LOGIN_CONNECTED forState:UIControlStateNormal];
        [_faceButton setTitle:FACEBOOK_MSG_LOGIN_CONNECTED forState:UIControlStateHighlighted];
        [_faceButton setIconImage:nil];
        _logoFacebook.hidden = NO;
        _unlinkFacebook.hidden = NO;
        _isFacebookConnected = YES;
    }
    else {
        
        [_faceButton setTitle:FACEBOOK_MSG_LOGIN_SIMPLE forState:UIControlStateNormal];
        [_faceButton setIconImage:[UIImage imageNamed:@"ic_facebook_button"]];
        _logoFacebook.hidden = YES;
        _unlinkFacebook.hidden = YES;
        _isFacebookConnected = NO;
    }
}

#pragma mark - Validation

- (NSArray *)validateAndGetInvalidFields {
    self.alertMsg = nil;
    NSMutableArray *invalidFields = [NSMutableArray new];
    
    if (self.txtName.text.length == 0) {
        if (!self.alertMsg) self.alertMsg = PERSONAL_DATA_WARNING_NAME;
        [invalidFields addObject:self.txtName];
    }
    else {
        self.txtName.text = [self.txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSMutableArray *components = [NSMutableArray arrayWithArray:[self.txtName.text componentsSeparatedByString:@" "]];
        NSArray *namesAux = [NSArray arrayWithArray:components];
        NSMutableArray *namesMutable = [NSMutableArray new];
        for (NSString *str in namesAux) {
            if (str.length > 0) {
                [namesMutable addObject:str];
            }
        }
        if (namesMutable.count == 1) {
            if (!self.alertMsg) self.alertMsg = PERSONAL_DATA_WARNING_NAME;
            [invalidFields addObject:self.txtName];
        }
    }
    
    if (self.btMale.enabled && self.btFemale.enabled) {
        if (!self.alertMsg) self.alertMsg = PERSONAL_DATA_WARNING_SEX;
        [invalidFields addObject:self.btMale];
        [invalidFields addObject:self.btFemale];
    }
    
    if (self.txtBirthDate.raw.length == 0) {
        if (!self.alertMsg) self.alertMsg = PERSONAL_DATA_WARNING_BIRTH_DATE;
        [invalidFields addObject:self.txtBirthDate];
    }
    
    if (self.txtTelephone.raw.length == 0 && self.txtCelphone.raw.length == 0) {
        if (!self.alertMsg) self.alertMsg = PERSONAL_DATA_WARNING_TELEPHONE;
        [invalidFields addObject:self.txtTelephone];
        [invalidFields addObject:self.txtCelphone];
    }
    
    NSString *telephoneRaw = self.txtTelephone.raw;
    if ((telephoneRaw.length > 0 && telephoneRaw.length < 10) || (telephoneRaw.length > 2 && ([telephoneRaw characterAtIndex:0] == '0' || [telephoneRaw characterAtIndex:2] == '0' || [telephoneRaw characterAtIndex:2] == '1'))) {
        if (!self.alertMsg) self.alertMsg = PERSONAL_DATA_WARNING_INVALID_TELEPHONE;
        [invalidFields addObject:self.txtTelephone];
    }
    
    NSString *celPhoneRaw = self.txtCelphone.raw;
    if ((celPhoneRaw.length > 0 && celPhoneRaw.length < 10) || (celPhoneRaw.length > 2 && ([celPhoneRaw characterAtIndex:0] == '0' || [celPhoneRaw characterAtIndex:2] == '0' || [celPhoneRaw characterAtIndex:2] == '1'))) {
        if (!self.alertMsg) self.alertMsg = PERSONAL_DATA_WARNING_INVALID_TELEPHONE;
        [invalidFields addObject:self.txtCelphone];
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (self.txtEmail.text.length == 0 || ![emailTest evaluateWithObject:self.txtEmail.text]) {
        if (!self.alertMsg) self.alertMsg = PERSONAL_DATA_WARNING_EMAIL;
        [invalidFields addObject:self.txtEmail];
    }
    
    return invalidFields.copy;
}

- (void)alertField:(UIView *)view color:(CGColorRef)color {
    view.layer.borderColor = color;
    view.layer.borderWidth = 1.0f;
}

- (void)unalertView:(UIView *)view {
    if ([view isKindOfClass:[WMFloatLabelMaskedTextField class]]) {
        WMFloatLabelMaskedTextField *textField = (WMFloatLabelMaskedTextField *)view;
        textField.layer.borderColor = [textField defaultBorderColor];
    }
    else {
        view.layer.borderColor = RGBA(232, 232, 232, 1).CGColor;
    }
}

#pragma mark - Save Changes

- (IBAction)saveChangesPressed:(id)sender {
    [self.scrollView endEditing:YES];
    
    //Clean alerts
    for (UIView *view in self.validationFields) {
        [self unalertView:view];
    }
    
    NSArray *invalidFields = [self validateAndGetInvalidFields];
    if (invalidFields.count == 0) {
        [self updateUserDataLocally];
        [self saveChanges];
    }
    else {
        [self.view showFeedbackAlertOfKind:WarningAlert message:_alertMsg];
        for (UIView *view in invalidFields) {
            [self alertField:view color:[FeedbackColor warningColor].CGColor];
        }
        [self adjustScrollToView:invalidFields.firstObject];
    }
}

- (void)updateUserDataLocally {
    NSInteger indexOfBlankSpace = [self.txtName.text rangeOfString:@" "].location;
    self.userPersonalData.firstName = [self.txtName.text substringToIndex:indexOfBlankSpace];
    self.userPersonalData.lastName = [self.txtName.text substringFromIndex:indexOfBlankSpace+1];
    
    self.userPersonalData.gender = self.btMale.enabled ? @"FEMALE" : @"MALE";
    self.userPersonalData.document = self.txtDocument.raw;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"dd/MM/yyyy";
    NSDate *birthDate = [formatter dateFromString:self.txtBirthDate.text];
    self.userPersonalData.dateBirth = [birthDate formattedDateWithFormat:@"yyyy-MM-dd"];
    
    NSMutableArray *phonesMutable = [NSMutableArray new];
    
    if (self.txtTelephone.raw.length > 0) {
        NSDictionary *residentialPhoneDict = @{@"areaCode" : [self.txtTelephone.raw substringToIndex:2],
                                               @"number" : [self.txtTelephone.raw substringFromIndex:2],
                                               @"type" : @"RESIDENTIAL"};
        PhoneModel *residentialPhone = [[PhoneModel alloc] initWithDictionary:residentialPhoneDict error:NULL];
        [phonesMutable addObject:residentialPhone];
    }
    
    if (self.txtCelphone.raw.length > 0) {
        NSDictionary *mobilePhoneDict = @{@"areaCode" : [self.txtCelphone.raw substringToIndex:2],
                                          @"number" : [self.txtCelphone.raw substringFromIndex:2],
                                          @"type" : @"MOBILE"};
        PhoneModel *cellPhone = [[PhoneModel alloc] initWithDictionary:mobilePhoneDict error:NULL];
        [phonesMutable addObject:cellPhone];
    }
    
    NSArray *phonesArray = [NSArray arrayWithArray:phonesMutable];
    self.userPersonalData.phones = (NSArray<PhoneModel>*)phonesArray;
    
    self.userPersonalData.email = self.txtEmail.text;
    
    NSMutableDictionary *prefMutable = [NSMutableDictionary dictionaryWithDictionary:self.userPersonalData.preferences];
    [prefMutable setObject:self.switchReceiveNews.on ? @YES : @NO forKey:@"email"];
    self.userPersonalData.preferences = [NSDictionary dictionaryWithDictionary:prefMutable];
}

- (void)saveChanges {
    self.scrollView.hidden = YES;
    [self.loader startAnimating];
    
    [WBRUserManager updateUserWithUserPersonalData:self.userPersonalData fromCompleteScreen:NO successBlock:^{
        [WMOmniture trackPersonalDataUpdate];
        [self saveUserPersonalDataSuccess];
    } failureBlock:^(NSError *error) {
        if (error.code == 400 || error.code == 401) {
            [self presentLoginWithLoginSuccessBlock:^{
                [self saveChanges];
            } dismissBlock:^{
                [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
            }];
        }
        else {
            [self saveUserPersonalDataFailureWithError:error.localizedDescription];
        }
    }];
}

- (void)saveUserPersonalDataSuccess {
    [self.loader stopAnimating];
    [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:PERSONAL_DATA_SUCCESS_SAVE];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveUserPersonalDataSucessWithUserData:)]) {
        [self.delegate saveUserPersonalDataSucessWithUserData:self.userPersonalData];
    }
}

- (void)saveUserPersonalDataFailureWithError:(NSString *)error {
    [self.loader stopAnimating];
    
    self.scrollView.hidden = NO;
    
    [self.navigationController.view showAlertWithMessage:error dismissBlock:^{
        [self saveChanges];
    }];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillHide:(NSNotification *)notification
{
    _offsetScroll = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:self.view.bounds];
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (_offsetScroll) {
    
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollView.contentSize.height-250);
        
        _offsetScroll = NO;
    }
    
    NSDictionary* userInfo = [notification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.height -= keyboardSize.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollView.contentSize.height+250);
    _offsetScroll = YES;
}

- (IBAction)handleTap:(id)sender {
    
    if (_offsetScroll) {
        
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollView.contentSize.height-250);
        
        _offsetScroll = NO;
    }
    
    [self.view endEditing:YES];
}

#pragma mark - ScrollView
- (void)adjustScrollToView:(UIView *)view {
    if (self.scrollView.contentOffset.y > view.frame.origin.y) {
        CGRect newScrollFrame = CGRectMake(0, view.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView scrollRectToVisible:newScrollFrame animated:YES];
    }
}

#pragma mark - Change Password

- (IBAction)changePasswordPressed:(id)sender {
    self.changePasswordScreen = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
    [self.navigationController pushViewController:self.changePasswordScreen animated:YES];
}

- (void)changePasswordSuccess:(FeedbackAlertView *)formAlert {
    self.btSaveChanges.hidden = YES;
    formAlert.frame = CGRectMake(0, self.view.frame.size.height, formAlert.frame.size.width, formAlert.frame.size.height);
    [self.view addSubview:formAlert];
    [formAlert animateWithEaseInCompletionBlock:^{
        self.btSaveChanges.hidden = NO;
    } easeOutCompletionBlock:nil];
}

#pragma mark - Background

- (void)handleEnteredBackgroundPersonalData:(NSNotification *)notification
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


- (void)handleActivePersonalData:(NSNotification *)notification {
    
    if(_screenCacheImageView != nil) {
        
        [_screenCacheImageView removeFromSuperview];
        _screenCacheImageView = nil;
    }
}

@end
