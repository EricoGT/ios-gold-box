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
#import "WMFloatLabelMaskedTextField.h"
#import "WMPickerTextField.h"
#import "MyAddressesConnection.h"
#import "ZipCodeModel.h"
#import "AddressModel.h"
#import "WBRNavigationBarButtonItemFactory.h"
#import "UIColor+Pallete.h"
#import "WMOmniture.h"

#import "WBRAddressManager.h"

@interface OFAddressViewController () <WMPickerTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (weak, nonatomic) IBOutlet WMButtonRounded *btAdd;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtZipCode;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtName;
@property (weak, nonatomic) IBOutlet WMPickerTextField *txtTypeAddress;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtStreet;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtNumber;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtNeighborhood;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtComplement;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtState;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtCity;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtReference;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtAddressDescription;

@property (nonatomic, weak) IBOutlet UIButton *mainAdressCheckmarkButton;
@property (nonatomic, assign) BOOL mainAddress;

@property (weak, nonatomic) IBOutlet UIButton *noNumberToggleButton;
@property (nonatomic, assign) BOOL noNumber;
@property (weak, nonatomic) IBOutlet UILabel *noNumberLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSDictionary *skinDict;
@property (strong, nonatomic) NSDictionary *addressDict;
@property (strong, nonatomic) NSString *operation;
@property (strong, nonatomic) NSString *lastZipCode;
@property (assign, nonatomic) BOOL isKeyboardVisible;

@property (nonatomic, strong) NSArray *addressTypes;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *cityActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *stateActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *zipCodeActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *streetActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *neighborhoodActivityIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionButtomContainerBottomConstraint;
@property (assign, nonatomic) CGFloat defaultActionButtomContainerBottomConstraint;

@property (nonatomic, strong) NSString *alertMsg;

@end

@implementation OFAddressViewController

- (OFAddressViewController *)initWithOperation:(NSString *)operation dictAddress:(NSDictionary *)dictAddress delegate:(id<addressAddDelegate>)delegate {
    
    NSString *title =  @"Adicionar endereço";
    
    if ([operation isEqualToString:@"editAddress"]) {
        title =  @"Editar endereço";
    }
    else if ([operation isEqualToString:@"addAddress"]) {
        title =  @"Onde receber?";
    }

    self = [super initWithTitle:title isModal:YES searchButton:NO cartButton:NO wishlistButton:NO];
    if (self) {
        _delegate = delegate;
        
        NSDictionary *dictSkin = [OFSkinInfo getSkinDictionary];
        self.skinDict = dictSkin;
        self.operation = operation;
        self.addressDict = dictAddress;
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
    
    [self customizeNavigationBar];
    
    [WMOmniture trackCheckoutNewAddressScreen];
    [FlurryWM logEvent_checkout_new_address_entering];
    
    [self setupView];
    [self setUpTextFields];
    [self setUpActivityIndicators];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    self.addressTypes = @[@"Residencial", @"Comercial"];
    self.txtTypeAddress.options = self.addressTypes;
    self.txtTypeAddress.wmPickerTextFieldDelegate = self;

    //Change for edit mode
    if ([_operation isEqualToString:@"editAddress"])
    {
        [_btAdd setTitle:@"Alterar" forState:UIControlStateNormal];
        [_btAdd setTitle:@"Alterar" forState:UIControlStateHighlighted];
        
        
        NSString *lastZipCodeInserted = self.addressDict[@"postalCode"];
        lastZipCodeInserted = [lastZipCodeInserted stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if (lastZipCodeInserted.length == 8)
        {
            NSMutableString *mutableZipCode = [NSMutableString stringWithString:lastZipCodeInserted];
            [mutableZipCode insertString:@"-" atIndex:5];
            lastZipCodeInserted = mutableZipCode.copy;
        }
        
        _txtZipCode.text = lastZipCodeInserted;
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
        NSString *streetNameDecoded = [_addressDict[@"street"] kv_decodeHTMLCharacterEntities];
        _txtStreet.text = streetNameDecoded;
        _txtNumber.text = _addressDict[@"number"];
        _txtNeighborhood.text = _addressDict[@"neighborhood"];
        _txtComplement.text = _addressDict[@"complement"];
        _txtState.text = _addressDict[@"state"];
        
        _txtCity.text = _addressDict[@"city"];
        _txtReference.text = _addressDict[@"referencePoint"];
        _txtAddressDescription.text = [_addressDict objectForKey:@"description"];
        [self setMainAddress:[_addressDict[@"default"] boolValue]];
        [self setNoNumber: [_addressDict[@"number"] isEqualToString: kAddressNoNumberDefaultValue]];

    } else {
        [self setupForNewAddress];
    }
    
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
    _txtAddressDescription.tag = 10;
    
    if ([OFSetup backgroundEnable])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    [self backButtonSetup];
}

- (void)customizeNavigationBar {
    
    self.navigationItem.rightBarButtonItem = [WBRNavigationBarButtonItemFactory createBarButtonItemWithImageString:@"imgCartAddressNavbar" andFrameRect:CGRectMake(0, 0, 62, 44)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self applyShadowViewBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupConstraints];
}

#pragma mark - Setup View

- (void)setupView
{
    [self.btAdd setTitle:@"Utilizar este endereço" forState:UIControlStateNormal];
    
    //Notifications (Keyboard)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setUpTextFields
{
    self.txtZipCode.mask = @"#####-###";
    
    [self.txtState setEnabled:NO];
    [self.txtState setTextColor:[UIColor colorWithWMBColorOption:WMBColorOptionDarkGray]];
    
    [self.txtCity setEnabled:NO];
    [self.txtCity setTextColor:[UIColor colorWithWMBColorOption:WMBColorOptionDarkGray]];
}

- (void)setUpActivityIndicators
{
    self.streetActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.neighborhoodActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.zipCodeActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.stateActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.cityActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
}

- (void)applyShadowViewBottom {
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_viewBottom.bounds];
    _viewBottom.layer.masksToBounds = NO;
    _viewBottom.layer.shadowColor = [UIColor blackColor].CGColor;
    _viewBottom.layer.shadowOffset = CGSizeMake(0.0f, -7.0f);
    _viewBottom.layer.shadowOpacity = 0.2f;
    _viewBottom.layer.shadowRadius = 4.0f;
    _viewBottom.layer.shadowPath = shadowPath.CGPath;
}

- (void)setupForNewAddress
{
    [self.mainAdressCheckmarkButton setImage:[UIImage imageNamed:@"btn_checkbox_off.png"] forState:UIControlStateNormal];
    [self.mainAdressCheckmarkButton setImage:[UIImage imageNamed:@"btn_checkbox_off.png"] forState:UIControlStateHighlighted];
    self.mainAddress = NO;
    self.noNumber = NO;
}

- (void)setupConstraints
{
    self.defaultActionButtomContainerBottomConstraint = self.actionButtomContainerBottomConstraint.constant;
}


#pragma mark - Zip Code
- (void)searchZipCode
{
    [FlurryWM logEvent_checkout_new_address_search_btn];

    [WMOmniture trackAddressZipSearch];
    
    [self.scrollView endEditing:YES];
    [self startZipCodeLoading];
    
    [[MyAddressesConnection new] getZipCodeData:self.txtZipCode.raw completionBlock:^(ZipCodeModel *zipCode)
     {
         dispatch_async(dispatch_get_main_queue(), ^(void)
                        {
                            [self stopZipCodeLoading];
                            [self updateZipCodeInfo:zipCode];
                        });
     }
                                        failure:^(NSString *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^(void)
                        {
                            [self stopZipCodeLoading];
                            [self.view showFeedbackAlertOfKind:WarningAlert message:ADDRESS_WARNING_ZIP];
                        });
     }];
}

- (void)updateZipCodeInfo:(ZipCodeModel *)model
{
    NSString *streetNameDecoded = [model.street kv_decodeHTMLCharacterEntities];
    self.txtStreet.text = [NSString stringWithFormat:@"%@ %@", model.streetType, streetNameDecoded];
    if ([self.txtStreet.text isEqualToString:@" "]) {
        self.txtStreet.text = @"";
    }
    
    self.txtNeighborhood.text = model.neighborhood ?: @"";
    self.txtCity.text = model.city ?: @"";
    self.txtState.text = model.stateAcronym ?: @"";
}

#pragma mark - Loading
- (void)startZipCodeLoading
{
    [self.txtZipCode setEnabled:NO];
    [self.streetActivityIndicator startAnimating];
    [self.neighborhoodActivityIndicator startAnimating];
    [self.cityActivityIndicator startAnimating];
    [self.stateActivityIndicator startAnimating];
    [self.zipCodeActivityIndicator startAnimating];
}

- (void)stopZipCodeLoading
{
    [self.txtZipCode setEnabled:YES];
    [self.streetActivityIndicator stopAnimating];
    [self.neighborhoodActivityIndicator stopAnimating];
    [self.cityActivityIndicator stopAnimating];
    [self.stateActivityIndicator stopAnimating];
    [self.zipCodeActivityIndicator stopAnimating];
}

#pragma mark Main Address Button States
- (void)mainAddressPressed:(id)sender
{
    self.mainAddress = !self.mainAddress;
}

- (void)setMainAddress:(BOOL)mainAddress
{
    _mainAddress = mainAddress;
    if (mainAddress)
    {
        [self.mainAdressCheckmarkButton setImage:[UIImage imageNamed:@"btn_checkbox_on.png"] forState:UIControlStateNormal];
        [self.mainAdressCheckmarkButton setImage:[UIImage imageNamed:@"btn_checkbox_on.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.mainAdressCheckmarkButton setImage:[UIImage imageNamed:@"btn_checkbox_off.png"] forState:UIControlStateNormal];
        [self.mainAdressCheckmarkButton setImage:[UIImage imageNamed:@"btn_checkbox_off.png"] forState:UIControlStateHighlighted];
    }
}

#pragma mark No Number Button States

- (IBAction)noNumberPressed:(id)sender {
    self.noNumber = !self.noNumber;
}

- (void)setNoNumber:(BOOL)noNumber {
    _noNumber = noNumber;
    if (noNumber)
    {
        [self.noNumberToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_on.png"] forState:UIControlStateNormal];
        [self.noNumberToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_on.png"] forState:UIControlStateHighlighted];
        
        self.txtNumber.text = @"S/N";
        [self.txtNumber setEnabled:NO];
        [self.txtNumber setTextColor:[UIColor colorWithWMBColorOption:WMBColorOptionDarkGray]];
        
        [self.noNumberLabel setTextColor:[UIColor colorWithWMBColorOption:WMBColorOptionDarkGray]];
    }
    else
    {
        [self.noNumberToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_off.png"] forState:UIControlStateNormal];
        [self.noNumberToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_off.png"] forState:UIControlStateHighlighted];
        
        [self.txtNumber setEnabled:YES];
        if ([self.txtNumber.text isEqualToString: kAddressNoNumberDefaultString])
        {
            self.txtNumber.text = @"";
        }
        
        [self.noNumberLabel setTextColor: [UIColor colorWithWMBColorOption:WMBColorOptionLightBlue]];
    }
}

#pragma mark - Keyboard
- (void) hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [UIView animateWithDuration:.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
        self.actionButtomContainerBottomConstraint.constant = self.defaultActionButtomContainerBottomConstraint;
        
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView animateWithDuration:.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
        self.actionButtomContainerBottomConstraint.constant = self.defaultActionButtomContainerBottomConstraint + keyboardRect.size.height;
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - BackButton override

- (void)backButtonSetup {
    //Back button action
    UIButton *customBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [UIImage imageNamed:@"ic_ignore"];
    [customBackButton setImage:btnImg forState:UIControlStateNormal];
    customBackButton.frame = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
    [customBackButton addTarget:self action:@selector(pressedBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBackButton];
}

- (void)pressedBackButtonAction {
    if ([self.delegate respondsToSelector:@selector(closeAddAddressController:)]) {
        [self.delegate closeAddAddressController:self];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
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
    if ([textField isKindOfClass:[WMFloatLabelMaskedTextField class]])
    {
        WMFloatLabelMaskedTextField *floatLabelTextField = (WMFloatLabelMaskedTextField *)textField;
        if (floatLabelTextField.mask.length > 0)
        {
            BOOL shouldChangeChars = NO;
            shouldChangeChars = [floatLabelTextField shouldChangeCharactersInRange:range replacementString:string];
            
            if (textField == self.txtZipCode && textField.text.length == 9)
            {
                [self searchZipCode];
            }
            
            return shouldChangeChars;
        }
    }
    
    if (textField == self.txtName)
    {
        if (self.txtName.text.length + string.length > 100)
        {
            return NO;
        }
        
        NSMutableCharacterSet *filteredChars = [NSMutableCharacterSet alphanumericCharacterSet];
        [filteredChars formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
        NSCharacterSet *blockedCharSet = [filteredChars invertedSet];
        return [string rangeOfCharacterFromSet:blockedCharSet].location == NSNotFound;
    }
    
    
    NSString *text = [textField.text stringByAppendingString:string];
    NSInteger lenght = text.length;
    
    if (textField == _txtZipCode || textField == _txtNumber)
    {
        NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSRange setRange = [string rangeOfCharacterFromSet:[acceptableCharactersSet invertedSet]];
        if (setRange.location != NSNotFound || (textField == _txtZipCode && lenght > 8) || (textField == _txtNumber && lenght > 6))
        {
            return NO;
        }
    }
    
    BOOL isBackSpaceKey = ([string isEqualToString:@""]) ? YES : NO;
    
    if (!isBackSpaceKey) {
        NSArray *oneHundredLengthTextFields = @[_txtName, _txtTypeAddress, _txtNeighborhood, _txtComplement];
        if (([oneHundredLengthTextFields containsObject:textField] && lenght > 100) || (textField == _txtStreet && lenght > 150) || (textField == _txtReference && lenght > 200) || (textField == _txtAddressDescription && lenght > 15 ))
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.txtTypeAddress)
    {
        if (self.txtTypeAddress.text.length == 0)
        {
            self.txtTypeAddress.text = self.addressTypes[0];
        }
    }
}

- (void) showAddress
{
    [_txtName becomeFirstResponder];
}

- (NSArray *)validateAndGetInvalidFields
{
    self.alertMsg = nil;
    NSMutableArray *invalidFields = [NSMutableArray new];
    
    if (self.txtName.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_NAME;
        [invalidFields addObject:self.txtName];
    }
    else
    {
        NSMutableArray *components = [NSMutableArray arrayWithArray:[self.txtName.text componentsSeparatedByString:@" "]];
        NSArray *namesAux = [NSArray arrayWithArray:components];
        NSMutableArray *namesMutable = [NSMutableArray new];
        for (NSString *str in namesAux)
        {
            if (str.length > 0)
            {
                [namesMutable addObject:str];
            }
        }
        if (namesMutable.count == 1)
        {
            if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_NAME;
            [invalidFields addObject:self.txtName];
        }
    }
    
    if (self.txtZipCode.text.length == 0) {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_ZIP_CODE;
        [invalidFields addObject:self.txtZipCode];
    }
    
    if (self.txtTypeAddress.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_ADDRESS_TYPE;
        [invalidFields addObject:self.txtTypeAddress];
    }
    
    if (self.txtStreet.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_STREET;
        [invalidFields addObject:self.txtStreet];
    }
    
    if (self.txtNeighborhood.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_NEIGHBORHOOD;
        [invalidFields addObject:self.txtNeighborhood];
    }
    
    if (self.txtNumber.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_NUMBER;
        [invalidFields addObject:self.txtNumber];
    }
    
    return invalidFields.copy;
}

- (BOOL)validateFields {
    
    NSArray *invalidFields = [self validateAndGetInvalidFields];
    if (invalidFields.count > 0) {
        [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message: self.alertMsg];
        for (UIView *fieldView in invalidFields) {
            fieldView.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        }
        
        return NO;
    }
    return YES;
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
             @"number" : _noNumber ? @"0" : _txtNumber.text,
             @"complement" : _txtComplement.text,
             @"postalCode" : zip,
             @"type" : addressType,
             @"referencePoint" : _txtReference.text? : @"",
             @"description" : _txtAddressDescription.text? : @"",
             @"default" : [NSNumber numberWithBool:_mainAddress] ?: @0};
}

- (WBRCheckoutAddressModel *)getAddressModel {
    
    NSString *addressType = ([self.txtTypeAddress.text isEqualToString:@"Comercial"]) ? @"BUSINESS" : @"RESIDENTIAL";
    NSString *zip = [self.txtZipCode.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    WBRCheckoutAddressModel *addressModel = [[WBRCheckoutAddressModel alloc] init];
    addressModel.receiverName = self.txtName.text;
    addressModel.country = @"Brasil";
    addressModel.state = self.txtState.text;
    addressModel.city = self.txtCity.text;
    addressModel.neighborhood = self.txtNeighborhood.text;
    addressModel.street = self.txtStreet.text;
    addressModel.number = self.noNumber ? @"0" : self.txtNumber.text;
    addressModel.complement = self.txtComplement.text;
    addressModel.postalCode = zip;
    addressModel.type = addressType;
    addressModel.referencePoint = self.txtReference.text? : @"";
    addressModel.descriptionAddress = self.txtAddressDescription.text? : @"";
    addressModel.defaultAddress = [NSNumber numberWithBool:self.mainAddress] ?: @0;
    
    return addressModel;
}

- (void) addAddress
{
    if ([self validateFields]) {
        [self.navigationController.view showModalLoading];
        
        [WBRAddressManager newAddress:[self getAddressModel] successBlock:^{
            [self newAddressCreation:nil];
        } failureBlock:^(NSError *error) {
            [self newAddressCreation:error];
        }];
    }
}

- (void)addressUpdated:(NSError *)error
{
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.navigationController.view hideModalLoading];
        if (error == nil) {
            //Sucesso
            if ([self.delegate respondsToSelector:@selector(addressViewController:updatedAddress:)])
            {
                [self.delegate addressViewController:self updatedAddress:[self getAddressDict]];
            }
        }
        else
        {
            NSString *msgAlert = error.localizedDescription;
            if (error.code == 408) {
                msgAlert = ERROR_CONNECTION_TIMEOUT;
            }
            [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:msgAlert];
        }
    });
}


- (void)refreshAddress
{
    if ([self validateFields]) {
        
        [self.navigationController.view showModalLoading];
        [WBRAddressManager updateAddress:[self getAddressModel] forAddressId:self.addressDict[@"id"] successBlock:^{
            [self addressUpdated:nil];
        } failureBlock:^(NSError *error) {
            [self addressUpdated:error];
        }];
    }
}

- (void)newAddressCreation:(NSError *)error {
    
    [self.navigationController.view hideModalLoading];
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
        [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
    }
}

- (void)refreshButtonPressed
{
    
    [self.view endEditing:YES];
    
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
- (void)handleBackground:(NSNotification *)notification
{
    LogInfo(@"Background OFAddressViewController");
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Public methods
- (NSString *)getAddressId {
    return self.addressDict[@"id"] ?: @"";
}

@end
