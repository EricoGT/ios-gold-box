//
//  WBRPaymentCreditCardTableViewCell.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentCreditCardTableViewCell.h"

#import "WMFloatLabelMaskedTextField.h"
#import "CreditCardInteractor.h"

static const NSInteger kRateLabelTopHeightConstraint = 8;
static const NSInteger kHolderLabelTrailingConstraint = 10;
static const NSInteger kHolderLabelTrailingConstraintExpiredCard = 50;

@interface WBRPaymentCreditCardTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *defaultCardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bankFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *holderLabel;
@property (weak, nonatomic) IBOutlet UILabel *validityDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiredLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateLabelTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *valueTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *installmentTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *securityCodeTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holderLabelTrailingConstraint;

@end

@implementation WBRPaymentCreditCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.securityCodeTextField.delegate = self;
    
    self.cardView.layer.cornerRadius = 4.0f;
    self.cardView.layer.masksToBounds = YES;
    
    [self setBorderColorGray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedUserDefaults:) name:NSUserDefaultsDidChangeNotification object:nil];
}

#pragma mark - Override

- (void)willMoveToWindow:(UIWindow *)newWindow {
    
    if (!newWindow) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)changedUserDefaults:(NSNotification *)notification {

    if (![self.valueTextField.text isEqualToString:[self valueString]]) {
        [self showValueToBePayed];
        [self resetState];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self setBorderColorBlue];
    }
    else {
        [self setBorderColorGray];
    }
}

#pragma mark - Private Methods

- (void)setBorderColorBlue {
    self.cardView.layer.borderWidth = 2.0f;
    self.cardView.layer.borderColor = RGBA(33, 150, 243, 1).CGColor;
}

- (void)setBorderColorGray {
    self.cardView.layer.borderWidth = 1.0f;
    self.cardView.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
}

- (void)shouldShowDefaultCard:(BOOL)show {
    
    if (show) {
        self.defaultCardImageView.hidden = NO;
    }
    else {
        self.defaultCardImageView.hidden = YES;
    }
}

- (void)shouldShowExpiredWarningState:(BOOL)show {
    
    if (show) {
        self.validityDateLabel.hidden = YES;
        self.expiredLabel.hidden = NO;
        [self.cardView setBackgroundColor:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]];
        self.holderLabelTrailingConstraint.constant = kHolderLabelTrailingConstraintExpiredCard;
        self.userInteractionEnabled = NO;
    }
    else {
        self.validityDateLabel.hidden = NO;
        self.expiredLabel.hidden = YES;
        [self.cardView setBackgroundColor:[UIColor clearColor]];
        self.holderLabelTrailingConstraint.constant = kHolderLabelTrailingConstraint;
        self.userInteractionEnabled = YES;
    }
    
    [self layoutIfNeeded];
}

- (void)showValueToBePayed {
    self.valueTextField.text = [self valueString];
}

- (NSString *)valueString {
    
    NSString *key = @"";
    
    if ([self.paymentNumber isEqualToString:@"1"]) {
        key = @"valueNoInterest1";
    } else {
        key = @"valueNoInterest2";
    }
    
    NSString *ttGlobalOrder = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    NSString *ttGlobal = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:[ttGlobalOrder floatValue]]];
    
    return ttGlobal;
}

- (NSString *)currencyFormat:(float) value {
    NSNumber *amount = [[NSNumber alloc] initWithFloat:value];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"R$"];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *newFormat = [numberFormatter stringFromNumber:amount];
    
    LogInfo(@"Number: %@", newFormat);
    
    //Remove currency symbol
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"R$" withString:@""];
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    return newFormat;
}

- (NSString *)expirationDateToShow:(NSString *)expirationDate {
    
    NSString *result;
    result = [expirationDate substringToIndex:2];
    result = [NSString stringWithFormat:@"%@/%@", result, [expirationDate substringFromIndex:5]];
    
    return result;
}

- (BOOL)checkFilledInformation {
    
    if (self.securityCodeTextField.text.length > 0 && self.installmentTextField.text.length > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - Public Methods

- (void)setInstallmentText:(NSString *)selectedInstallment {
    self.installmentTextField.text = selectedInstallment;
    self.showingRateWarning = NO;
    self.rateLabel.text = @"";
    self.rateLabelTopConstraint.constant = 0;
    [self layoutIfNeeded];
}

- (NSString *)securityValue {
    return self.securityCodeTextField.text;
}

- (NSString *)selectedInstallment {
    return self.installmentTextField.text;
}

- (void)setRateLabelText:(NSString *)text {
    
    if (text) {
        self.showingRateWarning = YES;
        self.rateLabel.text = text;
        self.rateLabelTopConstraint.constant = kRateLabelTopHeightConstraint;
        [self layoutIfNeeded];
    }
}

- (void)resetState {
    self.showingRateWarning = NO;
    self.installmentTextField.text = @"";
    self.securityCodeTextField.text = @"";
    self.rateLabel.text = @"";
    self.rateLabelTopConstraint.constant = 0;
    [self layoutIfNeeded];
}

#pragma mark - IBAction

- (IBAction)installmentsButtonAction:(UIButton *)sender {
    [self.delegate WBRPaymentCreditCardTableViewCellDidSelectInstallmentOptions:self];
}

#pragma mark - Custom Setter

- (void)setCard:(WBRCardModel *)card {
    [self resetState];
    self.showingRateWarning = NO;
    self.cardTitleLabel.text = [NSString stringWithFormat:@"%@ - Final %@", [card.brand capitalizedString], card.last4];
    [self shouldShowDefaultCard:card.defaultCard];
    self.holderLabel.text = [card.holder.name capitalizedString];
    self.validityDateLabel.text = [self expirationDateToShow:card.expirationDate];
    [self shouldShowExpiredWarningState:card.expired];
    CreditCardFlag cardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:[card.mask substringToIndex:6]];
    UIImage *cardImage = [CreditCardInteractor minImageForFlag:cardFlag];
    [self showValueToBePayed];
    self.bankFlagImageView.image = cardImage;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.securityCodeTextField) {
        
        NSUInteger newLengthSecCode = [textField.text length] + [string length] - range.length;
        if (newLengthSecCode > 4) {
            return NO;
        }
        else {
            return YES;
        }
    }
    
    return YES;
}

@end
