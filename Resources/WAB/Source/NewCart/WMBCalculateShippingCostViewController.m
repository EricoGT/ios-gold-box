//
//  WMBCalculateShippingCostViewController.m
//  Walmart
//
//  Created by Rafael Valim on 13/07/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBCalculateShippingCostViewController.h"
#import "WMBFloatLabelMaskedTextFieldView.h"
#import "WMOmniture.h"
#import "WBRAddressManager.h"

@interface WMBCalculateShippingCostViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewYAlignmentConstraint;
@property (weak, nonatomic) IBOutlet WMBFloatLabelMaskedTextFieldView *inputFloatLabelMaskedTextField;

@property (weak, nonatomic) IBOutlet WMButtonRounded *calculateShippingCostButton;
@property (weak, nonatomic) IBOutlet WMButtonRounded *cancelButton;

@end

@implementation WMBCalculateShippingCostViewController

static CGFloat const ContainerViewYAlignmentConstraintForKeyboardOpened = -100.0f;
static CGFloat const ContainerViewYAlignmentConstraintForKeyboardClosed = 0.0f;

static CGFloat const HiddenElementAlphaValue = 0.0f;
static CGFloat const DisabledElementAlphaValue = 0.5f;
static CGFloat const EnabledElementAlphaValue = 1.0f;

static NSInteger const ZipCodeMaxLenght = 9;
static NSInteger const ZipCodeDashIndex = 5;

- (instancetype)init {
    self = [super init];
    if (self) {
        //Setup the presentation style
        self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputField];
    [self addKeyboardDismissTapRecognizer];
    [self setRoundedCorner];

    [WMOmniture trackDeliveryShippingPopUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.containerView setAlpha:HiddenElementAlphaValue];
    [self formatZipCodeString];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performDisplayAnimations];
}

- (IBAction)cancelShippingAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissShippingCostCalculationViewController)]) {
            [self.delegate didDismissShippingCostCalculationViewController];
        }
    }];
}

- (IBAction)calculateShippingAction:(id)sender {
    
    NSString *inputTextString = self.inputFloatLabelMaskedTextField.inputTextField.raw;
    if ([inputTextString length] == 8) {
        [self dismissKeyboard];
        [self calculateShipmentForCEP:inputTextString];
        [self enableUserInteractionFields:NO];
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.25f animations:^{
        self.containerViewYAlignmentConstraint.constant = ContainerViewYAlignmentConstraintForKeyboardOpened;
        [self.view layoutIfNeeded];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.25f animations:^{
        self.containerViewYAlignmentConstraint.constant = ContainerViewYAlignmentConstraintForKeyboardClosed;
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //This method already changes the textfield's string by the replacement string
    BOOL shouldChangeCharacters = [(WMFloatLabelMaskedTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    
    //So we just need to evaluate the lenght of the textField.text to enable/disable the "Calculate" button
    if ([textField.text length] == ZipCodeMaxLenght) {
        [self enableCalculateShippingCostButton:YES];
    }
    else {
        [self enableCalculateShippingCostButton:NO];
    }
    
    return shouldChangeCharacters;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self enableCalculateShippingCostButton:NO];
    return YES;
}

#pragma mark - AddressConnectionDelegate - Shippment Handling

- (void)calculateShipmentForCEP:(NSString *)CEP {
    
    [self.inputFloatLabelMaskedTextField startAnimatingActivityIndicator];
    
    [WBRAddressManager getShipmentOptionsForZipcode:CEP sucessBlock:^(NSNumber *price) {
        [self shipmentResult:price Error:nil];
    } failureBlock:^(NSError *error, NSData *responseError) {
        
        [self shipmentResult:nil Error:error];
    }];
}

- (void)shipmentResult:(NSNumber *)price Error:(NSError *)error {
    
    [self.inputFloatLabelMaskedTextField stopAnimatingActivityIndicator];
    
    if (!error) {
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(didCalculateShippingFeeForCEP)]) {
                [self.delegate didCalculateShippingFeeForCEP];
            }
        }];
    }
    else {
        [self.inputFloatLabelMaskedTextField showErrorMessage:error.localizedDescription];
        [self enableUserInteractionFields:YES];
    }
}

- (void)errorZip:(NSDictionary *)dictError {
    [self.inputFloatLabelMaskedTextField showErrorMessage:ERROR_SHIPPING_ROUTE];
    [self.inputFloatLabelMaskedTextField stopAnimatingActivityIndicator];
    [self enableUserInteractionFields:YES];
}

#pragma mark - Private Methods

- (void)enableCalculateShippingCostButton:(BOOL)enable {
    if (enable) {
        self.calculateShippingCostButton.userInteractionEnabled = YES;
        self.calculateShippingCostButton.alpha = EnabledElementAlphaValue;
    }
    else {
        self.calculateShippingCostButton.userInteractionEnabled = NO;
        self.calculateShippingCostButton.alpha = DisabledElementAlphaValue;
    }
}

- (void)enableUserInteractionFields:(BOOL)enable {
    [self.calculateShippingCostButton setUserInteractionEnabled:enable];
    [self.cancelButton setUserInteractionEnabled:enable];
    [self.inputFloatLabelMaskedTextField.inputTextField setUserInteractionEnabled:enable];
    
    if (enable) {
        self.calculateShippingCostButton.alpha = EnabledElementAlphaValue;
        self.cancelButton.alpha = EnabledElementAlphaValue;
    }
    else {
        self.calculateShippingCostButton.alpha = DisabledElementAlphaValue;
        self.cancelButton.alpha = DisabledElementAlphaValue;
    }
}

- (void)performDisplayAnimations {
    [UIView animateWithDuration:0.2f animations:^{
        [self.containerView setAlpha:EnabledElementAlphaValue];
    } completion:^(BOOL finished) {
    }];
}

- (void)formatZipCodeString {
    if ([self.currentPostalCode length] > 0) {
        NSMutableString *postalCode = [NSMutableString stringWithString:self.currentPostalCode];
        if ([self.currentPostalCode length] > ZipCodeDashIndex) {
            [postalCode insertString:@"-" atIndex:ZipCodeDashIndex];
        }
        [self.inputFloatLabelMaskedTextField.inputTextField setText:postalCode];
        if ([postalCode length] == ZipCodeMaxLenght) {
            [self enableCalculateShippingCostButton:YES];
        }
    }
}

- (void)addKeyboardDismissTapRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)setupInputField {
    [self enableCalculateShippingCostButton:NO];
    [self.inputFloatLabelMaskedTextField.inputTextField setFloatLabelPassiveColor:RGBA(204, 204, 204, 1)];
    [self.inputFloatLabelMaskedTextField.inputTextField setFloatLabelActiveColor:RGBA(33, 150, 243, 1)];
    [self.inputFloatLabelMaskedTextField.inputTextField setMask:@"#####-###"];
    self.inputFloatLabelMaskedTextField.inputTextField.placeholder = @"CEP";
    self.inputFloatLabelMaskedTextField.inputTextField.delegate = self;
    [self.inputFloatLabelMaskedTextField.inputTextField setup];
}

- (void)dismissKeyboard {
    [self.inputFloatLabelMaskedTextField.inputTextField resignFirstResponder];
}

- (void)setRoundedCorner {
    self.containerView.layer.cornerRadius = 2.0f;
    self.containerView.layer.masksToBounds = YES;
}

@end
