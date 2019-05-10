//
//  PersonalDataComplementViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 12/8/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "PersonalDataComplementViewController.h"
#import "NSDate+DateTools.h"
#import "PhoneModel.h"
#import "User.h"
#import "WMMyAccountViewController.h"
#import "User.h"
#import "WBRUserManager.h"

@interface PersonalDataComplementViewController () <UITextFieldDelegate>
- (IBAction)closeComplement:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrComplement;
@property (weak, nonatomic) IBOutlet UIView *viewStatus;

@property (weak, nonatomic) IBOutlet WMButton *btUpdate;
- (IBAction)updateInfoUser:(id)sender;

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapStatus;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posYConstraintPhone;

@property BOOL isErrorAuth;

@end

@implementation PersonalDataComplementViewController

- (PersonalDataComplementViewController *)initWithPersonalDataDict:(NSDictionary *)dictDataPersonal delegate:(id<personalComplementDelegate>)delegate {
    self = [super initWithTitle:@"Cadastro" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO];
    if (self) {
        _dictDataPersonal = dictDataPersonal;
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
    
    [_scrComplement removeGestureRecognizer:_singleTap];
    [_viewStatus removeGestureRecognizer:_singleTapStatus];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_scrComplement addGestureRecognizer:_singleTap];
    self.singleTapStatus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_viewStatus addGestureRecognizer:_singleTapStatus];
    
    _isCpf = YES;
    
    [self applyMask];
    [self applyRulesToShowForm:_dictDataPersonal];
    
    _btCancel.layer.cornerRadius = 4.0f;
    _btCancel.layer.masksToBounds = YES;
}

#pragma mark - Rules to show correct form

- (void) applyRulesToShowForm:(NSDictionary *) dictData {
    
    LogInfo(@"Dict Personal: %@", dictData);
    
    if (dictData) {
        
        if (![[dictData objectForKey:@"hasDocument"] boolValue] && ![[dictData objectForKey:@"hasPhone"] boolValue]) {
            [self completeAll];
        }
        else if (![[dictData objectForKey:@"hasDocument"] boolValue]) {
            [self completeDocument];
        }
        else if (![[dictData objectForKey:@"hasPhone"] boolValue]) {
            [self completePhone];
        }
        else {
            [self completeAll];
        }
    }
}

- (void) completePhone {
    
    LogInfo(@"Complete Phone!");
    
    _txtCpf.hidden = YES;
    _txtNasc.hidden = YES;
    
    
    //Show only Phones
    _txtPhone.hidden = NO;
    _txtPhoneMobile.hidden = NO;
    
    _posYConstraintPhone.constant = _posYConstraintPhone.constant-118;
}

- (void) completeDocument {
    
    LogInfo(@"Complete Document!");
    
    //Show only CPF and phone
    _txtPhone.hidden = YES;
    _txtPhoneMobile.hidden = YES;
    
    _txtCpf.hidden = NO;
    _txtNasc.hidden = NO;
    
    _posYConstraint.constant = _posYConstraint.constant-118;
}

- (void) completeAll {
    
    LogInfo(@"Complete All!");
    
    _txtPhone.hidden = NO;
    _txtPhoneMobile.hidden = NO;
    
    _txtCpf.hidden = NO;
    _txtNasc.hidden = NO;
}


#pragma mark - Mask TextField

- (void) applyMask {
    
    _txtCpf.mask = @"###.###.###-##";
    _txtCpf.delegate = self;
    _txtPhone.mask          = @"(##) #### ####";
    _txtPhone.delegate = self;
    _txtPhoneMobile.mask    = @"(##) ##### ####";
    _txtPhoneMobile.delegate = self;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.date = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [formatter dateFromString:@"1900-01-01"];
    datePicker.maximumDate = [NSDate date];
    datePicker.backgroundColor = RGBA(255, 255, 255, 1);
    [datePicker addTarget:self action:@selector(updateBirthDate:) forControlEvents:UIControlEventValueChanged];
    [self.txtNasc setInputView:datePicker];
    _txtNasc.pastingEnabled = @NO;
    _txtNasc.cuttingEnabled = @NO;
}

#pragma mark - DatePicker

- (void)updateBirthDate:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)_txtNasc.inputView;
    _txtNasc.text = [picker.date formattedDateWithFormat:@"dd/MM/yyyy"];
}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _txtCpf) {
        
        if ([string isEqualToString:@""]) return YES;
        NSMutableString *mutableResult = [[NSMutableString alloc] initWithString:[textField.text stringByAppendingString:string]];
        NSInteger lenght = mutableResult.length;
        
        NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![acceptableCharactersSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        if (lenght > 18) return NO;
        [mutableResult replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        [mutableResult replaceOccurrencesOfString:@"-" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
        
        BOOL insertedPunctuation = NO;
        //(000.)
        if (lenght > 3)
        {
            [mutableResult insertString:@"." atIndex:3];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(000.000.)
        if (lenght > 7)
        {
            [mutableResult insertString:@"." atIndex:7];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        //(000.000.000-)
        if (lenght > 11)
        {
            [mutableResult insertString:@"-" atIndex:11];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        if (lenght > 14)
        {
            
            [mutableResult replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
            [mutableResult replaceOccurrencesOfString:@"-" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
            [mutableResult replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
            
            [mutableResult insertString:@"." atIndex:2];
            [mutableResult insertString:@"." atIndex:6];
            [mutableResult insertString:@"/" atIndex:10];
            [mutableResult insertString:@"-" atIndex:15];
            textField.text = mutableResult;
            insertedPunctuation = YES;
        }
        
        if (insertedPunctuation) return NO;
        return YES;
    }
    
    if ([textField isKindOfClass:[WMFloatLabelMaskedTextField class]] && textField != _txtCpf) {
        
        WMFloatLabelMaskedTextField *floatLabelTextField = (WMFloatLabelMaskedTextField *)textField;
        if (floatLabelTextField.mask.length > 0) {
            
            return [floatLabelTextField shouldChangeCharactersInRange:range replacementString:string];
        }
    }
    return YES;
}

#pragma mark - Validation of fields

- (void) validateFields {
    
    LogInfo(@"txtCPF: %@", _txtCpf.text);
    LogInfo(@"txtCPF hidden: %i", _txtCpf.hidden);
    
    _isAllOk = YES;
    
    if (_txtCpf.text.length > 14) {
        
        _isCpf = NO;
        
    } else {
        
        _isCpf = YES;
    }
    
    //Validate CPF
    if (!_txtCpf.hidden) {
        
        if (_isCpf) {
            
            if (![self isCPFValid:[self cleanPunctuation:_txtCpf.text]] || _txtCpf.text.length == 0) {
                
                [self showAlertErrorWithMessage:INVALID_CPF_CNPJ inField:_txtCpf];
                
                _txtCpf.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
                
                _isAllOk = NO;
                
            } else {
                _txtCpf.layer.borderColor = _txtCpf.defaultBorderColor;
            }
        }
        else {
            
            NSString *strCnpj = [self cleanPunctuation:_txtCpf.text];
            if (![self isCNPJValid:strCnpj] || _txtCpf.text.length == 0) {
                
                [self showAlertErrorWithMessage:INVALID_CPF_CNPJ inField:_txtCpf];
                
                _txtCpf.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
                
                _isAllOk = NO;
                
            } else {
                _txtCpf.layer.borderColor = _txtCpf.defaultBorderColor;
            }
        }
        
        //Validate brithday date (optional)
        //        if (_txtNasc.raw.length == 0) {
        //
        //            [self showAlertErrorWithMessage:PERSONAL_DATA_WARNING_BIRTH_DATE inField:_txtNasc];
        //
        //            _txtNasc.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
        //        }
        //        else {
        //            _txtNasc.layer.borderColor = _txtNasc.defaultBorderColor;
        //        }
    }
    
    //Validate telephone
    if (!_txtPhone.hidden) {
        
        //        NSString *telephoneRaw = _txtPhone.raw;
        NSString *telephoneRaw = [self cleanPunctuation:_txtPhone.text];
        if ((telephoneRaw.length > 0 && telephoneRaw.length < 9) || (telephoneRaw.length > 2 && ([telephoneRaw characterAtIndex:0] == '0' || [telephoneRaw characterAtIndex:2] == '0' || [telephoneRaw characterAtIndex:2] == '1'))) {
            
            [self showAlertErrorWithMessage:PERSONAL_DATA_WARNING_INVALID_TELEPHONE_LOCAL inField:_txtPhone];
            
            _txtPhone.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
            
            _isAllOk = NO;
            
        } else {
            _txtPhone.layer.borderColor = _txtPhone.defaultBorderColor;
        }
        //Validate mobile phone
        //        NSString *celPhoneRaw = _txtPhoneMobile.raw;
        NSString *celPhoneRaw = [self cleanPunctuation:_txtPhoneMobile.text];
        if ((celPhoneRaw.length > 0 && celPhoneRaw.length < 10) || (celPhoneRaw.length > 2 && ([celPhoneRaw characterAtIndex:0] == '0' || [celPhoneRaw characterAtIndex:2] == '0' || [celPhoneRaw characterAtIndex:2] == '1'))) {
            
            [self showAlertErrorWithMessage:PERSONAL_DATA_WARNING_INVALID_TELEPHONE_CELL inField:_txtPhoneMobile];
            
            _txtPhoneMobile.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
            
            _isAllOk = NO;
            
        } else {
            _txtPhoneMobile.layer.borderColor = _txtPhoneMobile.defaultBorderColor;
        }
        //Validate if one telephone was filled
        if (_txtPhone.text.length == 0 & _txtPhoneMobile.text.length == 0) {
            
            [self showAlertErrorWithMessage:EMPTY_PHONE inField:nil];
            
            _txtPhone.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
            _txtPhoneMobile.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
            
            _isAllOk = NO;
            
        }
    }
    
    if (_isAllOk) {
        
        LogInfo(@"All OK!");
        
        [self updateUserData];
    }
}

- (NSString *)cleanPunctuation:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@")" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return text;
}

- (void) showAlertErrorWithMessage:(NSString *) msg inField:(WMFloatLabelMaskedTextField *) txtField {
    
    [self hideKeyboard];
    
    [self.navigationController.view showAlertWithMessage:msg];
}

- (void) updateInfoUser:(id)sender {
    
    [self hideKeyboard];
    [self validateFields];
}

- (void) updateUserData {
    
    _userPersonalData = [[User alloc] init];
    
    if (!_txtCpf.hidden) {
        
        //        self.userPersonalData.document = _txtCpf.raw;
        self.userPersonalData.document = [self cleanPunctuation:_txtCpf.text];
        
        if (_txtNasc.text.length > 0) {
            
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"dd/MM/yyyy";
            NSDate *birthDate = [formatter dateFromString:_txtNasc.text];
            self.userPersonalData.dateBirth = [birthDate formattedDateWithFormat:@"yyyy-MM-dd"];
        }
    }
    
    if (!_txtPhone.hidden) {
        
        NSMutableArray *phonesMutable = [NSMutableArray new];
        
        if (_txtPhone.text.length > 0) {
            NSDictionary *residentialPhoneDict = @{@"areaCode" : [[self cleanPunctuation:_txtPhone.text] substringToIndex:2],
                                                   @"number" : [[self cleanPunctuation:_txtPhone.text] substringFromIndex:2],
                                                   @"type" : @"RESIDENTIAL"};
            PhoneModel *residentialPhone = [[PhoneModel alloc] initWithDictionary:residentialPhoneDict error:NULL];
            [phonesMutable addObject:residentialPhone];
        }
        
        if (_txtPhoneMobile.text.length > 0) {
            NSDictionary *mobilePhoneDict = @{@"areaCode" : [[self cleanPunctuation:_txtPhoneMobile.text] substringToIndex:2],
                                              @"number" : [[self cleanPunctuation:_txtPhoneMobile.text] substringFromIndex:2],
                                              @"type" : @"MOBILE"};
            PhoneModel *cellPhone = [[PhoneModel alloc] initWithDictionary:mobilePhoneDict error:NULL];
            [phonesMutable addObject:cellPhone];
        }
        
        NSArray *phonesArray = [NSArray arrayWithArray:phonesMutable];
        self.userPersonalData.phones = (NSArray<PhoneModel>*)phonesArray;
    }
    
    [self updateUserDataServer];
}

- (void) updateUserDataServer {
    
    [self.view showModalLoading];
    
    LogInfo(@"CPF   : %@", _userPersonalData.document);
    LogInfo(@"Nasc. : %@", _userPersonalData.dateBirth);
    LogInfo(@"Phones: %@", _userPersonalData.phones);
    
    [WBRUserManager updateUserWithUserPersonalData:self.userPersonalData fromCompleteScreen:YES successBlock:^{
        [WMOmniture trackPersonalDataUpdate];
        [self persistAndUpdateUserData];
    } failureBlock:^(NSError *error) {
        if ((error.code == 400)) {
            LogErro(@"400: %@", error.localizedFailureReason);
            
            self->_isErrorAuth = NO;
            
            [self.view hideModalLoading];
            
            NSData *dataErr = [error.localizedFailureReason dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dataErr options:NSJSONReadingAllowFragments error:&jsonError];
            
            if ([[json objectForKey:@"name"] isEqualToString:@"ValidationError"]) {
                
                if ([json objectForKey:@"errors"]) {
                    
                    NSArray *arrErrors = [json objectForKey:@"errors"];
                    if (arrErrors.count > 0) {
                        
                        if ([[arrErrors objectAtIndex:0] objectForKey:@"message"]) {
                            
                            NSString *strMsgError = [[arrErrors objectAtIndex:0] objectForKey:@"message"];
                            
                            if ([strMsgError isEqualToString:@"Document already exists!"]) {
                                
                                self->_txtCpf.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
                            }
                            else if ([strMsgError isEqualToString:@"Document invalid"]) {
                                
                                self->_txtCpf.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
                            }
                            else if ([strMsgError isEqualToString:@"must be in the past"]) {
                                
                                self->_txtNasc.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
                            }
                            else if ([strMsgError isEqualToString:@"Phone number invalid."]) {
                                
                                self->_txtPhone.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
                                self->_txtPhoneMobile.layer.borderColor = RGBA(243, 123, 32, 1).CGColor;
                            }
                            else {
                                
                                self->_txtCpf.layer.borderColor = RGBA(232, 232, 232, 1).CGColor;
                                self->_txtNasc.layer.borderColor = RGBA(232, 232, 232, 1).CGColor;
                                self->_txtPhone.layer.borderColor = RGBA(232, 232, 232, 1).CGColor;
                                self->_txtPhoneMobile.layer.borderColor = RGBA(232, 232, 232, 1).CGColor;
                            }
                        }
                    }
                }
            }
            
            [self showUserAlertWithMsg:error.localizedDescription];
        }
        else if (error.code == 401) {
            LogErro(@"401!");
            
            self->_isErrorAuth = YES;
            [self.view hideModalLoading];
            [self showUserAlertWithMsg:ERROR_CONNECTION_AUTH_COMPLEMENT];
        }
        else {
            LogErro(@"Others errors");
            
            self->_isErrorAuth = NO;
            
            [self.view hideModalLoading];
            
            [self showUserAlertWithMsg:ERROR_CONNECTION_UNKNOWN];
        }
    }];
}

- (void)persistAndUpdateUserData
{
    [User persist];

    [self.view hideLoading];
    [self.navigationController popViewControllerAnimated:YES];
    
    //Continue checkout
    [[self delegate] successFromComplement];
}

- (void) showUserAlertWithMsg:(NSString *) msg {
    
    [self hideKeyboard];
    [self.view showAlertWithMessage:msg dismissBlock:^{
        if (self->_isErrorAuth) {
            MDSSqlite *sq = [MDSSqlite new];
            [sq deleteAllTokenCheckout];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Gesture Touch
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    [self hideKeyboard];
}

- (void) hideKeyboard {
    
    [_txtPhone resignFirstResponder];
    [_txtNasc resignFirstResponder];
    [_txtCpf resignFirstResponder];
    [_txtPhoneMobile resignFirstResponder];
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)sender
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 250, 0);
    _scrComplement.contentInset = insets;
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    _scrComplement.contentInset = insets;
}

#pragma mark - Cancel screen

- (IBAction)closeComplement:(id)sender {
    
    [_txtPhone resignFirstResponder];
    [_txtNasc resignFirstResponder];
    [_txtCpf resignFirstResponder];
    [_txtPhoneMobile resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CPF and CNPJ validation

- (BOOL)isCPFValid:(NSString *)cpf
{
    NSInteger sumCheckDigit1 = 0, sumCheckDigit2 = 0, checkDigit1 = -1, checkDigit2 = -1;
    if ((cpf.length != 11) ||
        ([cpf isEqualToString:@"00000000000"]) ||
        ([cpf isEqualToString:@"11111111111"]) ||
        ([cpf isEqualToString:@"22222222222"]) ||
        ([cpf isEqualToString:@"33333333333"]) ||
        ([cpf isEqualToString:@"44444444444"]) ||
        ([cpf isEqualToString:@"55555555555"]) ||
        ([cpf isEqualToString:@"66666666666"]) ||
        ([cpf isEqualToString:@"77777777777"]) ||
        ([cpf isEqualToString:@"88888888888"]) ||
        ([cpf isEqualToString:@"99999999999"]))
        return NO;
    else
    {
        for (NSInteger i = cpf.length; i > 2; i--)
        {
            NSRange range = NSMakeRange(cpf.length - i,1);
            NSInteger value = [[cpf substringWithRange:range] integerValue];
            sumCheckDigit1 += value * (i-1);
            sumCheckDigit2 += value * i;
        }
        
        checkDigit1 = 11 - (sumCheckDigit1 % cpf.length);
        if (checkDigit1 >= 10)
            checkDigit1 = 0;
        sumCheckDigit2 += 2 * checkDigit1;
        checkDigit2 = 11 - (sumCheckDigit2 % cpf.length);
        if (checkDigit2 >= 10)
            checkDigit2 = 0;
        
        
        NSRange range9 = NSMakeRange(9, 1);
        NSRange range10 = NSMakeRange(10, 1);
        
        return ((checkDigit1 == [[cpf substringWithRange:range9] integerValue])
                && (checkDigit2 == [[cpf substringWithRange:range10] integerValue]));
    }
}

- (BOOL)isCNPJValid:(NSString *)cnpj
{
    
    LogInfo(@"CNPJ: %@", cnpj);
    
    NSInteger sumCheckDigit1 = 0, sumCheckDigit2 = 0, checkDigit1 = -1, checkDigit2 = -1;
    if ((cnpj.length != 14) ||
        ([cnpj isEqualToString:@"00000000000000"]) ||
        ([cnpj isEqualToString:@"11111111111111"]) ||
        ([cnpj isEqualToString:@"22222222222222"]) ||
        ([cnpj isEqualToString:@"33333333333333"]) ||
        ([cnpj isEqualToString:@"44444444444444"]) ||
        ([cnpj isEqualToString:@"55555555555555"]) ||
        ([cnpj isEqualToString:@"66666666666666"]) ||
        ([cnpj isEqualToString:@"77777777777777"]) ||
        ([cnpj isEqualToString:@"88888888888888"]) ||
        ([cnpj isEqualToString:@"99999999999999"]))
        return NO;
    else
    {
        NSInteger multiplyFactor = 6;
        for (NSInteger i = cnpj.length; i > 2; i--)
        {
            NSRange range = NSMakeRange((cnpj.length - i),1);
            NSInteger value = [[cnpj substringWithRange:range] integerValue];
            
            if (multiplyFactor == 2)
                sumCheckDigit1 += value * 9;
            else
                sumCheckDigit1 += value * (multiplyFactor-1);
            sumCheckDigit2 += value * multiplyFactor;
            
            if (multiplyFactor == 2)
                multiplyFactor = 9;
            else
                multiplyFactor--;
        }
        
        checkDigit1 = 11 - (sumCheckDigit1 % 11);
        if (checkDigit1 >= 10)
            checkDigit1 = 0;
        sumCheckDigit2 += 2 * checkDigit1;
        checkDigit2 = 11 - (sumCheckDigit2 % 11);
        if (checkDigit2 >= 10)
            checkDigit2 = 0;
        
        NSRange range12 = NSMakeRange(12, 1);
        NSRange range13 = NSMakeRange(13, 1);
        
        return ((checkDigit1 == [[cnpj substringWithRange:range12] integerValue])
                && (checkDigit2 == [[cnpj substringWithRange:range13] integerValue]));
    }
}

@end
