//
//  AddressViewController.m
//  Walmart
//
//  Created by Renan on 5/20/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "AddressViewController.h"
#import "OFMessages.h"
#import "MyAddressesConnection.h"
#import "ZipCodeModel.h"
#import "UIImage+Additions.h"
#import "NSString+HTML.h"
#import "UIColor+Pallete.h"

@interface AddressViewController () <UITextFieldDelegate, WMPickerTextFieldDelegate>

@property (assign, nonatomic) CGFloat addButtonTopConstraintConstant;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *mainAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (nonatomic, weak) IBOutlet UIButton *mainAdressCheckmarkButton;
@property (nonatomic, assign) BOOL mainAddress;

@property (weak, nonatomic) IBOutlet UIButton *noNumberToggleButton;
@property (nonatomic, assign) BOOL noNumber;
@property (weak, nonatomic) IBOutlet UILabel *noNumberLabel;

@property (nonatomic, strong) NSArray *addressTypes;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *streetActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *neighborhoodActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *stateActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *cityActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *zipCodeActivityIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionButtomContainerBottomConstraint;
@property (assign, nonatomic) CGFloat defaultActionButtomContainerBottomConstraint;

- (IBAction)addOrUpdateAddress;
- (IBAction)mainAddressPressed:(id)sender;

@end

@implementation AddressViewController

- (AddressViewController *)initWithAddress:(AddressModel *)address {
    NSString *title = address ? MY_ADDRESSES_EDIT_ADDRESS_TITLE : MY_ADDRESSES_NEW_ADDRESS_TITLE;
    if (self = [super initWithTitle:title isModal:NO searchButton:NO cartButton:NO wishlistButton:NO]) {
        _address = address;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    [self setUpTextFields];
    [self setUpActivityIndicators];
    
    if (self.address)
    {
        [self updateAddressWithModel:self.address];
    }
    else
    {
        [self setupForNewAddress];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self applyShadowViewBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupConstraints];
}

#pragma mark - Setup
- (void)applyShadowViewBottom {
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_viewBottom.bounds];
    _viewBottom.layer.masksToBounds = NO;
    _viewBottom.layer.shadowColor = [UIColor blackColor].CGColor;
    _viewBottom.layer.shadowOffset = CGSizeMake(0.0f, -7.0f);
    _viewBottom.layer.shadowOpacity = 0.2f;
    _viewBottom.layer.shadowRadius = 4.0f;
    _viewBottom.layer.shadowPath = shadowPath.CGPath;
}

- (void)setUp
{
    //Navigation Bar
    if (self.isEditingAddress) {
        self.title = MY_ADDRESSES_EDIT_ADDRESS_TITLE;
        [self.actionButton setTitle:@"Salvar" forState:UIControlStateNormal];
    } else {
        self.title = MY_ADDRESSES_NEW_ADDRESS_TITLE;
        [self.actionButton setTitle:@"Adicionar" forState:UIControlStateNormal];
    }
    
    UIButton *customBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImg = [UIImage imageNamed:@"img_back"];
    [customBackButton setImage:btnImg forState:UIControlStateNormal];
    customBackButton.frame = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
    
    if (self.isFirstAddress) {
        [customBackButton addTarget:self.navigationController action:@selector(popToRootViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [customBackButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBackButton];
    
    //Notifications (Keyboard)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //Custom gestures
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizedInScrollView)];
    tapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGesture];
    
    self.addressTypes = @[@"Residencial", @"Comercial"];
    self.addressTypeTextField.options = self.addressTypes;
    self.addressTypeTextField.wmPickerTextFieldDelegate = self;
}

- (void)setUpTextFields
{
    self.zipCodeTextField.mask = @"#####-###";

    [self.stateTextField setEnabled:NO];
    [self.stateTextField setUserInteractionEnabled:NO];
    [self.stateTextField setTextColor:[UIColor colorWithWMBColorOption:WMBColorOptionDarkGray]];

    [self.cityTextField setEnabled:NO];
    [self.cityTextField setUserInteractionEnabled:NO];
    [self.cityTextField setTextColor:[UIColor colorWithWMBColorOption:WMBColorOptionDarkGray]];
    }

- (void)setUpActivityIndicators
{
    self.streetActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.neighborhoodActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.zipCodeActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.stateActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.cityActivityIndicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
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


- (void)updateAddressWithModel:(AddressModel *)address
{
    self.zipCodeTextField.text = address.formattedZipCode;
    self.receiverNameTextField.text = address.receiverName;
    self.addressTypeTextField.text = address.type;
    NSString *streetNameDecoded = [address.street kv_decodeHTMLCharacterEntities];
    self.streetTextField.text = streetNameDecoded;
    self.neighborhoodTextField.text = address.neighborhood;
    self.numberTextField.text = address.number;
    self.complementTextField.text = address.complement;
    self.cityTextField.text = address.city;
    self.stateTextField.text = address.state;
    self.referenceTextField.text = address.referencePoint;
    self.addressNameTextField.text = address.addressDescription;
    self.mainAddress = self.address.defaultAddress.boolValue;
    
    [self setNoNumber:[address.number isEqualToString: kAddressNoNumberDefaultValue]];
}

- (void)updateZipCodeInfo:(ZipCodeModel *)model
{
    self.cityTextField.text = model.city ?: @"";
    self.stateTextField.text = model.stateAcronym ?: @"";
    self.neighborhoodTextField.text = model.neighborhood ?: @"";
    
    NSString *streetNameDecoded = [model.street kv_decodeHTMLCharacterEntities];
    self.streetTextField.text = [NSString stringWithFormat:@"%@ %@", model.streetType, streetNameDecoded];
    if ([self.streetTextField.text isEqualToString:@" "]) {
        self.streetTextField.text = @"";
    }
}

#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.addressTypeTextField)
    {
        if (self.addressTypeTextField.text.length == 0)
        {
            self.addressTypeTextField.text = self.addressTypes[0];
        }
    }
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
            
            if (textField == self.zipCodeTextField && textField.text.length == 9)
            {
                [self searchZipCode];
            }
            
            return shouldChangeChars;
        }
    }
    
    if (textField == self.zipCodeTextField)
    {
        NSMutableCharacterSet *filteredChars = [NSMutableCharacterSet decimalDigitCharacterSet];
        [filteredChars formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
        NSCharacterSet *blockedCharSet = [filteredChars invertedSet];
        return [string rangeOfCharacterFromSet:blockedCharSet].location == NSNotFound;
    }
    
    if (textField == self.receiverNameTextField)
    {
        if (self.receiverNameTextField.text.length + string.length > 100)
        {
            return NO;
        }
        
        NSMutableCharacterSet *filteredChars = [NSMutableCharacterSet alphanumericCharacterSet];
        [filteredChars formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
        NSCharacterSet *blockedCharSet = [filteredChars invertedSet];
        return [string rangeOfCharacterFromSet:blockedCharSet].location == NSNotFound;
    }
    
    if (textField == self.streetTextField)
    {
        if (self.streetTextField.text.length + string.length > 150)
        {
            return NO;
        }
    }
    
    if (textField == self.neighborhoodTextField)
    {
        if (self.neighborhoodTextField.text.length + string.length > 100)
        {
            return NO;
        }
    }
    
    if (textField == self.numberTextField)
    {
        if (self.numberTextField.text.length + string.length > 6)
        {
            return NO;
        }
    }
    
    if (textField == self.cityTextField)
    {
        if (self.cityTextField.text.length + string.length > 100)
        {
            return NO;
        }
    }
    
    if (textField == self.stateTextField)
    {
        if (self.stateTextField.text.length + string.length > 2)
        {
            return NO;
        }
    }
    
    if (textField == self.complementTextField)
    {
        if (self.complementTextField.text.length + string.length > 100)
        {
            return NO;
        }
    }
    
    if (textField == self.addressTypeTextField)
    {
        return NO;
    }
    
    return YES;
}

- (NSArray *)validateAndGetInvalidFields
{
    self.alertMsg = nil;
    NSMutableArray *invalidFields = [NSMutableArray new];
    
    if (self.receiverNameTextField.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_NAME;
        [invalidFields addObject:self.receiverNameTextField];
    }
    else
    {
        NSMutableArray *components = [NSMutableArray arrayWithArray:[self.receiverNameTextField.text componentsSeparatedByString:@" "]];
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
            [invalidFields addObject:self.receiverNameTextField];
        }
    }
    
    if (self.zipCodeTextField.text.length == 0) {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_ZIP_CODE;
        [invalidFields addObject:self.zipCodeTextField];
    }
    
    if (self.addressTypeTextField.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_ADDRESS_TYPE;
        [invalidFields addObject:self.addressTypeTextField];
    }
    
    if (self.streetTextField.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_STREET;
        [invalidFields addObject:self.streetTextField];
    }
    
    if (self.neighborhoodTextField.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_NEIGHBORHOOD;
        [invalidFields addObject:self.neighborhoodTextField];
    }
    
    if (self.numberTextField.text.length == 0)
    {
        if (!self.alertMsg) self.alertMsg = ADDRESS_WARNING_NUMBER;
        [invalidFields addObject:self.numberTextField];
    }
    
    return invalidFields.copy;
}

#pragma mark - Address Type Picker
- (void)pickerTextField:(id)pickerTextField didFinishSelectingOption:(NSString *)option
{
    self.addressTypeTextField.text = option;
}

#pragma mark - Zip Code
- (void)searchZipCode
{
    [WMOmniture trackAddressZipSearch];

    [self.scrollView endEditing:YES];
    [self startZipCodeLoading];
    
    [[MyAddressesConnection new] getZipCodeData:self.zipCodeTextField.raw completionBlock:^(ZipCodeModel *zipCode)
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
            self.alertMsg = ADDRESS_WARNING_ZIP;
            [self.view showFeedbackAlertOfKind:WarningAlert message:self->_alertMsg];
        });
    }];
}

#pragma mark - Add or update address
- (void)unvalidateFields
{
    for (id view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[WMFloatLabelMaskedTextField class]])
        {
            WMFloatLabelMaskedTextField *textField = (WMFloatLabelMaskedTextField *)view;
            textField.layer.borderColor = [textField defaultBorderColor];
        }
    }
}

- (void)addOrUpdateAddress
{
    
    [self.view endEditing:YES];
    [self unvalidateFields];
    
    self.address = [self createAddressModel];
    
    [self.scrollView endEditing:YES];
    NSArray *invalidFields = [self validateAndGetInvalidFields];
    if (invalidFields.count == 0)
    {
        [self.navigationController.view showModalLoading];
        
        if (self.isEditingAddress)
        {
            [[MyAddressesConnection new] updateAddress:self.address completionBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController.view hideModalLoading];
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:ADDRESS_SUCCESS_UPDATE];
                });
                
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (error.code == 401) {
                        [self presentLoginWithLoginSuccessBlock:^{
                            [self addOrUpdateAddress];
                        } dismissBlock:^{
                            [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                        }];
                    }
                    else {
                        [self.navigationController.view hideModalLoading];
                        [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:ADDRESS_ERROR_SAVE];
                    }
                });
            }];
        }
        else
        {
            [WMOmniture trackAddressAddTry];
            [[MyAddressesConnection new] addAddress:self.address completionBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WMOmniture trackAddressAdd];
                    [self.navigationController.view hideModalLoading];
                    [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:ADDRESS_SUCCESS_ADD];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (error.code == 401) {
                        [self presentLoginWithLoginSuccessBlock:^{
                            [self addOrUpdateAddress];
                        } dismissBlock:^{
                            [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                        }];
                    }
                    else {
                        [self.navigationController.view hideModalLoading];
                        [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:ADDRESS_ERROR_SAVE];
                    }
                });
            }];
        }
    }
    else
    {
        [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message:_alertMsg];
        for (UIView *view in invalidFields)
        {
            view.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        }
    }
}

- (AddressModel *)createAddressModel
{
    AddressModel *model = [AddressModel new];
    if (self.address)
    {
        model.addressId = self.address.addressId;
    }
    
    model.zipcode = self.zipCodeTextField.text;
    model.receiverName = self.receiverNameTextField.text;
    model.type = self.addressTypeTextField.text;
    model.street = self.streetTextField.text;
    model.neighborhood = self.neighborhoodTextField.text;
    model.number = (self.noNumber) ? kAddressNoNumberDefaultValue : self.numberTextField.text;
    model.complement = self.complementTextField.text;
    model.city = self.cityTextField.text;
    model.state = self.stateTextField.text;
    model.referencePoint = self.referenceTextField.text;
    model.addressDescription = self.addressNameTextField.text;
    model.defaultAddress = @(self.mainAddress);
    
    return model;
}

#pragma mark - Keyboard
- (void)tapGestureRecognizedInScrollView
{
    [self.scrollView endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
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

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
        self.actionButtomContainerBottomConstraint.constant = self.defaultActionButtomContainerBottomConstraint;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Loading
- (void)startZipCodeLoading
{
    [self.streetTextField setEnabled:NO];
    [self.neighborhoodTextField setEnabled:NO];
    [self.zipCodeTextField setEnabled:NO];
    [self.actionButton setEnabled:NO];
    
    [self.streetActivityIndicator startAnimating];
    [self.neighborhoodActivityIndicator startAnimating];
    [self.cityActivityIndicator startAnimating];
    [self.stateActivityIndicator startAnimating];
    [self.zipCodeActivityIndicator startAnimating];
}

- (void)stopZipCodeLoading
{
    [self.streetTextField setEnabled:YES];
    [self.neighborhoodTextField setEnabled:YES];
    [self.zipCodeTextField setEnabled:YES];
    [self.actionButton setEnabled:YES];
    
    [self.streetActivityIndicator stopAnimating];
    [self.neighborhoodActivityIndicator stopAnimating];
    [self.cityActivityIndicator stopAnimating];
    [self.stateActivityIndicator stopAnimating];
    [self.zipCodeActivityIndicator stopAnimating];
}

#pragma No Number Button States
- (IBAction)noNumberPressed:(id)sender {
    self.noNumber = !self.noNumber;
}

- (void)setNoNumber:(BOOL)noNumber {
    _noNumber = noNumber;
    if (noNumber)
    {
        [self.noNumberToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_on.png"] forState:UIControlStateNormal];
        [self.noNumberToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_on.png"] forState:UIControlStateHighlighted];
        self.numberTextField.text = kAddressNoNumberDefaultString;
        [self.numberTextField setEnabled:NO];
        [self.numberTextField setTextColor:[UIColor colorWithWMBColorOption:WMBColorOptionDarkGray]];
        
        [self.noNumberLabel setTextColor:[UIColor colorWithWMBColorOption:WMBColorOptionDarkGray]];
    }
    else
    {
        [self.noNumberToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_off.png"] forState:UIControlStateNormal];
        [self.noNumberToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_off.png"] forState:UIControlStateHighlighted];
        [self.numberTextField setEnabled:YES];
        
        if ([self.numberTextField.text isEqualToString: kAddressNoNumberDefaultString])
        {
            self.numberTextField.text = @"";
        }
        
        [self.noNumberLabel setTextColor: [UIColor colorWithWMBColorOption:WMBColorOptionDarkGray]];
    }
}


#pragma Main Address Button States
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

#pragma mark - Dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
