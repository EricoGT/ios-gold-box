//
//  WMPaymentContainerViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 5/5/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMPaymentContainerViewController.h"
#import "CustomMenuButton.h"
#import "OFShipmentTemp.h"
#import "NSNumber+Currency.h"
#import "CardPaymentCell.h"
#import "ServicesModel.h"
#import "WMBankingTicket.h"
#import "NSNumber+Currency.h"

#define MARGIN_DEFAULT 15
#define MENU_BUTTON_HEIGHT 44

@interface WMPaymentContainerViewController () <payPickerDelegate, WMBankingTicketDelegate>

@property (nonatomic, weak) IBOutlet UIView *menuView;
@property (nonatomic, weak) IBOutlet UIView *bottomIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomIndicatorViewLeading;

@property (nonatomic, strong) UIView *dividerView;
@property (nonatomic, strong) UIView *contentViewCreditCard;
@property (nonatomic, strong) UIView *contentViewBankingTicket;
@property (nonatomic, strong) UIButton *paymentOptionButton1;
@property (nonatomic, strong) UIButton *paymentOptionButton2;
@property (nonatomic, assign) BOOL isCheckoutError;
@property (nonatomic, strong) NSDictionary *bankingTicketDictionary;
@property (nonatomic, assign) CGFloat positionCreditCard;
@property (nonatomic, assign) CGFloat positionBankingTicket;

@property (nonatomic, strong) WMBankingTicket *bankingTicketController;

@property (assign, nonatomic) BOOL alreadySetup;

@property (assign, nonatomic) BOOL applyOffset;

@end

@implementation WMPaymentContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (BOOL)isPayingWithCreditCard
{
    return _creditCardSelected;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // TODO: Refactor this class to avoid using this boolean
    if (!_alreadySetup) {
        self.alreadySetup = YES;
        
        self.view.layer.masksToBounds = YES;
        self.view.layer.borderWidth = 1.0f;
        self.view.layer.cornerRadius = 3.0f;
        self.view.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
        
        [self setupMenu];
        
        CGRect bankingTicketViewFrame = _contentViewBankingTicket.frame;
        bankingTicketViewFrame.origin.x = bankingTicketViewFrame.size.width;
        _contentViewBankingTicket.frame = bankingTicketViewFrame;
        
        if (_payingWithTwoCards)
        {
            [self setupTwoCards];
        }
        else
        {
            [self setupOneCard];
            [self setupBankingTicket];
        }
        [self updateHeight];
    }
}

- (void)reloadValuesWithPaymentDictionary:(NSDictionary *)paymentDictionary {
    if (_creditCardSelected) {
        if ([_firstCardPayment hasValidCard] || [_secondCardPayment hasValidCard]) {
            [_firstCardPayment callInstallments];
        }
        else {
            if (_payingWithTwoCards) {
                self.paymentDictionary = paymentDictionary;
                
                NSDictionary *dictResumeCard = [paymentDictionary valueForKey:@"installment"];
                NSDictionary *dictCartTotals = [dictResumeCard objectForKey:@"cartAmounts"];
                NSString *ttGlobalOrder = [dictCartTotals objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
                NSString *ttServicesOrder = [dictCartTotals objectForKey:@"servicesAmount"] ?: @"0";
                
                float ttProducts = ttGlobalOrder.floatValue - ttServicesOrder.floatValue;
                float ttProductsToShowToUser = ttGlobalOrder.floatValue;
                NSString *strTotalProductsWithoutServicesToUser = @(ttProducts/100).currencyFormat;
                NSString *strTotalProductsWithServices = @(ttProductsToShowToUser/100).currencyFormat;
                NSString *ttServices = @(ttServicesOrder.floatValue/100).currencyFormat;
                int ttProd = [ttGlobalOrder intValue] - [ttServicesOrder intValue];
                
                NSDictionary *dictCart = [_paymentDictionary valueForKey:@"cart"];
                NSArray *items = [dictCart objectForKey:@"items"];
                int ttOnlyProducts = 0;
                for (NSDictionary *item in items)
                {
                    //First, verify if this is a warranty extended
                    BOOL service = [item[@"service"] boolValue];
                    if (!service) ttOnlyProducts ++;
                }
                
                NSString *strTotalOnlyProducts = @"Pagamento do produto";
                if (ttOnlyProducts > 1) {
                    strTotalOnlyProducts = @"Pagamento dos produtos";
                }
                [_firstCardPayment fillInfoPaymentWithDictionary:
                 @{@"titlePayment"        :   strTotalOnlyProducts,
                   @"strValueInThisCard"   :   strTotalProductsWithServices,
                   @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
                   @"paymentNumber"        :   @"1",
                   @"showUserValue"        :   strTotalProductsWithoutServicesToUser,
                   @"doublePayment"       :   [NSNumber numberWithBool:YES],
                   @"hasExtendedWarranty": @NO,
                   @"hasProduct": @YES
                   }];
                
                [_secondCardPayment fillInfoPaymentWithDictionary:
                 @{@"titlePayment" : @"Seguro Garantia Estendida Original",
                   @"strValueInThisCard"   :   ttServices,
                   @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
                   @"paymentNumber"        :   @"2",
                   @"showUserValue"        :   ttServices,
                   @"doublePayment"        :   @(YES),
                   @"hasExtendedWarranty": @YES,
                   @"hasProduct": @NO
                   }];
            }
            else {
                NSDictionary *dictResumeCard = [paymentDictionary valueForKey:@"installment"];
                NSDictionary *dictCartTotals = [dictResumeCard objectForKey:@"cartAmounts"];
                NSString *ttGlobalOrder = [dictCartTotals objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
                float ttProducts = ttGlobalOrder.floatValue;
                
                NSString *strTotalProductsWithoutServices = @(ttProducts/100).currencyFormat;
                int ttProd = ttGlobalOrder.intValue;
                NSString *ttGlobal = @(ttGlobalOrder.floatValue/100).currencyFormat;
                
                [_firstCardPayment fillInfoPaymentWithDictionary:
                 @{@"titlePayment" : @"Pagamento do produto",
                   @"strValueInThisCard"   :   strTotalProductsWithoutServices,
                   @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
                   @"paymentNumber"        :   @"1",
                   @"showUserValue"        :   ttGlobal,
                   @"doublePayment"        :   @(NO),
                   @"hasExtendedWarranty"  :   @(_isSinglePaymentAndHasExtendedWarranty),
                   @"hasProduct": @YES
                   }];
            }
        }
    }
    else {
        [_firstCardPayment callInstallmentsBankingTicket];
        
        NSDictionary *cart = paymentDictionary[@"cart"];
        NSDictionary *dictContent = [cart objectForKey:@"amounts"] ?: @"0";
        NSString *ttGlobalOrder = [dictContent objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
        float ttProductsToShowToUser = [ttGlobalOrder floatValue];
        NSString *strTotalProductsWithServices = @(ttProductsToShowToUser/100).currencyFormat;
        NSDictionary *dictPaymentTicketBanking = @{@"paymentDesc" : @"Pagamento à vista", @"valueDesc" : strTotalProductsWithServices};
        [_bankingTicketController feedContentLabels:dictPaymentTicketBanking];
    }
}

#pragma mark - Setup
- (void)setup
{
    _positionCreditCard = 0;
    _positionBankingTicket = 0;
    
    self.contentViewCreditCard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _contentView.bounds.size.height)];
    _contentViewCreditCard.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_contentViewCreditCard];
    
    self.contentViewBankingTicket = [[UIView alloc] initWithFrame:CGRectMake(_contentViewCreditCard.frame.size.width, 0, self.view.frame.size.width, _contentView.bounds.size.height)];
    _contentViewBankingTicket.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_contentViewBankingTicket];
    
    [_contentView layoutIfNeeded];
    [_contentView layoutSubviews];

    NSDictionary *cart = _paymentDictionary[@"cart"] ?: @{};
    [[OFShipmentTemp new] assignCartItems:cart[@"items"] ?: @[]];
    NSDictionary *dictCredit = [_paymentDictionary valueForKey:@"paymentTypes"];
    
    if ([dictCredit valueForKey:@"Boleto"])
    {
        NSArray *arrTicket = [dictCredit valueForKey:@"Boleto"];
        if (arrTicket.count > 0) self.bankingTicketDictionary = [arrTicket objectAtIndex:0];
    }
    
    NSArray *arrCredit = [dictCredit valueForKey:@"Credito"];
    NSMutableArray *cards = [NSMutableArray new];
    
    for (NSDictionary *card in arrCredit)
    {
        int cardId = [card[@"id"] intValue];
        NSString *nameCard = card[@"name"];
        if ([nameCard.lowercaseString isEqualToString:@"mastercard"]) nameCard = @"MASTER";
        [cards addObject:@{@"idCard" : [NSNumber numberWithInt:cardId], @"nameCard" : nameCard}];
    }
    
    if ([dictCredit valueForKey:@"Boleto"])
    {
        NSArray *arrTicket = [dictCredit valueForKey:@"Boleto"];
        if ((int)[arrTicket count] > 0)
        {
            self.bankingTicketDictionary = [arrTicket objectAtIndex:0];
        }
    }
}

#pragma mark - Banking Ticket
- (void)setupBankingTicket
{
    self.bankingTicketController = [[WMBankingTicket alloc] initWithNibName:@"WMBankingTicket" bundle:nil];
    _bankingTicketController.delegate = self;
    [_bankingTicketController view];
    [self addContentToBankingTicketView:_bankingTicketController];
}

- (void)finishOrderWithBankingTicket
{
    LogInfo(@"Finish order with banking ticket");
    if ([self.delegate respondsToSelector:@selector(finishOrder)]) {
        [self.delegate finishOrder];
    }
}

- (void)finishOrderWithCreditCard
{
    LogInfo(@"Finish order with credit card");
    if ([self.delegate respondsToSelector:@selector(finishOrder)]) {
        [self.delegate finishOrder];
    }
}

#pragma mark - One Card
- (void)setupOneCard
{
    _applyOffset = YES;
    
    NSDictionary *dictResumeCard = [_paymentDictionary valueForKey:@"installment"];
    NSDictionary *dictCartTotals = [dictResumeCard objectForKey:@"cartAmounts"];
    NSString *ttGlobalOrder = [dictCartTotals objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
    float ttProducts = ttGlobalOrder.floatValue;
    
    NSString *strTotalProductsWithoutServices = @(ttProducts/100).currencyFormat;
    int ttProd = ttGlobalOrder.intValue;
    NSString *ttGlobal = @(ttGlobalOrder.floatValue/100).currencyFormat;
    
    _firstCardPayment = [[CardPaymentCell alloc] initWithNibName:@"CardPaymentCell" bundle:nil];
    _firstCardPayment.isBankingTicket = YES;
    _firstCardPayment.delegate = self;
    _firstCardPayment.hideFinishOrderButton = NO;
    _firstCardPayment.view.backgroundColor = [UIColor whiteColor];
    [_firstCardPayment fillInfoPaymentWithDictionary:
                                       @{@"titlePayment" : @"Pagamento do produto",
                                         @"strValueInThisCard"   :   strTotalProductsWithoutServices,
                                         @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
                                         @"paymentNumber"        :   @"1",
                                         @"showUserValue"        :   ttGlobal,
                                         @"doublePayment"        :   @(NO),
                                         @"hasExtendedWarranty"  :   @(_isSinglePaymentAndHasExtendedWarranty),
                                         @"hasProduct": @YES
                                         }];
    [self addContentToCreditCardView:_firstCardPayment];
}

#pragma mark - Two Cards
- (void)setupTwoCards
{
    NSDictionary *dictResumeCard = [_paymentDictionary valueForKey:@"installment"];
    NSDictionary *dictCartTotals = [dictResumeCard objectForKey:@"cartAmounts"];
    NSString *ttGlobalOrder = [dictCartTotals objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
    NSString *ttServicesOrder = [dictCartTotals objectForKey:@"servicesAmount"] ?: @"0";
    
    float ttProducts = ttGlobalOrder.floatValue - ttServicesOrder.floatValue;
    float ttProductsToShowToUser = ttGlobalOrder.floatValue;
    NSString *strTotalProductsWithoutServicesToUser = @(ttProducts/100).currencyFormat;
    NSString *strTotalProductsWithServices = @(ttProductsToShowToUser/100).currencyFormat;
    NSString *ttServices = @(ttServicesOrder.floatValue/100).currencyFormat;
    int ttProd = [ttGlobalOrder intValue] - [ttServicesOrder intValue];
    
    NSDictionary *dictCart = [_paymentDictionary valueForKey:@"cart"];
    NSArray *items = [dictCart objectForKey:@"items"];
    int ttOnlyProducts = 0;
    for (NSDictionary *item in items)
    {
        //First, verify if this is a warranty extended
        BOOL service = [item[@"service"] boolValue];
        if (!service) ttOnlyProducts ++;
    }
    
    NSString *strTotalOnlyProducts = @"Pagamento do produto";
    if (ttOnlyProducts > 1) {
        strTotalOnlyProducts = @"Pagamento dos produtos";
    }
    
    _firstCardPayment = [[CardPaymentCell alloc] initWithNibName:@"CardPaymentCell" bundle:nil];
    _firstCardPayment.isBankingTicket = YES;
    _firstCardPayment.delegate = self;
    _firstCardPayment.hideFinishOrderButton = YES;
    _firstCardPayment.view.backgroundColor = [UIColor whiteColor];
    [_firstCardPayment fillInfoPaymentWithDictionary:
                                       @{@"titlePayment"        :   strTotalOnlyProducts,
                                         @"strValueInThisCard"   :   strTotalProductsWithServices,
                                         @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
                                         @"paymentNumber"        :   @"1",
                                         @"showUserValue"        :   strTotalProductsWithoutServicesToUser,
                                         @"doublePayment"       :   [NSNumber numberWithBool:YES],
                                         @"hasExtendedWarranty": @NO,
                                         @"hasProduct": @YES
                                         }];
    
    _applyOffset = NO;
    
    [self addContentToCreditCardView:_firstCardPayment];
    
    _dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, _positionCreditCard, self.view.frame.size.width, 1)];
    _dividerView.backgroundColor = RGBA(204, 204, 204, 1);
    [_contentViewCreditCard addSubview:_dividerView];
    
    _secondCardPayment = [[CardPaymentCell alloc] initWithNibName:@"CardPaymentCell" bundle:nil];
    _secondCardPayment.isBankingTicket = YES;
    _secondCardPayment.delegate = self;
    _secondCardPayment.hideFinishOrderButton = NO;
    _secondCardPayment.view.backgroundColor = [UIColor whiteColor];
    [_secondCardPayment fillInfoPaymentWithDictionary:
                                        @{@"titlePayment" : @"Seguro Garantia Estendida Original",
                                          @"strValueInThisCard"   :   ttServices,
                                          @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
                                          @"paymentNumber"        :   @"2",
                                          @"showUserValue"        :   ttServices,
                                          @"doublePayment"        :   @(YES),
                                          @"hasExtendedWarranty": @YES,
                                          @"hasProduct": @NO
                                          }];
    
    _applyOffset = YES;
    
    [self addContentToCreditCardView:_secondCardPayment];
    [_contentViewCreditCard bringSubviewToFront:_dividerView];
}

#pragma mark - CardPaymentCell Delegates
- (void)goCreditCards
{
    //Called when we have a error
    [self selectCreditCard];
}

- (void)updateValueInfosTicket:(NSArray *)arrValues
{
    //Called after installments result
    NSDictionary *dictContent = [[arrValues objectAtIndex:0] objectForKey:@"amounts"] ?: @"0";
    NSString *ttGlobalOrder = [dictContent objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
    float ttProductsToShowToUser = [ttGlobalOrder floatValue];
    NSString *strTotalProductsWithServices = @(ttProductsToShowToUser/100).currencyFormat;
    NSDictionary *dictPaymentTicketBanking = @{@"paymentDesc" : @"Pagamento à vista", @"valueDesc" : strTotalProductsWithServices};
    [_bankingTicketController feedContentLabels:dictPaymentTicketBanking];
}

- (void)updateValueInfos:(NSArray *)arrValues
{
    //Called after installments result
    if ([self.delegate respondsToSelector:@selector(didUpdatePaymentResumeInformation:)]) {
        [self.delegate didUpdatePaymentResumeInformation:arrValues];
    }
}

- (void)cardPaymentCell:(CardPaymentCell *)cardPaymentCell DidUpdateHeight:(CGFloat)newHeight
{
    _positionCreditCard = _firstCardPayment.view.frame.origin.y;
    _positionCreditCard += _firstCardPayment.view.frame.size.height + MARGIN_DEFAULT;
    
    if (_payingWithTwoCards)
    {
        CGRect dividerFrame = _dividerView.frame;
        dividerFrame.origin.y = _positionCreditCard;
        self.dividerView.frame = dividerFrame;
        
        CGRect secondCardFrame = _secondCardPayment.view.frame;
        secondCardFrame.origin.y = _positionCreditCard;
        self.secondCardPayment.view.frame = secondCardFrame;
        
        _positionCreditCard += _secondCardPayment.view.frame.size.height + MARGIN_DEFAULT;
    }
    
    [self updateHeight];
    [self containerHeightDidUpdate];
}

- (void) cardPaymentCellPressedScanCardButton:(CardPaymentCell *)cardPaymentCell
{
    if ([self.delegate respondsToSelector:@selector(paymentCardPressedScanCardButton:)])
    {
        [self.delegate paymentCardPressedScanCardButton:cardPaymentCell];
    }
}

#pragma mark - Menu
- (void)setupMenu
{
    CGFloat menuButtonWidth = (self.menuView.frame.size.width - (MARGIN_DEFAULT * 3))/2;

    _paymentOptionButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _paymentOptionButton1.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
    [_paymentOptionButton1 setTitle:@"Cartão de Crédito" forState:UIControlStateNormal];
    [_paymentOptionButton1 setTitleColor:RGBA(26, 117, 207, 1) forState:UIControlStateNormal];
    [_paymentOptionButton1 addTarget:self action:@selector(selectCreditCard) forControlEvents:UIControlEventTouchUpInside];
    _paymentOptionButton1.frame = CGRectMake(MARGIN_DEFAULT, 0, menuButtonWidth, MENU_BUTTON_HEIGHT);

    BOOL includeBankingTicket = [WALMenuViewController singleton].services.paymentByBankSlip.boolValue;
    if (includeBankingTicket && !_payingWithTwoCards)
    {
        _paymentOptionButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
        _paymentOptionButton2.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
        [_paymentOptionButton2 addTarget:self action:@selector(selectBankSlip) forControlEvents:UIControlEventTouchUpInside];
        [_paymentOptionButton2 setTitle:@"Boleto Bancário" forState:UIControlStateNormal];
        [_paymentOptionButton2 setTitleColor:RGBA(204, 204, 204, 1) forState:UIControlStateNormal];
        _paymentOptionButton2.frame = CGRectMake(_menuView.frame.size.width - menuButtonWidth - MARGIN_DEFAULT, 0, menuButtonWidth, MENU_BUTTON_HEIGHT);
        
        [_menuView addSubview:_paymentOptionButton1];
        [_menuView addSubview:_paymentOptionButton2];
    }
    else
    {
        _paymentOptionButton1.frame = CGRectMake(self.view.frame.size.width/2 - (menuButtonWidth/2), 0, menuButtonWidth, MENU_BUTTON_HEIGHT);
        [_menuView addSubview:_paymentOptionButton1];
    }
    
    [self selectCreditCard];
    _bottomIndicatorViewLeading.constant = _paymentOptionButton1.center.x - (_bottomIndicatorView.frame.size.width/2);
}

- (void)selectCreditCard
{
    if (_creditCardSelected) return;
    
    [self dismissVisibleKeyboard];
    _creditCardSelected = YES;
    [_paymentOptionButton1 setTitleColor:RGBA(26, 117, 207, 1) forState:UIControlStateNormal];
    [_paymentOptionButton2 setTitleColor:RGBA(204, 204, 204, 1) forState:UIControlStateNormal];
    
    [self updateHeight];

    _bottomIndicatorViewLeading.constant = _paymentOptionButton1.center.x - (_bottomIndicatorView.frame.size.width/2);
    CGRect creditCardViewFrame = _contentViewCreditCard.frame;
    CGRect bankSlipViewFrame = _contentViewBankingTicket.frame;
    
    creditCardViewFrame.origin.x = 0;
    bankSlipViewFrame.origin.x = bankSlipViewFrame.size.width;
    
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self->_contentViewCreditCard.frame = creditCardViewFrame;
        self->_contentViewBankingTicket.frame = bankSlipViewFrame;
        [self->_menuView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self containerHeightDidUpdate];
    }];
    
    [_firstCardPayment callInstallments];
}

- (void)selectBankSlip
{
    if (!_creditCardSelected) return;
    
    [self dismissVisibleKeyboard];
    _creditCardSelected = NO;
    [_paymentOptionButton1 setTitleColor:RGBA(204, 204, 204, 1) forState:UIControlStateNormal];
    [_paymentOptionButton2 setTitleColor:RGBA(26, 117, 207, 1) forState:UIControlStateNormal];
    
    [self updateHeight];

    _firstCardPayment.isBankingTicket = YES;
    if (_bankingTicketDictionary)
    {
        [_firstCardPayment getInstalls:_bankingTicketDictionary];
    }

    _bottomIndicatorViewLeading.constant = _paymentOptionButton2.center.x - (_bottomIndicatorView.frame.size.width/2);
    CGRect creditCardViewFrame = _contentViewCreditCard.frame;
    CGRect bankSlipViewFrame = _contentViewBankingTicket.frame;
    
    creditCardViewFrame.origin.x = 0 - creditCardViewFrame.size.width;
    bankSlipViewFrame.origin.x = 0;
    
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self->_contentViewCreditCard.frame = creditCardViewFrame;
        self->_contentViewBankingTicket.frame = bankSlipViewFrame;
        [self->_menuView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self containerHeightDidUpdate];
    }];
}

#pragma mark - Errors
- (void)checkoutError:(NSString *)error backToCart:(BOOL)backToCart
{
    self.isCheckoutError = backToCart;
    [self errorConn:error];
}

- (void)errorCheckoutAuth
{
    self.isCheckoutError = YES;
    [self errorConn:ERROR_401_CHECKOUT];
}

- (void)errorConnNewCheckout:(NSString *)msgError
{
    [self errorConn:msgError];
}

- (void)errorCheckout:(NSDictionary *)dictError
{
    LogNewCheck(@"Error Payment Card Checkout: %@", dictError);
    self.isCheckoutError = YES;
    if ([dictError objectForKey:@"errorId"])
    {
        NSString *errorCode = [dictError objectForKey:@"errorId"];
        NSString *msgError;
        if ([errorCode isKindOfClass:[NSString class]])
        {
            msgError = [[OFMessages new] getMsgCheckout:errorCode];
            LogNewCheck(@"Error Payment Card to user: %@", msgError);
        }
        else
        {
            msgError = ERROR_UNKNOWN_CATEGORY;
        }
        [self errorConn:msgError];
    }
    else if ([dictError objectForKey:@"errorMessage"])
    {
        NSString *errorCode = [dictError objectForKey:@"errorMessage"];
        if ([errorCode isEqualToString:@"PREAUTH"])
        {
            NSString *msgError = [[OFMessages new] getMsgCheckout:errorCode];
            LogNewCheck(@"Error Payment Card to user: %@", msgError);
            [self errorConn:msgError];
        }
        else
        {
            [self errorConn:ERROR_CONNECTION_UNKNOWN];
        }
    }
    else
    {
        [self errorConn:ERROR_CONNECTION_UNKNOWN];
    }
}

- (void)errorConn:(NSString *)msgError
{
    [self.navigationController.view hideModalLoading];
    [self.navigationController.view showAlertWithMessage:msgError dismissBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->_isCheckoutError)
            {
                self->_isCheckoutError = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        });
    }];
}

#pragma mark - Height
- (void)updateHeight
{
    if (_creditCardSelected)
    {
        CGRect newFrame = self.view.frame;
        newFrame.size.height = _positionCreditCard + + MARGIN_DEFAULT + self.menuView.frame.size.height + MARGIN_DEFAULT;
        self.view.frame = newFrame;
    }
    else
    {
        CGRect newFrame = self.view.frame;
        newFrame.size.height = _positionBankingTicket + self.menuView.frame.size.height;
        self.view.frame = newFrame;
    }
}

- (void)containerHeightDidUpdate
{
    if ([self.delegate respondsToSelector:@selector(didUpdateContainerHeight:)])
    {
        [self.delegate didUpdateContainerHeight:self.view.frame.size.height];
    }
}

#pragma mark - Helper
- (void)addContentToCreditCardView:(UIViewController *)controller
{
    
    [self addChildViewController:controller];
    [controller willMoveToParentViewController:self];
    
    if (_applyOffset) {
        controller.view.frame = CGRectMake(0, _positionCreditCard, self.view.frame.size.width, controller.view.frame.size.height - 70);
    }
    else {
        controller.view.frame = CGRectMake(0, _positionCreditCard, self.view.frame.size.width, controller.view.frame.size.height);
    }
    
        [_contentViewCreditCard addSubview:controller.view];
    
    if (_applyOffset) {
        _positionCreditCard += controller.view.frame.size.height;
    }
    else {
        _positionCreditCard += controller.view.frame.size.height + MARGIN_DEFAULT;
    }
}

- (void)addContentToBankingTicketView:(UIViewController *)controller
{
    [self addChildViewController:controller];
    [controller willMoveToParentViewController:self];
    controller.view.frame = CGRectMake(0, _positionBankingTicket, self.view.frame.size.width, self.view.frame.size.height);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    controller.view.frame = CGRectMake(0, _positionBankingTicket, self.view.frame.size.width, [self.bankingTicketController containerHeight]);
    [_contentViewBankingTicket addSubview:controller.view];
    _positionBankingTicket += controller.view.frame.size.height + MARGIN_DEFAULT;
}

#pragma mark - Keyboard
- (void)dismissVisibleKeyboard
{
    [self.view endEditing:YES];
    //self.currentTextField = nil;
}

@end
