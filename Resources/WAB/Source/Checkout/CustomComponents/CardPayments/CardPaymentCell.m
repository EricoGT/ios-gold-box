//
//  CardPaymentCell.m
//  CustomComponents
//
//  Created by Marcelo Santos on 2/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "CardPaymentCell.h"
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

@interface CardPaymentCell () <PaymentOptionsViewControllerDelegate>

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
@property (weak) IBOutlet UITextField *txtCardOwnerName;
@property (weak) IBOutlet UITextField *txtDocumentOwnerNumber;
@property (weak) IBOutlet UITextField *txtCardNumber;
@property (weak) IBOutlet UITextField *txtCodCardNumber;
@property (weak) IBOutlet UITextField *txtMonthCard;
@property (weak) IBOutlet UITextField *txtYearCard;
@property (weak) IBOutlet UITextField *txtInstallments;

@property (weak) IBOutlet UILabel *rateMessageLabel;

@property (nonatomic, strong) NSArray *arrCreditCards;
@property (nonatomic, strong) NSMutableArray *arrButtonsCards;

@property (weak) NSString *cCardSelected;
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

@property (nonatomic, assign) CreditCardFlag creditCardFlag;
@property (nonatomic, weak) IBOutlet WMButton *finishOrderButton;

@property (nonatomic, strong) UILabel *rateMessage;

@property (nonatomic, strong) UIImageView *screenCacheImageView;
@property (nonatomic, strong) UIImageView *imgLogo;

@end

@implementation CardPaymentCell

@synthesize delegate, isBankingTicket;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([OFSetup backgroundEnable]) {
        //Background Notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleEnteredBackgroundPaymentCell:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleActivePaymentCell:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasInt1"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasInt2"];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"priceWithRate1"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"priceWithRate2"];
    
    self.cardSelectedId = 1000;
    
    _txtCardOwnerName.tag = 1;
    _txtDocumentOwnerNumber.tag = 2;
    _txtCardNumber.tag = 3;
    _txtCodCardNumber.tag = 4;
    
    [self formatCard];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if(_screenCacheImageView != nil) {
        
        _imgLogo = nil;
        
        [_screenCacheImageView removeFromSuperview];
        _screenCacheImageView = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (void) fillMockCard1
{
    _txtCardOwnerName.text = @"Sam's Club de São Paulo";
    _txtDocumentOwnerNumber.text = @"052.641.038-87";
    //_txtCardNumber.text = @""; //3841.0011.1122.2233334
    _txtCodCardNumber.text = @"678";
    _txtMonthCard.text = @"12";
    _txtYearCard.text = @"2020";
    
    NSMutableString *cardNumber = [[NSMutableString alloc] initWithString:_txtCardNumber.text];
    [self applyMasksOnCreditCardsWithString:cardNumber inTextField:_txtCardNumber];
    [self callInstallments];
}

- (void) fillMockCard2
{
    _txtCardOwnerName.text = @"Walmart Brasil de São Paulo";
    _txtDocumentOwnerNumber.text = @"123.696.208-70";
    //_txtCardNumber.text = @"4024.0071.6445.3184";
    _txtCodCardNumber.text = @"345";
    _txtMonthCard.text = @"10";
    _txtYearCard.text = @"2016";
    
    NSMutableString *cardNumber = [[NSMutableString alloc] initWithString:_txtCardNumber.text];
    [self applyMasksOnCreditCardsWithString:cardNumber inTextField:_txtCardNumber];
    [self callInstallments];
}

- (void) fillMockCard3
{
    _txtCardOwnerName.text = @"[MASTER] Walmart Brasil de São Paulo";
    _txtDocumentOwnerNumber.text = @"123.696.208-70";
    _txtCardNumber.text = @"5234.3558.2552.5970";
    _txtCodCardNumber.text = @"345";
    _txtMonthCard.text = @"10";
    _txtYearCard.text = @"2020";
    
    NSMutableString *cardNumber = [[NSMutableString alloc] initWithString:_txtCardNumber.text];
    [self applyMasksOnCreditCardsWithString:cardNumber inTextField:_txtCardNumber];
    [self callInstallments];
}

- (void) fillScrollCreditCardsWithContent:(NSArray *) arrCreditCards
{
    NSDictionary *dictAllCards = @{
                                   @1   : @"visa",
                                   @2   : @"amex",
                                   @3   : @"mastercard",
                                   @4   : @"diners",
                                   @22  : @"hiper",
                                   @33  : @"elo"
                                   };
    
    NSMutableArray *arrCards = [NSMutableArray new];
    
    for (int k = 0; k < (int)[arrCreditCards count]; k++)
    {
        NSDictionary *dictCard = [arrCreditCards objectAtIndex:k];
        NSString *idCardReceived = [dictCard objectForKey:@"idCard"];
        if ([dictAllCards objectForKey:idCardReceived])
        {
            NSString *nameCard = [dictAllCards objectForKey:idCardReceived];
            [arrCards addObject:nameCard];
        }
    }
    
    LogInfo(@"Cards received: %@", arrCards);
    
    self.arrButtonsCards = [NSMutableArray new];
    self.arrCreditCards = [NSArray arrayWithArray:arrCards];
}

- (void) selectCreditCard:(id)sender
{
    UIButton *button = (UIButton*) sender;
    LogInfo(@"Button #: %i", (int)button.tag);
    
    if ((int)button.tag < 1000)
    {
        self.cardSelectedId = (int) button.tag;
    }
    
    if (_cardSelectedId < 1000)
    {
        self.cCardSelected = [_arrCreditCards objectAtIndex:_cardSelectedId];
        LogInfo(@"Credit Card: %@", _cCardSelected);
        
        [[NSUserDefaults standardUserDefaults] setObject:_cCardSelected forKey:@"cardSel"];
        
        //Control state selected
        [self deselectAllCreditCards];
        
        [[_arrButtonsCards objectAtIndex:_cardSelectedId] setSelected:YES];
        UIButton *buttonCard = [_arrButtonsCards objectAtIndex:_cardSelectedId];
        
        buttonCard.layer.masksToBounds = YES;
        buttonCard.layer.borderWidth = 2.0f;
        buttonCard.layer.cornerRadius = 3.0f;
        buttonCard.layer.borderColor = RGBA(26, 117, 207, 1).CGColor;
        
        self.cardAlreadySelected = YES;
        
        if (![OFSetup enableInstallmentsWithRateInCheckout])
        {
            [self.navigationController.view showModalLoading];
            [self callInstallments];
        }
        else
        {
            _txtCardNumber.text = @"";
            _arrCreditCardInstallments = nil;
            _txtCodCardNumber.text = @"";
            _txtYearCard.text = @"";
            _txtYearCard.placeholder = @"Ano";
            _txtMonthCard.text = @"";
            _txtMonthCard.placeholder = @"Mês";
            
            _txtInstallments.text = @"";
            _txtInstallments.placeholder = @"Quantidade de Parcelas";
            [self removeRateMessage];
        }
    }
}

- (void) getInstalls:(NSDictionary *) dictTicket
{
    self.dictBankingTicket = dictTicket;
    
    [self callInstallmentsBankingTicket];
}

- (void) deselectAllCreditCards
{
    for (int i = 0; i < (int)[_arrButtonsCards count]; i++)
    {
        [[_arrButtonsCards objectAtIndex:i] setSelected:NO];
        UIButton *buttonCard = [_arrButtonsCards objectAtIndex:i];
        buttonCard.layer.masksToBounds = YES;
        buttonCard.layer.borderWidth = 2.0f;
        buttonCard.layer.cornerRadius = 3.0f;
        buttonCard.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    }
}

- (void) formatCard
{
    if (!isBankingTicket)
    {
        [self applyRoundedAndBorder:_viewCardBackground];
    }
    
    [self applyRoundedAndBorder:_viewValueToPayInThisCard];
    [self applyRoundedAndBorder:_viewCardOwnerName];
    [self applyRoundedAndBorder:_viewDocumentOwnerNumber];
    [self applyRoundedAndBorder:_viewCardNumber];
    [self applyRoundedAndBorder:_viewCodCardNumber];
    [self applyRoundedAndBorder:_viewMonthCard];
    [self applyRoundedAndBorder:_viewYearCard];
    [self applyRoundedAndBorder:_viewInstallments];
    
    [self applyFontsFields:_txtValueToPayInThisCard];
    [self applyFontsFields:_txtCardOwnerName];
    [self applyFontsFields:_txtDocumentOwnerNumber];
    [self applyFontsFields:_txtCardNumber];
    [self applyFontsFields:_txtCodCardNumber];
    [self applyFontsFields:_txtMonthCard];
    [self applyFontsFields:_txtYearCard];
    [self applyFontsFields:_txtInstallments];
    
    _lblDate.font = [UIFont fontWithName:fontDefault size:sizeFont12];;
    _lblTitlePayment.font = [UIFont fontWithName:fontSemiBold size:sizeFont13];
    _lblTitleInfoPayment.font = [UIFont fontWithName:fontDefault size:sizeFont12];
    
    [_txtValueToPayInThisCard setEnabled:NO];
    _viewValueToPayInThisCard.backgroundColor = RGBA(235, 235, 235, 1);
}

- (void) applyRoundedAndBorder:(UIView *) viewField
{
    viewField.layer.masksToBounds = YES;
    viewField.layer.borderWidth = 1.0f;
    viewField.layer.cornerRadius = 3.0f;
    viewField.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
}

- (void) applyFontsFields:(UITextField *) txtField
{
    txtField.font = [UIFont fontWithName:fontDefault size:sizeFont12];
}

- (void) configMonthCard:(id)sender
{
    [self hideKeyboardCard];
    NSArray *arrMonths = @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"];
    
    self.pp = [[PaymentPickerViewController alloc] initWithNibName:@"PaymentPickerViewController" bundle:nil];
    _pp.view.frame = CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height);
    _pp.delegate = self;
    
    [self.view.window addSubview:_pp.view];
    
    NSDictionary *content = @{@"contentArray"   :   arrMonths,
                              @"description"    :   CREDIT_CARD_SELECT_MONTH,
                              @"codField"       :   @"months",
                              @"valueSelected"  :   _txtMonthCard.text ?: @""
                              };
    [_pp fillPicker:content];
}

- (void) closePicker
{
    [_pp.view removeFromSuperview];
    _pp.view = nil;
}

- (void) configYearCard:(id)sender
{
    [self hideKeyboardCard];
    
    //Get date info
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    int year = (int)[components year];
    
    NSMutableArray *mutArrYear = [NSMutableArray new];
    for (int i=0;i<15;i++) {
        [mutArrYear addObject:[NSString stringWithFormat:@"%i", year+i]];
    }
    
    NSArray *arrYears = [NSArray arrayWithArray:mutArrYear];
    
    self.pp = [[PaymentPickerViewController alloc] initWithNibName:@"PaymentPickerViewController" bundle:nil];
    _pp.view.frame = CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height);
    _pp.delegate = self;
    
    [self.view.window addSubview:_pp.view];
    
    NSDictionary *content = @{@"contentArray"   :   arrYears,
                              @"description"    :   CREDIT_CARD_SELECT_YEAR,
                              @"codField"       :   @"years",
                              @"valueSelected"  :   _txtYearCard.text
                              };
    
    [_pp fillPicker:content];
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
    [[self delegate] updateValueInfos:_arrValues];
    [[self delegate] updateValueInfosTicket:_arrValues];
}

- (void) resetCreditCardNumber
{    
    _arrCreditCardInstallments = nil;
    _txtInstallments.text = @"";
    _txtInstallments.placeholder = @"Quantidade de Parcelas";
    
    _installmentItemSelected = nil;
    _installmentsSelected = nil;
    _installmentsIndexSelected = 0;
}

- (void) configInstallments:(id)sender
{
    [_txtCardNumber resignFirstResponder];
    LogInfo(@"Arr credit install: %@", _arrCreditCardInstallments);
    
    [self hideKeyboardCard];
    
    if (![self validateCardForTypeWithText:_txtCardNumber.text] || _creditCardFlag == CreditCardFlagUnrecognized) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:self];
        [self.navigationController.view showAlertWithMessage:ERROR_CREDIT_CARD];
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
    LogInfo(@"valueSelected : %@", _txtInstallments.text);
    
    NSDictionary *content = @{@"contentArray"   :   arrInstalls,
                              @"description"    :   CREDIT_CARD_SELECT_INSTALMMENTS,
                              @"codField"       :   @"installments",
                              @"valueSelected"  :   _txtInstallments.text ?: @""
                              };
    
    if (arrInstalls.count > 0)
    {
        [self.navigationController.view showModalLoading];
        
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
            //                NSArray *installments = [Installment arrayOfModelsFromDictionaries:_arrCreditCardInstallments error:&parserError];
            NSArray *installments = [Installment arrayOfModelsFromDictionaries:arrAllInst error:&parserError];
            
            LogInfo(@"Installments Array (payment number: %@) [%i]: %@", _paymentNumber, (int)[installments count], installments);
            
            self.paymentOptions = [[PaymentOptionsViewController alloc] initWithInstallments:installments selectedIndex:_installmentsIndexSelected];
            _paymentOptions.view.frame = CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height);
            _paymentOptions.delegate = self;
            [self.view.window addSubview:_paymentOptions.view];
            
            [self hideKeyboardCard];
            [self.navigationController.view hideModalLoading];
        }
        else
        {
            self.pp = [[PaymentPickerViewController alloc] initWithNibName:@"PaymentPickerViewController" bundle:nil];
            _pp.view.frame = CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height);
            _pp.delegate = self;
            
            [_pp fillPicker:content];
            
            [self.view.window addSubview:_pp.view];
            
            [self hideKeyboardCard];
            [self.navigationController.view hideModalLoading];
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
    _txtInstallments.text = installment.formattedMessageWithRateForCheckout;
    
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
            
            CGFloat margin = 15;
            CGFloat rateLabelWidth = self.view.frame.size.width - (margin * 2);
            UIFont *rateLabelFont = [UIFont fontWithName:fontDefault size:sizeFont12];;
            CGSize rateTextSize = [strText sizeForTextWithFont:rateLabelFont constrainedToSize:CGSizeMake(rateLabelWidth, CGFLOAT_MAX)];
            
            self.rateMessage = [[UILabel alloc] initWithFrame:CGRectMake(margin, _viewCardBackground.frame.origin.y + _viewCardBackground.frame.size.height + margin, rateLabelWidth, rateTextSize.height)];
            _rateMessage.textColor = RGBA(153, 153, 153, 1);
            _rateMessage.numberOfLines = 0;
            _rateMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _rateMessage.font = rateLabelFont;
            _rateMessage.backgroundColor = [UIColor clearColor];
            _rateMessage.numberOfLines = 0;
            _rateMessage.text = strText;
            [self.view addSubview:_rateMessage];
            
            if (_hideFinishOrderButton)
            {
                CGRect frame = self.view.frame;
                frame.size.height = _rateMessage.frame.origin.y + _rateMessage.frame.size.height;
                self.view.frame = frame;
            }
            else
            {
                CGRect finishOrderButtonFrame = _finishOrderButton.frame;
                finishOrderButtonFrame.origin.y = _rateMessage.frame.origin.y + _rateMessage.frame.size.height + margin;
                self.finishOrderButton.frame = finishOrderButtonFrame;
                
                CGRect frame = self.view.frame;
                frame.size.height = _finishOrderButton.frame.origin.y + _finishOrderButton.frame.size.height;
                self.view.frame = frame;
            }
            
            if ([self.delegate respondsToSelector:@selector(cardPaymentCell:DidUpdateHeight:)])
            {
                [self.delegate cardPaymentCell:self DidUpdateHeight:self.view.frame.size.height];
            }
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
    
    [_rateMessage removeFromSuperview];
    _rateMessage = nil;
    
    CGFloat margin = 15;
    if (_hideFinishOrderButton)
    {
        CGRect frame = self.view.frame;
        frame.size.height = _viewCardBackground.frame.origin.y + _viewCardBackground.frame.size.height;
        self.view.frame = frame;
    }
    else
    {
        CGRect finishOrderButtonFrame = _finishOrderButton.frame;
        finishOrderButtonFrame.origin.y = _viewCardBackground.frame.origin.y + _viewCardBackground.frame.size.height + margin;
        self.finishOrderButton.frame = finishOrderButtonFrame;
        
        CGRect frame = self.view.frame;
        frame.size.height = _finishOrderButton.frame.origin.y + _finishOrderButton.frame.size.height;
        self.view.frame = frame;
    }
    
    if ([self.delegate respondsToSelector:@selector(cardPaymentCell:DidUpdateHeight:)])
    {
        [self.delegate cardPaymentCell:self DidUpdateHeight:self.view.frame.size.height];
    }
}


- (void) callInstallments
{
    _txtInstallments.text = @"";
    self.installmentsIndexSelected = 0;
    
    _cCardSelected = [CreditCardInteractor valueForFlag:_creditCardFlag];
    if (_cCardSelected.length <= 0) return;

    [self.navigationController.view showModalLoading];
    [[NSUserDefaults standardUserDefaults] setObject:_cCardSelected forKey:@"cardSel"];
    self.isInstallment = YES;
    
    LogInfo(@"Value to Debit: %i", _valueToDebit);
    
    NSString *nameCard = _cCardSelected;
    if ([nameCard isEqualToString:@"hiper"]) {
        nameCard = @"HIPERCARD";
    } else if ([nameCard isEqualToString:@"master"]) {
        nameCard = @"MASTERCARD";
    }
    NSString *typeCard = [self getCardNameWithName:_cCardSelected];
    LogInfo(@"Cod Card : %@", typeCard);
    LogInfo(@"Name Card: %@", nameCard);
    
    NSDictionary *addressInfo = [[OFAddressTemp new] getAddressDictionary];
    NSString *billingAddressId = [addressInfo objectForKey:@"id"];
    
    NSString *cardIndex = @"card1";
    
    if ([_paymentNumber isEqualToString:@"2"])
    {
        cardIndex = @"card2";
    }
    
    NSDictionary *dictFirstCreditCard = @{@"cardViewNumber" : cardIndex,
                                          @"id"             : typeCard,
                                          @"name"           : [nameCard uppercaseString],
                                          @"type"           : @"CREDIT_CARD",
                                          @"credit"         : [NSNumber numberWithBool:YES],
                                          @"firstCreditCardAmount"   : [NSNumber numberWithInt:0],
                                          @"moip"           : [NSNumber numberWithBool:NO],
                                          @"billingAddressId": [NSNumber numberWithInt:[billingAddressId intValue]],
                                          @"sigeBankId"     : [NSNumber numberWithInt:0],
                                          @"sigePaymentTypeId": [NSNumber numberWithInt:1]
                                          };
    
    if ([OFSetup enableInstallmentsWithRateInCheckout]) {
        
        //Calculate bin
        NSString *strCardNb = [self cleanPunctuation:_txtCardNumber.text];
        
        if (strCardNb.length >= 6) {
            
            NSString *strBin = [strCardNb substringToIndex:6];
            int binNb = [strBin intValue];
            
            dictFirstCreditCard = @{@"cardViewNumber"   : cardIndex,
                                    @"bin"              : [NSNumber numberWithInt:binNb],
                                    @"id"               : typeCard,
                                    @"name"             : [nameCard uppercaseString],
                                    @"type"             : @"CREDIT_CARD",
                                    @"credit"           : [NSNumber numberWithBool:YES],
                                    @"firstCreditCardAmount"   : [NSNumber numberWithInt:0],
                                    @"moip"             : [NSNumber numberWithBool:NO],
                                    @"billingAddressId" : [NSNumber numberWithInt:[billingAddressId intValue]],
                                    @"sigeBankId"       : [NSNumber numberWithInt:0],
                                    @"sigePaymentTypeId": [NSNumber numberWithInt:1]
                                    };
        }
    }
    
    NSDictionary *dictTypeDTO;
    
    NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"dictCreditPrevious"];
    NSDictionary *dictCreditPrevious = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
    
    if ([_paymentNumber isEqualToString:@"1"])
    {
        if (!dictCreditPrevious)
        {
            dictTypeDTO = @{@"firstCreditCard"         : dictFirstCreditCard,
                            @"secondCreditCard"        : [NSNull null],
                            @"firstCreditCardAmount"   : [NSNumber numberWithInt:_valueToDebit],
                            @"credit"                  : [NSNumber numberWithBool:YES],
                            @"id"        : [NSNull null]
                            };
        }
        else
        {
            dictTypeDTO = @{@"firstCreditCard"         : dictFirstCreditCard,
                            @"secondCreditCard"        : dictCreditPrevious,
                            @"firstCreditCardAmount"   : [NSNumber numberWithInt:_valueToDebit],
                            @"credit"                  : [NSNumber numberWithBool:YES],
                            @"id"        : [NSNull null]
                            };
        }
        
        if (!dictCreditPrevious)
        {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictFirstCreditCard];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"dictCreditPrevious"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else
    {
        if (!dictCreditPrevious)
        {
            dictTypeDTO = @{@"firstCreditCard"         : [NSNull null],
                            @"secondCreditCard"        : dictFirstCreditCard,
                            @"firstCreditCardAmount"   : [NSNumber numberWithInt:_valueToDebit],
                            @"credit"                  : [NSNumber numberWithBool:YES],
                            @"id"        : [NSNull null]
                            };
        }
        else
        {
            dictTypeDTO = @{@"firstCreditCard"         : dictCreditPrevious,
                            @"secondCreditCard"        : dictFirstCreditCard,
                            @"firstCreditCardAmount"   : [NSNumber numberWithInt:_valueToDebit],
                            @"credit"                  : [NSNumber numberWithBool:YES],
                            @"id"        : [NSNull null]
                            };
        }
        
        if (!dictCreditPrevious)
        {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictFirstCreditCard];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"dictCreditPrevious"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (!_doublePayment)
    {
        dictTypeDTO = @{@"id"                     : [self getCardNameWithName:_cCardSelected],
                        @"name"                   : [nameCard uppercaseString],
                        @"type"                   : @"CREDIT_CARD",
                        @"sigePaymentTypeId"      : [NSNumber numberWithInt:1],
                        @"sigeBankId"             : [NSNumber numberWithInt:0],
                        @"credit"                 : [NSNumber numberWithBool:YES],
                        @"cardViewNumber"         : @"singleCard",
                        @"firstCreditCardAmount"  : [NSNumber numberWithInt:_valueToDebit]
                        };
        
        if ([OFSetup enableInstallmentsWithRateInCheckout]) {
            
            //Calculate bin
            NSString *strCardNb = [self cleanPunctuation:_txtCardNumber.text];
            
            if (strCardNb.length >= 6) {
                
                NSString *strBin = [strCardNb substringToIndex:6];
                int binNb = [strBin intValue];
                
                dictTypeDTO = @{@"id"                     : [self getCardNameWithName:_cCardSelected],
                                @"bin"                    : [NSNumber numberWithInt:binNb],
                                @"name"                   : [nameCard uppercaseString],
                                @"type"                   : @"CREDIT_CARD",
                                @"sigePaymentTypeId"      : [NSNumber numberWithInt:1],
                                @"sigeBankId"             : [NSNumber numberWithInt:0],
                                @"credit"                 : [NSNumber numberWithBool:YES],
                                @"cardViewNumber"         : @"singleCard",
                                @"firstCreditCardAmount"  : [NSNumber numberWithInt:_valueToDebit]
                                };
            }
        }
    }
    
    NSDictionary *dictCreditPayment = @{@"paymentTypeDTO"  :   dictTypeDTO,
                                        @"splitServicePayment"     : [NSNumber numberWithBool:_doublePayment],
                                        @"credit"   :   [NSNumber numberWithBool:YES]
                                        };
    LogInfo(@"Credit Payment: %@", dictCreditPayment);
    
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

- (void) callInstallmentsBankingTicket
{
    [self.navigationController.view showModalLoading];
    self.isInstallment = YES;
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestPaymentWithInstallments:dataString];
        });
    } failure:^(NSError *error, NSString *dataString) {
        if (error.code == 401) {
            LogErro(@"401 received! Token expired [%@]! :(", @"selectDeliveryPaymentWithCompleteCart");
            [self errorCheckoutAuth];
        } else if (error.code == 400) {
            LogErro(@"400!");
            NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:dataString];
            [self errorCheckout:msgError];
        } else {
            LogErro(@"Error code: %ld", (long)error.code);
            [self errorConnNewCheckout:error.localizedDescription];
        }
    }];
}


- (void) requestPaymentWithInstallments:(NSString *) strPaymentWithCart
{
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
    
    [[NSUserDefaults standardUserDefaults] setObject:@([dictInstallmentsService[@"firstCreditCardValue"] floatValue] / 100.0f) ?: nil forKey:@"valueNoInterest1"];
    [[NSUserDefaults standardUserDefaults] setObject:@([dictInstallmentsService[@"secondCreditCardValue"] floatValue] / 100.0f) ?: nil forKey:@"valueNoInterest2"];
    
    [self updatePriceCard];
    
    [self updatePriceTicket];
    [self.navigationController.view hideModalLoading];
    
    //_txtInstallments.text = @"";
    //_installmentItemSelected = nil;
    //_installmentsSelected = nil;
    //_installmentsIndexSelected = 0;
}


- (NSString *) getCardNameWithName:(NSString *) nameCard
{
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

- (void) fillTextFieldWithContent:(NSDictionary *) dictContentField
{
    LogInfo(@"Content: %@", dictContentField);
    
    int lineSelected = [[dictContentField objectForKey:@"lineSelected"] intValue];
    
    if ([[dictContentField objectForKey:@"codField"] isEqualToString:@"months"])
    {
        _txtMonthCard.text = [dictContentField objectForKey:@"valueSelected"];
    }
    else if ([[dictContentField objectForKey:@"codField"] isEqualToString:@"years"])
    {
        _txtYearCard.text = [dictContentField objectForKey:@"valueSelected"];
    }
    else if ([[dictContentField objectForKey:@"codField"] isEqualToString:@"installments"])
    {
        _txtInstallments.text = [dictContentField objectForKey:@"valueSelected"];
        self.installmentsSelected = [_arrCreditCardInstallments objectAtIndex:lineSelected];
        LogInfo(@"Installments selected: %@", _installmentsSelected);
    }
}

- (void) fillInfoPaymentWithDictionary:(NSDictionary *) dictInfo {
    _txtInstallments.text = @"";
    
    LogInfo(@"dict Info: %@", dictInfo);
    if (isBankingTicket)
    {
        _secureWarning.hidden = YES;
        float widthLbl = self.view.frame.size.width - 30;
        _lblTitlePayment.frame = CGRectMake(_lblTitlePayment.frame.origin.x, _lblTitlePayment.frame.origin.y, widthLbl, _lblTitlePayment.frame.size.height);
        [_lblTitlePayment sizeToFit];
        
        CGRect cardReaderButtonFrame = _cardReaderButton.frame;
        cardReaderButtonFrame.origin.x = _lblTitlePayment.frame.origin.x;
        cardReaderButtonFrame.origin.y = _lblTitlePayment.frame.origin.y + _lblTitlePayment.frame.size.height + 20;
        self.cardReaderButton.frame = cardReaderButtonFrame;
        
        CGRect viewCardFrame = _viewCardBackground.frame;
        viewCardFrame.origin.y = _cardReaderButton.frame.origin.y + _cardReaderButton.frame.size.height + 20;
        self.viewCardBackground.frame = viewCardFrame;
    }
    
    NSString *titlePayment = [dictInfo objectForKey:@"titlePayment"];
    self.strValueFromService = [dictInfo objectForKey:@"strValueFromService"];
    LogInfo(@"strValue: %@", _strValueFromService);
    
    self.valueToDebit = [_strValueFromService intValue];
    self.paymentNumber = [dictInfo objectForKey:@"paymentNumber"];
    self.strValueToUser = [dictInfo objectForKey:@"showUserValue"];
    _lblTitlePayment.text = titlePayment;
    _txtValueToPayInThisCard.text = _strValueToUser;
    self.doublePayment = [[dictInfo objectForKey:@"doublePayment"] boolValue];
    BOOL autoFill = NO;
    
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
            [self fillMockCard3];
        }
        else
        {
            [self fillMockCard2];
        }
    }
    
    self.hasProduct = [dictInfo[@"hasProduct"] boolValue];
    self.hasExtendedWarranty = [dictInfo[@"hasExtendedWarranty"] boolValue];
    
    if (_hideFinishOrderButton)
    {
        self.finishOrderButton.hidden = YES;
        CGRect frame = self.view.frame;
        frame.size.height = _viewCardBackground.frame.origin.y + _viewCardBackground.frame.size.height;
        self.view.frame = frame;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void) errorConnectionInstallments:(NSString *) msgError
{
    [self hideKeyboardCard];
    LogErro(@"Error call simulate installments: %@", msgError);
    
    if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
    {
        [self.delegate checkoutError:msgError backToCart:NO];
    }
}

- (void) errorConnNewCheckout:(NSString *) msgError
{
    [self hideKeyboardCard];
    [[self delegate] goCreditCards];
    [self deselectAllCreditCards];
    
    if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
    {
        [self.delegate checkoutError:msgError backToCart:NO];
    }
}

- (void) errorCheckoutAuth
{
    [self hideKeyboardCard];
    [[self delegate] goCreditCards];
    
    if ([self.delegate respondsToSelector:@selector(checkoutError:backToCart:)])
    {
        [self.delegate checkoutError:ERROR_401_CHECKOUT backToCart:YES];
    }
}

- (void) errorCheckout:(NSDictionary *) dictError
{
    [self.navigationController.view hideModalLoading];
    LogNewCheck(@"Error Payment Card Checkout: %@", dictError);
    
    LogInfo(@"isBoleto: %i", isBankingTicket);
    if (isBankingTicket)
    {
        [[self delegate] goCreditCards];
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
- (NSDictionary *)getContentPayment
{
    //Cleaning sequences of white spaces in name
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:self];
    
    NSString *name = _txtCardOwnerName.text;
    NSString *squashed = [name stringByReplacingOccurrencesOfString:@"[ ]+" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, name.length)];
    NSString *cleanName = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.txtCardOwnerName.text = cleanName;
    
    if (_txtCardNumber.text.length == 0)
    {
        return [self getDictErrorToPaymentWithMsg:CREDIT_CARD_NOT_SET];
    }
    else if (![self validateCardForTypeWithText:_txtCardNumber.text])
    {
        return [self getDictErrorToPaymentWithMsg:ERROR_CREDIT_CARD];
    }
    else if (_txtCardOwnerName.text.length < 4)
    {
        return [self getDictErrorToPaymentWithMsg:ERROR_NAME];
    }
    else if (![self validateCpfCnpj])
    {
        return [self getDictErrorToPaymentWithMsg:ERROR_CNPJ_CPF];
    }
    else if (_txtMonthCard.text.length == 0)
    {
        return [self getDictErrorToPaymentWithMsg:ERROR_MONTH_CCARD];
    }
    else if (_txtYearCard.text.length == 0)
    {
        return [self getDictErrorToPaymentWithMsg:ERROR_YEAR_CCARD];
    }
    else if (_txtCodCardNumber.text.length == 0)
    {
        return [self getDictErrorToPaymentWithMsg:ERROR_SEC_CCARD];
    }
    if (![self verifyCreditCardValidate])
    {
        return [self getDictErrorToPaymentWithMsg:ERROR_VALIDATE_CCARD];
    }
    else if (_txtInstallments.text.length == 0)
    {
        return [self getDictErrorToPaymentWithMsg:ERROR_INSTALLMENTS];
    }
    
    //If success then inform other class
    BOOL hasInterest = NO;
    _cardAlreadySelected = YES;
    
    if ([_paymentNumber isEqualToString:@"1"]) {
        hasInterest = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt1"];
    } else {
        hasInterest = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt2"];
    }
    
    NSDictionary *dictPayment = @{@"blockOperation"     :   [NSNumber numberWithBool:NO],
                                  @"nameCard"           :   _txtCardOwnerName.text ?: @"",
                                  @"documentNumber"     :   _txtDocumentOwnerNumber.text ?: @"",
                                  @"cardNumber"         :   _txtCardNumber.text ?: @"",
                                  @"codCardNumber"      :   _txtCodCardNumber.text ?: @"",
                                  @"monthCard"          :   _txtMonthCard.text ?: @"",
                                  @"yearCard"           :   _txtYearCard.text ?: @"",
                                  @"installmentsCard"   :   _txtInstallments.text ?: @"",
                                  @"paymentNumber"      :   _paymentNumber ?: @"",
                                  @"cardId"             :   [self getCardNameWithName:_cCardSelected] ?: @"",
                                  @"cardName"           :   _cCardSelected ?: @"",
                                  @"installmentsChoosed":   _txtInstallments.text ?: @"",
                                  @"cardSelected"       :  [NSNumber numberWithBool:_cardAlreadySelected],
                                  @"hasInterest"        :  [NSNumber numberWithBool:hasInterest]
                                  };
    
    return dictPayment;
}

- (NSDictionary *)getDictErrorToPaymentWithMsg:(NSString *) msgError
{
    BOOL blockOperation = YES;
    NSDictionary *dictPaymentError = @{@"blockOperation"     :   [NSNumber numberWithBool:blockOperation],
                                       @"error"              :   msgError,
                                       @"paymentNumber"      :   _paymentNumber,
                                       @"installmentsChoosed":  _txtInstallments.text ?: @"",
                                       @"cardSelected"       :  [NSNumber numberWithBool:_cardAlreadySelected]
                                       };
    return dictPaymentError;
}


- (BOOL) verifyCreditCardValidate
{
    BOOL successValidate = YES;
    
    //Get date info
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    int year = (int)[components year];
    int month = (int)[components month];
    
    NSString *today = [NSString stringWithFormat:@"%i%02d", year, month];
    NSString *dateChoosed = [NSString stringWithFormat:@"%@%@", _txtYearCard.text, _txtMonthCard.text];
    
    if ([today intValue] > [dateChoosed intValue])
    {
        successValidate = NO;
    }
    
    return successValidate;
}

- (BOOL) validateCpfCnpj
{
    BOOL valid = NO;
    
    //Validation
    [self.view endEditing:YES];
    
    if ([self isCPFValid:[self cleanPunctuation:_txtDocumentOwnerNumber.text]])
    {
        LogInfo(@"CPF válido");
        valid = YES;
    }
    else
    {
        LogErro(@"CPF inválido");
    }
    
    if ([self isCNPJValid:[self cleanPunctuation:_txtDocumentOwnerNumber.text]])
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[[self delegate] setPaymentNumber:_paymentNumber andTextField:textField andPosition:textField.tag];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _txtCardNumber)
    {
        if (_txtCardNumber.text.length > 0)
        {
            if ([self hasValidCard])
            {
                [self callInstallments];
            }
            else
            {
                _arrCreditCardInstallments = nil;
                _txtInstallments.text = @"";
                _txtInstallments.placeholder = @"Quantidade de Parcelas";
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:self];
                
                [self hideKeyboardCard];
                [self.navigationController.view showAlertWithMessage:ERROR_CREDIT_CARD];
            }
        }
    }
}

- (BOOL)hasValidCard {
    NSString *strVerifyValidCard = [self getNameCardWithNumber:_txtCardNumber.text];
    BOOL cardVerified = ([strVerifyValidCard isEqualToString:_cCardSelected]) ? YES : NO;
    return _txtCardNumber.text.length > 0 && [self validateCardForTypeWithText:_txtCardNumber.text] && cardVerified;
}

#pragma mark - Masks
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //if ([string isEqualToString:@""]) return YES;
    
    if (textField == _txtDocumentOwnerNumber)
    {
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
    else if (textField == _txtCodCardNumber)
    {
        //Security Code
        NSUInteger newLengthSecCode = [textField.text length] + [string length] - range.length;
        if(newLengthSecCode > 4){
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (textField == _txtCardOwnerName)
    {
        //Name on Credit Card
        NSUInteger newLengthOwnerName = [textField.text length] + [string length] - range.length;
        if(newLengthOwnerName > 120){
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (textField == _txtCardNumber)
    {
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
    return YES;
}

- (BOOL) applyMasksOnCreditCardsWithString:(NSMutableString *) strText inTextField:(UITextField *) textField
{
    //LogInfo(@"Credit Card Mask: %@", _cCardSelected);
    NSInteger lenght = strText.length;
    
    self.creditCardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:strText];
    UIImage *imageForCurrentFlag = [CreditCardInteractor imageForFlag:_creditCardFlag];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageForCurrentFlag.size.width, imageForCurrentFlag.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:leftView.frame];
    imageView.image = imageForCurrentFlag;
    [leftView addSubview:imageView];
    
    self.txtCardNumber.rightView = leftView;
    self.txtCardNumber.rightViewMode = UITextFieldViewModeAlways;
    
    if (_creditCardFlag == CreditCardFlagVisa || _creditCardFlag == CreditCardFlagMaster || _creditCardFlag == CreditCardFlagElo)
    {
       if (lenght > 19) return NO;
        [strText replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, strText.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [strText insertString:@"." atIndex:4];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.)
        if (lenght > 9)
        {
            [strText insertString:@"." atIndex:9];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.####.)
        if (lenght > 14)
        {
            [strText insertString:@"." atIndex:14];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.####.####)
        if (insertedPunctuation) return NO;
    }
    else if (_creditCardFlag == CreditCardFlagAmex)
    {
        if (lenght > 17) return NO;
        [strText replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, strText.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [strText insertString:@"." atIndex:4];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.######.)
        if (lenght > 11)
        {
            [strText insertString:@"." atIndex:11];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        ////(####.######.#####)
        if (insertedPunctuation) return NO;
    }
    else if (_creditCardFlag == CreditCardFlagDiners)
    {
        if (lenght > 16) return NO;
        [strText replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, strText.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [strText insertString:@"." atIndex:4];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.######.)
        if (lenght > 11)
        {
            [strText insertString:@"." atIndex:11];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        ////(####.######.####)
        if (insertedPunctuation) return NO;
    }
    else if (_creditCardFlag == CreditCardFlagHiper)
    {
        if (lenght > 19) return NO;
        
        [strText replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, strText.length)];
        
        BOOL insertedPunctuation = NO;
        //(####.)
        if (lenght > 4)
        {
            [strText insertString:@"." atIndex:4];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.)
        if (lenght > 9)
        {
            [strText insertString:@"." atIndex:9];
            textField.text = strText;
            insertedPunctuation = YES;
        }
        
        //(####.####.####.)
        if (lenght > 14)
        {
            [strText insertString:@"." atIndex:14];
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
        _cCardSelected = @"visa";
        return @"visa";
    }
    else if (([predAmex evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtAmex)) {
        _cCardSelected = @"amex";
        return @"amex";
    }
    else if (([predMaster evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtMaster)) {
        _cCardSelected = @"mastercard";
        return @"mastercard";
    }
    else if (([predDiners evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtDiners)) {
        _cCardSelected = @"diners";
        return @"diners";
    }
    else if (([predHiper evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtHiper)) {
        _cCardSelected = @"hiper";
        return @"hiper";
    }
    else if (([predElo evaluateWithObject:cardNumber]) && (cardNumber.length == minimumLenghtElo)) {
        _cCardSelected = @"elo";
        return @"elo";
    }
    else {
        return nil;
    }
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
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return text;
}

- (void) hideKeyboardCard
{
    [self.view endEditing:YES];
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

- (IBAction)finishOrder
{
    if ([self.delegate respondsToSelector:@selector(finishOrderWithCreditCard)])
    {
        [self.delegate finishOrderWithCreditCard];
    }
}

- (IBAction)presentCameraToScanCreditCard
{
    if ([self.delegate respondsToSelector:@selector(cardPaymentCellPressedScanCardButton:)])
    {
        [self.delegate cardPaymentCellPressedScanCardButton:self];
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
        _txtCardNumber.text = cardInfo.cardNumber;
        if (cardInfo.expiryMonth != 0) _txtMonthCard.text = [NSString stringWithFormat:@"%.2lu", (unsigned long)cardInfo.expiryMonth];
        if (cardInfo.expiryYear != 0) _txtYearCard.text = @(cardInfo.expiryYear).stringValue;
        if (cardInfo.cvv.length > 0) _txtCodCardNumber.text = cardInfo.cvv;
    }
    else
    {
        if (_hasProduct) [WMOmniture trackCreditCardScanProductError];
        if (_hasExtendedWarranty) [WMOmniture trackCreditCardScanWarrantyError];
    }
    
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        NSMutableString *cardNumber = [[NSMutableString alloc] initWithString:self->_txtCardNumber.text];
        [self applyMasksOnCreditCardsWithString:cardNumber inTextField:self->_txtCardNumber];
        [self callInstallments];

        if (![self validateCardForTypeWithText:self->_txtCardNumber.text] || self->_creditCardFlag == CreditCardFlagUnrecognized)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissKeyboard" object:self];
            
            [self.navigationController.view showAlertWithMessage:ERROR_READING_CREDIT_CARD];
        }
    }];
}

#pragma mark - Background

- (void)handleEnteredBackgroundPaymentCell:(NSNotification *)notification
{
    LogInfo(@"Background Payment Cell!");
    
    _screenCacheImageView = [[UIImageView alloc]initWithFrame:
                             [self.view.window frame]];
    
    [_screenCacheImageView setTintColor:[UIColor blackColor]];
    
    [_screenCacheImageView setBackgroundColor:RGBA(2, 123, 195, 1)];
    
    
    _imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_walmart_home"]];
    
    float posX = (self.view.window.frame.size.width - _imgLogo.frame.size.width)/2;
    float posY = (self.view.window.frame.size.height - _imgLogo.frame.size.height)/2;
    
    _imgLogo.frame = CGRectMake(posX, posY, _imgLogo.frame.size.width, _imgLogo.frame.size.height);
    
    [_screenCacheImageView addSubview:_imgLogo];
    
    [self.view.window addSubview:_screenCacheImageView];
    
    
    [self closePaymentOptions];
}


- (void)handleActivePaymentCell:(NSNotification *)notification {
    
    if(_screenCacheImageView != nil) {
        
        [_screenCacheImageView removeFromSuperview];
        _screenCacheImageView = nil;
    }
}


@end
