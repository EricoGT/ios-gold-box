//
//  WBRPaymentViewController.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/25/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//
#import "WBRPaymentViewController.h"

#import "WBRPaymentMethodsView.h"
#import "WBRPaymentWarrantyView.h"
#import "WBRThankYouPageViewController.h"

#import "PaymentMultipleWarning.h"
#import "CardShippingAddressViewController.h"
#import "WMPaymentContainerViewController.h"
#import "WBRNavigationBarButtonItemFactory.h"

#import "OFAddressTemp.h"
#import "CardIOPaymentViewController.h"
#import "CardIOUtilities.h"
#import <AVFoundation/AVFoundation.h>
#import "WMOmniture.h"
#import "OFPayTemp.h"
#import "OFShipmentTemp.h"
#import "AddressObj.h"
#import "PaymentCouponSubmitView.h"
#import "PaymentSummaryView.h"
#import "CouponInteractor.h"
#import "NSNumber+Currency.h"
#import "WBRPaymentNewCartCardSimple.h"
#import "WBRPaymentNewCartCardWarranty.h"
#import "WBRPaymentNewCartOthers.h"
#import "OFFormatter.h"
#import "WMBDiscountCouponViewController.h"
#import "ShipAddressCell.h"
#import "WBRPaymentHeaderSectionView.h"
#import "DeliveryEstimateInteractor.h"
#import "WBRWalletModel.h"
#import "WBRPaymentWarrantyDisclaimer.h"
#import "WBRPaymentManager.h"

typedef enum : NSUInteger {
    kPaymentComponentProduct,
    kPaymentComponentWarranty
} kPaymentComponent;

@interface WBRPaymentViewController () <WBRPaymentMethodsViewProtocol, WBRPaymentWarrantyViewProtocol, delegateProductsResume, delegateShippingAddress, WMPaymentContainerViewControllerDelegate, PaymentCouponSubmitView, PaymentSummaryViewDelegate, delegateSimplePayment, DiscountCouponProtocol, UITableViewDelegate, UITableViewDataSource, WBRPaymentNewCartOthersDelegate, WBRPaymentHeaderSectionViewDelegate, WBRPaymentNewCartCardSimpleDelegate, WBRPaymentWarrantyDisclaimerProtocol>

@property (weak, nonatomic) IBOutlet WBRPaymentMethodsView *paymentMethodsView;
@property (weak, nonatomic) IBOutlet WBRPaymentWarrantyView *warrantyPaymentMethodsView;

@property (weak, nonatomic) IBOutlet  UITableView *tbCart;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentMethodsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warrantyPaymentMethodsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewCartViewHeightConstraint;

@property (strong, nonatomic) NSNumber *numberOfCards;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet WMButtonRounded *submitOrderButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionButtomContainerBottomConstraint;
@property (assign, nonatomic) CGFloat defaultActionButtomContainerBottomConstraint;

@property (assign, nonatomic) BOOL paymentTypeCreditCard;
@property (nonatomic, copy) NSString *currentRedemptionCode;

//Variable to evaluate when we are done binding the items from a seller and begins to bind the next seller products
//This logic is needed to retrieve the scheduling information required on the ThankYouPage
//With this variable, it will be possible to create a structure that contains all the scheduled deliveries, grouped by seller
@property (nonatomic, copy) NSString *lastSellerId;
@property (nonatomic, strong) NSMutableDictionary *thankYouPageDeliveryInformation;

@property (strong, nonatomic) WMBDiscountCouponViewController *discountCouponViewController;

@property (nonatomic, strong) NSArray *products;

@property (nonatomic, strong) NSArray *cartProducts;
@property (strong, nonatomic) WBRPaymentNewCartOthers *cartResume;

@property (weak, nonatomic) IBOutlet WBRPaymentWarrantyDisclaimer *paymentWarrantyDisclaimer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentWarrantyDisclaimerHeightConstraint;

@property (nonatomic) kPaymentComponent calledInstallments;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSDictionary *paymentDictionary;

@property (nonatomic, strong) CardProductsResume *productsCardController;
@property (strong, nonatomic) PaymentCouponSubmitView *couponSubmitView;
@property (nonatomic, strong) PaymentSummaryView *paymentSummaryView;
@property (nonatomic, strong) CardShippingAddressViewController *shippingAddressController;

@property (assign, nonatomic) BOOL hasUsedCardScanForProduct;
@property (assign, nonatomic) BOOL hasUsedCardScanForWarranty;
@property (assign, nonatomic) BOOL backToCart;

@property (assign, nonatomic) BOOL successShow;

@property (assign, nonatomic) BOOL removedCoupon;
@property (assign, nonatomic) BOOL addedCoupon;

@end

@implementation WBRPaymentViewController

static CGFloat const DisabledElementAlphaValue = 0.5f;
static CGFloat const EnabledElementAlphaValue = 1.0f;

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.removedCoupon = NO;
    self.addedCoupon = NO;
    
    self.paymentMethodsView.delegate = self;
    self.paymentMethodsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.warrantyPaymentMethodsView.delegate = self;
    self.warrantyPaymentMethodsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.paymentWarrantyDisclaimer.delegate = self;
    
    self.numberOfCards = @(2);
    
    [WMOmniture trackPaymentScreen];
    
    [self setContinueButtonEnabled:NO];
    
    [self setupTitle];
    
    [self includeImageNavigationBar];
    
    [self setupTableCartView];
    
    [self fetchData];
    
    self.paymentTypeCreditCard = YES;
    
    self.defaultActionButtomContainerBottomConstraint = self.actionButtomContainerBottomConstraint.constant;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([OFSetup backgroundEnable]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnteredBackgroundPayment:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    [self reloadPaymentViewConstraint];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([OFSetup backgroundEnable]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self applyShadowViewBottom];
}

#pragma mark - Data Fetch
- (void)fetchData {
    
    [self.navigationController.view showSmartModalLoading];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_deliveries options:0 error:&error];
    if (!jsonData)
    {
        LogErro(@"Error fetching data: %@", error);
    }
    else
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [WBRPaymentManager postPaymentWithCart:jsonString successBlock:^(NSString *dataString) {
            [self requestPaymentWithCart:dataString];
        } failure:^(NSError *error, NSString *dataString) {
            
            if (error.code == 401) {
                LogErro(@"401 received! Token expired [%@]! :(", @"selectDeliveryPaymentWithCompleteCart");
                [self errorCheckoutAuth];
            }
            else if (error.code == 400) {
                LogErro(@"400!");
                NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:dataString];
                [self errorCheckout:msgError];
            }else {
                LogErro(@"Erro [%@]!", @"");
                [self errorConnNewCheckout:error.localizedDescription];
            }
        }];
    }
}

- (void)removeCurrentRedemptionCode {
    
    [self.navigationController.view showModalLoading];
    
    self.removedCoupon = YES;
    
    NSDictionary *couponDict = @{@"giftCard": @{@"redemptionCode": self.currentRedemptionCode ?: @"",
                                                @"remove": @(YES)}};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:couponDict options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [WBRPaymentManager postPaymentInstallments:jsonString successBlock:^(NSString *dataString) {
        
        [self requestPaymentWithInstallments:dataString];
        
    } failure:^(NSError *error, NSString *dataString) {
        
        if (error.code == 401) {
            LogErro(@"401 received! Token expired [%@]! :(", @"installments");
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

- (void)requestPaymentWithCart:(NSString *)strPaymentWithCart
{
    NSError *error;
    NSData *jsonData = [strPaymentWithCart dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paymentInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableDictionary *paymentMutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:paymentInfo];
    [paymentMutableDictionary addEntriesFromDictionary:_deliveries];
    
    _paymentDictionary = paymentMutableDictionary.copy;
    
    
    [self.navigationController.view hideSmartModalLoading];
    
    NSDictionary *cart = _paymentDictionary[@"cart"];
    
    self.cartProducts  = cart[@"items"];
    
    if (_removedCoupon) {
        self.removedCoupon = NO;
        
        NSArray *giftCards = cart[@"giftCards"];
        if (giftCards.count > 0) {
            [self.view showFeedbackAlertOfKind:ErrorAlert message:COUPON_REMOVE_FAILURE];
        }
        else {
            [self.paymentMethodsView reloadContent];
        }
    }
    else if (self.addedCoupon) {
        self.addedCoupon = NO;
        [self.paymentMethodsView reloadContent];
    }
    
    
    NSArray *removedGiftCards = _paymentDictionary[@"removedGiftCards"];
    if (removedGiftCards.count > 0) {
        _couponSubmitView.couponSubmitView.warningMessage = [CouponInteractor warningMessageForRemovedCoupons:removedGiftCards];
    }
    
    [self setup];
    

    self.tableViewCartViewHeightConstraint.constant = 3000;
    [self.tbCart reloadData];
    [self.tbCart layoutIfNeeded];
    self.tableViewCartViewHeightConstraint.constant = [self.tbCart contentSize].height;
    
    //Variable to evaluate when we are done binding the items from a seller and begins to bind the next seller products
    //This logic is needed to retrieve the scheduling information required on the ThankYouPage
    //With this variable, it will be possible to create a structure that contains all the scheduled deliveries, grouped by seller
    self.lastSellerId = @"";
    self.thankYouPageDeliveryInformation = [NSMutableDictionary new];
    
    [self setContinueButtonEnabled:YES];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSError *walletError = nil;
        WBRWalletModel *wallet = [[WBRWalletModel alloc] initWithDictionary:[paymentInfo objectForKey:@"wallet"] error:&walletError];
        self.paymentMethodsView.wallet = wallet;
        
        if (self.splitedPayment) {
            self.warrantyPaymentMethodsView.wallet = wallet;
        }
        
        [self reloadPaymentViewConstraint];
    }];
}


#pragma mark -
- (void)setup
{
    self.paymentMethodsView.paymentDictionary = _paymentDictionary;

    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self reloadPaymentViewConstraint];
    
    if (self.splitedPayment) {
        [self setupTwoCards];
        [self.paymentMethodsView setOnlyCreditCardOption:YES];
    } else {
        [self setupOneCard];
        [self.paymentMethodsView setOnlyCreditCardOption:NO];
    }

    if ([WALMenuViewController singleton].services.isCouponEnabled.boolValue) {
        [self setupPaymentCouponSubmitView];
    }
    
    [self setupCartResume];
}

- (void)setupTableCartView {
    
    [self.tbCart registerNib:[UINib nibWithNibName:NSStringFromClass([WBRPaymentNewCartCardSimple class]) bundle:nil] forCellReuseIdentifier:[WBRPaymentNewCartCardSimple reuseIdentifier]];
    [self.tbCart registerNib:[UINib nibWithNibName:NSStringFromClass([WBRPaymentNewCartCardWarranty class]) bundle:nil] forCellReuseIdentifier:[WBRPaymentNewCartCardWarranty reuseIdentifier]];
    [self.tbCart registerNib:[UINib nibWithNibName:NSStringFromClass([ShipAddressCell class]) bundle:nil] forCellReuseIdentifier:[ShipAddressCell reuseIdentifier]];
    
    [self.tbCart setDelegate:self];
    [self.tbCart setDataSource:self];
    
    self.tbCart.rowHeight = UITableViewAutomaticDimension;
    self.tbCart.estimatedRowHeight = 140;
    
    self.cartResume = [WBRPaymentNewCartOthers new];
    [self.cartResume setDelegate:self];
    self.cartResume.delegate = self;
}

#pragma mark - Custom Title
- (void)setupCartResume {
    NSDictionary *dictInstallments = self.paymentDictionary[@"installment"];
    NSDictionary *dictResume = dictInstallments[@"cartAmounts"];
    
    
    float productsAmount = [dictResume[@"productsAmount"] floatValue] / 100;
    float servicesAmount = [dictResume[@"servicesAmount"] floatValue] / 100;
    float subTotal = productsAmount;
    
    NSDictionary *cartDict = self.paymentDictionary[@"cart"];
    NSString *postalCode = cartDict[@"postalCode"];
    
    NSString *freightPriceString;
    NSNumberFormatter *formatter = [[OFFormatter sharedInstance] currencyFormatter];
    
    if (postalCode && ![postalCode isEqualToString:@""]) {
        float estimatedShipmentCost = [dictResume[@"estimatedBestShippingAmount"] floatValue] / 100;
        if (estimatedShipmentCost > 0) {
            NSNumber *shipmentCost = [[NSNumber alloc] initWithFloat:estimatedShipmentCost];
            freightPriceString = [formatter stringFromNumber:shipmentCost];
        }
        else {
            freightPriceString = SHIPMENT_VALUE_FREE;
        }
    }
    
    float total = [cartDict[@"totalPrice"] floatValue] / 100;
    
    NSDictionary *dictBestInstallment = cartDict[@"bestInstallment"];
    float valuePerInstallment = [dictBestInstallment[@"valuePerInstallment"] floatValue];
    int installmentQty = [dictBestInstallment[@"installmentAmount"] intValue];
    
    //Coupon
    NSArray *giftCards = cartDict[@"giftCards"];
    NSDictionary *coupon;
    if (giftCards.count >0) {
        coupon = giftCards[0];
    }
    CGFloat vlNominalDiscount = [[dictResume objectForKey:@"totalNominalDiscount"] floatValue]/100;
    
    int quantity = [self countQuantitiesProducts];
    
    NSString *servicesAmountString;
    if (self.isSinglePaymentAndHasExtendedWarranty || self.splitedPayment) {
        servicesAmountString = [formatter stringFromNumber:[NSNumber numberWithFloat:servicesAmount]];
    }
    
    [self.cartResume setCoupon:coupon withNominalDiscount:vlNominalDiscount];
    
    [self.cartResume setupWithSubtotal:subTotal itemsQty:quantity postalCode:postalCode freightPrice:freightPriceString warrantyPrice:servicesAmountString total:total valuePerInstallment:valuePerInstallment installmentQty:installmentQty];
    
    
    [self.cartResume setNeedsLayout];
    [self.cartResume layoutIfNeeded];
    
    [self.cartResume updateViewHeightFrame];
    
    [self.tbCart setTableHeaderView:self.cartResume];
}

- (void)setupTitle
{
    [self setTitle:@"Como quer pagar?"];
}

- (void)includeImageNavigationBar {
    
    self.navigationItem.rightBarButtonItem = [WBRNavigationBarButtonItemFactory createBarButtonItemWithImageString:@"imgPaymentNavbar" andFrameRect:CGRectMake(0, 0, 54, 42)];
}

#pragma mark - PaymentCouponSubmitView
- (void)setupPaymentCouponSubmitView {
    
    NSArray *giftCards = [[_paymentDictionary objectForKey:@"cart"] objectForKey:@"giftCards"];
    if (giftCards.count > 0) {
        self.currentRedemptionCode = [giftCards[0] objectForKey:@"redemptionCode"];
    }
    else {
        self.currentRedemptionCode = nil;
    }
    
    if ((self.currentRedemptionCode != nil || [self.cartResume addCouponButtonIsVisible]) && self.splitedPayment) {
        
        [self removeCurrentRedemptionCode];
        [self.cartResume setCouponContainerVisibility:NO];
    } else if (!self.splitedPayment) {
        
        [self.cartResume setCouponContainerVisibility:YES];
    }
}

#pragma mark - WMPaymentContainerViewController Delegates
- (void)didUpdatePaymentResumeInformation:(NSArray *)arrValues
{
    if (arrValues.count > 1) {
        NSMutableDictionary *paymentDictionaryMutable = _paymentDictionary.mutableCopy;
        paymentDictionaryMutable[@"cart"] = arrValues[0];
        paymentDictionaryMutable[@"installment"] = arrValues[1];
        self.paymentDictionary = paymentDictionaryMutable.copy;
        _paymentSummaryView.summary = @{@"cart": arrValues[0],
                                        @"installment": arrValues[1]}.copy;
    }
}

- (void)simplePaymentOption
{
    [FlurryWM logEvent_eventCheckoutPaymentChoiceChanged];
    self.splitedPayment = NO;
    [self fetchData];
}

- (void)paymentMethodsShowFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message {
    [self.navigationController.view showFeedbackAlertOfKind:kind message:message];
}

#pragma mark - Products Card Delegates
- (void) backToCartFromCardProducts
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) backToSelectDeliveries
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Shipping Address Card Delegate
- (void)backToSelectShippingAddress
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

#pragma mark - Helpers
- (void)makeCardProductsToSuccess:(CardProductsResume *)cap withDictData:(NSArray *)arrProducts
{
    [cap removeEdition];
    [[OFCartTemp new] assignCardProducts:cap];
}

- (void)makeCardDeliveryToSuccess:(CardShippingAddressViewController *) cs withDictData:(NSDictionary *) dictDelivery
{
    NSMutableDictionary *dictMutDelivery = [NSMutableDictionary dictionaryWithDictionary:dictDelivery];
    [dictMutDelivery setObject:[NSNumber numberWithBool:NO] forKey:@"enableEdit"];
    [dictMutDelivery setObject:@"Endereço de entrega" forKey:@"labelAddress"];
    [cs updateAddressWithDictionary:dictMutDelivery];
    [[OFShipmentTemp new] assignCardDeliverieAddress:cs];
}

- (BOOL)hasExtendedWarranty {
    NSDictionary *dictCart = [_paymentDictionary valueForKey:@"cart"];
    NSArray *itemsProducts = [dictCart objectForKey:@"items"];
    
    for (NSDictionary *item in itemsProducts)
    {
        if ([item[@"service"] boolValue])
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - CardPaymentCellDelegate
- (void)paymentMethodsPressedScanCardButton:(WBRPaymentAddNewCardView *)cardPaymentCell
{
    if ([CardIOUtilities canReadCardWithCamera])
    {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if (granted) {
                    [self presentCardScanViewControllerWithCardPaymentCell:cardPaymentCell];
                }
            }];
        }
        else {
            [self presentCardScanViewControllerWithCardPaymentCell:cardPaymentCell];
        }
    }
    else
    {
        [self showCameraAccessAlert];
    }
}

- (void)presentCardScanViewControllerWithCardPaymentCell:(WBRPaymentAddNewCardView *)cardPaymentCell
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CardIOPaymentViewController *cardController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:cardPaymentCell];
        cardController.hideCardIOLogo = YES;
        cardController.disableManualEntryButtons = YES;
        cardController.collectExpiry = NO;
        cardController.collectCVV = NO;
        cardController.collectCardholderName = NO;
        cardController.collectPostalCode = NO;
        cardController.suppressScanConfirmation = YES;
        [self presentViewController:cardController animated:YES completion:^{
            if (cardPaymentCell.hasProduct) {
                self.hasUsedCardScanForProduct = YES;
                [WMOmniture trackCreditCardScanProductPayment];
            }
            if (cardPaymentCell.hasExtendedWarranty) {
                self.hasUsedCardScanForWarranty = YES;
                [WMOmniture trackCreditCardScanWarrantyPayment];
            }
        }];
    });
}

- (void)showCantScanCardAlert {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissVisibleKeyboard];
        [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message:CARD_SCANNER_CAMERA_ERROR];
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

- (void)dismissVisibleKeyboard
{
    [self.view endEditing:YES];
}

- (void)handleEnteredBackgroundPayment:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->_successShow) {
            [self.paymentMethodsView closePaymentOptions];
            [self.warrantyPaymentMethodsView closePaymentOptions];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    });
}

#pragma mark - Private Methods

- (void)populateThankYouPageDeliveryInfoWithData:(NSDictionary *)itemDict andDeliveryInfo:(NSString *)scheduledDeliveryText {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSString *sellerId = [itemDict objectForKey:@"sellerId"];
        if (![sellerId isEqualToString:self.lastSellerId]) {
            self.lastSellerId = sellerId;
            
            if (![self.thankYouPageDeliveryInformation objectForKey:sellerId]) {
                [self.thankYouPageDeliveryInformation setObject:scheduledDeliveryText forKey:sellerId];
            }
        }
    }];
}

- (void)setContinueButtonEnabled:(BOOL)enabled {
    
    //If we are disabling, even before the animation is finished, the button should already be disabled
    if (!enabled) {
        [self.submitOrderButton setUserInteractionEnabled:NO];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        if (enabled) {
            self.submitOrderButton.alpha = EnabledElementAlphaValue;
        }
        else {
            self.submitOrderButton.alpha = DisabledElementAlphaValue;
        }
    } completion:^(BOOL finished) {
        //If we are enabling the button, it should only be enabled after the animation finishes
        if (enabled) {
            [self.submitOrderButton setUserInteractionEnabled:YES];
        }
    }];
}

- (void)applyShadowViewBottom {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bottomView.bounds];
    self.bottomView.layer.masksToBounds = NO;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0.0f, -7.0f);
    self.bottomView.layer.shadowOpacity = 0.2f;
    self.bottomView.layer.shadowRadius = 4.0f;
    self.bottomView.layer.shadowPath = shadowPath.CGPath;
}

- (void)reloadPaymentViewConstraint {
    
    self.paymentMethodsViewHeightConstraint.constant = [self.paymentMethodsView.suggestedHeight floatValue];
    
    if (self.splitedPayment) {
        self.warrantyPaymentMethodsViewHeightConstraint.constant = [self.warrantyPaymentMethodsView.suggestedHeight floatValue];
        [self.warrantyPaymentMethodsView setHidden:NO];
        
        self.paymentWarrantyDisclaimerHeightConstraint.constant = [self.paymentWarrantyDisclaimer.suggestedHeight floatValue];
        [self.paymentWarrantyDisclaimer setHidden:NO];
    }
    else {
        [self.warrantyPaymentMethodsView collapseContent];
        self.warrantyPaymentMethodsViewHeightConstraint.constant = 0;
        [self.warrantyPaymentMethodsView setHidden:YES];
        
        self.paymentWarrantyDisclaimerHeightConstraint.constant = 0;
        [self.paymentWarrantyDisclaimer setHidden:YES];
    }
    
    [self.view layoutIfNeeded];
}


#pragma mark - One Card
- (void)setupOneCard
{
    
    NSDictionary *dictResumeCard = [_paymentDictionary valueForKey:@"installment"];
    NSDictionary *dictCartTotals = [dictResumeCard objectForKey:@"cartAmounts"];
    NSString *ttGlobalOrder = [dictCartTotals objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
    float ttProducts = ttGlobalOrder.floatValue;
    
    NSString *strTotalProductsWithoutServices = @(ttProducts/100).currencyFormat;
    int ttProd = ttGlobalOrder.intValue;
    NSString *ttGlobal = @(ttGlobalOrder.floatValue/100).currencyFormat;
    
    [self.paymentMethodsView fillInfoPaymentWithDictionary:
     @{@"titlePayment" : @"Pagamento do produto",
       @"strValueInThisCard"   :   strTotalProductsWithoutServices,
       @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
       @"paymentNumber"        :   @"1",
       @"showUserValue"        :   ttGlobal,
       @"doublePayment"        :   @(NO),
       @"hasExtendedWarranty"  :   @(self.isSinglePaymentAndHasExtendedWarranty),
       @"hasProduct": @YES
       }];
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
    int ttOnlyWarranty = 0;
    for (NSDictionary *item in items)
    {
        //First, verify if this is a warranty extended
        BOOL service = [item[@"service"] boolValue];
        if (!service) {
            ttOnlyProducts ++;
        } else {
            ttOnlyWarranty ++;
        }
        
    }
    
    NSString *strTotalOnlyProducts = @"Pagamento do produto";
    if (ttOnlyProducts > 1) {
        strTotalOnlyProducts = @"Pagamento dos produtos";
    }
    
    [self.paymentMethodsView fillInfoPaymentWithDictionary:
     @{@"titlePayment"        :   strTotalOnlyProducts,
       @"strValueInThisCard"   :   strTotalProductsWithServices,
       @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
       @"paymentNumber"        :   @"1",
       @"showUserValue"        :   strTotalProductsWithoutServicesToUser,
       @"doublePayment"       :   [NSNumber numberWithBool:YES],
       @"hasExtendedWarranty": @NO,
       @"hasProduct": @YES
       }];
    
    
    NSString *strTotalOnlyWarranty = @"Pagamento da Garantia Estendida";
    if (ttOnlyWarranty > 1) {
        strTotalOnlyWarranty = @"Pagamento das Garantias Estendidas";
    }
    
    [self.warrantyPaymentMethodsView fillInfoPaymentWithDictionary:
     @{@"titlePayment"         : strTotalOnlyWarranty,
       @"strValueInThisCard"   :   ttServices,
       @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
       @"paymentNumber"        :   @"2",
       @"showUserValue"        :   ttServices,
       @"doublePayment"        :   @(YES),
       @"hasExtendedWarranty": @YES,
       @"hasProduct": @NO
       }];
}

- (NSString *)getCardTypeWithName:(NSString *) nameCard {
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

- (NSString *)cleanPunctuation:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return text;
}

- (NSString *)creditCardName:(NSString *)creditCardName {
    
    NSString *nameCard = creditCardName;
    if ([nameCard isEqualToString:@"hiper"]) {
        nameCard = @"HIPERCARD";
    } else if ([nameCard isEqualToString:@"master"]) {
        nameCard = @"MASTERCARD";
    }
    
    return nameCard;
}

- (void)callInstallments {
    
    [self displayLoadingView];
    
    CreditCardFlag cardFlag = [self.paymentMethodsView getCreditCardFlag];
    NSString *firstCreditCardSelected = [CreditCardInteractor valueForFlag:cardFlag];
    NSDictionary *dictTypeDTO;
    
    if (self.splitedPayment) {
        
        NSString *secondCreditCardSelected = [CreditCardInteractor valueForFlag:[self.warrantyPaymentMethodsView getCreditCardFlag]];
        NSDictionary *addressInfo = [[OFAddressTemp new] getAddressDictionary];
        NSString *billingAddressId = [addressInfo objectForKey:@"id"];
        
        //        First payment
        NSString *firstCreditCardName = [self creditCardName:firstCreditCardSelected];
        NSString *firstCreditCardType = [self getCardTypeWithName:firstCreditCardSelected];
        NSMutableDictionary *dictionaryFirstCredictCard = [NSMutableDictionary dictionaryWithDictionary:@{@"cardViewNumber" : @"card1",
                                                                                                          @"type"           : @"CREDIT_CARD",
                                                                                                          @"credit"         : [NSNumber numberWithBool:YES],
                                                                                                          @"firstCreditCardAmount"   : [NSNumber numberWithInt:0],
                                                                                                          @"moip"           : [NSNumber numberWithBool:NO],
                                                                                                          @"billingAddressId": [NSNumber numberWithInt:[billingAddressId intValue]],
                                                                                                          @"sigeBankId"     : [NSNumber numberWithInt:0],
                                                                                                          @"sigePaymentTypeId": [NSNumber numberWithInt:1]
                                                                                                          }];
        if ([firstCreditCardName length] > 0) {
            [dictionaryFirstCredictCard setObject:[firstCreditCardName uppercaseString] forKey:@"name"];
        }
        if ([firstCreditCardType length] > 0) {
            [dictionaryFirstCredictCard setObject:firstCreditCardType forKey:@"id"];
        }
        NSMutableDictionary *dictFirstCreditCard = [[NSMutableDictionary alloc] initWithDictionary:dictionaryFirstCredictCard];
        
        
        //        Second payment
        NSString *secondCreditCardName = [self creditCardName:secondCreditCardSelected];
        NSString *secondCreditCardType = [self getCardTypeWithName:secondCreditCardSelected];
        NSMutableDictionary *dictionarySecondCreditCard = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                                          @"cardViewNumber" : @"card2",
                                                                                                          @"type"           : @"CREDIT_CARD",
                                                                                                          @"credit"         : [NSNumber numberWithBool:YES],
                                                                                                          @"firstCreditCardAmount"   : [NSNumber numberWithInt:0],
                                                                                                          @"moip"           : [NSNumber numberWithBool:NO],
                                                                                                          @"billingAddressId": [NSNumber numberWithInt:[billingAddressId intValue]],
                                                                                                          @"sigeBankId"     : [NSNumber numberWithInt:0],
                                                                                                          @"sigePaymentTypeId": [NSNumber numberWithInt:1]
                                                                                                          }];
        if ([secondCreditCardName length] > 0) {
            [dictionarySecondCreditCard setObject:[secondCreditCardName uppercaseString] forKey:@"name"];
        }
        if ([secondCreditCardType length] > 0) {
            [dictionarySecondCreditCard setObject:secondCreditCardType forKey:@"id"];
        }
        NSMutableDictionary *dictSecondCreditCard = [[NSMutableDictionary alloc] initWithDictionary:dictionarySecondCreditCard];
        
        
        if ([OFSetup enableInstallmentsWithRateInCheckout]) {
            
            NSString *strCardNbFirst = [self cleanPunctuation:[self.paymentMethodsView getCreditCardNumber]];
            if (strCardNbFirst.length >= 6) {
                NSString *strBin = [strCardNbFirst substringToIndex:6];
                int binNb = [strBin intValue];
                [dictFirstCreditCard setObject:[NSNumber numberWithInt:binNb] forKey:@"bin"];
            }
            
            NSString *strCardNbSecond = [self cleanPunctuation:[self.warrantyPaymentMethodsView getCreditCardNumber]];
            if (strCardNbSecond.length >= 6) {
                NSString *strBin = [strCardNbSecond substringToIndex:6];
                int binNb = [strBin intValue];
                [dictSecondCreditCard setObject:[NSNumber numberWithInt:binNb] forKey:@"bin"];
            }
        }
        
        NSDictionary *dictDTODictionary = @{
                                            @"firstCreditCardAmount"   : [NSNumber numberWithInteger:[self.paymentMethodsView getValueToDebit]],
                                            @"credit": [NSNumber numberWithBool:YES],
                                            @"id": [NSNull null]
                                            };
        NSMutableDictionary *dictTypeDTOMultable = [[NSMutableDictionary alloc] initWithDictionary:dictDTODictionary];
        
        if (secondCreditCardName == nil || ![secondCreditCardName isEqualToString:@""]) {
            [dictTypeDTOMultable setObject:dictSecondCreditCard forKey:@"secondCreditCard"];
        }
        else {
            [dictTypeDTOMultable setObject:[NSNull null] forKey:@"secondCreditCard"];
        }
        
        if (firstCreditCardName == nil || ![firstCreditCardName isEqualToString:@""]) {
            [dictTypeDTOMultable setObject:dictFirstCreditCard forKey:@"firstCreditCard"];
        }
        else {
            [dictTypeDTOMultable setObject:[NSNull null] forKey:@"firstCreditCard"];
        }
        
        dictTypeDTO = dictTypeDTOMultable;
    }
    else {
        
        NSString *firstCreditCardName = [self creditCardName:firstCreditCardSelected];
        NSString *firstCreditCardType = [self getCardTypeWithName:firstCreditCardSelected];
        
        dictTypeDTO = @{@"id"                     : firstCreditCardType,
                        @"name"                   : [firstCreditCardName uppercaseString],
                        @"type"                   : @"CREDIT_CARD",
                        @"sigePaymentTypeId"      : [NSNumber numberWithInt:1],
                        @"sigeBankId"             : [NSNumber numberWithInt:0],
                        @"credit"                 : [NSNumber numberWithBool:YES],
                        @"cardViewNumber"         : @"singleCard",
                        @"firstCreditCardAmount"  : [NSNumber numberWithInteger:[self.paymentMethodsView getValueToDebit]]
                        };
        
        if ([OFSetup enableInstallmentsWithRateInCheckout]) {
            
            //Calculate bin
            NSString *strCardNb = [self cleanPunctuation:[self.paymentMethodsView getCreditCardNumber]];
            
            if (strCardNb.length >= 6) {
                
                NSString *strBin = [strCardNb substringToIndex:6];
                int binNb = [strBin intValue];
                
                dictTypeDTO = @{@"id"                     : firstCreditCardType,
                                @"bin"                    : [NSNumber numberWithInt:binNb],
                                @"name"                   : [firstCreditCardName uppercaseString],
                                @"type"                   : @"CREDIT_CARD",
                                @"sigePaymentTypeId"      : [NSNumber numberWithInt:1],
                                @"sigeBankId"             : [NSNumber numberWithInt:0],
                                @"credit"                 : [NSNumber numberWithBool:YES],
                                @"cardViewNumber"         : @"singleCard",
                                @"firstCreditCardAmount"  : [NSNumber numberWithInteger:[self.paymentMethodsView getValueToDebit]]
                                };
            }
        }
    }
    
    NSDictionary *dictCreditPayment = @{@"paymentTypeDTO" : dictTypeDTO,
                                        @"splitServicePayment" : [NSNumber numberWithBool:self.splitedPayment],
                                        @"credit"   :   [NSNumber numberWithBool:YES]
                                        };
    
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

- (void)requestPaymentWithInstallments:(NSString *) strPaymentWithCart {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [self hideLoadingView];
        
        if (self.calledInstallments == kPaymentComponentProduct) {
            [self.paymentMethodsView processInstallments:strPaymentWithCart];
        }
        else if (self.calledInstallments == kPaymentComponentWarranty) {
            [self.warrantyPaymentMethodsView processInstallments:strPaymentWithCart];
        }
    }];
}

- (void)reloadValuesWithPaymentDictionary:(NSDictionary *)paymentDictionary {
    if (self.paymentMethodsView.cCardSelected) {
        if ([self.paymentMethodsView hasValidCard] || [self.warrantyPaymentMethodsView hasValidCard]) {
            [self WBRPaymentMethodsViewDidReceiveInstallmentNotification:self.paymentMethodsView];
        } else {
            if (self.splitedPayment) {
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
                [self.paymentMethodsView fillInfoPaymentWithDictionary:
                 @{@"titlePayment"        :   strTotalOnlyProducts,
                   @"strValueInThisCard"   :   strTotalProductsWithServices,
                   @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
                   @"paymentNumber"        :   @"1",
                   @"showUserValue"        :   strTotalProductsWithoutServicesToUser,
                   @"doublePayment"       :   [NSNumber numberWithBool:YES],
                   @"hasExtendedWarranty": @NO,
                   @"hasProduct": @YES
                   }];
                
                [self.warrantyPaymentMethodsView fillInfoPaymentWithDictionary:
                 @{@"titlePayment" : @"Seguro Garantia Estendida Original",
                   @"strValueInThisCard"   :   ttServices,
                   @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
                   @"paymentNumber"        :   @"2",
                   @"showUserValue"        :   ttServices,
                   @"doublePayment"        :   @(YES),
                   @"hasExtendedWarranty": @YES,
                   @"hasProduct": @NO
                   }];
                
            } else {
                
                NSDictionary *dictResumeCard = [paymentDictionary valueForKey:@"installment"];
                NSDictionary *dictCartTotals = [dictResumeCard objectForKey:@"cartAmounts"];
                NSString *ttGlobalOrder = [dictCartTotals objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
                float ttProducts = ttGlobalOrder.floatValue;
                
                NSString *strTotalProductsWithoutServices = @(ttProducts/100).currencyFormat;
                int ttProd = ttGlobalOrder.intValue;
                NSString *ttGlobal = @(ttGlobalOrder.floatValue/100).currencyFormat;
                
                [self.paymentMethodsView fillInfoPaymentWithDictionary:
                 @{@"titlePayment" : @"Pagamento do produto",
                   @"strValueInThisCard"   :   strTotalProductsWithoutServices,
                   @"strValueFromService"  :   [NSNumber numberWithInt:ttProd],
                   @"paymentNumber"        :   @"1",
                   @"showUserValue"        :   ttGlobal,
                   @"doublePayment"        :   @(NO),
                   @"hasExtendedWarranty"  :   @(self.splitedPayment),
                   @"hasProduct": @YES
                   }];
            }
        }
    } else {
        [self.paymentMethodsView updatePaymentInformation];
    }
}


#pragma mark - WBRPaymentMethodsViewProtocol

- (void)WBRPaymentMethodsViewDidReceiveInstallmentNotification:(WBRPaymentMethodsView *)paymentWarrantyView {
    self.calledInstallments = kPaymentComponentProduct;
    [self callInstallments];
}

- (void)WBRPaymentMethodsView:(WBRPaymentMethodsView *)paymentMethodsView didSelectCard:(WBRCardModel *)card {
    [self setContinueButtonEnabled:YES];
}

- (void)WBRPaymentMethodsView:(WBRPaymentMethodsView *)paymentMethodsView didUpdateContentHeight:(NSNumber *)newHeight {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [UIView animateWithDuration:0.3f animations:^{
            [self reloadPaymentViewConstraint];
        }];
    }];
}

- (void)didChangePaymentMethod {
    //    [self setContinueButtonEnabled:NO];
}

- (void)didChoosePaymentMethodCreditCard {
    self.paymentTypeCreditCard = YES;
    [self setContinueButtonEnabled:YES];
}

- (void)didChoosePaymentMethodCreditBankSlip {
    self.paymentTypeCreditCard = NO;
    [self setContinueButtonEnabled:YES];
}

#pragma mark - PaymentWarrantyViewProtocol

- (void)WBRPaymentWarrantyView:(WBRPaymentWarrantyView *)paymentWarrantyView didUpdateContentHeight:(NSNumber *)newHeight {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [UIView animateWithDuration:0.3f animations:^{
            [self reloadPaymentViewConstraint];
        }];
    }];
}

- (void)WBRPaymentWarrantyViewDidReceiveInstallmentNotification:(WBRPaymentWarrantyView *)paymentWarrantyView {
    
    self.calledInstallments = kPaymentComponentWarranty;
    [self callInstallments];
}

#pragma mark - PaymentWarrantyViewProtocol

- (void)displayLoadingView {
    [self.navigationController.view showSmartModalLoading];
}

- (void)hideLoadingView {
    [self.navigationController.view hideSmartModalLoading];
}

#pragma mark - PaymentWarrantyViewProtocol

- (void)checkoutError:(NSString *)error backToCart:(BOOL)backToCart {
    
    [self.navigationController.view hideModalLoading];
    [self.navigationController.view showAlertWithMessage:error dismissBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (backToCart) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        });
    }];
}

#pragma mark - PaymentWarrantyDisclaimerProtocol

- (void)WBRPaymentWarrantySelectedSinglePayment:(WBRPaymentWarrantyDisclaimer *)paymentWarrantyDisclaimer {
    self.isSinglePaymentAndHasExtendedWarranty = YES;
    self.splitedPayment = NO;
    [self.paymentMethodsView setOnlyCreditCardOption:YES];
    [self.paymentMethodsView clearCreditCardInputtedContent];
    [self fetchData];
}

#pragma mark - Finish Order

- (IBAction)finishOrderButtonAction:(id)sender {
    [self finishOrder];
}

- (void)finishOrder
{
    LogInfo(@"Has Interest 1a: %i", [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt1"]);
    LogInfo(@"Has Interest 2a: %i", [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt2"]);
    
    BOOL hasInt1 = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt1"];
    BOOL hasInt2 = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt2"];
    
    if (!hasInt1 && hasInt2) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUniqueInterest"];
    }
    else if (!hasInt2 && hasInt1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUniqueInterest"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUniqueInterest"];
    }
    
    
    NSMutableArray *arrChecks = [NSMutableArray new];
    if (self.paymentTypeCreditCard) {
        if (self.splitedPayment) {
            
            if (self.paymentMethodsView) {
                LogInfo(@"1st Dictionary: %@", [self.paymentMethodsView getContentPayment]);
                [arrChecks addObject:[self.paymentMethodsView getContentPayment]];
            }
            
            if (self.warrantyPaymentMethodsView) {
                LogInfo(@"2nd Dictionary: %@", [self.warrantyPaymentMethodsView getContentPayment]);
                [arrChecks addObject:[self.warrantyPaymentMethodsView getContentPayment]];
            }
            
        } else {
            if (self.paymentMethodsView)
            {
                LogInfo(@"1st Dictionary: %@", [self.paymentMethodsView getContentPayment]);
                [arrChecks addObject:[self.paymentMethodsView getContentPayment]];
            }
        }
    }
    
    LogInfo(@"Check payments array: %@", arrChecks);
    int ttCardOptions = (int)[arrChecks count];
    
    for (int i=0;i<ttCardOptions;i++)
    {
        NSDictionary *dictPayment = [arrChecks objectAtIndex:i];
        
        BOOL blockOrder = [[dictPayment objectForKey:@"blockOperation"] boolValue];
        NSString *msgError = [dictPayment objectForKey:@"error"];
        int paymentNumber = [[dictPayment objectForKey:@"paymentNumber"] intValue];
        //if (blockOrder && _paymentContainerViewController.isPayingWithCreditCard)
        if (blockOrder && self.paymentTypeCreditCard)
        {
            NSString *strMsg = [NSString stringWithFormat:@"%@", msgError];
            if (ttCardOptions > 1)
            {
                NSString *indexPayment = @"primeiro";
                if (paymentNumber == 2)
                {
                    indexPayment = @"segundo";
                }
                strMsg = [NSString stringWithFormat:@"%@ no %@ pagamento.", msgError, indexPayment];
            }
            
            [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message:strMsg];
            return;
        }
    }
    
    //If success, package to order
    [self.navigationController.view showModalLoading];
    [self confirmOrderWithArrayItems:arrChecks];
}

- (void)confirmOrderWithArrayItems:(NSArray *)arrChecks
{
    LogInfo(@"arr checks: %@", arrChecks);
    NSMutableArray *arrPayment = [NSMutableArray new];
    
    NSDictionary *addressInfo = _fullAddress;
    NSString *billingAddressId = [addressInfo objectForKey:@"id"];
    
    NSDictionary *dictResumeCard = [_paymentDictionary valueForKey:@"installment"];
    NSDictionary *dictCartTotals = [dictResumeCard objectForKey:@"cartAmounts"];
    
    NSString *ttServicesOrder = [dictCartTotals objectForKey:@"servicesAmount"] ?: @"0"; //Garantia estendida
    NSString *ttGlobalOrder = [dictCartTotals objectForKey:@"totalAmountPlusGiftCardDiscountAmount"] ?: @"0";
    
    int ttProductsValue = [ttGlobalOrder intValue];
    int ttServicesValue = [ttServicesOrder intValue];
    
    for (int i=0;i<(int)[arrChecks count];i++)
    {
        int ttProducts = 0;
        if (ttProducts == 0)
        {
            ttProducts = ttProductsValue - ttServicesValue;
            if (i==1) {
                ttProducts = ttServicesValue;
            }
            
            if ((int)[arrChecks count] == 1) {
                ttProducts = ttProductsValue;
            }
        }
        
        NSDictionary *dictPayment = [NSDictionary new];
        //if (_paymentContainerViewController.isPayingWithCreditCard)
        if (self.paymentTypeCreditCard)
        {
            NSString *expirationMonth = [[arrChecks objectAtIndex:i] objectForKey:@"monthCard"];
            NSString *expirationYear = [[arrChecks objectAtIndex:i] objectForKey:@"yearCard"];
            expirationYear = [@"20" stringByAppendingString:expirationYear];
            NSString *paymentTypeName = [[[arrChecks objectAtIndex:i] objectForKey:@"cardName"] uppercaseString];
            NSString *paymentTypeId = [[arrChecks objectAtIndex:i] objectForKey:@"cardId"];
            
            if (paymentTypeName.length > 0)
            {
                if ([paymentTypeName.uppercaseString isEqualToString:@"MASTERCARD"])
                {
                    paymentTypeName = @"MASTER";
                }
            }
            
            NSString *installmentsNumberFull = [[arrChecks objectAtIndex:i] objectForKey:@"installmentsCard"];
            NSArray *arrInstallments = [installmentsNumberFull componentsSeparatedByString:@"x"];
            NSString *installmentsNumber = [arrInstallments objectAtIndex:0];
            
            NSString *creditCardNumber = [[arrChecks objectAtIndex:i] objectForKey:@"cardNumber"];
            creditCardNumber = [creditCardNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
            creditCardNumber = [creditCardNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
            creditCardNumber = [creditCardNumber stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSString *cvv2 = [[arrChecks objectAtIndex:i] objectForKey:@"codCardNumber"];
            
            NSString *cardHolder = [[arrChecks objectAtIndex:i] objectForKey:@"nameCard"];
            NSString *document = [[arrChecks objectAtIndex:i] objectForKey:@"documentNumber"];
            document = [document stringByReplacingOccurrencesOfString:@"." withString:@""];
            document = [document stringByReplacingOccurrencesOfString:@"-" withString:@""];
            document = [document stringByReplacingOccurrencesOfString:@"," withString:@""];
            document = [document stringByReplacingOccurrencesOfString:@"/" withString:@""];
            document = [document stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            
            NSString *installmentsChoosed = [[arrChecks objectAtIndex:i] objectForKey:@"installmentsChoosed"];
            NSString *creditCardToken = [[arrChecks objectAtIndex:i] objectForKey:@"creditCardToken"];
            
            NSNumber *allowSaveCard = [[arrChecks objectAtIndex:i] objectForKey:@"allowSaveCard"];
            
            if ([allowSaveCard boolValue]) {
                [WMOmniture trackCreditCardAllowSaveToNextShop];
            }
            
            dictPayment =  @{       @"expirationMonth"     :   [NSNumber numberWithInt:[expirationMonth intValue]],
                                    @"expirationYear"      :   [NSNumber numberWithInt:[expirationYear intValue]],
                                    @"paymentTypeName"     :   paymentTypeName,
                                    @"paymentTypeId"       :   paymentTypeId,
                                    @"value"               :   [NSNumber numberWithInt:ttProducts],
                                    @"installmentsNumber"  :   installmentsNumber,
                                    @"billingAddressId"    :   billingAddressId,
                                    @"creditCardNumber"    :   creditCardNumber,
                                    @"cvv2"                :   cvv2,
                                    @"cardHolder"          :   cardHolder,
                                    @"document"            :   document,
                                    @"installmentsChoosed" :   installmentsChoosed,
                                    @"hasInterestToOrder"  :   [NSNumber numberWithBool:[[[arrChecks objectAtIndex:i] objectForKey:@"hasInterest"] boolValue]],
                                    @"allowSaveCard"       :   [NSNumber numberWithBool:[[[arrChecks objectAtIndex:i] objectForKey:@"allowSaveCard"] boolValue]]
                                    };
            
            NSMutableDictionary *paymentDictionary = [[NSMutableDictionary alloc] initWithDictionary:dictPayment];
            
            if (creditCardToken != nil &&
                ![creditCardToken isEqualToString:@""]) {
                [paymentDictionary setObject:creditCardToken forKey:@"creditCardId"];
            }
            
            //Adding installmentPlanId for new installments (january-2019)
            if ([[[_paymentDictionary objectForKey:@"cart"] objectForKey:@"bestInstallment"] objectForKey:@"installmentPlanId"]) {
                
                NSNumber *instPlanId = [[[_paymentDictionary objectForKey:@"cart"] objectForKey:@"bestInstallment"] objectForKey:@"installmentPlanId"];
                [paymentDictionary setObject:instPlanId forKey:@"installmentPlanId"];
            }
            
            LogInfo(@"dictPayment: %@", paymentDictionary);
            
            [arrPayment addObject:paymentDictionary];
        }
    }
    
    if (arrChecks.count == 0) //If !BankSlip
    {
        NSDictionary *dictPayment = @{@"value" : [NSNumber numberWithInt:ttProductsValue], @"paymentTypeName" : @"boleto", @"installmentsNumber" : @1};
        
        [arrPayment addObject:dictPayment];
    }
    [[OFPayTemp new] assignArrayPay:arrPayment];
    
    NSMutableDictionary *dictMutFinalAddress = [NSMutableDictionary dictionaryWithDictionary:addressInfo];
    [dictMutFinalAddress removeObjectForKey:@"iControl"];
    [dictMutFinalAddress removeObjectForKey:@"status"];
    [dictMutFinalAddress removeObjectForKey:@"qtyAddress"];
    
    NSDictionary *dictOrder = @{@"deliveryAddress"  :   dictMutFinalAddress,
                                @"paymentInfo"      :   arrPayment
                                };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictOrder
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    LogInfo(@"Dict Payment Order: %@", jsonString);
    [self sendPackageToOrder:jsonString];
}

- (void) sendPackageToOrder:(NSString *) jsonString {
    NSString *strJsonPO = jsonString;
    strJsonPO = [strJsonPO stringByReplacingOccurrencesOfString:@"\\" withString:@""];

    [WBRPaymentManager postPaymentPlaceOrder:@{@"placeorder":strJsonPO} successBlock:^(NSString *dataString) {
        [self requestPlaceOrder:dataString];
    } failure:^(NSError *error, NSString *dataString) {
        if (error.code == 401) {
            LogErro(@"401 received! Token expired Place Order! :(");
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

- (void)errorCheckoutAuth {
    self.backToCart = YES;
    [self errorConn:ERROR_401_CHECKOUT];
}

- (void)errorConnNewCheckout:(NSString *)msgError {
    self.backToCart = YES;
    [self errorConn:msgError];
}

- (void)errorCheckout:(NSDictionary *)dictError {
    LogNewCheck(@"Error Payment Card Checkout: %@", dictError);
    self.backToCart = YES;
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
            if (self->_backToCart)
            {
                self.backToCart = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        });
    }];
}

- (void)requestPlaceOrder:(NSString *)strPlaceOrder
{
    LogNewCheck(@"Success ORDER: %@", strPlaceOrder);
    
    NSError *error = nil;
    NSData *jsonData = [strPlaceOrder dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *arrPay;
    if (self.paymentTypeCreditCard) {
        NSMutableArray *arrPayTemp = [NSMutableArray new];
        [arrPayTemp addObject:[self.paymentMethodsView getContentPayment]];
        if (self.splitedPayment) {
            [arrPayTemp addObject:[self.warrantyPaymentMethodsView getContentPayment]];
        }
        
        NSArray *arrPaymentCreditCards = [[OFPayTemp new] getArrPay];
        //Get the first payment, because we don't have payment with more than 1 credit card, unless with Extended Warranty (we don't have extended warranty at this moment (02/26/2018)
        if (arrPaymentCreditCards.count > 0) {
            NSDictionary *dictCard = [arrPaymentCreditCards objectAtIndex:0];
            NSMutableDictionary *dictPayTemp = [NSMutableDictionary dictionaryWithDictionary:[arrPayTemp objectAtIndex:0]];
            [dictPayTemp setObject:[dictCard objectForKey:@"value"] forKey:@"value"];
            [arrPayTemp removeAllObjects];
            [arrPayTemp addObject:dictPayTemp];
        }

        arrPay = arrPayTemp;
    }
    else {
        arrPay = [[OFPayTemp new] getArrPay];
    }
    
//    NSArray *arrPay = [[OFPayTemp new] getArrPay];

    LogInfo(@"Arr Payment: %@", arrPay);
    
    NSString *nrOrder = [jsonObjects valueForKey:@"orderId"];
    LogNewCheck(@"************************************************************************");
    LogNewCheck(@"----------------------- nrOrder: %@------------------------------", nrOrder);
    LogNewCheck(@"************************************************************************");
    
    //Prepare view to order success without edit option
    NSArray *products = _productsCardController.products[@"products"];
    [self makeCardProductsToSuccess:_productsCardController withDictData:products];
    
    //Prepare card to show in Order
    [self makeCardDeliveryToSuccess:_shippingAddressController withDictData:_shippingAddressController.addressContent];
    
    NSMutableDictionary *resume = [NSMutableDictionary dictionaryWithDictionary:[arrPay objectAtIndex:0]];
    [resume setObject:nrOrder forKey:@"orderNumber"];
    
    //Determine total global
    int valueTotal = 0;

    for (int k=0;k<(int)[arrPay count];k++)
    {
        NSDictionary *dictTp = [arrPay objectAtIndex:k];
        int valueTp = [[dictTp objectForKey:@"value"] intValue];
        valueTotal = valueTotal + valueTp;
    }

    //Products
    OFShipmentTemp *tempStore = [OFShipmentTemp new];
    NSArray *deliveries = [tempStore getDeliveries];
    NSArray *cartItems = [tempStore getCartItens];
    
    NSDictionary *successDictionary = @{@"orderResume"                  : resume,
                                        @"payment"                      : arrPay,
                                        @"userInfo"                     : self.fullAddress,
                                        @"cart"                         : cartItems ?: @[],
                                        @"deliveries"                   : deliveries,
                                        @"extendedWarranty"             : @([self hasExtendedWarranty]),
                                        @"totalOrder"                   : @(valueTotal),
                                        @"hasUsedCardScan"              : @(_hasUsedCardScanForProduct || _hasUsedCardScanForWarranty),
                                        @"hasUsedCardScanForProduct"    : @(_hasUsedCardScanForProduct),
                                        @"hasUsedCardScanForWarranty"   : @(_hasUsedCardScanForWarranty),
                                        @"scheduledDeliveryInformation" : self.thankYouPageDeliveryInformation
                                        };
    
    LogInfo(@"Success dictionary: %@", successDictionary);
    
    //Removing Loading
    [self.navigationController.view hideModalLoading];
    
    _successShow = YES;
    
    WBRThankYouPageViewController *suc = [[WBRThankYouPageViewController alloc] init];
    suc.successDictionary = successDictionary;
    //if (!_paymentContainerViewController.isPayingWithCreditCard)
    if (!self.paymentTypeCreditCard)
    {
        suc.isBankingTicket = YES;
    }
    [self.navigationController pushViewController:suc animated:YES];
}

#pragma mark Cart Overview Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.cartProducts.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        WBRPaymentHeaderSectionView *headerView = [[WBRPaymentHeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, self.tbCart.frame.size.width, self.tbCart.frame.size.height)];
        [headerView setDelegate:self];
        return headerView;
    } else {
        return nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NSMutableDictionary *itemDict = self.cartProducts[indexPath.row];
        
        BOOL service = [itemDict[@"service"] boolValue];
        if (service) {
            WBRPaymentNewCartCardWarranty *cell = [tableView dequeueReusableCellWithIdentifier:[WBRPaymentNewCartCardWarranty reuseIdentifier] forIndexPath:indexPath];
            [cell setCell:itemDict];
            return cell;
        } else {
            WBRPaymentNewCartCardSimple *cell = [tableView dequeueReusableCellWithIdentifier:[WBRPaymentNewCartCardSimple reuseIdentifier] forIndexPath:indexPath];
            [cell setDelegate:self];
            [itemDict setObject:[self getShippingEstimateDate:itemDict[@"key"]] forKey:@"customDeliveryInformation"];
            [cell setCell:itemDict];
            [self populateThankYouPageDeliveryInfoWithData:itemDict andDeliveryInfo:cell.deliveryDaysLabel.text];
            return cell;
        }
        
    } else {
        ShipAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:[ShipAddressCell reuseIdentifier] forIndexPath:indexPath];
        [cell setUserInteractionEnabled:NO];
        [cell setupWithAddressDict:self.fullAddress enableEditControls:FALSE];
        return cell;
    }
}

-(NSString *)getShippingEstimateDate:(NSString *)productKey {
    NSString *productDelivery;
    NSArray *deliveriesArray = [_paymentDictionary objectForKey:@"selectedDeliveries"];
    for (NSDictionary *delivery in deliveriesArray) {
        NSArray *itemsKeys = delivery[@"itemsKeys"];
        if ([itemsKeys containsObject:productKey]) {
            
            NSNumber *deliveryEstimateInDays = delivery[@"shippingEstimateInDays"];
            NSString *deliveryEstimateTimeUnit = delivery[@"shippingEstimateTimeUnit"];
            NSString *customDeliveryInformation = [DeliveryEstimateInteractor deliveryEstimateWithDays:deliveryEstimateInDays.unsignedIntegerValue unit:deliveryEstimateTimeUnit];
            
            productDelivery = customDeliveryInformation;
            break;
        }
    }
    
    return productDelivery;
}

- (int) countQuantitiesProducts {
    
    int qty = 0;
    
    for (int i=0;i<(int)[self.cartProducts count];i++) {
        
        NSDictionary *dictPd = [self.cartProducts objectAtIndex:i];
        if (![dictPd[@"service"] boolValue]) {
            int qtyPd = [[dictPd objectForKey:@"quantity"] intValue];
            qty = qty + qtyPd;
        }
        
    }
    
    return qty;
}

#pragma mark - TableViewCart Delegate
- (void)changeButtonTouched {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


#pragma mark - WBRPaymentNewCartCardSimpleDelegate
- (void)changeDeliveryDateTouched {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showSellerDescriptionWithSellerId:(NSString *)sellerId {
    WMWebViewController *sellerDescription = [[WMWebViewController alloc] initWithURLStr:[[OFUrls new] getURLSellerDescriptionWithSellerId:sellerId] title:@"Detalhes"];
    WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:sellerDescription];
    [self presentViewController:container animated:YES completion:nil];
}

#pragma mark - WBRPaymentNewCartOthersDelegate
- (void)removeCouponWithRedemptionCode:(NSString *)redemptionCode {
    [self removeCurrentRedemptionCode];
}

- (void)showAddCouponViewController {
    [self showDiscountCouponView];
}

- (void)touchedChangeProducts {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Discount Coupon Handling

- (void)didApplyDiscountCouponToOrder {
    [self fetchData];
    self.addedCoupon = YES;
}

- (void)didDismissCouponViewController {
    [self.navigationController.view hideSmartLoading];
}

- (void)showDiscountCouponView {
    self.discountCouponViewController = [[WMBDiscountCouponViewController alloc] init];
    self.discountCouponViewController.delegate = self;
    self.discountCouponViewController.isCheckoutFlow = YES;
    
    [self.navigationController.view showSmartLoadingWithBackgroundColor:RGBA(33, 150, 243, 1)];
    
    [self.navigationController presentViewController:self.discountCouponViewController animated:YES completion:^{
    }];
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

@end
