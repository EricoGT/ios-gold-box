//
//  WMBDiscountCouponViewController.m
//  Walmart
//
//  Created by Rafael Valim on 13/07/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBDiscountCouponViewController.h"
#import "WMBFloatLabelMaskedTextFieldView.h"

#import "CartConnection.h"
#import "WMParser.h"
#import "WMOmniture.h"
#import "WBRPaymentManager.h"

@interface WMBDiscountCouponViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewYAlignmentConstraint;
@property (weak, nonatomic) IBOutlet WMBFloatLabelMaskedTextFieldView *inputFloatLabelMaskedTextField;


@property (weak, nonatomic) IBOutlet WMButtonRounded *checkCouponButton;
@property (weak, nonatomic) IBOutlet WMButtonRounded *cancelButton;

@end

static CGFloat const ContainerViewYAlignmentConstraintForKeyboardOpened = -100.0f;
static CGFloat const ContainerViewYAlignmentConstraintForKeyboardClosed = 0.0f;

static CGFloat const HiddenElementAlphaValue = 0.0f;
static CGFloat const DisabledElementAlphaValue = 0.5f;
static CGFloat const EnabledElementAlphaValue = 1.0f;

static NSInteger const DiscountCouponMinLenght = 1;
static NSInteger const DiscountCouponMaxLenght = 20;

@implementation WMBDiscountCouponViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //Setup the presentation style
        self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.isCheckoutFlow = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputField];
    [self addKeyboardDismissTapRecognizer];
    [self setRoundedCorner];
    [self setupButtons];

    [WMOmniture trackDiscountCouponPopUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.containerView setAlpha:HiddenElementAlphaValue];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performDisplayAnimations];
}

- (IBAction)cancelDiscountCouponAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissCouponViewController)]) {
            [self.delegate didDismissCouponViewController];
        }
    }];
}

- (IBAction)calculateDiscoutAction:(id)sender {
    
    NSString *inputTextString = self.inputFloatLabelMaskedTextField.inputTextField.raw;
    
    [self.inputFloatLabelMaskedTextField startAnimatingActivityIndicator];
    [self enableUserInteractionFields:NO];
    [self dismissKeyboard];
    
    if (self.isCheckoutFlow) {
        [self checkCouponForCheckoutScreenScreen:inputTextString];
    }
    else {
        [self checkCouponForCartScreen:inputTextString];
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
    
    NSString *replacingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([replacingString length] >= DiscountCouponMinLenght) {
        [self enableCheckCouponButton:YES];
    }
    else {
        [self enableCheckCouponButton:NO];
    }
    
    BOOL shouldChangeCharacters = YES;
    if ([replacingString length] > DiscountCouponMaxLenght) {
        shouldChangeCharacters = NO;
    }
    
    return shouldChangeCharacters;
}

#pragma mark - Coupon ServiceHandling

- (void)checkCouponForCartScreen:(NSString *)coupon {
    
    [CartConnection submitCouponWithRedemptionCode:coupon successBlock:^(NSDictionary *cart, NSDictionary *errorDict) {
        
        // If one of these keys exist, the user tried to add a coupon through updateCart service.
        NSNumber *newCouponAdded = cart[@"newCouponAdded"] ?: cart[@"newGiftCardAdded"];
        if (newCouponAdded) {
            NSArray *voucherStatus = cart[@"voucherStatus"];
            if (voucherStatus.count > 0 && [voucherStatus[0] isEqualToString:@"COUPON_ALLOWED_ONLY_FOR_WALMART"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.inputFloatLabelMaskedTextField stopAnimatingActivityIndicator];
                    [self enableUserInteractionFields:YES];
                    [self.inputFloatLabelMaskedTextField showErrorMessage:COUPON_ALLOWED_ONLY_FOR_WALMART];
                });
            }
            else {
                
                BOOL submittedCouponSuccess = [newCouponAdded boolValue];
                
                if (submittedCouponSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:^{
                            if ([self.delegate respondsToSelector:@selector(didApplyDiscountCouponToOrder)]) {
                                [self.delegate didApplyDiscountCouponToOrder];
                            }
                        }];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.inputFloatLabelMaskedTextField stopAnimatingActivityIndicator];
                        [self enableUserInteractionFields:YES];
                        [self.inputFloatLabelMaskedTextField showErrorMessage:COUPON_SUBMIT_FAILURE];
                    });
                }
            }
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.inputFloatLabelMaskedTextField stopAnimatingActivityIndicator];
            [self enableUserInteractionFields:YES];
            [self.inputFloatLabelMaskedTextField showErrorMessage:error.localizedDescription];
        });
    }];
    
}

#pragma mark - Private Methods

- (void)enableCheckCouponButton:(BOOL)enable {
    if (enable) {
        self.checkCouponButton.userInteractionEnabled = YES;
        self.checkCouponButton.alpha = EnabledElementAlphaValue;
    }
    else {
        self.checkCouponButton.userInteractionEnabled = NO;
        self.checkCouponButton.alpha = DisabledElementAlphaValue;
    }
}

- (void)enableUserInteractionFields:(BOOL)enable {
    [self.checkCouponButton setUserInteractionEnabled:enable];
    [self.cancelButton setUserInteractionEnabled:enable];
    [self.inputFloatLabelMaskedTextField.inputTextField setUserInteractionEnabled:enable];
    
    if (enable) {
        self.checkCouponButton.alpha = EnabledElementAlphaValue;
        self.cancelButton.alpha = EnabledElementAlphaValue;
    }
    else {
        self.checkCouponButton.alpha = DisabledElementAlphaValue;
        self.cancelButton.alpha = DisabledElementAlphaValue;
    }
}

- (void)performDisplayAnimations {
    [UIView animateWithDuration:0.2f animations:^{
        [self.containerView setAlpha:EnabledElementAlphaValue];
    } completion:^(BOOL finished) {
    }];
}

- (void)addKeyboardDismissTapRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)setupInputField {
    [self enableCheckCouponButton:NO];
    [self.inputFloatLabelMaskedTextField.inputTextField setFloatLabelPassiveColor:RGBA(204, 204, 204, 1)];
    [self.inputFloatLabelMaskedTextField.inputTextField setFloatLabelActiveColor:RGBA(33, 150, 243, 1)];
    self.inputFloatLabelMaskedTextField.inputTextField.placeholder = @"Cupom de desconto";
    self.inputFloatLabelMaskedTextField.inputTextField.delegate = self;
    [self.inputFloatLabelMaskedTextField.inputTextField setup];
}

- (void)setupButtons {
    [self.cancelButton setFont:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    [self.checkCouponButton setFont:[UIFont fontWithName:@"Roboto-Regular" size:13]];
}

- (void)dismissKeyboard {
    [self.inputFloatLabelMaskedTextField.inputTextField resignFirstResponder];
}

- (void)setRoundedCorner {
    self.containerView.layer.cornerRadius = 2.0f;
    self.containerView.layer.masksToBounds = YES;
}

#pragma mark - Payment Controller Specific Service Call

- (void)checkCouponForCheckoutScreenScreen:(NSString *)redemptionCode {
    
    NSDictionary *couponDict = @{@"giftCard": @{@"redemptionCode": redemptionCode ?: @"",
                                                @"remove": @(NO)}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:couponDict options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [WBRPaymentManager postPaymentWithCart:jsonString successBlock:^(NSString *dataString) {
        [self requestPaymentWithCart:dataString];
    } failure:^(NSError *error, NSString *dataString) {
        if (error.code == 401) {
            LogErro(@"401 received! Token expired [%@]! :(", @"selectDeliveryPaymentWithCompleteCart");
            [self errorCheckoutAuth];
        } else if (error.code == 400) {
            LogErro(@"400!");
            NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:dataString];
            [self errorCheckout:msgError];
        } else {
            LogErro(@"Error code:%ld", (long)error.code);
            [self errorConnNewCheckout:error.localizedDescription];
        }
    }];
}

#pragma mark - WMConnectionNewCheckout Delegate

- (void)errorCheckoutAuth {
    
    [self.inputFloatLabelMaskedTextField stopAnimatingActivityIndicator];
    [self enableUserInteractionFields:YES];
    [self.inputFloatLabelMaskedTextField showErrorMessage:COUPON_SUBMIT_FAILURE];
}

- (void)errorConnNewCheckout:(NSString *)msgError {
    
    [self.inputFloatLabelMaskedTextField stopAnimatingActivityIndicator];
    [self enableUserInteractionFields:YES];
    [self.inputFloatLabelMaskedTextField showErrorMessage:msgError];
}

- (void)errorCheckout:(NSDictionary *)dictError {
    
    [self.inputFloatLabelMaskedTextField stopAnimatingActivityIndicator];
    [self enableUserInteractionFields:YES];
    [self.inputFloatLabelMaskedTextField showErrorMessage:COUPON_SUBMIT_FAILURE];
}

- (void)requestPaymentWithCart:(NSString *)strPaymentWithCart {
    
    NSError *error;
    NSData *jsonData = [strPaymentWithCart dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paymentInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableDictionary *paymentMutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:paymentInfo];
    
    NSDictionary *cart = paymentMutableDictionary[@"cart"];
    NSArray *giftCards = cart[@"giftCards"];
    
    if (giftCards.count > 0) {
        //Successfully added discount coupon
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(didApplyDiscountCouponToOrder)]) {
                    [self.delegate didApplyDiscountCouponToOrder];
                }
            }];
        });
    }
    else {
        //Failed to add coupon
        
        [self.inputFloatLabelMaskedTextField stopAnimatingActivityIndicator];
        [self enableUserInteractionFields:YES];
        [self.inputFloatLabelMaskedTextField showErrorMessage:COUPON_SUBMIT_FAILURE];
    }
    
}





@end
