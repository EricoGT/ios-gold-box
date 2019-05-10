//
//  WBRPaymentMethodsView.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/25/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentMethodsView.h"

#import "WBRPaymentOptionsView.h"
#import "WBRPaymentCreditCardContent.h"
#import "NSNumber+Currency.h"

#pragma mark - Legacy Imports

#import "OFSetupCustomCheckout.h"
#import "OFAddressTemp.h"
#import "WMBankingTicket.h"
#import "WBRPaymentViewController.h"
#import "OFPayTemp.h"
#import "PaymentOptionsViewController.h"
#import "Installment.h"
#import "OFSetup.h"
#import "OFMessages.h"

#import "CardIOPaymentViewController.h"
#import "CardIOCreditCardInfo.h"
#import "CreditCardInteractor.h"

#import "SecTextField.h"
#import "WBRPaymentManager.h"

@interface WBRPaymentMethodsView () <WBRPaymentOptionsViewProtocol, WBRPaymentCreditCardContentProtocol, PaymentOptionsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet WBRPaymentOptionsView *paymentOptionsView;
@property (weak, nonatomic) IBOutlet WBRPaymentCreditCardContent *paymentCreditCardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typePaymentLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentOptionsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *informationHeaderViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *bankSlipValueLabel;

@property (assign, nonatomic) BOOL paymentTypeCreditCard;

#pragma mark - Legacy CardPaymentCell Properties

@property (weak) IBOutlet UIView *viewCardBackground;
@property (weak) IBOutlet UIView *viewValueToPayInThisCard;
@property (weak) IBOutlet UIView *viewCardOwnerName;
@property (weak) IBOutlet UIView *viewDocumentOwnerNumber;
@property (weak) IBOutlet UIView *viewCardNumber;
@property (weak) IBOutlet UIView *viewCodCardNumber;
@property (weak) IBOutlet UILabel *lblDate;
@property (weak) IBOutlet UIView *viewMonthCard;
@property (weak) IBOutlet UIView *viewYearCard;
@property (weak) IBOutlet UIView *viewInstallments;
@property (weak) IBOutlet UILabel *lblTitlePayment;
@property (weak) IBOutlet UILabel *lblTitleInfoPayment;

@property (weak, nonatomic) IBOutlet UIImageView *secureWarning;
@property (weak, nonatomic) IBOutlet WMButton *cardReaderButton;

@property (weak) IBOutlet UITextField *txtValueToPayInThisCard;

@property (nonatomic, strong) NSArray *arrCreditCards;
@property (nonatomic, strong) NSMutableArray *arrButtonsCards;


@property (weak) NSString *nameCardSelected;
@property (weak) NSString *strValueFromService;

@property (weak) NSString *paymentNumber;
@property (weak) NSString *strValueToUser;

@property int valueToDebit;

@property (nonatomic, strong) NSArray *arrCreditCardInstallments;

@property (nonatomic) BOOL cardAlreadySelected;
@property (nonatomic) BOOL doublePayment;
@property (nonatomic) BOOL isInstallment;

@property (weak) NSDictionary *installmentsSelected;
@property (nonatomic, assign) NSUInteger installmentsIndexSelected;
@property (nonatomic, strong) Installment *installmentItemSelected;

@property (nonatomic, strong) PaymentPickerViewController *pp;
@property (nonatomic, strong) PaymentOptionsViewController *paymentOptions;

@property int cardSelectedId;

@property (nonatomic, strong) NSDictionary *dictBankingTicket;
@property (nonatomic, strong) NSDictionary *dictInstallsRequest;
@property (nonatomic, strong) NSArray *arrValues;

@property float firstCreditCardMaxCET;
@property float secondCreditCardMaxCET;

@property (nonatomic, weak) IBOutlet WMButton *finishOrderButton;

@property (nonatomic, strong) UIImageView *screenCacheImageView;
@property (nonatomic, strong) UIImageView *imgLogo;

@property (nonatomic, assign) BOOL hideFinishOrderButton;
@property (nonatomic) BOOL showInstallments;

@end

static CGFloat const iPhoneSmallWidthConstant = 320.0f;
static CGFloat const iPhoneMediumWidthConstant = 375.0f;

@implementation WBRPaymentMethodsView

#pragma mark - Init Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    
    UINib *nib = [UINib nibWithNibName:@"WBRPaymentMethodsView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    self.paymentTypeCreditCard = YES;
    
    self.paymentOptionsView.delegate = self;
    self.paymentOptionsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.paymentCreditCardView.delegate = self;
    self.paymentCreditCardView.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - Private Methods

- (void)reloadContentForPaymentType:(kPaymentType)payment {
    
    if ([self.delegate respondsToSelector:@selector(didChangePaymentMethod)]) {
        [self.delegate didChangePaymentMethod];
    }
    
    [self scrollToPayment:payment];
    [self updateContentHeight];
    
    if (payment == kPaymentTypeBankingSlip) {
        [self clearCreditCardInputtedContent];
        self.bankSlipValueLabel.alpha = 0.0f;
        self.paymentTypeCreditCard = NO;
        [self updatePaymentInformation];
    }
    else {
        self.showInstallments = NO;
        [self.paymentCreditCardView resetCardsState];
        self.paymentTypeCreditCard = YES;
        
        self.cCardSelected = [CreditCardInteractor valueForFlag:[self.paymentCreditCardView getCreditCardFlag]];
        
        if ([self.delegate respondsToSelector:@selector(WBRPaymentMethodsViewDidReceiveInstallmentNotification:)]) {
            [self.delegate WBRPaymentMethodsViewDidReceiveInstallmentNotification:self];
        }
    }
}

- (void)scrollToPayment:(kPaymentType)payment {
    
    CGRect scrollViewFrame = self.scrollView.frame;
    scrollViewFrame.origin.x = scrollViewFrame.size.width * payment;
    scrollViewFrame.origin.y = 0;
    
    [self.scrollView scrollRectToVisible:scrollViewFrame animated:YES];
}

- (void)updateContentHeight {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.delegate WBRPaymentMethodsView:self didUpdateContentHeight:self.suggestedHeight];
    }];
}

- (void)showInstallmentOptionsIfNeeded {
    if (self.paymentCreditCardView.currentState == kPaymentCreditCardStateSelectingAddedCard && self.showInstallments) {
        self.showInstallments = NO;
        [self configInstallments:nil];
    }
}

#pragma mark - Public Methods

- (void)clearCreditCardInputtedContent {
    [self.paymentCreditCardView clearCreditCardInputtedContent];
}

- (void)reloadContent {

    if (self.paymentTypeCreditCard) {
        [self reloadContentForPaymentType:kPaymentTypeCreditCard];
    } else {
        [self reloadContentForPaymentType:kPaymentTypeBankingSlip];
    }
    
}

- (void)collapseContent {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.informationHeaderViewHeightConstraint.constant = 0;
        self.paymentOptionsViewHeightConstraint.constant = 0;
        [self.paymentCreditCardView collapseContent];
        
        [self layoutIfNeeded];
    }];
}

- (BOOL) hasValidCard {
    
    NSString *creditCardNumber = [self.paymentCreditCardView getCreditCardNumber];
    NSString *strVerifyValidCard = [self.paymentCreditCardView getNameCardWithNumber:creditCardNumber];
    BOOL cardVerified = ([strVerifyValidCard isEqualToString:_cCardSelected]) ? YES : NO;
    return creditCardNumber.length > 0 && [self validateCardForTypeWithText:creditCardNumber] && cardVerified;
}

- (void)setOnlyCreditCardOption:(BOOL)visible {
    [self.paymentOptionsView setOnlyCreditCardOption:visible];
}

#pragma mark - WBRPaymentMethodsViewProtocol

- (void)WBRPaymentOptionsViewDidSelectCreditCard:(WBRPaymentOptionsView *)paymentOptionsView {
    [self reloadContentForPaymentType:kPaymentTypeCreditCard];
}

- (void)WBRPaymentOptionsViewDidSelectBankingSlip:(WBRPaymentOptionsView *)paymentOptionsView {
    [self reloadContentForPaymentType:kPaymentTypeBankingSlip];
}

#pragma mark - WBRPaymentCreditCardContentProtocol

- (void)WBRPaymentCreditCardContent:(WBRPaymentCreditCardContent *)paymentCreditCardContent didSelectCard:(WBRCardModel *)card {
    
    [self.delegate WBRPaymentMethodsView:self didSelectCard:card];
}

- (void)WBRPaymentCreditCardContent:(WBRPaymentCreditCardContent *)paymentCreditCardContent didUpdateHeight:(NSNumber *)newHeight {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.delegate WBRPaymentMethodsView:self didUpdateContentHeight:[self suggestedHeight]];
    }];
}

- (void)paymentCreditCardContentShowFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message {
    if ([self.delegate respondsToSelector:@selector(paymentMethodsShowFeedbackAlertOfKind:message:)]) {
        [self.delegate paymentMethodsShowFeedbackAlertOfKind:kind message:message];
    }
}

- (void)paymentCreditCardContentOpenPaymentOptions {
    [self configInstallments:nil];
}

- (void)paymentCreditCardContentCallInstallments {
    self.showInstallments = YES;
    
    self.cCardSelected = [CreditCardInteractor valueForFlag:[self getCreditCardFlag]];
    
    if ([self.delegate respondsToSelector:@selector(WBRPaymentMethodsViewDidReceiveInstallmentNotification:)]) {
        [self.delegate WBRPaymentMethodsViewDidReceiveInstallmentNotification:self];
    }
}

- (void)paymentCreditCardContentPressedScanCardButton:(WBRPaymentAddNewCardView *)cardPaymentCell {
    if ([self.delegate respondsToSelector:@selector(paymentMethodsPressedScanCardButton:)]) {
        [self.delegate paymentMethodsPressedScanCardButton:cardPaymentCell];
    }
}

#pragma mark - Custom Getter

- (NSNumber *)suggestedHeight {
    
    NSNumber *scrollViewContentHeight;
    
    switch (self.paymentOptionsView.selectedPayment) {
        case kPaymentTypeCreditCard:
            scrollViewContentHeight = @([self.paymentCreditCardView.suggestedHeight floatValue]);
            break;
        case kPaymentTypeBankingSlip: {
            CGFloat width = [[UIScreen mainScreen] bounds].size.width;
            if (width == iPhoneSmallWidthConstant) { //4S, 5, 5S
                scrollViewContentHeight = @(305);
            }
            else if (width == iPhoneMediumWidthConstant) { //6, 7, 8...
                scrollViewContentHeight = @(270);
            }
            else { //Plus
                scrollViewContentHeight = @(275);
            }
            break;
        }
    }
    
    NSNumber *allContentHeight = @([scrollViewContentHeight floatValue] + [self.paymentOptionsView.suggestedHeight floatValue] + 21 + self.typePaymentLabelTopConstraint.constant);
    
    return allContentHeight;
}

#pragma mark - Custom Setter

- (void)setWallet:(WBRWalletModel *)wallet {
    self.paymentCreditCardView.wallet = wallet;
}

- (void) updatePriceCard
{
    if ([_paymentNumber isEqualToString:@"1"]) {
        NSString *ttGlobalOrder = [[NSUserDefaults standardUserDefaults] objectForKey:@"valueNoInterest1"];
        NSString *ttGlobal = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:[ttGlobalOrder floatValue]]];
        _txtValueToPayInThisCard.text = ttGlobal;
    }
}

- (void) updatePriceTicket
{
    LogInfo(@"_dictInstallsRequest: %@", _dictInstallsRequest);
    //[[self delegate] updateValueInfos:_arrValues];
    //[[self delegate] updateValueInfosTicket:_arrValues]
    
    NSDictionary *dictContent = [[_arrValues objectAtIndex:0] objectForKey:@"amounts"] ?: @"0";
    NSString *ttGlobalOrder = [dictContent objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
    float ttProductsToShowToUser = [ttGlobalOrder floatValue];
    NSString *strTotalProductsWithServices = @(ttProductsToShowToUser/100).currencyFormat;
    
    NSString *baseString = @"Pagamento à vista";
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", baseString, strTotalProductsWithServices]];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:17.0f] range:[attrString.string rangeOfString:attrString.string]];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:[attrString.string rangeOfString:baseString]];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGBA(76, 175, 80, 1) range:[attrString.string rangeOfString:strTotalProductsWithServices]];
    
    [self.bankSlipValueLabel setAttributedText:attrString];
    self.bankSlipValueLabel.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.bankSlipValueLabel.alpha = 1.0f;
    }];
}

- (void) configInstallments:(id)sender
{
    [self.paymentCreditCardView resignFirstResponderCreditCardNumberField];
    LogInfo(@"Arr credit install: %@", self.arrCreditCardInstallments);

    NSString *installmentsText = [self.paymentCreditCardView getSelectedInstallmentText];
    
    [self hideKeyboardCard];
    
    if (self.paymentCreditCardView.currentState == kPaymentCreditCardStateAddingNewCard) {
        if (![self validateCardForTypeWithText: [self.paymentCreditCardView getCreditCardNumber]] || [self.paymentCreditCardView getCreditCardFlag] == CreditCardFlagUnrecognized) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:self];
            [self.paymentCreditCardView setCreditCardNumberInvalidLayout:true];
            if ([self.delegate respondsToSelector:@selector(paymentMethodsShowFeedbackAlertOfKind:message:)]) {
                [self.delegate paymentMethodsShowFeedbackAlertOfKind:WarningAlert message:ERROR_CREDIT_CARD];
            }
            return;
        }
    }

    NSMutableArray *arrInstalls = [NSMutableArray new];

    for (int i = 0; i < (int)[_arrCreditCardInstallments count]; i++)
    {
        NSDictionary *dictInst = [_arrCreditCardInstallments objectAtIndex:i];

        if ([dictInst objectForKey:@"rate"]) {

            if ([[dictInst objectForKey:@"rate"] doubleValue] == 0) {

                NSString *strOption = [NSString stringWithFormat:@"%@x de R$ %@", [NSString stringWithFormat:@"%@", [dictInst objectForKey:@"installmentAmount"]], [dictInst objectForKey:@"formattedValuePerInstallment"]];
                [arrInstalls addObject:strOption];
            }
        }
        else {

            NSString *strOption = [NSString stringWithFormat:@"%@x de R$ %@", [NSString stringWithFormat:@"%@", [dictInst objectForKey:@"installmentAmount"]], [dictInst objectForKey:@"formattedValuePerInstallment"]];
            [arrInstalls addObject:strOption];
        }
    }

    LogInfo(@"arrInstalls   : %@", arrInstalls);
    LogInfo(@"description   : %@", CREDIT_CARD_SELECT_INSTALMMENTS);
    LogInfo(@"valueSelected : %@", installmentsText);

    NSDictionary *content = @{@"contentArray"   :   arrInstalls,
                              @"description"    :   CREDIT_CARD_SELECT_INSTALMMENTS,
                              @"codField"       :   @"installments",
                              @"valueSelected"  :   installmentsText ?: @""
                              };

    if (arrInstalls.count > 0)
    {
        [self.delegate displayLoadingView];

        if ([OFSetup enableInstallmentsWithRateInCheckout])
        {

            LogInfo(@"Arr credit inst: %@", _arrCreditCardInstallments);

            NSMutableArray *arrAllInst = [NSMutableArray arrayWithArray:_arrCreditCardInstallments];

            NSString *strValue1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"valueNoInterest1"];
            NSString *strValue2 = [[NSUserDefaults standardUserDefaults] stringForKey:@"valueNoInterest2"];

            for (int i=0;i<(int)_arrCreditCardInstallments.count;i++) {

                NSDictionary *dictInst = [_arrCreditCardInstallments objectAtIndex:i];
                if ([[dictInst objectForKey:@"priceWithRate"] floatValue] == 0) {
                    if ([_paymentNumber isEqualToString:@"1"]) {

                        NSMutableDictionary *dictNew = [arrAllInst objectAtIndex:i];
                        [dictNew setValue:strValue1 forKey:@"priceWithRate"];

                    }
                    else if ([_paymentNumber isEqualToString:@"2"]) {

                        NSMutableDictionary *dictNew = [arrAllInst objectAtIndex:i];
                        [dictNew setValue:strValue2 forKey:@"priceWithRate"];
                    }
                }
            }

            LogInfo(@"Arr all inst: %@", arrAllInst);

            NSError *parserError;
            NSArray *installments = [Installment arrayOfModelsFromDictionaries:arrAllInst error:&parserError];

            LogInfo(@"Installments Array (payment number: %@) [%i]: %@", _paymentNumber, (int)[installments count], installments);

            self.paymentOptions = [[PaymentOptionsViewController alloc] initWithInstallments:installments selectedIndex:_installmentsIndexSelected];
            _paymentOptions.view.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
            _paymentOptions.view.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);

            _paymentOptions.delegate = self;
            [self.window addSubview:_paymentOptions.view];

            [self.delegate hideLoadingView];
        }
        else
        {
            self.pp = [[PaymentPickerViewController alloc] initWithNibName:@"PaymentPickerViewController" bundle:nil];
//            _pp.view.frame = CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height);
            _pp.view.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
            _pp.delegate = self;

            [_pp fillPicker:content];

//            [self.view.window addSubview:_pp.view];
            [self.window addSubview:_pp.view];

//            [self hideKeyboardCard];
//            [self.navigationController.view hideModalLoading];
            [self.delegate hideLoadingView];
        }
    }
}

//Payment Options View Controller
- (void)closePaymentOptions {
    [_paymentOptions.view removeFromSuperview];
    _paymentOptions.view = nil;
}

- (void)paymentOptionSelected:(Installment *)installment index:(NSUInteger)index {

    _installmentsIndexSelected = index;
    _installmentItemSelected = installment;
    [self.paymentCreditCardView setInstallmentText: installment.formattedMessageWithRateForCheckout];

    [_paymentOptions.view removeFromSuperview];
    _paymentOptions.view = nil;

    LogInfo(@"Installments selected: %@", _installmentItemSelected);
    
    if ([OFSetup enableInstallmentsWithRateInCheckout])
    {
        LogInfo(@"Rate choosed: %f", _installmentItemSelected.rate.floatValue);
        if (_installmentItemSelected.rate.floatValue > 0)
        {
            LogInfo(@"Payment number: %@", _paymentNumber);
            LogInfo(@"Installments Array: %@", _arrCreditCardInstallments);
            //LogInfo(@"Value of firstCreditCardMaxCET: %.2f", _firstCreditCardMaxCET);

            float rateInst = _installmentItemSelected.rate.floatValue;
            NSString *creditCardMaxCET = [NSString stringWithFormat:@"%.2f", _firstCreditCardMaxCET];
            LogInfo(@"creditCardMaxCET: %@", creditCardMaxCET);

            float valueWithRate = _installmentItemSelected.priceWithRate.floatValue;
            LogInfo(@"Value with rate: %f", valueWithRate);

            NSString *strValueRate = [self currencyFormat:valueWithRate];
            LogInfo(@"Value with rate 2: %@", strValueRate);

            if ([_paymentNumber isEqualToString:@"1"])
            {
                creditCardMaxCET = [NSString stringWithFormat:@"%.2f", _firstCreditCardMaxCET];
                [[NSUserDefaults standardUserDefaults] setObject:creditCardMaxCET forKey:@"firstCreditCET"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasInt1"];
                [[NSUserDefaults standardUserDefaults] setObject:strValueRate forKey:@"priceWithRate1"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f", rateInst] forKey:@"monthInterest1"];
            }
            else
            {
                creditCardMaxCET = [NSString stringWithFormat:@"%.2f", _secondCreditCardMaxCET];
                [[NSUserDefaults standardUserDefaults] setObject:creditCardMaxCET forKey:@"secondCreditCET"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasInt2"];
                [[NSUserDefaults standardUserDefaults] setObject:strValueRate forKey:@"priceWithRate2"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f", rateInst] forKey:@"monthInterest2"];
            }
            //LogInfo(@"Dict Pay: %@", dictPay);

            NSString *monthlyRate = [[NSString stringWithFormat:@"%.2f", rateInst] stringByAppendingString:@"%"];
            NSString *yearlyRate = [creditCardMaxCET stringByAppendingString:@"%"];
            NSString *strText = [NSString stringWithFormat:TRACKING_INSTALLMENTS_RATE_MESSAGE,monthlyRate,yearlyRate];

            [self.paymentCreditCardView setRateLabel: strText];
        }
        else
        {
            [self removeRateMessage];
        }
    }

    LogInfo(@"Has Interest 1: %i", [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt1"]);
    LogInfo(@"Has Interest 2: %i", [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt2"]);

    LogInfo(@"Total Value 1: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"priceWithRate1"]);
    LogInfo(@"Total Value 2: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"priceWithRate2"]);
}

- (void)removeRateMessage
{
    if ([_paymentNumber isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasInt1"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasInt2"];
    }

    [self.paymentCreditCardView hideRateLabelAnimated:YES];
}

- (CreditCardFlag)getCreditCardFlag {
    return [self.paymentCreditCardView getCreditCardFlag];
}

- (NSString *)getCreditCardNumber {
    return [self.paymentCreditCardView getCreditCardNumber];
}

- (NSInteger)getValueToDebit {
    NSInteger valueToDebit = (NSInteger)self.valueToDebit;
    return valueToDebit;
}

- (void)updatePaymentInformation
{
    //TODO: SHOW LOADING
    if ([self.delegate respondsToSelector:@selector(displayLoadingView)]) {
        [self.delegate displayLoadingView];
    }
    self.isInstallment = YES;
    
    //TODO: IMPROVE THIS INFO GATHERING LOGIC
    NSDictionary *dictCredit = [_paymentDictionary valueForKey:@"paymentTypes"];
    if ([dictCredit valueForKey:@"Boleto"])
    {
        NSArray *arrTicket = [dictCredit valueForKey:@"Boleto"];
        if (arrTicket.count > 0) {
            self.dictBankingTicket = [arrTicket objectAtIndex:0];
        }
    }
    
    NSDictionary *dictCreditPayment = @{@"paymentTypeDTO"  :   _dictBankingTicket,
                                        @"credit"   :   [NSNumber numberWithBool:NO]
                                        };
    LogInfo(@"Banking Ticket Payment: %@", dictCreditPayment);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictCreditPayment
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LogNewCheck(@"Json new: %@", jsonString);
    
    [WBRPaymentManager postPaymentInstallments:jsonString successBlock:^(NSString *dataString) {

        [self requestPaymentWithInstallments:dataString];

    } failure:^(NSError *error, NSString *dataString) {
        if (error.code == 401) {
            LogErro(@"401 received! Token expired [%@]! :(", @"installments");
            [self errorCheckoutAuth];
        } else if (error.code == 400) {
            LogErro(@"400!");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:dataString];
                [self errorCheckout:msgError];
            });
        } else {
            LogErro(@"Error code:%ld", (long)error.code);
            [self errorConnNewCheckout:error.localizedDescription];
        }
    }];
}

- (void)requestPaymentWithInstallments:(NSString *) strPaymentWithCart
{
    LogInfo(@"Request Payment with cart (paymentCardViewController): %@", strPaymentWithCart);
    [self requestJsonInstallments:strPaymentWithCart];
}

- (void)processInstallments:(NSString *)strPaymentWithCart {
    LogInfo(@"Request Payment with cart (paymentCardViewController): %@", strPaymentWithCart);
    [self requestJsonInstallments:strPaymentWithCart];
}

- (void) requestJsonInstallments:(NSString *) strJsonInstallments
{
    LogInfo(@"Json Installments: %@", strJsonInstallments);
    
    NSError *error = nil;
    NSData *jsonData = [strJsonInstallments dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    //Json Parse
    NSArray *keys = [jsonObjects allKeys];
    LogInfo(@"Keys Installments: %@", keys);
    
    self.dictInstallsRequest = [jsonObjects valueForKey:@"cart"];
    
    NSDictionary *dictInstallmentsService = [jsonObjects valueForKey:@"installment"];
    LogInfo(@"dictInstall keys: %@", [dictInstallmentsService allKeys]);
    
    _firstCreditCardMaxCET = [[dictInstallmentsService objectForKey:@"firstCreditCardMaxCET"] floatValue];
    _secondCreditCardMaxCET = [[dictInstallmentsService objectForKey:@"secondCreditCardMaxCET"] floatValue];
    
    self.arrValues = @[_dictInstallsRequest, dictInstallmentsService];
    
    NSArray *installments = [dictInstallmentsService objectForKey:@"firstCreditCardInstallmentItemDTOs"];
    if (installments && installments.count > 0) {
        _arrCreditCardInstallments = installments;
    }
    
    if ([_paymentNumber isEqualToString:@"2"])
    {
        self.arrCreditCardInstallments = [dictInstallmentsService objectForKey:@"secondCreditCardInstallmentItemDTOs"];
    }
    LogInfo(@"arrCreditInstall: %@", _arrCreditCardInstallments);
    
    if (dictInstallmentsService[@"firstCreditCardValue"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@([dictInstallmentsService[@"firstCreditCardValue"] floatValue] / 100.0f) ?: nil forKey:@"valueNoInterest1"];
    }
    else if (dictInstallmentsService[@"secondCreditCardValue"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@([dictInstallmentsService[@"secondCreditCardValue"] floatValue] / 100.0f) ?: nil forKey:@"valueNoInterest2"];
    }
    
    if (self.paymentTypeCreditCard) {
        [self updatePriceCard];
        
        if ([self.delegate respondsToSelector:@selector(didChoosePaymentMethodCreditCard)]) {
            [self.delegate didChoosePaymentMethodCreditCard];
        }
        
        [self showInstallmentOptionsIfNeeded];
    }
    else {
        [self updatePriceTicket];
        
        if ([self.delegate respondsToSelector:@selector(didChoosePaymentMethodCreditBankSlip)]) {
            [self.delegate didChoosePaymentMethodCreditBankSlip];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(hideLoadingView)]) {
        [self.delegate hideLoadingView];
    }
    
    [self.paymentCreditCardView clearSelectedInstallment];
    self.installmentItemSelected = nil;
    self.installmentsSelected = nil;
    self.installmentsIndexSelected = 0;
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

//- (void) fillTextFieldWithContent:(NSDictionary *) dictContentField
//{
//    LogInfo(@"Content: %@", dictContentField);
//
//    int lineSelected = [[dictContentField objectForKey:@"lineSelected"] intValue];
//
//    if ([[dictContentField objectForKey:@"codField"] isEqualToString:@"months"])
//    {
//        _txtMonthCard.text = [dictContentField objectForKey:@"valueSelected"];
//    }
//    else if ([[dictContentField objectForKey:@"codField"] isEqualToString:@"years"])
//    {
//        _txtYearCard.text = [dictContentField objectForKey:@"valueSelected"];
//    }
//    else if ([[dictContentField objectForKey:@"codField"] isEqualToString:@"installments"])
//    {
//        _txtInstallments.text = [dictContentField objectForKey:@"valueSelected"];
//        self.installmentsSelected = [_arrCreditCardInstallments objectAtIndex:lineSelected];
//        LogInfo(@"Installments selected: %@", _installmentsSelected);
//    }
//}

- (void) fillInfoPaymentWithDictionary:(NSDictionary *) dictInfo {

    //    _txtInstallments.text = @"";
    [self.paymentCreditCardView clearSelectedInstallment];

    LogInfo(@"dict Info: %@", dictInfo);
    if (isBankingTicket)
    {
        //TODO: CHECK BANKING TICKET
        
//        _secureWarning.hidden = YES;
//        float widthLbl = self.view.frame.size.width - 30;
//        _lblTitlePayment.frame = CGRectMake(_lblTitlePayment.frame.origin.x, _lblTitlePayment.frame.origin.y, widthLbl, _lblTitlePayment.frame.size.height);
//        [_lblTitlePayment sizeToFit];
//
//        CGRect cardReaderButtonFrame = _cardReaderButton.frame;
//        cardReaderButtonFrame.origin.x = _lblTitlePayment.frame.origin.x;
//        cardReaderButtonFrame.origin.y = _lblTitlePayment.frame.origin.y + _lblTitlePayment.frame.size.height + 20;
//        self.cardReaderButton.frame = cardReaderButtonFrame;
//
//        CGRect viewCardFrame = _viewCardBackground.frame;
//        viewCardFrame.origin.y = _cardReaderButton.frame.origin.y + _cardReaderButton.frame.size.height + 20;
//        self.viewCardBackground.frame = viewCardFrame;
    }
    
    NSString *titlePayment = @"Cartões salvos";
    if ([[dictInfo objectForKey:@"doublePayment"] boolValue]) {
        titlePayment = [dictInfo objectForKey:@"titlePayment"];
    }
    [self.paymentCreditCardView setCardContainerLabelText:titlePayment];
    
    self.strValueFromService = [dictInfo objectForKey:@"strValueFromService"];
    LogInfo(@"strValue: %@", _strValueFromService);

    self.valueToDebit = [_strValueFromService intValue];
    self.paymentNumber = [dictInfo objectForKey:@"paymentNumber"];
    self.strValueToUser = [dictInfo objectForKey:@"showUserValue"];
    _lblTitlePayment.text = titlePayment;
    _txtValueToPayInThisCard.text = _strValueToUser;
    self.doublePayment = [[dictInfo objectForKey:@"doublePayment"] boolValue];
    BOOL autoFill = NO;

    [self.paymentCreditCardView setPaymentNumber: self.paymentNumber];
    
    NSString *strValueUser = _strValueToUser;
    strValueUser = [strValueUser stringByReplacingOccurrencesOfString:@"R$ " withString:@""];
    strValueUser = [strValueUser stringByReplacingOccurrencesOfString:@"," withString:@""];
    strValueUser = [strValueUser stringByReplacingOccurrencesOfString:@"." withString:@""];

    float ftValue = [strValueUser floatValue]/100;
    NSString *strValueWithoutInterest = [NSString stringWithFormat:@"%.2f", ftValue];

    LogInfo(@"Payment number # %@: %@", _paymentNumber, strValueWithoutInterest);

    if ([_paymentNumber isEqualToString:@"1"]) {

        [[NSUserDefaults standardUserDefaults] setObject:strValueWithoutInterest forKey:@"valueNoInterest1"];
        LogInfo(@"strValueSaved: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"valueNoInterest1"]);
    }
    else if ([_paymentNumber isEqualToString:@"2"]) {

        [[NSUserDefaults standardUserDefaults] setObject:strValueWithoutInterest forKey:@"valueNoInterest2"];
        LogInfo(@"strValueSaved: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"valueNoInterest2"]);
    }

#ifdef DEBUG
    autoFill = NO;
#endif

#ifdef DEBUGQA
    autoFill = NO;
#endif

#if defined CONFIGURATION_EnterpriseQA
    autoFill = NO;
#endif

#if defined CONFIGURATION_DebugCalabash
    autoFill = NO;
#endif

    if (autoFill)
    {
        if ([_paymentNumber isEqualToString:@"1"])
        {
//            [self fillMockCard3];
        }
        else
        {
//            [self fillMockCard2];
        }
    }

    [self.paymentCreditCardView setHasProduct:[dictInfo[@"hasProduct"] boolValue]];
    [self.paymentCreditCardView setHasExtendedWarranty:[dictInfo[@"hasExtendedWarranty"] boolValue]];

    if (_hideFinishOrderButton)
    {
//        self.finishOrderButton.hidden = YES;
//        CGRect frame = self.view.frame;
//        frame.size.height = _viewCardBackground.frame.origin.y + _viewCardBackground.frame.size.height;
//        self.view.frame = frame;
        
        //TODO: HIDE FINISH BUTTON
    }
}

//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}

- (void) errorConnectionInstallments:(NSString *) msgError
{
    //TODO: HIDE KEYBOARD
    //[self hideKeyboardCard];
    LogErro(@"Error call simulate installments: %@", msgError);
    
    if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
    {
        [self.delegate checkoutError:msgError backToCart:NO];
    }
}

- (void) errorConnNewCheckout:(NSString *) msgError
{
    //TODO: HIDE KEYBOARD
    //[self hideKeyboardCard];
    //[[self delegate] goCreditCards];
    //[self deselectAllCreditCards];
    
    if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
    {
        [self.delegate checkoutError:msgError backToCart:YES];
    }
}

- (void) errorCheckoutAuth
{
    //TODO: HIDE KEYBOARD
    //[self hideKeyboardCard];
    //[[self delegate] goCreditCards];
    
    if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
    {
        [self.delegate checkoutError:ERROR_401_CHECKOUT backToCart:YES];
    }
}

- (void) errorCheckout:(NSDictionary *) dictError
{
    if ([self.delegate respondsToSelector:@selector(hideLoadingView)]) {
        [self.delegate hideLoadingView];
    }
    
    LogNewCheck(@"Error Payment Card Checkout: %@", dictError);
    
    LogInfo(@"isBoleto: %i", isBankingTicket);
    if (isBankingTicket)
    {
        //[[self delegate] goCreditCards];
    }
    
    if ([dictError objectForKey:@"errorId"])
    {
        NSString *errorCode = [dictError objectForKey:@"errorId"];
        
        //Yes, we have a code id
        NSString *msgError = [[OFMessages new] getMsgCheckout:errorCode];
        LogNewCheck(@"Error Payment Card to user: %@", msgError);
        
        if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
        {
            [self.delegate checkoutError:msgError backToCart:YES];
        }
    }
    else if ([dictError objectForKey:@"errorMessage"])
    {
        NSString *errorCode = [dictError objectForKey:@"errorMessage"];
        
        //Yes, we have an error code
        if ([errorCode isEqualToString:@"PREAUTH"])
        {
            NSString *msgError = [[OFMessages new] getMsgCheckout:errorCode];
            LogNewCheck(@"Error Payment Card to user: %@", msgError);
            
            if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
            {
                [self.delegate checkoutError:msgError backToCart:YES];
            }
        }
        else if ([errorCode isEqualToString:@"PRODUCT_UNAVAILABLE"])
            
        {
            NSString *msgError = [[OFMessages new] getMsgCheckout:errorCode];
            LogNewCheck(@"Error Payment Card to user: %@", msgError);
            
            if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
            {
                [self.delegate checkoutError:msgError backToCart:YES];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
            {
                [self.delegate checkoutError:ERROR_CONNECTION_UNKNOWN backToCart:YES];
            }
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
        {
            [self.delegate checkoutError:ERROR_CONNECTION_UNKNOWN backToCart:YES];
        }
    }
}

#pragma mark - Validations and content
- (NSDictionary *)getContentPayment {
    return [self.paymentCreditCardView getContentPayment];
}

- (BOOL)validateCardForTypeWithText:(NSString *)text
{
    text = [self cleanPunctuation:text];
    NSString *regex = nil;
    NSInteger minimiumLenght = 0;

    if ([_cCardSelected isEqualToString:@"visa"])
    {
        //        regex= @"^4[0-9]*";
        regex= @"^(?!451416)\(?!40117[8-9])\(?!431274)\(?!438935)\(?!457393)\(?!45763[1-2])(4[0-9])[0-9]*";
        minimiumLenght = 16;
    }
    else if ([_cCardSelected isEqualToString:@"amex"])
    {
        regex= @"^3[47][0-9]*";
        minimiumLenght = 15;
    }
    else if ([_cCardSelected isEqualToString:@"mastercard"])
    {
        regex= @"^5[1-5][0-9]*";
        minimiumLenght = 16;
    }
    else if ([_cCardSelected isEqualToString:@"diners"])
    {
        regex= @"^3(?:0[0-5]|[68][0-9])[0-9]*";
        minimiumLenght = 14;
    }
    else if ([_cCardSelected isEqualToString:@"hiper"])
    {
        regex= @"^(3841|606282)[0-9]*";
        minimiumLenght = 16;
    }
    else if ([_cCardSelected isEqualToString:@"elo"])
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

- (NSString *)cleanPunctuation:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return text;
}

- (void) hideKeyboardCard
{
    [self endEditing:YES];
}

//Currency
- (NSString *) currencyFormat:(float) value
{
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

@end
