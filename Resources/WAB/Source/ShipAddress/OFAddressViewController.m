//
//  OFAddressViewController.m
//  Ofertas
//
//  Created by Marcelo Santos on 9/23/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFAddressViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+HTML.h"
#import "OFLoginViewController.h"
#import "UIImage+Additions.h"
#import "NSString+Validation.h"

@interface OFAddressViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewAlert;
@property (weak, nonatomic) IBOutlet UIView *viewAlertBlack;

@property (weak, nonatomic) IBOutlet UIView *viewUpperBar;
@property (weak, nonatomic) IBOutlet UIView *viewComboTypeAddress;
@property (weak, nonatomic) IBOutlet UIView *viewComboType;
@property (weak, nonatomic) IBOutlet UIView *viewAddress;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIView *zipCodeBoxView;
@property (weak, nonatomic) IBOutlet UIView *addressBoxView;

@property (assign, nonatomic) BOOL addressOn;
@property (assign, nonatomic) BOOL isSkin;

@property (weak, nonatomic) IBOutlet WMButton *btSearch;
@property (weak, nonatomic) IBOutlet WMButton *btAdd;
@property (weak, nonatomic) IBOutlet UIButton *btCancel;

@property (weak, nonatomic) IBOutlet UILabel *lblAddAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblShipment;

@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtTypeAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtStreet;
@property (weak, nonatomic) IBOutlet UITextField *txtNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtNeighborhood;
@property (weak, nonatomic) IBOutlet UITextField *txtComplement;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtReference;
@property (weak, nonatomic) IBOutlet UIButton *btShowHideCombo;

@property (weak, nonatomic) IBOutlet UIScrollView *scrAddress;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

@property (strong, nonatomic) NSDictionary *skinDict;
@property (strong, nonatomic) NSDictionary *addressDict;
@property (strong, nonatomic) NSString *operation;
@property (strong, nonatomic) WMConnectionAddress *connectionAddress;
@property (strong, nonatomic) NSString *lastZipCode;
@property (assign, nonatomic) BOOL isKeyboardVisible;

@end

@implementation OFAddressViewController

- (OFAddressViewController *)initWithOperation:(NSString *)operation dictAddress:(NSDictionary *)dictAddress delegate:(id<addressAddDelegate>)delegate {
    NSString *title = [operation isEqualToString:@"editAddress"] ? @"Editar endereço" : @"Adicionar endereço";
    self = [super initWithTitle:title isModal:YES searchButton:NO cartButton:NO wishlistButton:NO];
    if (self) {
        _delegate = delegate;
        
        NSDictionary *dictSkin = [OFSkinInfo getSkinDictionary];
        self.skinDict = dictSkin;
        self.operation = operation;
        self.addressDict = dictAddress;
        
        self.connectionAddress = [WMConnectionAddress new];
        _connectionAddress.delegate = self;
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [FlurryWM logEvent_checkout_new_address_entering];
    [self registerKeyboardNotifications];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    _zipCodeBoxView.layer.cornerRadius = 3.0f;
    _zipCodeBoxView.layer.borderWidth = 1.0f;
    _zipCodeBoxView.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
    _zipCodeBoxView.layer.masksToBounds = YES;
    _zipCodeBoxView.clipsToBounds = YES;
    
    _addressBoxView.layer.cornerRadius = 3.0f;
    _addressBoxView.layer.borderWidth = 1.0f;
    _addressBoxView.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
    _addressBoxView.layer.masksToBounds = YES;
    _addressBoxView.clipsToBounds = YES;
    
    _viewAlertBlack.layer.cornerRadius = 10.0f;
    _viewAlertBlack.layer.masksToBounds = YES;
    _viewAlert.hidden = YES;
    
    _txtTypeAddress.text = @"";
    
    _viewAddress.hidden = YES;
    _btAdd.hidden = YES;
    
    //Change for edit mode
    if ([_operation isEqualToString:@"editAddress"])
    {
        _lblShipment.text = @"Alterar endereço";
        _lblAddAddress.text = @"Alterar endereço de entrega";
        _viewAddress.hidden = NO;
        _btAdd.hidden = NO;
        
        [_btAdd setTitle:@"Alterar" forState:UIControlStateNormal];
        [_btAdd setTitle:@"Alterar" forState:UIControlStateHighlighted];
        
        _txtZipCode.text = _addressDict[@"postalCode"];
        self.lastZipCode = _txtZipCode.text;
        _txtName.text = _addressDict[@"receiverName"];
        
        NSString *strType = _addressDict[@"type"];
        if ([strType isEqualToString:@"BUSINESS"])
        {
            strType = @"Comercial";
        }
        else if ([strType isEqualToString:@"RESIDENTIAL"])
        {
            strType = @"Residencial";
        }
        _txtTypeAddress.text = strType;
        
        _txtStreet.text = _addressDict[@"street"];
        _txtNumber.text = _addressDict[@"number"];
        _txtNeighborhood.text = _addressDict[@"neighborhood"];
        _txtComplement.text = _addressDict[@"complement"];
        _txtState.text = _addressDict[@"state"];
        _txtCity.text = _addressDict[@"city"];
        _txtReference.text = _addressDict[@"referencePoint"];
    }
    
    _actInd.hidden = YES;
    
    _btSearch.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13];
    
    _viewComboType.layer.cornerRadius = 4.0f;
    _viewComboType.layer.masksToBounds = YES;

    _viewComboTypeAddress.layer.cornerRadius = 4.0f;
    _viewComboTypeAddress.layer.masksToBounds = YES;
    _lblAddAddress.textAlignment = NSTextAlignmentCenter;
    
    //Tags textfields
    _txtZipCode.tag = 0;
    _txtName.tag = 1;
    _txtTypeAddress.tag = 2;
    _txtStreet.tag = 3;
    _txtNumber.tag = 4;
    _txtNeighborhood.tag = 5;
    _txtComplement.tag = 6;
    _txtState.tag = 7;
    _txtCity.tag = 8;
    _txtReference.tag = 9;
    
    if ([OFSetup backgroundEnable])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
            [self showHideCombo];
            break;
            
        case 3:
        case 4:
        case 5:
        case 6:
            [textField becomeFirstResponder];
            break;
            
        case 9:
            [self addAddress];
            break;
            
        default:
            break;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByAppendingString:string];
    NSInteger lenght = text.length;
    
    if (textField == _txtZipCode || textField == _txtNumber)
    {
        NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSRange setRange = [string rangeOfCharacterFromSet:[acceptableCharactersSet invertedSet]];
        if (setRange.location != NSNotFound || (textField == _txtZipCode && lenght > 8) || (textField == _txtNumber && lenght > 9))
        {
            return NO;
        }
    }
    
    NSArray *oneHundredLengthTextFields = @[_txtName, _txtTypeAddress, _txtNeighborhood, _txtComplement];
    if (([oneHundredLengthTextFields containsObject:textField] && lenght > 100) || (textField == _txtStreet && lenght > 150) || (textField == _txtReference && lenght > 200))
    {
        return NO;
    }
    
    return YES;
}

- (void)zipInfos:(NSDictionary *)infos Error:(NSError *)error
{
    _actInd.hidden = YES;
    _txtName.enabled = YES;
    _txtTypeAddress.enabled = YES;
    _txtStreet.enabled = YES;
    _txtNumber.enabled = YES;
    _txtNeighborhood.enabled = YES;
    _txtComplement.enabled = YES;
    _txtState.enabled = YES;
    _txtCity.enabled = YES;
    _txtReference.enabled = YES;
    _btShowHideCombo.enabled = YES;
    
    if (infos && !error)
    {
        LogInfo(@"SUCESSO!\n%@",infos);
        NSString *strStreet = infos[@"street"];
        LogInfo(@"Street i18n Old: %@", strStreet);
        strStreet = [strStreet kv_decodeHTMLCharacterEntities];
        LogInfo(@"Street i18n New: %@", strStreet);
        
        if (![_operation isEqualToString:@"editAddress"])
        {
            _viewAddress.hidden = NO;
            _btAdd.hidden = NO;
        }
        
        _txtCity.text = infos[@"city"];
        _txtState.text = infos[@"stateAcronym"];
        _txtStreet.text = strStreet.length > 2 ? strStreet : @"";
        _txtNeighborhood.text = infos[@"neighborhood"];
        
        self.lastZipCode = _txtZipCode.text;
    }
    else
    {
        [self showAlertWithMessage:error.localizedDescription];
    }
}

- (void) showAddress
{
    _viewAddress.hidden = NO;
    _btAdd.hidden = NO;
    _actInd.hidden = YES;
    [_txtName becomeFirstResponder];
}

- (NSString *)validateAddressAndGetErrorMessage
{
    OFMessages *mes = [[OFMessages alloc] init];
    
    if (_txtName.text.length < 3 || ![_txtName.text isName])
    {
        return INVALID_NAME_DESTINY;
    }
    else if (_txtName.text.length == 0)
    {
        return [NSString stringWithFormat:@"%@ %@", [mes emptyGeneralMessage], [mes emptyLabelName]];
    }
    else if (_txtTypeAddress.text.length == 0)
    {
        return [NSString stringWithFormat:@"%@ %@", [mes emptyGeneralMessage], [mes emptyLabelAddressType]];
    }
    else if (_txtStreet.text.length == 0)
    {
        return [NSString stringWithFormat:@"%@ %@", [mes emptyGeneralMessage], [mes emptyLabelStreet]];
    }
    else if (_txtNeighborhood.text.length == 0)
    {
        return [NSString stringWithFormat:@"%@ %@", [mes emptyGeneralMessage], [mes emptyLabelNeighborhood]];
    }
    else if (_txtNumber.text.length == 0)
    {
        return [NSString stringWithFormat:@"%@ %@", [mes emptyGeneralMessage], [mes emptyLabelNumber]];
    }
    else if (_txtZipCode.text.length == 0)
    {
        return [NSString stringWithFormat:@"%@ %@", [mes emptyGeneralMessage], [mes emptyLabelZipcode]];
    }
    else if (![_txtZipCode.text isEqualToString:_lastZipCode])
    {
        return [mes zipCodeChangedMessage];
    }
    return nil;
}

- (NSDictionary *)getAddressDict
{
    NSString *addressType = ([_txtTypeAddress.text isEqualToString:@"Comercial"]) ? @"BUSINESS" : @"RESIDENTIAL";
    NSString *zip = [_txtZipCode.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return @{@"receiverName" : _txtName.text,
             @"country" : @"Brasil",
             @"state" : _txtState.text,
             @"city" : _txtCity.text,
             @"neighborhood" : _txtNeighborhood.text,
             @"street" : _txtStreet.text,
             @"number" : _txtNumber.text,
             @"complement" : _txtComplement.text,
             @"postalCode" : zip,
             @"type" : addressType,
             @"referencePoint" : _txtReference.text};
}

- (void) addAddress
{
    [self hideKeyboard];
    NSString *validationErrorMessage = [self validateAddressAndGetErrorMessage];
    if (validationErrorMessage.length > 0) {
        [self showAlertWithMessage:validationErrorMessage];
    }
    else
    {
        [self showModalLoading];
        [_connectionAddress newAddressWithDictionary:[self getAddressDict]];
    }
}

- (void)addressUpdated:(NSError *)error
{
    dispatch_async( dispatch_get_main_queue(), ^{
        [self hideModalLoading];
        if (error == nil)
        {
            //Sucesso
            if ([_delegate respondsToSelector:@selector(addressViewController:updatedAddress:)])
            {
                [_delegate addressViewController:self updatedAddress:[self getAddressDict]];
            }
        }
        else
        {
            NSString *msgAlert = error.localizedDescription;
            if (error.code == 408) {
                msgAlert = ERROR_CONNECTION_TIMEOUT;
            }
            [self showAlertWithMessage:msgAlert];
        }
    });
}

- (void)refreshAddress
{
    //    [FlurryController logButtonTouch:@"Salvar" inScreen:@"Editar endereço de entrega"];
    [self hideKeyboard];
    
    NSString *validationErrorMessage = [self validateAddressAndGetErrorMessage];
    if (validationErrorMessage.length > 0)
    {
        [self showAlertWithMessage:validationErrorMessage];
    }
    else
    {
        [self showModalLoading];
        [_connectionAddress updateAddressWithDictionary:[self getAddressDict] forAddressID:_addressDict[@"id"]];
    }
}

- (void)newAddressCreation:(NSError *)error
{
    [self hideModalLoading];
    if (error == nil)
    {
        //Sucesso
        if ([_delegate respondsToSelector:@selector(addressViewController:addedNewAddress:)])
        {
            [_delegate addressViewController:self addedNewAddress:[self getAddressDict]];
        }
    }
    else
    {
        [self showAlertWithMessage:error.localizedDescription];
    }
}

- (void)newAddressError:(NSString *)error
{
    [self showAlertWithMessage:error];
}

- (void) showHideCombo
{
    _viewComboTypeAddress.layer.cornerRadius = 4.0f;
    _viewComboTypeAddress.layer.masksToBounds = YES;
    if (_addressOn)
    {
        _viewComboTypeAddress.hidden = YES;
        self.addressOn = NO;
    }
    else
    {
        _viewComboTypeAddress.hidden = NO;
        self.addressOn = YES;
    }
}

- (IBAction)pressedSearch
{
    [FlurryWM logEvent_checkout_new_address_search_btn];
    
    _txtTypeAddress.text = @"";
    _txtStreet.text = @"";
    _txtNumber.text = @"";
    _txtNeighborhood.text = @"";
    _txtComplement.text = @"";
    _txtState.text = @"";
    _txtCity.text = @"";
    _txtReference.text = @"";
    
    _txtName.enabled = NO;
    _txtTypeAddress.enabled = NO;
    _txtStreet.enabled = NO;
    _txtNumber.enabled = NO;
    _txtNeighborhood.enabled = NO;
    _txtComplement.enabled = NO;
    _txtState.enabled = NO;
    _txtCity.enabled = NO;
    _txtReference.enabled = NO;
    _btShowHideCombo.enabled = NO;
    
    if (_txtZipCode.text.length >= 8)
    {
        _actInd.hidden = NO;
        [self hideKeyboard];
        NSString *correctCep = [_txtZipCode.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [_connectionAddress getInfosFromZip:correctCep];
    }
    else
    {
        [self hideKeyboard];
        [self showAlertWithMessage:[[OFMessages new] zipCodeInvalidMessage]];
    }
}

- (void) typeResidential
{
    _txtTypeAddress.text = @"Residencial";
    _viewComboTypeAddress.hidden = YES;
    self.addressOn = NO;
    [_txtStreet becomeFirstResponder];
}

- (void) typeCommercial
{
    _txtTypeAddress.text = @"Comercial";
    _viewComboTypeAddress.hidden = YES;
    self.addressOn = NO;
    [_txtStreet becomeFirstResponder];
}

- (void)refreshButtonPressed
{
    if ([_operation isEqualToString:@"editAddress"])
    {
        [self performSelector:@selector(refreshAddress) withObject:nil afterDelay:0.1];
    }
    else
    {
        [self performSelector:@selector(addAddress) withObject:nil afterDelay:0.1];
    }
}

#pragma mark - Keyboard
- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.isKeyboardVisible = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!self.isKeyboardVisible)
    {
        NSDictionary* info = [notification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.scrAddress.contentInset = contentInsets;
        self.scrAddress.scrollIndicatorInsets = contentInsets;
        self.isKeyboardVisible = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.isKeyboardVisible)
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.scrAddress.contentInset = contentInsets;
        self.scrAddress.scrollIndicatorInsets = contentInsets;
        self.isKeyboardVisible = NO;
    }
}

- (void) hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)handleBackground:(NSNotification *)notification
{
    LogInfo(@"Background OFAddressViewController");
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

@end
