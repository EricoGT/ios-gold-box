//
//  WBRAddCreditCardViewController.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 26/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "WBRAddCreditCardViewController.h"
#import "WBRCreditCard.h"
#import "WMFloatLabelMaskedTextField.h"
#import "CreditCardInteractor.h"
#import "WBRCreditCardValidation.h"
#import "WBRUserDocumentValidation.h"
#import "CardIOPaymentViewController.h"
#import "CardIOCreditCardInfo.h"
#import "CardIOUtilities.h"

@interface WBRAddCreditCardViewController () <UITextFieldDelegate, CardIOPaymentViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *creditCardNumber;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *creditCardName;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *creditCardExpirationDate;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *clientDocument;
@property (weak, nonatomic) IBOutlet UIImageView *creditCardFlagImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionButtonContainerBottomConstraint;
@property (assign, nonatomic) CGFloat defaultActionButtomContainerBottomConstraint;

@end

@implementation WBRAddCreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Adicionar cartão";
    
    [self setupTextFieldsDelegates];
    [self setupKeyboard];
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self applyShadowViewBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    self.defaultActionButtomContainerBottomConstraint = self.actionButtonContainerBottomConstraint.constant;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTextFieldsDelegates {
    self.creditCardNumber.delegate = self;
    self.creditCardName.delegate = self;
    self.creditCardExpirationDate.delegate = self;
    self.clientDocument.delegate = self;
}

- (void)setupKeyboard {
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
}

#pragma mark - Keyboard

- (void)tapGestureRecognizedInScrollView {
    [self dismissVisibleKeyboard];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView animateWithDuration:.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
        self.actionButtonContainerBottomConstraint.constant = self.defaultActionButtomContainerBottomConstraint + keyboardRect.size.height;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
        self.actionButtonContainerBottomConstraint.constant = self.defaultActionButtomContainerBottomConstraint;
        [self.view layoutIfNeeded];
    }];
}


- (IBAction)addCard:(id)sender {
    
    [self dismissVisibleKeyboard];
    
    BOOL hasSomeError = NO;
    NSString *stringErrorMessage = @"";
    UITextField *fieldWithError = nil;
    
    if (self.creditCardNumber.text.length == 0)
    {
        fieldWithError = self.creditCardNumber;
        stringErrorMessage = CREDIT_CARD_NOT_SET;
        hasSomeError = YES;
    }
    else if (![WBRCreditCardValidation hasValidCardNumber:self.creditCardNumber.text])
    {
        fieldWithError = self.creditCardNumber;
        stringErrorMessage = ERROR_CREDIT_CARD;
        hasSomeError = YES;
    }
    else if (self.creditCardName.text.length < 4)
    {
        fieldWithError = self.creditCardName;
        stringErrorMessage = ERROR_NAME;
        hasSomeError = YES;
    }
    else if (![WBRCreditCardValidation verifyCreditCardExpirationDate:self.creditCardExpirationDate.text])
    {
        fieldWithError = self.creditCardExpirationDate;
        stringErrorMessage = ERROR_VALIDATE_CCARD;
        hasSomeError = YES;
    }
    else if (![WBRUserDocumentValidation validateCpfCnpj:self.clientDocument.text])
    {
        fieldWithError = self.clientDocument;
        stringErrorMessage = ERROR_CNPJ_CPF;
        hasSomeError = YES;
    }
    
    if (hasSomeError) {
        [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message:stringErrorMessage];
        fieldWithError.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
    } else {
        WBRModelCreditCard *creditCard = [[WBRModelCreditCard alloc] init];
        creditCard.cardNumber = [self.creditCardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];// @"4111111111111111";
        creditCard.brand = [[WBRCreditCardValidation getNameCardWithNumber:self.creditCardNumber.text] uppercaseString];
        creditCard.lastDigitsOfCard = [self.creditCardNumber.text substringWithRange:NSMakeRange(self.creditCardNumber.text.length-4, 4)];
            
        creditCard.expiryYear = [WBRCreditCardValidation getCreditCardExpirationYearFrom:self.creditCardExpirationDate.text];
        creditCard.expiryMonth = [WBRCreditCardValidation getCreditCardExpirationMonthFrom:self.creditCardExpirationDate.text];

        creditCard.expirationDate = [NSString stringWithFormat:@"%@/20%@", creditCard.expiryMonth, creditCard.expiryYear];

        creditCard.expired = NO;

        creditCard.completeName = self.creditCardName.text;
        creditCard.document = self.clientDocument.text;
        
        //Default value, can be any value. Android is also using 222
        creditCard.cvv2 = @"222";
        
        [self addCreditCard:creditCard];
    }
}

- (IBAction)presentCameraScanCreditCard:(id)sender {
    if ([CardIOUtilities canReadCardWithCamera])
    {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if (granted) {
                    [self presentCardScanViewControllerWithCardPaymentCell];
                }
            }];
        }
        else {
           [self presentCardScanViewControllerWithCardPaymentCell];
        }
    }
    else
    {
        [self showCameraAccessAlert];
    }
}

#pragma mark API
- (void)addCreditCard:(WBRModelCreditCard *) creditCard{
    
    [self.navigationController.view showSmartModalLoading];
    
    [[WBRCreditCard new] addUserCreditCard:creditCard withSuccess:^(NSData *data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController.view hideModalLoading];
                if ([self.delegate respondsToSelector:@selector(didAddCreditCard)]) {
                    [self.delegate didAddCreditCard];
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
    } andFailure:^(NSError *error, NSData *dataError) {
        NSString *errorMessage = SELF_HELP_CREDITCARD_SUCCESS_ADD_ERROR;

        //Track if the error message is for repeated card. If 400 and has the ER9000 code, the card is already add previously
        if (error.code == 400) {
            NSString *bodyString = [[NSString alloc] initWithData:dataError encoding:NSUTF8StringEncoding];
            NSData *jsonData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            if (json) {
                NSArray *arrayMessage = json[@"errors"];
                for (NSDictionary *dictMessage in arrayMessage) {
                    NSDictionary *dictErrorMessage = dictMessage[@"message"];
                    NSString *errorCode = [dictErrorMessage objectForKey:@"errorCode"];
                    if ([errorCode isEqualToString:@"ER9000"]) {
                        errorMessage = SELF_HELP_CREDITCARD_SUCCESS_ADD_ERROR_REPEAT_CARD;
                        break;
                    }
                }
            }
        }
        [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:errorMessage];
        [self.navigationController.view hideSmartLoading];
    }];
}

#pragma mark Keyboard
- (void)dismissVisibleKeyboard {
    [self.view endEditing:YES];
}


#pragma mark Camera
- (void)presentCardScanViewControllerWithCardPaymentCell {
    dispatch_async(dispatch_get_main_queue(), ^{
        CardIOPaymentViewController *cardController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
        cardController.hideCardIOLogo = YES;
        cardController.disableManualEntryButtons = YES;
        cardController.collectExpiry = NO;
        cardController.collectCVV = NO;
        cardController.collectCardholderName = NO;
        cardController.collectPostalCode = NO;
        cardController.suppressScanConfirmation = YES;
        [self presentViewController:cardController animated:YES completion:^{}];
    });
}

- (void)showCameraAccessAlert {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissVisibleKeyboard];
        [self.navigationController.view showPopupWithTitle:CARD_SCANNER_CAMERA_DENIED_TITLE
                                                   message:CARD_SCANNER_CAMERA_DENIED_MESSAGE
                                         cancelButtonTitle:CARD_SCANNER_CAMERA_DENIED_CANCEL
                                               cancelBlock:nil
                                         actionButtonTitle:CARD_SCANNER_CAMERA_DENIED_SETTINGS
                                               actionBlock:^{
                                                   if (UIApplicationOpenSettingsURLString != NULL) {
                                                       NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                       [[UIApplication sharedApplication] openURL:appSettings];
                                                   }
                                               }];
    });
}

#pragma mark CardIO Delegates
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    if (cardInfo)
    {
        self.creditCardNumber.text = cardInfo.cardNumber;
        
        NSString *month = @"";
        NSString *year = @"";
        if (cardInfo.expiryMonth != 0) month = [NSString stringWithFormat:@"%.2lu", (unsigned long)cardInfo.expiryMonth];
        if (cardInfo.expiryYear != 0) year = @(cardInfo.expiryYear).stringValue;
        
        if (month.length == 2 && year.length == 2) {
            self.creditCardExpirationDate.text = [NSString stringWithFormat:@"%@/%@", month, year];
        }
    }
    
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        NSRange range = NSMakeRange(0, [self.creditCardNumber.text length]);
        if (![WBRCreditCardValidation applyCreditCardNumberMaskOnKeyTouchedInTextField:self.creditCardNumber shouldChangeCharactersInRange:range replacementString:@""]) {
            CreditCardFlag creditCardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:self.creditCardNumber.text];
            [self.creditCardFlagImage setImage:[CreditCardInteractor minImageForFlag:creditCardFlag]];
        }
        
        if (![WBRCreditCardValidation hasValidCardNumber:self.creditCardNumber.text]) {
            [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message:ERROR_READING_CREDIT_CARD];
        }
    }];
}

#pragma Mark - TextField Delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.clientDocument) {
        
        return [WBRUserDocumentValidation applyUserDocumentMaskOnKeyTouchedInTextField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    } else if (textField == self.creditCardName) {
        
        return [WBRUserDocumentValidation applyUserNameMaskOnKeyTouchedInTextField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }else if (textField == self.creditCardNumber) {
        
        CreditCardFlag creditCardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:textField.text];
        [self.creditCardFlagImage setImage:[CreditCardInteractor minImageForFlag:creditCardFlag]];
        
        return [WBRCreditCardValidation applyCreditCardNumberMaskOnKeyTouchedInTextField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    else if (textField == self.creditCardExpirationDate) {
        
        return [WBRCreditCardValidation applyCreditCardExpirationDateMaskOnKeyTouchedInTextField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.creditCardNumber) {
        if (self.creditCardNumber.text.length > 0)
        {
            if (![WBRCreditCardValidation hasValidCardNumber:self.creditCardNumber.text]) {
                
                [self dismissVisibleKeyboard];
                [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message:ERROR_CREDIT_CARD];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.creditCardNumber.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
                }];
                
            }
        }
    } else if (textField == self.creditCardExpirationDate) {
        if (self.creditCardExpirationDate.text.length > 0) {
            if (![WBRCreditCardValidation verifyCreditCardExpirationDate:self.creditCardExpirationDate.text]) {
                
                [self dismissVisibleKeyboard];
                [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message:ERROR_EXPIRATION_DATE_CCARD];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.creditCardExpirationDate.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
                }];
            }
        }
    }
}

@end
