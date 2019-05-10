//
//  WBRPaymentAddNewCardView.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/30/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentAddNewCardView.h"

#import "OFAddressTemp.h"
#import "Installment.h"
#import "OFMessages.h"
#import "WMBDottedBorderButton.h"
#import "WMOmniture.h"
#import "WBRCreditCardValidation.h"

static const NSInteger kAddNewCardStateShowingFormHeight      = 456;
static const NSInteger kAddNewCardStateShowingFormWithoutSaveCardButtonHeight = 423;
static const NSInteger kAddNewCardStateShowingAddButtonHeight = 75;

@interface WBRPaymentAddNewCardView () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet WMButtonRounded *cardReaderButton;

@property (weak, nonatomic) IBOutlet WMBDottedBorderButton *addNewCardButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewCardButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewCardButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewCardViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *creditCardFlagImage;

@property (weak, nonatomic) IBOutlet UIButton *saveCardToggleButton;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateLabelTopContraint;

@property (assign, nonatomic) CGFloat rateLabelTopContraintDefault;

@property (weak, nonatomic) IBOutlet UIView *saveCardView;

@property (nonatomic, assign) BOOL saveCard;
@property (nonatomic, assign) BOOL cardAlreadySelected;


@end

@implementation WBRPaymentAddNewCardView

#pragma mark - Init methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void)customInit {
    [self initSubviews];
    
    [self.cardReaderButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    
    [self.clientDocument setDelegate:self];
    [self.creditCardNumber setDelegate:self];
    [self.creditCardCvv setDelegate:self];
    [self.creditCardName setDelegate:self];
    [self.creditCardExpirationDate setDelegate:self];
    
    self.saveCard = NO;
    
    self.rateLabelTopContraintDefault = self.rateLabelTopContraint.constant;
    
    [self hideRateLabel];
}

- (void)initSubviews {

    self.translatesAutoresizingMaskIntoConstraints = NO;
    UINib *nib = [UINib nibWithNibName:@"WBRPaymentAddNewCardView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

#pragma mark - Public Methods

- (void)showAddForm:(BOOL)shouldShow {

    if (shouldShow) {
        self.addNewCardButton.hidden = YES;
        self.currentState = kAddNewCardStateShowingForm;
        self.addNewCardButtonHeightConstraint.constant = 0;
        
        if (!self.shouldShowTitle) {
            self.titleLabelBottomConstraint.constant = 0;
            self.titleLabelHeightConstraint.constant = 0;
            self.titleLabel.hidden = YES;
        }
        
        if (self.shouldHideSaveCard) {
            self.saveCardView.hidden = YES;
            [self.delegate WBRPaymnetAddNewCardView:self didUpdateContentHeight:self.suggestedHeight];
        }
        else {
            self.saveCardView.hidden = NO;
            [self.delegate WBRPaymnetAddNewCardView:self didUpdateContentHeight:self.suggestedHeight];
        }
        
        [self layoutIfNeeded];
    } else {
        self.addNewCardButton.hidden = NO;
        self.currentState = kAddNewCardStateShowingAddButton;
        self.addNewCardButtonHeightConstraint.constant = 70;
        [self.delegate WBRPaymnetAddNewCardView:self didUpdateContentHeight:self.suggestedHeight];
        [self resetContentValues];
        [self layoutIfNeeded];
    }
}

- (void)collapseContent {
    
    self.addNewCardButton.hidden = YES;
    self.addNewCardButtonTopConstraint.constant = 0;
    self.addNewCardButtonHeightConstraint.constant = 0;
    self.addNewCardViewBottomConstraint.constant = 0;
    [self layoutIfNeeded];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
- (NSDictionary *)getContentPayment
{
    self.cardAlreadySelected = NO;
    //Cleaning sequences of white spaces in name
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:self];
    
    NSString *name = self.creditCardName.text;
    NSString *squashed = [name stringByReplacingOccurrencesOfString:@"[ ]+" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, name.length)];
    NSString *cleanName = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.creditCardName.text = cleanName;
    
    if (self.creditCardNumber.text.length == 0)
    {
        self.creditCardNumber.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        return [self getDictErrorToPaymentWithMsg:CREDIT_CARD_NOT_SET];
    }
    else if (![self validateCardForTypeWithText:self.creditCardNumber.text])
    {
        self.creditCardNumber.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        return [self getDictErrorToPaymentWithMsg:ERROR_CREDIT_CARD];
    }
    else if (self.creditCardName.text.length < 4)
    {
        self.creditCardName.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        return [self getDictErrorToPaymentWithMsg:ERROR_NAME];
    }
    else if (![self verifyCreditCardExpirationDate])
    {
        self.creditCardExpirationDate.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        return [self getDictErrorToPaymentWithMsg:ERROR_VALIDATE_CCARD];
    }
    else if (self.creditCardCvv.text.length == 0)
    {
        self.creditCardCvv.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        return [self getDictErrorToPaymentWithMsg:ERROR_SEC_CCARD];
    }
    else if (self.installmentSelectedTextField.text.length == 0)
    {
        self.installmentSelectedTextField.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        return [self getDictErrorToPaymentWithMsg:ERROR_INSTALLMENTS];
    }
    else if (![self validateCpfCnpj])
    {
        self.clientDocument.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
        return [self getDictErrorToPaymentWithMsg:ERROR_CNPJ_CPF];
    }
    
    //If success then inform other class
    BOOL hasInterest = NO;
    self.cardAlreadySelected = YES;
    
    if ([self.paymentNumber isEqualToString:@"1"]) {
        hasInterest = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt1"];
    } else {
        hasInterest = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt2"];
    }
    
    NSMutableString *creditCardNumber = [[NSMutableString alloc] initWithString:self.creditCardNumber.text];
    NSString *creditCardToServer = [self setMaskToCardNumber:creditCardNumber];
    
    NSDictionary *dictPayment = @{@"blockOperation"     :   [NSNumber numberWithBool:NO],
                                  @"nameCard"           :   self.creditCardName.text ?: @"",
                                  @"documentNumber"     :   self.clientDocument.text ?: @"",
                                  @"cardNumber"         :   creditCardToServer ?: @"",
                                  @"codCardNumber"      :   self.creditCardCvv.text ?: @"",
                                  @"monthCard"          :   [self getCreditCardExpirationMonth] ?: @"",
                                  @"yearCard"           :   [self getCreditCardExpirationYear] ?: @"",
                                  @"installmentsCard"   :   self.installmentSelectedTextField.text ?: @"",
                                  @"paymentNumber"      :   self.paymentNumber ?: @"",
                                  @"cardId"             :   [self getCardNameWithName:[CreditCardInteractor valueForFlag:self.creditCardFlag]] ?: @"",
                                  @"cardName"           :   [CreditCardInteractor valueForFlag:self.creditCardFlag] ?: @"",
                                  @"installmentsChoosed":   self.installmentSelectedTextField.text ?: @"",
                                  @"cardSelected"       :  [NSNumber numberWithBool:self.cardAlreadySelected],
                                  @"hasInterest"        :  [NSNumber numberWithBool:hasInterest],
                                  @"allowSaveCard"      :  [NSNumber numberWithBool:self.saveCard]
                                  };
    
    return dictPayment;
}

- (void)setRateTextLabel:(NSString *)rateText {
    self.rateLabel.text = rateText;
    [self layoutIfNeeded];
    
    if (self.rateLabel.isHidden) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.rateLabel setHidden:NO];
            self.rateLabelTopContraint.constant = self.rateLabelTopContraintDefault;
            [self.delegate WBRPaymnetAddNewCardView:self didUpdateContentHeight:@(self.layer.frame.size.height + self.rateLabel.layer.frame.size.height + self.rateLabelTopContraint.constant)];
            [self layoutIfNeeded];
        }];
        
        
    }
}

- (void)hideRateLabelAnimated:(BOOL)animated {
    if (self.rateLabel.isHidden) return;
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self hideRateLabel];
        }];
    } else {
        [self hideRateLabel];
    }
}

- (void)resetContentValues {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.creditCardNumber.text = @"";
        self.creditCardName.text = @"";
        self.creditCardName.text = @"";
        self.creditCardCvv.text = @"";
        self.creditCardExpirationDate.text = @"";
        self.installmentSelectedTextField.text = @"";
        self.clientDocument.text = @"";
        self.creditCardFlagImage.image = nil;
        
        if (self.saveCard) {
            [self.saveCardToggleButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }];
}

#pragma mark - Private Methods

- (void)hideRateLabel {
    [self.rateLabel setText:@""];
    [self.rateLabel setHidden:YES];
    [self.delegate WBRPaymnetAddNewCardView:self didUpdateContentHeight:@(self.layer.frame.size.height - self.rateLabel.layer.frame.size.height - self.rateLabelTopContraint.constant)];
    self.rateLabelTopContraint.constant = 0;
    [self layoutIfNeeded];
}

- (NSString *)getCreditCardExpirationMonth {
    if (self.creditCardExpirationDate.text.length < 5) {
        return nil;
    }
    
    NSString *date = self.creditCardExpirationDate.text;
    LogInfo(@"Month: %@", [date substringToIndex:2]);
    return [date substringToIndex:2];
}

- (NSString *)getCreditCardExpirationYear {
    if (self.creditCardExpirationDate.text.length < 5) {
        return nil;
    }
    NSString *date = self.creditCardExpirationDate.text;
    LogInfo(@"Year: %@", [date substringFromIndex:3]);
    return [date substringFromIndex:3];
}

- (NSString *)getCardNameWithName:(NSString *) nameCard {
    NSDictionary *dictAllCards = @{
                                   @"visa"       : @"1",
                                   @"amex"       : @"2",
                                   @"mastercard" : @"3",
                                   @"diners"     : @"4",
                                   @"hiper"      : @"22",
                                   @"elo"        : @"33"
                                   };
    NSString *idCard = [dictAllCards objectForKey:nameCard];
    return idCard;
}

- (NSString *)setMaskToCardNumber:(NSMutableString *)card {
    
    //LogInfo(@"Credit Card Mask: %@", self.cCardSelected);
    NSInteger lenght = card.length;
    
    self.creditCardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:card];
    UIImage *imageForCurrentFlag = [CreditCardInteractor minImageForFlag:_creditCardFlag];
    [self.creditCardFlagImage setImage:imageForCurrentFlag];
    
    [card replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, card.length)];
    [card replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, card.length)];
    
    if (_creditCardFlag == CreditCardFlagVisa || _creditCardFlag == CreditCardFlagMaster || _creditCardFlag == CreditCardFlagElo) {
        
        if (lenght > 4) {
            [card insertString:@"." atIndex:4];
        }
        
        //(####.####.)
        if (lenght > 9) {
            [card insertString:@"." atIndex:9];
        }
        
        //(####.####.####.)
        if (lenght > 14) {
            [card insertString:@"." atIndex:14];
        }
    }
    else if (_creditCardFlag == CreditCardFlagAmex) {
        
        //(####.)
        if (lenght > 4) {
            [card insertString:@"." atIndex:4];
        }
        
        //(####.######.)
        if (lenght > 11) {
            [card insertString:@"." atIndex:11];
        }
    }
    else if (_creditCardFlag == CreditCardFlagDiners) {
        
        //(####.)
        if (lenght > 4) {
            [card insertString:@"." atIndex:4];
        }
        
        //(####.######.)
        if (lenght > 11) {
            [card insertString:@"." atIndex:11];
        }
    }
    else if (_creditCardFlag == CreditCardFlagHiper) {
        //(####.)
        if (lenght > 4) {
            [card insertString:@"." atIndex:4];
        }
        
        //(####.####.)
        if (lenght > 9) {
            [card insertString:@"." atIndex:9];
        }
        
        //(####.####.####.)
        if (lenght > 14) {
            [card insertString:@"." atIndex:14];
        }
    }
    
    return card;
}

#pragma mark - IBAction

- (IBAction)addNewCardAction:(id)sender {
    [WMOmniture trackCreditCardAdd];
    [UIView animateWithDuration:0.3 animations:^{
        [self showAddForm:YES];
    }];
}

- (IBAction)saveCardPressed:(id)sender {
    self.saveCard = !self.saveCard;
}

- (IBAction)openPaymentOptions:(id)sender {
    [self.installmentSelectedTextField defaultBorderColor];
    if ([self.delegate respondsToSelector:@selector(paymentAddNewCardViewOpenPaymentOptions)]) {
        [self.delegate paymentAddNewCardViewOpenPaymentOptions];
    }
}

- (IBAction)presentCameraToScanCreditCard
{
    if ([self.delegate respondsToSelector:@selector(paymentAddNewCardViewPressedScanCardButton:)])
    {
        [self.delegate paymentAddNewCardViewPressedScanCardButton:self];
    }
}

#pragma mark - Custom Getter

- (NSNumber *)suggestedHeight {
    
    NSNumber *suggestedHeight;
    if (self.currentState == kAddNewCardStateShowingAddButton) {
        
        suggestedHeight = [NSNumber numberWithInteger:kAddNewCardStateShowingAddButtonHeight];
    }
    else {
        
        NSNumber *height = self.saveCardView.hidden ? [NSNumber numberWithInteger:kAddNewCardStateShowingFormWithoutSaveCardButtonHeight] : [NSNumber numberWithInteger:kAddNewCardStateShowingFormHeight] ;
        
        if (!self.rateLabel.isHidden) {
            height = [NSNumber numberWithInt:([height intValue] + self.rateLabel.layer.frame.size.height + self.rateLabelTopContraint.constant)] ;
        }
        
        height = @([height floatValue] + self.titleLabelHeightConstraint.constant + self.titleLabelBottomConstraint.constant);
        
        suggestedHeight = height;
    }
    
    return suggestedHeight;
}

- (void)setSaveCard:(BOOL)saveCard {
    _saveCard = saveCard;
    if (saveCard) {
        [self.saveCardToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_on.png"] forState:UIControlStateNormal];
    } else {
        [self.saveCardToggleButton setImage:[UIImage imageNamed:@"btn_checkbox_off.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - CardIOPaymentViewControllerDelegate
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    if (cardInfo)
    {
        self.creditCardNumber.text = cardInfo.cardNumber;
        
        if (cardInfo.cvv.length > 0) self.creditCardCvv.text = cardInfo.cvv;

        NSString *month = @"";
        NSString *year = @"";
        if (cardInfo.expiryMonth != 0) month = [NSString stringWithFormat:@"%.2lu", (unsigned long)cardInfo.expiryMonth];
        if (cardInfo.expiryYear != 0) year = @(cardInfo.expiryYear).stringValue;
        
        if (month.length == 2 && year.length == 2) {
            self.creditCardExpirationDate.text = [NSString stringWithFormat:@"%@/%@", month, year];
        }
    }
    else
    {
        if (_hasProduct) [WMOmniture trackCreditCardScanProductError];
        if (_hasExtendedWarranty) [WMOmniture trackCreditCardScanWarrantyError];
    }
    
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        NSMutableString *cardNumber = [[NSMutableString alloc] initWithString:self.creditCardNumber.text];
        [self applyMasksOnCreditCardsWithString:cardNumber inTextField:self.creditCardNumber];
        [self.delegate paymentAddNewCardViewCallInstallments];
        
        if (![self hasValidCard] || ![self validateCardForTypeWithText:self.creditCardNumber.text] || self.creditCardFlag == CreditCardFlagUnrecognized)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:self];
            [self.delegate paymentAddNewCardViewShowFeedbackAlertOfKind:WarningAlert message:ERROR_READING_CREDIT_CARD];
        }
    }];
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.clientDocument) {
        NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![acceptableCharactersSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        NSMutableString *mutableResult = [[NSMutableString alloc] initWithString:[textField.text stringByAppendingString:string]];
        NSInteger lenght = mutableResult.length;
        BOOL isCPF = (lenght <= 14) ? YES : NO;
        
        if (lenght > 18) return NO;
        
        if (isCPF)
        {
            [mutableResult replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
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
            
            if (range.length == 1 && string.length == 0) return YES;
            if (insertedPunctuation) return NO;
        }
        else
        {
            //CNPJ
            [mutableResult replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
            [mutableResult replaceOccurrencesOfString:@"-" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
            [mutableResult replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, mutableResult.length)];
            
            BOOL insertedPunctuation = NO;
            //(00.)
            if (lenght > 2)
            {
                [mutableResult insertString:@"." atIndex:2];
                textField.text = mutableResult;
                insertedPunctuation = YES;
            }
            
            //(00.000.)
            if (lenght > 6)
            {
                [mutableResult insertString:@"." atIndex:6];
                textField.text = mutableResult;
                insertedPunctuation = YES;
            }
            
            //(00.000.000/)
            if (lenght > 10)
            {
                [mutableResult insertString:@"/" atIndex:10];
                textField.text = mutableResult;
                insertedPunctuation = YES;
            }
            
            //(00.000.000/0000-)
            if (lenght > 15)
            {
                [mutableResult insertString:@"-" atIndex:15];
                textField.text = mutableResult;
                insertedPunctuation = YES;
            }
            
            if (range.length == 1 && string.length == 0) return YES;
            if (insertedPunctuation) return NO;
        }
        
        return YES;
    }
    else if (textField == self.creditCardCvv) {
        //Security Code
        NSUInteger newLengthSecCode = [textField.text length] + [string length] - range.length;
        if(newLengthSecCode > 4){
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (textField == self.creditCardName) {
        //Name on Credit Card
        NSUInteger newLengthOwnerName = [textField.text length] + [string length] - range.length;
        if(newLengthOwnerName > 50){
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (textField == self.creditCardNumber) {
        //Credit Card number
        NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![acceptableCharactersSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        NSMutableString *mutableResult = [[NSMutableString alloc] initWithString:[textField.text stringByAppendingString:string]];
        if (range.length==1 && string.length==0)
        {
            NSString *str = textField.text;
            NSString *truncatedString = [str substringToIndex:[str length]-1];
            mutableResult = [[NSMutableString alloc] initWithString:truncatedString];
        }
        
        return [self applyMasksOnCreditCardsWithString:mutableResult inTextField:textField];
        
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
            if ([self hasValidCard]) {
                
                if ([self.delegate respondsToSelector:@selector(paymentAddNewCardViewCallInstallments)]) {
                    [self.delegate paymentAddNewCardViewCallInstallments];
                }
                
            } else {

                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:self];
                
                [self endEditing:YES];
                if ([self.delegate respondsToSelector:@selector(showFeedbackAlertOfKind:message:)]) {
                    [self.delegate paymentAddNewCardViewShowFeedbackAlertOfKind:WarningAlert message:ERROR_CREDIT_CARD];
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.creditCardNumber.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
                    
                    //                self.installments = nil;
                    self.installmentSelectedTextField.text = @"";
                    self.installmentSelectedTextField.placeholder = @"Quantidade de Parcelas";
                }];
                
            }
        }
    } else if (textField == self.creditCardExpirationDate) {
        if (self.creditCardExpirationDate.text.length > 0) {
            if (![WBRCreditCardValidation verifyCreditCardExpirationDate:self.creditCardExpirationDate.text]) {
                
                [self endEditing:YES];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.creditCardExpirationDate.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
                }];
                
                if ([self.delegate respondsToSelector:@selector(paymentAddNewCardViewShowFeedbackAlertOfKind:message:)]) {
                    [self.delegate paymentAddNewCardViewShowFeedbackAlertOfKind:WarningAlert message:ERROR_EXPIRATION_DATE_CCARD];
                }
            }
        }
    }
}

#pragma mark - Validation

- (BOOL) applyMasksOnCreditCardsWithString:(NSMutableString *) strText inTextField:(UITextField *) textField
{
    //LogInfo(@"Credit Card Mask: %@", self.cCardSelected);
    NSInteger lenght = strText.length;
    
    self.creditCardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:strText];
    UIImage *imageForCurrentFlag = [CreditCardInteractor minImageForFlag:_creditCardFlag];
    [self.creditCardFlagImage setImage:imageForCurrentFlag];
    
    if (_creditCardFlag == CreditCardFlagVisa || _creditCardFlag == CreditCardFlagMaster || _creditCardFlag == CreditCardFlagElo)
    {
        if (lenght > 19) return NO;
        [strText replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, strText.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [strText insertString:@" " atIndex:4];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.)
        if (lenght > 9)
        {
            [strText insertString:@" " atIndex:9];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.####.)
        if (lenght > 14)
        {
            [strText insertString:@" " atIndex:14];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.####.####)
        if (insertedPunctuation) return NO;
    }
    else if (_creditCardFlag == CreditCardFlagAmex)
    {
        if (lenght > 17) return NO;
        [strText replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, strText.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [strText insertString:@" " atIndex:4];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.######.)
        if (lenght > 11)
        {
            [strText insertString:@" " atIndex:11];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        ////(####.######.#####)
        if (insertedPunctuation) return NO;
    }
    else if (_creditCardFlag == CreditCardFlagDiners)
    {
        if (lenght > 16) return NO;
        [strText replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, strText.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [strText insertString:@" " atIndex:4];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.######.)
        if (lenght > 11)
        {
            [strText insertString:@" " atIndex:11];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        ////(####.######.####)
        if (insertedPunctuation) return NO;
    }
    else if (_creditCardFlag == CreditCardFlagHiper)
    {
        if (lenght > 19) return NO;
        
        [strText replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, strText.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [strText insertString:@" " atIndex:4];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.)
        if (lenght > 9)
        {
            [strText insertString:@" " atIndex:9];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.####.)
        if (lenght > 14)
        {
            [strText insertString:@" " atIndex:14];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        ////(####.####.####.#######)
        if (insertedPunctuation) return NO;
    }
    else {
        if (lenght > 19) return NO;
    }
    
    return YES;
}

- (BOOL)hasValidCard {
    NSString *strVerifyValidCard = [self getNameCardWithNumber:self.creditCardNumber.text];
    BOOL cardVerified = ([strVerifyValidCard isEqualToString:self.cCardSelected]) ? YES : NO;
    return self.creditCardNumber.text.length > 0 && [self validateCardForTypeWithText:self.creditCardNumber.text] && cardVerified;
}

- (NSString *) getNameCardWithNumber:(NSString *) cardNumber {
    
    cardNumber = [self cleanPunctuation:cardNumber];
    
    //For VISA
    //    NSString *regexVisa = @"^4[0-9]*";
    NSString *regexVisa = @"^(?!451416)\(?!40117[8-9])\(?!431274)\(?!438935)\(?!457393)\(?!45763[1-2])(4[0-9])[0-9]*";
    NSPredicate *predVisa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexVisa];
    NSInteger minimumLenghtVisa = 16;
    //For AMEX
    NSString *regexAmex = @"^3[47][0-9]*";
    NSPredicate *predAmex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexAmex];
    NSInteger minimumLenghtAmex = 15;
    //For MASTERCARD
    NSString *regexMaster = @"^5[1-5][0-9]*";
    NSPredicate *predMaster = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexMaster];
    NSInteger minimumLenghtMaster = 16;
    //For DINERS
    NSString *regexDiners = @"^3(?:0[0-5]|[68][0-9])[0-9]*";
    NSPredicate *predDiners = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexDiners];
    NSInteger minimumLenghtDiners = 14;
    //For HIPER
    NSString *regexHiper = @"^(3841|606282)[0-9]*";
    NSPredicate *predHiper = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexHiper];
    NSInteger minimumLenghtHiper = 16;
    //For ELO
    //    NSString *regexElo = @"^(40117(8|9)|431274|438935|636297|451416|45763(1|2)|504175|627780|636297|636368|506699|457393|5067([0-6])|50677([0-8])|509[0-9])[0-9]*";
    NSString *regexElo = @"^(40117(8|9)|431274|438935|457393|636297|451416|45763(1|2)|504175|506699|5067([0-6])|50677([0-8])|509[0-9]|627780|636297|636368|65003[1-3]|65003[5-9]|65004[0-9]|65005[0-1]|65040[5-9]|6504[1-3][0-9]|65048[5-9]|65049[0-9]|6505[0-2][0-9]|65053[0-8]|65054[1-9]|6505[0-8][0-9]|65059[0-8]|65070[0-9]|65071[0-8]|65072[0-7]|65090[1-9]|65091[0-9]|650920|65165[2-9]|6516[6-7][0-9]|65500[0-9]|65501[0-9]|65502[1-9]|6550[3-4][0-9]|65505[0-8])[0-9]*";
    NSPredicate *predElo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexElo];
    NSInteger minimumLenghtElo = 16;
    
    if (([predVisa evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtVisa)) {
        self.cCardSelected = @"visa";
        return @"visa";
    }
    else if (([predAmex evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtAmex)) {
        self.cCardSelected = @"amex";
        return @"amex";
    }
    else if (([predMaster evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtMaster)) {
        self.cCardSelected = @"mastercard";
        return @"mastercard";
    }
    else if (([predDiners evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtDiners)) {
        self.cCardSelected = @"diners";
        return @"diners";
    }
    else if (([predHiper evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtHiper)) {
        self.cCardSelected = @"hiper";
        return @"hiper";
    }
    else if (([predElo evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtElo)) {
        self.cCardSelected = @"elo";
        return @"elo";
    }
    else {
        return nil;
    }
}

- (NSString *)cleanPunctuation:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return text;
}

- (BOOL)validateCardForTypeWithText:(NSString *)text
{
    text = [self cleanPunctuation:text];
    NSString *regex = nil;
    NSInteger minimiumLenght = 0;
    
    if ([self.cCardSelected isEqualToString:@"visa"])
    {
        //        regex= @"^4[0-9]*";
        regex= @"^(?!451416)\(?!40117[8-9])\(?!431274)\(?!438935)\(?!457393)\(?!45763[1-2])(4[0-9])[0-9]*";
        minimiumLenght = 16;
    }
    else if ([self.cCardSelected isEqualToString:@"amex"])
    {
        regex= @"^3[47][0-9]*";
        minimiumLenght = 15;
    }
    else if ([self.cCardSelected isEqualToString:@"mastercard"])
    {
        regex= @"^5[1-5][0-9]*";
        minimiumLenght = 16;
    }
    else if ([self.cCardSelected isEqualToString:@"diners"])
    {
        regex= @"^3(?:0[0-5]|[68][0-9])[0-9]*";
        minimiumLenght = 14;
    }
    else if ([self.cCardSelected isEqualToString:@"hiper"])
    {
        regex= @"^(3841|606282)[0-9]*";
        minimiumLenght = 16;
    }
    else if ([self.cCardSelected isEqualToString:@"elo"])
    {
        //        regex= @"^(40117(8|9)|431274|438935|636297|451416|45763(1|2)|504175|627780|636297|636368|506699|457393|5067([0-6])|50677([0-8])|509[0-9])[0-9]*";
        
        regex=@"^(40117(8|9)|431274|438935|457393|636297|451416|45763(1|2)|504175|506699|5067([0-6])|50677([0-8])|509[0-9]|627780|636297|636368|65003[1-3]|65003[5-9]|65004[0-9]|65005[0-1]|65040[5-9]|6504[1-3][0-9]|65048[5-9]|65049[0-9]|6505[0-2][0-9]|65053[0-8]|65054[1-9]|6505[0-8][0-9]|65059[0-8]|65070[0-9]|65071[0-8]|65072[0-7]|65090[1-9]|65091[0-9]|650920|65165[2-9]|6516[6-7][0-9]|65500[0-9]|65501[0-9]|65502[1-9]|6550[3-4][0-9]|65505[0-8])[0-9]*";
        minimiumLenght = 16;
    }
    
    LogInfo(@"Text length: %lu [%@]", (unsigned long)[text length], text);
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (([regexTest evaluateWithObject:text]) && (text.length == minimiumLenght))
    {
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)getDictErrorToPaymentWithMsg:(NSString *) msgError
{
    BOOL blockOperation = YES;
    NSDictionary *dictPaymentError = @{@"blockOperation"     :   [NSNumber numberWithBool:blockOperation],
                                       @"error"              :   msgError,
                                       @"paymentNumber"      :   self.paymentNumber,
                                       @"installmentsChoosed":  self.installmentSelectedTextField.text ?: @"",
                                       @"cardSelected"       :  [NSNumber numberWithBool:self.cardAlreadySelected]
                                       };
    return dictPaymentError;
}

- (BOOL) validateCpfCnpj
{
    BOOL valid = NO;
    
    //Validation
    [self endEditing:YES];
    
    if ([self isCPFValid:[self cleanPunctuation:self.clientDocument.text]])
    {
        LogInfo(@"CPF válido");
        valid = YES;
    }
    else
    {
        LogErro(@"CPF inválido");
    }
    
    if ([self isCNPJValid:[self cleanPunctuation:self.clientDocument.text]])
    {
        LogInfo(@"CNPJ válido");
        valid = YES;
    }
    else
    {
        LogErro(@"CNPJ inválido");
    }
    
    return valid;
}

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

- (BOOL) verifyCreditCardExpirationDate
{
    if (self.creditCardExpirationDate.text.length < 5) {
        return NO;
    }
    
    // Check month is valid (1, 2, 3.. 12)
    NSString *monthInserted = [self getCreditCardExpirationMonth];
    if ([monthInserted intValue] > 12) {
        return NO;
    }
    
    BOOL successValidate = YES;
    
    //Get date info
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    int year = (int)[components year];
    int month = (int)[components month];
    
    NSString *today = [NSString stringWithFormat:@"%i%02d", year, month];
    
    NSString *dateChoosed = [NSString stringWithFormat:@"20%@%@", [self getCreditCardExpirationYear], monthInserted];
    
    // Check expiration date is higher than today
    if ([today intValue] > [dateChoosed intValue])
    {
        successValidate = NO;
    }
    
    return successValidate;
}

@end
