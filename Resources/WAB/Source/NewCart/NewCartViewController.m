//
//  NewCartViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 5/16/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "NewCartViewController.h"
#import "WMParser.h"

#import "OFShipAddressViewController.h"
#import "PersonalDataComplementViewController.h"

#import "OFFormatter.h"
#import "WMTokens.h"
#import "NSString+Additions.h"
#import "NSString+HTML.h"

#import "InternetTest.h"
#import "FlurryWM.h"
#import "WMOmniture.h"

#import "WMWebViewController.h"
#import "WALShowcaseTrackerManager.h"
#import "WMRetargetingConnection.h"

#import "NewCartOthers.h"
#import "WMAlertView.h"
#import "User.h"

#import "CartConnection.h"
#import "CouponInteractor.h"

#import "WBRCartConnection.h"
#import "WMButtonRounded.h"

#import "WBRNavigationBarButtonItemFactory.h"
#import "WBRCheckoutManager.h"
#import "WMBCartManager.h"
#import "WBRBestInstallment.h"

@interface NewCartViewController () <addressShipAddDelegate, NewCartOthersDelegate, personalComplementDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPay;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalValue;
@property (weak, nonatomic) IBOutlet WMButtonRounded *btPay;
@property (weak, nonatomic) IBOutlet UIView *viewEmpty;

@property (strong, nonatomic) NSArray *arrProducts;
@property (nonatomic, strong) NSString *loggerKey;

@property (strong, nonatomic) NSString *latestQty;
@property (strong, nonatomic) NSString *oldQty;
@property (strong, nonatomic) NSString *keyProduct;
@property (strong, nonatomic) NSString *sellerId;
@property (strong, nonatomic) NSString *discountValue;

@property (strong, nonatomic) NSDictionary *dictProducts;

@property (assign, nonatomic) BOOL isFromZipButton;
@property (assign, nonatomic) BOOL deliveryNotPossible;
@property (assign, nonatomic) BOOL isFromBackground;
@property (assign, nonatomic) BOOL alreadyTryCart;
@property (assign, nonatomic) BOOL expiredToken;
@property (assign, nonatomic) BOOL blockFinishBuy;
@property (assign, nonatomic) BOOL blockFinishBuyQty;
@property (assign, nonatomic) BOOL discountApplyed;
@property (assign, nonatomic) BOOL isBuying;
@property (assign, nonatomic) BOOL isZipError;
@property (assign, nonatomic) BOOL keyboardUp;

@property (strong, nonatomic) PersonalDataComplementViewController *pdc;

@property (strong, nonatomic) NSDictionary *parsedCart;

@property (strong, nonatomic) NewCartOthers *cartFooter;

@property (nonatomic) BOOL hasTokenCheckout;
@property (nonatomic) BOOL isFacebook;

@property (strong, nonatomic) WMBCalculateShippingCostViewController *shippingCostViewController;
@property (strong, nonatomic) WMBDiscountCouponViewController *discountCouponViewController;

@end

@implementation NewCartViewController

- (id)init
{
    self = [super initWithTitle:@"Meu carrinho" isModal:YES searchButton:NO cartButton:NO wishlistButton:NO];
    if (self) {
        _arrPicker = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
        
        self.cartFooter = [NewCartOthers new];
        _cartFooter.delegate = self;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _hasTokenCheckout = NO;
    self.isBuying = NO;
    [self registerForKeyboardEvents];
    [self loadCartFromServerWithSuccessCompletion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unregisterForKeyboardEvents];
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self applyShadowViewBottom];
    
    UIView *footerView = _tbCart.tableFooterView;
    if (footerView) {
        CGFloat height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        CGRect footerFrame = footerView.frame;
        if (height != footerFrame.size.height) {
            footerFrame.size.height = height;
            footerView.frame = footerFrame;
            _tbCart.tableFooterView = footerView;
        }
    }
}

- (NSDictionary *)authData
{
    //Get all values
    User *user = [User sharedUser];
    NSMutableDictionary *authStatus = [[NSMutableDictionary alloc] init];
    [authStatus setValue:[[WMTokens new] getTokenCheckout] forKey:@"tkCk"];
    [authStatus setValue:[[WMTokens new] getCartId] forKey:@"cart"];
    [authStatus setValue:@(user.hasDocument) forKey:@"hasDocument"];
    [authStatus setValue:@(user.hasPhone) forKey:@"hasPhone"];
    return [NSDictionary dictionaryWithDictionary:authStatus];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWithFacebook:) name:@"faceBuyOrder" object:nil];
    
    LogNewCheck(@"[NewCartViewController - didLoad] Status Auth: %@", [self authData]);
    
    [_tbCart registerNib:[UINib nibWithNibName:NSStringFromClass([NewCartCardSimple class]) bundle:nil] forCellReuseIdentifier:[NewCartCardSimple reuseIdentifier]];
    [_tbCart registerNib:[UINib nibWithNibName:NSStringFromClass([NewCartCardWarranty class]) bundle:nil] forCellReuseIdentifier:[NewCartCardWarranty reuseIdentifier]];
    _tbCart.contentInset = UIEdgeInsetsMake(15.0f, 0.0f, 0.0f, 0.0f);
    _tbCart.hidden = YES;
    
    [FlurryWM logEvent_cart_entering];
    
    [self formatFonts];
    
    _tbCart.tableFooterView = _cartFooter;
    self.tbCart.rowHeight = UITableViewAutomaticDimension;
    self.tbCart.estimatedRowHeight = 80.0f;

    [self applyShadowViewBottom];
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

- (void)reloadFooter {
    float productsAmount = [_dictProducts[@"productsAmount"] floatValue] / 100;
    float servicesamount = [_dictProducts[@"servicesAmount"] floatValue] / 100;
    float subtotal = productsAmount + servicesamount;
    
    NSString *postalCode = _dictProducts[@"postalCode"];
    if (postalCode && ![postalCode isEqualToString:@""]) {
        float estimatedShipmentCost = [_dictProducts[@"estimatedBestShippingAmount"] floatValue] / 100;
        if (estimatedShipmentCost > 0) {
            self.freightPriceLbl = [self currencyFormat:estimatedShipmentCost];
        }
        else {
            self.freightPriceLbl = SHIPMENT_VALUE_FREE;
        }
    }
    
    float total = [_dictProducts[@"totalPrice"] floatValue] / 100;
    float valuePerInstallment = [_dictProducts[@"valuePerInstallment"] floatValue];
    int installmentQty = [_dictProducts[@"installmentAmount"] intValue];
    
    NSDictionary *coupon;
    NSArray *giftCards = _parsedCart[@"giftCards"];
    if (giftCards.count > 0) {
        coupon = giftCards[0];
    }
    
    CGFloat vlNominalDiscount = [[_parsedCart objectForKey:@"totalNominalDiscount"] floatValue]/100;
    self.discountApplyed = vlNominalDiscount > 0;
    if (vlNominalDiscount > 0) {
        self.discountValue = [self currencyFormat:vlNominalDiscount];
        LogNewCheck(@"Discount Value :-): %@", _discountValue);
    }
    else {
        _discountValue = [self currencyFormat:0];
    }

    WBRBestInstallment *bestInstallment = [[WBRBestInstallment alloc] initWithDictionary:[self.dictProducts objectForKey:@"bestInstallment"] error:nil];
    [_cartFooter setCoupon:coupon withNominalDiscount:vlNominalDiscount];
    
    [_cartFooter setupWithSubtotal:subtotal itemsQty:[self countQuantitiesProducts] postalCode:postalCode freightPrice:_freightPriceLbl
        total:total valuePerInstallment:valuePerInstallment installmentQty:installmentQty bestInstallment:bestInstallment];
    [_cartFooter setNeedsLayout];
    [_cartFooter layoutIfNeeded];
    
    [self viewDidLayoutSubviews];
}

- (void)handleActiveApplicationCart:(NSNotification *)notification {
    
    [WMOmniture trackProductsinCart:_arrProducts];
    _hasTokenCheckout = NO;
    [self loadCartFromServerWithSuccessCompletion:nil];
}

- (void)handleEnteredBackgroundCart:(NSNotification *)notification {
    
    self.isFromBackground = YES;
    LogInfo(@"Close Cart from background");
}

- (void)handleResignCart:(NSNotification *)notification {
    
    [self dismissPopupShippingAndCoupom];
    
    LogInfo(@"Cart from resign");
}

#pragma mark - Dismiss popup box for Discount and Shipping Cost

- (void) dismissPopupShippingAndCoupom {
    
    if (_shippingCostViewController || _discountCouponViewController) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        self.shippingCostViewController = nil;
        self.discountCouponViewController = nil;
        [self.navigationController.view hideSmartLoading];
    }
}


#pragma mark - Load Cart

#if defined CONFIGURATION_TestWm
- (void) loadCartFromServerWithSuccessCompletion:(void(^)(void))successCompletion {
    
    [self.view endEditing:YES];
    
    //Call loadCart
    self.arrProducts = nil;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"dictCartDeliveryError"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:content];
    LogNewCheck(@"[WMConnectionNewCheckout - getCartWithGet] msgerror: %@", msgError);
    
    [self errorCheckout:msgError];
}

#else

- (void)loadCartFromServerWithSuccessCompletion:(void(^)(void))successCompletion {
    _viewEmpty.hidden = YES;
    [self.navigationController.view showSmartModalLoading];
    
    [self.view endEditing:YES];

    NSString *cartId = [[WMTokens new] getCartId] ?: @"";
    NSString *tkck = [[WMTokens new] getTokenCheckout] ?: @"";
    
    if (USE_MOCK_CART) {
        
        NSString *fileName = @"mock-cart-error";
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSString *file = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if ([fileName isEqualToString:@"mock-cart-error"]) {
            
            NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:file];
            [self errorCheckout:msgError];
            
        } else {
            [self requestStringCart:file withError:NO andSellersId:@[] andTypeError:@"" andErrorCode:@""];
        }
        
    }
    else if (cartId.length == 0 && tkck.length == 0) {
        
        //Informations not found. Empty cart
        [self dismissPopupShippingAndCoupom];
        
        [self showEmptyCart];
    }
    else {
        
        [self includeImageNavigationBar];
        
        WMTokens *tkManager = [WMTokens new];
        WMBTokenModel *tkUs = [tkManager getTokenOAuthWithoutRefreshToken];
        
        if (tkUs.accessToken.length > 0 && !_hasTokenCheckout) {
            
            [[WMTokens new] convertTokenToCheckoutWithCompletion:^{
                [self requestCart];
                self.hasTokenCheckout = YES;
                
                if (successCompletion) {
                    successCompletion();
                }
            }];
        } else {
            [self requestCart];
            
            if (successCompletion) {
                successCompletion();
            }
        }
    }
}
#endif

- (void)requestCart {
    [WBRCheckoutManager getCartWithSuccess:^(NSString *dataString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestStringCart:dataString];
        });
        
    } failure:^(NSError *error, NSString *dataString) {
        
        if (error.code == 400) {
            BOOL emptyCart = [WMBCartManager isCartEmpty:dataString];
            BOOL cartExpired = [WMBCartManager isCartExpired:dataString];
            
            if (emptyCart) {
                [self showEmptyCart];
            } else if (cartExpired) {
                [self errorCartExpired];
            } else {
                NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:dataString];
                LogNewCheck(@"[WMConnectionNewCheckout - getCartWithGet] msgerror: %@", msgError);
                
                if ([[msgError objectForKey:@"errorCode"] isEqualToString:@"DELIVERY_NOT_POSSIBLE"]) {
                    [self errorCheckout:msgError];
                }
                else if ([[msgError objectForKey:@"errorCode"] isEqualToString:@"PRODUCT_UNAVAILABLE"]) {
                    [self errorCheckout:msgError];
                }
                else if ([[msgError objectForKey:@"errorLevel"] isEqualToString:@"CART_LEVEL"]) {
                    [self errorCheckout:msgError];
                }
                else if ([[msgError objectForKey:@"errorLevel"] isEqualToString:@"ITEM_LEVEL"]) {
                    [self errorCheckout:msgError];
                }
                else {
                    [self errorConnNewCheckout:ERROR_CONNECTION_UNKNOWN];
                }
            }
        } else {
            LogErro(@"Erro [%ld]!", (long)error.code);
            [self errorConnNewCheckout:error.localizedDescription];
        }
    }];

}

#pragma mark -

- (void)includeImageNavigationBar {
    
    self.navigationItem.rightBarButtonItem = [WBRNavigationBarButtonItemFactory createBarButtonItemWithImageString:@"imgCartNavbar" andFrameRect:CGRectMake(0, 0, 49, 44)];
}

- (void) requestStringCart:(NSString *) strRequestCart {
    
    [self requestStringCart:strRequestCart withError:NO andSellersId:@[] andTypeError:@"" andErrorCode:@""];
}

- (void) requestStringCart:(NSString *) strRequestCart withError:(BOOL) error andSellersId:(NSArray *) sellers andTypeError:(NSString *) typeError andErrorCode:(NSString *) errorCode {
    
    LogInfo(@"Request New Cart: %@", strRequestCart);
    
    LogInfo(@"Type Error: %@", typeError);
    
    self.blockFinishBuy = NO;
    
    if ([typeError isEqualToString:@"CART_LEVEL"]) {
        self.blockFinishBuy = YES;
    }
    
    self.blockFinishBuyQty = NO;
    
    [WMBCartManager parseCartAndToken:strRequestCart];
    
    WMParser *ps = [[WMParser alloc] init];
    ps.delegate = self;
    [ps parseNewCart:strRequestCart withError:error andSeller:sellers andTypeError:typeError andErrorCode:errorCode];
    ps = nil;
}

- (void) parsedNewCart:(NSDictionary *) parsedCart {
    LogInfo(@"Dict Parsed Cart: %@", parsedCart);
    self.parsedCart = parsedCart;
    self.arrProducts = [parsedCart objectForKey:@"products"];
    self.loggerKey = [parsedCart objectForKey:@"loggerKey"];
    
    [[WMRetargetingConnection new] trackCheckoutOrder:parsedCart step:CheckoutStepCart];
    
    NSArray *removedGiftCards = parsedCart[@"removedGiftCards"];
    if (removedGiftCards.count > 0) {
        //Show message coupon removed
        NSString *redemptionCode = [[removedGiftCards objectAtIndex:0] objectForKey:@"redemptionCode"] ?: @"";
        [_cartFooter showMsgCouponRemoved: redemptionCode];
    }
    
    [self searchByMaxQtyBySeller:parsedCart];
    [self searchByUnavailableProducts:parsedCart];
    [self searchByRemovedProducts:parsedCart];
}


- (void) searchByUnavailableProducts:(NSDictionary *) dictProd {
    
    for (int i=0;i<(int)[_arrProducts count];i++) {
        
        NSDictionary *dictProduct = [_arrProducts objectAtIndex:i];
        BOOL unavailableProd = [[dictProduct objectForKey:@"unavailableProduct"] boolValue];
        if (unavailableProd) {
            self.blockFinishBuy = YES;
        }
    }
}

- (void) searchByMaxQtyBySeller:(NSDictionary *) dictProd {
    
    for (int i=0;i<(int)[_arrProducts count];i++) {
        
        NSDictionary *dictProduct = [_arrProducts objectAtIndex:i];
        int qtyMax = [[dictProduct objectForKey:@"currentMaxQuantityBySellerAndSku"] intValue];
        int qtyInCart = [[dictProduct objectForKey:@"quantity"] intValue];
        
        if (qtyInCart > qtyMax) {
            LogNewCheck(@"Quantity choosed unavailable");
            self.blockFinishBuyQty = YES;
        }
    }
}

- (void) searchByRemovedProducts:(NSDictionary *) dictProd {
    
    [self continueToCart:dictProd];
}

- (void) continueToCart:(NSDictionary *) parsedCart {
    
    self.dictProducts = parsedCart;
    
    LogInfo(@"Parsed Cart: %@", parsedCart);
    
    self.arrProducts = [parsedCart objectForKey:@"products"];
    
    [WMOmniture trackProductsinCart:_arrProducts];
    
    LogInfo(@"Array products [%i]: %@", (int)[_arrProducts count], _arrProducts);
    
    if (_arrProducts.count > 0) {
        
        self.view.backgroundColor = RGBA(255, 255, 255, 1);
        
        //Update cartId
        NSString *cart = [parsedCart objectForKey:@"idCart"];
        [[WMTokens new] addCartId:cart];
        
        float value = [[parsedCart objectForKey:@"totalAmountWithEstimatedBestShippingPlusGiftCardDiscountAmount"] floatValue]/100;
        
        LogNewCheck(@"Value: %f", value);
        NSString *strValue = [self currencyFormat:value];
        
        float vlNominalDiscount = [[parsedCart objectForKey:@"totalNominalDiscount"] floatValue]/100;
        if (vlNominalDiscount > 0) {
            self.discountApplyed = YES;
            self.discountValue = [self currencyFormat:vlNominalDiscount];
            LogNewCheck(@"Discount Value: %@", _discountValue);
        }
        
        _tbCart.hidden = NO;
        
        _lblTotalValue.text = strValue;
        
        [self fillContent];
        
        [self.navigationController.view hideSmartModalLoading];
        
        [_tbCart reloadData];
        [self reloadFooter];
        
        
    }
    else {
        
        [self.navigationController.view hideSmartModalLoading];
        
        [self showEmptyCart];
    }
}

- (void) showEmptyCart {

    self.view.backgroundColor = RGBA(33, 150, 243, 1);
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.view hideSmartModalLoading];
    
    [FlurryWM logEvent_cart_empty];
    
    [WMOmniture trackEmptyCart];
    
    _lblTotalValue.hidden = YES;
    _lblTotalPay.hidden = YES;
    _btPay.hidden = YES;
    _viewBottom.hidden = YES;
    _tbCart.hidden = YES;
    [self fillContent];
    
    _viewEmpty.hidden = NO;
    
    [_tbCart reloadData];
    [self reloadFooter];
}

- (int) countQuantitiesProducts {
    
    int qty = 0;
    
    for (int i=0;i<(int)[_arrProducts count];i++) {
        
        NSDictionary *dictPd = [_arrProducts objectAtIndex:i];
        int qtyPd = [[dictPd objectForKey:@"quantity"] intValue];
        qty = qty + qtyPd;
    }
    
    return qty;
}

- (void) fillContent {
    
    LogInfo(@"Arr Products qty: %@", _arrProducts);
    
    self.title = @"Meu carrinho";
    
    //// New Total Items indicator
    [self addHeaderWithTotalItems];
}

- (void) addHeaderWithTotalItems {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tbCart.frame.size.width, 20)];
    UILabel *lblView = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 20)];
    float sizeFont = 15.0f;
    UIFont * fontCustom = [UIFont fontWithName:@"Roboto-Medium" size:sizeFont];
    lblView.font = fontCustom;
    lblView.textColor = RGBA(102, 102, 102, 255);
    
    //Determine quantity
    int qtyTotal = (int) [_arrProducts count];
    if ([OFSetup extendedWarrantyEnableNewCard]) {
        qtyTotal = [self countQuantitiesProducts];
    }
    if (qtyTotal == 1) {
        lblView.text  = [NSString stringWithFormat:@"%i item", qtyTotal];
    }
    else if (qtyTotal >  1) {
        lblView.text  = [NSString stringWithFormat:@"%i itens", qtyTotal];
    }
    else {
        lblView.text  = @"";
    }
    [headerView addSubview:lblView];
    _tbCart.tableHeaderView = headerView;
}

- (void) formatFonts {
    float sizeFont = 15.0f;
    UIFont * fontCustom = [UIFont fontWithName:@"Roboto" size:sizeFont];
    _lblTotalPay.font = fontCustom;
}


#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictProdCard = [_arrProducts objectAtIndex:indexPath.row];
    
    if ([[dictProdCard objectForKey:@"priceDivergent"] boolValue] || ![[dictProdCard objectForKey:@"quantityAvailable"] boolValue] || [[dictProdCard objectForKey:@"errorRoute"] boolValue] || [[dictProdCard objectForKey:@"errorGeneralBySeller"] boolValue] || [[dictProdCard objectForKey:@"errorCartLevel"] boolValue])
    {
        self.deliveryNotPossible = YES;
    }
    
    BOOL isExtend = [[dictProdCard objectForKey:@"isExtend"] boolValue];
    if (isExtend)
    {
        static NewCartCardWarranty *warrantySizingCell = nil;
        static dispatch_once_t warrantyOnceToken;
        dispatch_once(&warrantyOnceToken, ^{
            warrantySizingCell = [_tbCart dequeueReusableCellWithIdentifier:[NewCartCardWarranty reuseIdentifier]];
        });
        
        [warrantySizingCell setCell:dictProdCard];
        
        [warrantySizingCell setNeedsLayout];
        [warrantySizingCell layoutIfNeeded];
        
        CGFloat height = [warrantySizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height;
    }
    else
    {
        static NewCartCardSimple *productSizingCell = nil;
        static dispatch_once_t productOnceToken;
        dispatch_once(&productOnceToken, ^{
            productSizingCell = [_tbCart dequeueReusableCellWithIdentifier:[NewCartCardSimple reuseIdentifier]];
        });
        
        [productSizingCell setCell:dictProdCard];
        
        [productSizingCell setNeedsLayout];
        [productSizingCell layoutIfNeeded];
        
        return [productSizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
}
 */

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [_tbCart setScrollEnabled:YES];
    
    return (int) [_arrProducts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dictProduct = [_arrProducts objectAtIndex:indexPath.row];
    NSMutableDictionary *mutDictProduct = [NSMutableDictionary dictionaryWithDictionary:dictProduct];
    [mutDictProduct setObject:_loggerKey forKey:@"loggerKey"];
    NSDictionary *dictProdCard = mutDictProduct;
    
//    NSDictionary *dictProdCard = _arrProducts[indexPath.row];
    LogInfo(@"Extended: %i", [dictProdCard[@"isExtend"] boolValue]);
    
    BOOL isExtend = [dictProdCard[@"isExtend"] boolValue];
    
    if (isExtend) {
        NewCartCardWarranty *cell = [tableView dequeueReusableCellWithIdentifier:[NewCartCardWarranty reuseIdentifier] forIndexPath:indexPath];
        [cell setDelegate:self];
//        [cell setCell:_arrProducts[indexPath.row]];
        [cell setCell:dictProdCard];
        return cell;
    }
    else {
        
        NewCartCardSimple *cell = [tableView dequeueReusableCellWithIdentifier:[NewCartCardSimple reuseIdentifier] forIndexPath:indexPath];
        [cell setDelegate:self];
//        [cell setCell:_arrProducts[indexPath.row]];
        [cell setCell:dictProdCard];
        
        return cell;
    }
}


- (void)errorConnNewCheckout:(NSString *) msgError {
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    [FlurryWM logEvent_checkout_err:@{@"screen"  :   @"NewCartViewController",
                                      @"error"   :   msgError,
                                      @"method"  :   @"errorConnNewCheckout",
                                      @"cartId"     :   ctId,
                                      @"tkCheckout" :   tkCheck}];
    
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:msgError andUserMessage:msgError andScreen:@"NewCartViewController" andFragment:@"errorConnNewCheckout:"];
    
    LogInfo(@"Error New Checkout: %@", msgError);
    [self.navigationController.view hideSmartModalLoading];
    
    [self.navigationController.view showAlertWithMessage:msgError dismissBlock:^{
        [self dismissCart];
    }];
}

- (void) errorCheckoutAuth {
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    [FlurryWM logEvent_checkout_err:@{@"screen"  :   @"NewCartViewController",
                                      @"error"   :   @"Auth",
                                      @"method"  :   @"errorCheckoutAuth",
                                      @"cartId"     :   ctId,
                                      @"tkCheckout" :   tkCheck}];
    
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:@"Auth" andUserMessage:ERROR_401_CHECKOUT andScreen:@"NewCartViewController" andFragment:@"errorCheckoutAuth"];
    
    [self.navigationController.view showAlertWithMessage:ERROR_401_CHECKOUT dismissBlock:^{
        [self dismissCart];
    }];
}

- (void) errorCartExpired {
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    [FlurryWM logEvent_checkout_err:@{@"screen"  :   @"NewCartViewController",
                                      @"error"   :   @"Cart Expired!",
                                      @"method"  :   @"errorCartExpired",
                                      @"cartId"     :   ctId,
                                      @"tkCheckout" :   tkCheck}];
    
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:@"Cart Expired" andUserMessage:ERROR_UNKNOWN_AUTH andScreen:@"NewCartViewController" andFragment:@"errorCartExpired"];
    
    LogNewCheck(@"Cart EXPIRED!");
    
    //Clean Cart
    [[MDSSqlite new] deleteAllCartId];
    [[WMTokens new] deleteTokenOAuth];
    [[MDSSqlite new] deleteAllTokenCheckout];
    
    if (!_alreadyTryCart) {
        
        [self loadCartFromServerWithSuccessCompletion:nil];
        
        self.alreadyTryCart = YES;
    }
    else {
        
        self.expiredToken = YES;
        
        [self.navigationController.view showAlertWithMessage:ERROR_UNKNOWN_AUTH dismissBlock:^{
            [self dismissCart];
        }];
    }
    
}

- (void) back
{
    [FlurryWM logEvent_cart_back_btn];
    [self dismissCart];
}

- (void)dismissCart
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Currency
- (NSString *) currencyFormat:(float) value {
    NSNumber *amount = [[NSNumber alloc] initWithFloat:value];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"R$ "];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *newFormat = [numberFormatter stringFromNumber:amount];
    return newFormat;
}

- (void) scrollToLastRow {
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:(int)[_arrProducts count]-1 inSection:0];
    
    [_tbCart scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void) scrollToFirstRow {
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [_tbCart scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - CalculateShippingForCEPProtocol Handling

- (void)showCalculateShipmentViewController
{
    LogInfo(@"Calculate shipping clicked...");
    
    self.shippingCostViewController = [[WMBCalculateShippingCostViewController alloc] init];
    self.shippingCostViewController.delegate = self;
    
    NSString *postalCode = _dictProducts[@"postalCode"];
    if (postalCode) {
        self.shippingCostViewController.currentPostalCode = postalCode;
    }
    
    [self.navigationController.view showSmartLoadingWithBackgroundColor:RGBA(33, 150, 243, 1)];
    
    [self.navigationController presentViewController:self.shippingCostViewController animated:YES completion:^{
    }];
}

- (void)didCalculateShippingFeeForCEP {
    [self loadCartFromServerWithSuccessCompletion:nil];
}

- (void)didDismissShippingCostCalculationViewController {
    [self.navigationController.view hideSmartLoading];
}

#pragma mark - DiscountCouponProtocol Handling
- (void)showAddCouponViewController {
    self.discountCouponViewController = [[WMBDiscountCouponViewController alloc] init];
    self.discountCouponViewController.delegate = self;
    
    [self.navigationController.view showSmartLoadingWithBackgroundColor:RGBA(33, 150, 243, 1)];
    
    [self.navigationController presentViewController:self.discountCouponViewController animated:YES completion:^{
    }];
}

- (void)didApplyDiscountCouponToOrder {
    [self loadCartFromServerWithSuccessCompletion:nil];
}

- (void)didDismissCouponViewController {
    [self.navigationController.view hideSmartLoading];
}

#pragma mark - UITextField Protocol Handling
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [[NSString alloc] initWithString:[textField.text stringByAppendingString:string]];
    NSInteger lenght = text.length;
    
    NSCharacterSet *acceptableCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![acceptableCharactersSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    return lenght <= 8;
}

#pragma mark - newCartCardSimpleDelegate Handling

- (void)updateProductQuantityForNewQuantity:(NSInteger)newQuantity forKeyProduct:(NSString *)keyProd sellerID:(NSString *)sellId
{
    self.keyProduct = keyProd;
    self.sellerId = sellId;
    self.latestQty = [NSString stringWithFormat:@"%ld", (long)newQuantity];
    
    [self scrollToFirstRow];
    [self updateProduct];
}

- (void) qtyPressed:(int) qty keyProduct:(NSString *) keyProd descriptionProduct:(NSString *) desc selId:(NSString *) sellId andOldQty:(NSString *)oldQt {
    LogInfo(@"Qty received in Picker: %i", qty);
    LogInfo(@"Key received from Product: %@", keyProd);
    LogInfo(@"Description received: %@", desc);
    LogInfo(@"Seller Id received: %@", sellId);
    
    self.keyProduct = keyProd;
    self.sellerId = sellId;
    self.oldQty = oldQt;
}

#pragma mark - UIPickerViewDataSource Handling

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_arrPicker count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    LogInfo(@"Select Qty: %@", [_arrPicker objectAtIndex:row]);
    
    NSString *newQuantity = [_arrPicker objectAtIndex:row];
    
    NSScanner *scanner = [NSScanner scannerWithString:newQuantity];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    
    if (isNumeric) {
        self.latestQty = newQuantity;
    } else {
        self.latestQty = @"1";
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_arrPicker objectAtIndex:row];
}

#pragma mark - Update Product

//Testar
- (void) updateQtyProduct {
    LogInfo(@"Qty New: %@", _latestQty);
    LogInfo(@"Old Qty: %@", _oldQty);
    
    if (_latestQty != NULL) {
        
        [self scrollToFirstRow];
        [self updateProduct];
    }
}

- (void) updateProduct {
    [self.navigationController.view showSmartModalLoading];
    
    //Update
    NSString *jsonUpd = [NSString stringWithFormat:@"{\
                         'items': [\
                         {\
                         'quantity': %@,\
                         'key': '%@',\
                         'sellerId': '%@'\
                         }\
                         ]\
                         }", _latestQty, _keyProduct, _sellerId];
    
    NSString *cartId = [[WMTokens new] getCartId];
    NSString *tokenId = @"";
    
    if (![[[WMTokens new] getTokenCheckout] isEqualToString:@""]) {
        
        tokenId = [[WMTokens new] getTokenCheckout];
    }
    
    //Values
    NSDictionary *dictMock = @{@"tkUpdate" :   tokenId,
                               @"cart"  :   cartId
                               };
    [self updateProductOnCart:dictMock andJsonBody:jsonUpd];
}

-(void)updateProductOnCart:(NSDictionary *)dictMock andJsonBody:(NSString *)jsonBody {
    
    [WBRCheckoutManager updateProductWithCartDict:dictMock andProductBodyJson:jsonBody success:^(NSString *dataString) {

        [self requestUpdateProduct:dataString];

    } failure:^(NSError *error, NSString *dataString) {
        if (error.code == 400) {
            BOOL cartExpired = [WMBCartManager isCartExpired:dataString];
            if (cartExpired) {
                [self errorCartExpired];
            } else {
                NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:dataString];
                if ([[msgError objectForKey:@"errorCode"] isEqualToString:@"DELIVERY_NOT_POSSIBLE"]) {
                    [self errorCheckout:msgError];
                } else if ([[msgError objectForKey:@"errorCode"] isEqualToString:@"PRODUCT_UNAVAILABLE"]) {
                    [self errorCheckout:msgError];
                } else if ([[msgError objectForKey:@"errorLevel"] isEqualToString:@"CART_LEVEL"]) {
                    [self errorCheckout:msgError];
                } else if ([[msgError objectForKey:@"errorLevel"] isEqualToString:@"ITEM_LEVEL"]) {
                    [self errorCheckout:msgError];
                } else if ([[msgError objectForKey:@"errorCode"] isEqualToString:@"CART_OVERFLOW"]) {
                    [self errorConnNewCheckout:PRODUCT_CART_OVERFLOW];
                } else {
                    [self errorConnNewCheckout:ERROR_CONNECTION_UNKNOWN];
                }
            }
        }
        else {
            LogErro(@"Erro [%ld]!", (long)error.code);
            [self errorConnNewCheckout:error.localizedDescription];
        }
    }];
}

- (void) requestUpdateProduct:(NSString *) strRequestProductUpdated {
    [self.navigationController.view hideSmartModalLoading];
    
    self.blockFinishBuyQty = NO;
    
    LogInfo(@"Update Request: %@", strRequestProductUpdated);
    [WMBCartManager parseCartAndToken:strRequestProductUpdated];
    
    WMParser *ps = [WMParser new];
    ps.delegate = self;
    [ps parseNewCart:strRequestProductUpdated withError:NO andSeller:@[] andTypeError:@"" andErrorCode:@""];
    ps = nil;
}

#pragma mark - Remove Product

- (void) keyWarranty:(NSString *) keyProd selId:(NSString *) sellId idWarr:(NSString *) idWarranty {
    [self.navigationController.view showSmartModalLoading];
    
    [self scrollToFirstRow];
    
    //Update
    NSString *jsonUpd = [NSString stringWithFormat:@"{\
                         'items': [\
                         {\
                         'removeServices':[\
                         %@ \
                         ],\
                         'key': '%@',\
                         'sellerId': '%@'\
                         }\
                         ]\
                         }", idWarranty, keyProd, sellId];
    
    NSString *cartId = [[WMTokens new] getCartId];
    NSString *tokenId = @"";
    
    if (![[[WMTokens new] getTokenCheckout] isEqualToString:@""]) {
        
        tokenId = [[WMTokens new] getTokenCheckout];
    }
    
    //Values
    NSDictionary *dictMock = @{@"tkRemove" :   tokenId,
                               @"cart"  :   cartId
                               };
    
    [self updateProductOnCart:dictMock andJsonBody:jsonUpd];
}

#pragma mark - Remove Product

- (void) keyProduct:(NSString *) keyProd selId:(NSString *) sellId prodId:(NSString *)prodId {
    [self.navigationController.view showSmartModalLoading];
    
    [self scrollToFirstRow];
    
    //Update
    NSString *jsonUpd = [NSString stringWithFormat:@"{\
                         'items': [\
                         {\
                         'key': '%@',\
                         'sellerId': '%@'\
                         }\
                         ]\
                         }", keyProd, sellId];
    
    NSString *cartId = [[WMTokens new] getCartId];
    NSString *tokenId = @"";
    
    if (![[[WMTokens new] getTokenCheckout] isEqualToString:@""]) {
        
        tokenId = [[WMTokens new] getTokenCheckout];
    }

    NSDictionary *dictMock = @{@"tkRemove" :  tokenId,
                               @"cart" : cartId,
                               @"productId" : prodId
                               };
    
    [WBRCheckoutManager removeProductWithCartDict:dictMock andProductBodyJson:jsonUpd success:^(NSString *dataString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestRemoveProduct:dataString];
        });

    } failure:^(NSError *error, NSString *dataString) {
       
        if (error.code == 400) {
            
            BOOL cartExpired = [WMBCartManager isCartExpired:dataString];
            
            if (cartExpired) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self errorCartExpired];
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:dataString];
                    if ([[msgError objectForKey:@"errorCode"] isEqualToString:@"DELIVERY_NOT_POSSIBLE"]) {
                        [self errorCheckout:msgError];
                    } else if ([[msgError objectForKey:@"errorCode"] isEqualToString:@"PRODUCT_UNAVAILABLE"]) {
                        [self errorCheckout:msgError];
                    } else if ([[msgError objectForKey:@"errorLevel"] isEqualToString:@"CART_LEVEL"]) {
                        [self errorCheckout:msgError];
                    } else if ([[msgError objectForKey:@"errorLevel"] isEqualToString:@"ITEM_LEVEL"]) {
                        [self errorCheckout:msgError];
                    } else {
                        [self errorConnNewCheckout:ERROR_CONNECTION_UNKNOWN];
                    }
                });
            }
        } else {
            LogErro(@"Erro [%ld]!", (long)error.code);
            [self errorConnNewCheckout:error.localizedDescription];
        }
    }];
}

- (void) requestRemoveProduct:(NSString *) strRequestProductRemoved {
    [self.navigationController.view hideSmartModalLoading];
    
    LogInfo(@"Remove Request: %@", strRequestProductRemoved);
    
    [WMBCartManager parseCartAndToken:strRequestProductRemoved];
    
    self.discountApplyed = NO;
    self.discountValue = @"0";
    
    [self loadCartFromServerWithSuccessCompletion:nil];
}

- (void) reloadCart {
    LogNewCheck(@"reload cart!");
    [_tbCart reloadData];
    [self reloadFooter];
}

#pragma mark - Buy Order

- (void)buyOrder
{
    [FlurryWM logEvent_cart_order_done_btn];
    if (_isBuying) return;
    if (!_blockFinishBuy && !_blockFinishBuyQty) {
        
        self.isBuying = YES;
        
        //Call loadCart again
        //[self loadCartFromServer];
        
        [[WMTokens new] getTokenOAuth:^(NSString *token)
         {
             NSString *tkUs = token;
             NSDictionary *dictAuthStatus = [self authData];
             LogNewCheck(@"[NewCartViewController - buyOrder] Status Auth: %@", dictAuthStatus);
             NSString *tkCk = [dictAuthStatus objectForKey:@"tkCk"];
             NSString *cartId = [dictAuthStatus objectForKey:@"cart"];
             BOOL hasDocument = [[dictAuthStatus objectForKey:@"hasDocument"] boolValue];
             BOOL hasPhone = [[dictAuthStatus objectForKey:@"hasPhone"] boolValue];
             
             LogNewCheck(@"[NewCartViewController - buyOrder] Tkus           : %@", tkUs);
             LogNewCheck(@"[NewCartViewController - buyOrder] TkCk           : %@", tkCk);
             LogNewCheck(@"[NewCartViewController - buyOrder] CartId         : %@", cartId);
             LogNewCheck(@"[NewCartViewController - buyOrder] hasDocument    : %i", hasDocument);
             LogNewCheck(@"[NewCartViewController - buyOrder] hasPhone       : %i", hasPhone);
             
             if (!tkUs || [tkUs isEqualToString:@""] || [tkCk isEqualToString:@""])
             {
                 self.showLoginScreen = YES;
                 self.isBuying = NO;
                 [self loadLoginScreenFromCart];
             }
             else if (!self->_isFacebook && (!hasDocument || !hasPhone))
             {
                 //Show complement screen
                 LogNewCheck(@"Show screen complement");
                 self.pdc = [[PersonalDataComplementViewController alloc] initWithPersonalDataDict:dictAuthStatus.copy delegate:self];
                 [self.navigationController pushViewController:self->_pdc animated:YES];
             }
             else
             {
                 [self.navigationController.view showSmartModalLoading];
                 self.showLoginScreen = NO;
                 self.shipAdd = [OFShipAddressViewController new];
                 self->_shipAdd.delegate = self;
                 [self.navigationController pushViewController:self->_shipAdd animated:YES];
             }
         }];
    }
    else
    {
        LogNewCheck(@"Block Finish Buy!");
        NSString *strMsg = @"";
        if (_blockFinishBuy) {
            strMsg = PRODUCT_NOT_AVAILABLE;
        }
        else if (_blockFinishBuyQty) {
            strMsg = ERROR_QUANTITY_AVAILABLE;
        }
        [self.navigationController.view showAlertWithMessage:strMsg];
    }
}

- (void) closeShipAddressToCart {
    
    [self.shipAdd.view removeFromSuperview];
    self.shipAdd = nil;
    
    [self registerForKeyboardEvents];
    [self loadCartFromServerWithSuccessCompletion:nil];
}

- (void) closeShipAddressFromSuccess {
    
    [self.shipAdd.view removeFromSuperview];
    self.shipAdd = nil;
    
    [[WALMenuViewController singleton] dismissBackToRootViewController];
}

- (void) loadLoginScreenFromCart
{
    [self presentLoginWithLoginSuccessBlock:^{
        LogInfo(@"Login success New Cart...");
        //First, call loadCart, because this user can have a discount
        [self registerForKeyboardEvents];
        [self loadCartFromServerWithSuccessCompletion:^{
            [self buyOrder];
        }];
    }];
}

- (void) loginWithFacebook:(NSNotification *)notification {
    
    _isFacebook = YES;
    [self registerForKeyboardEvents];
    [self loadCartFromServerWithSuccessCompletion:^{
        [self buyOrder];
    }];
}

- (void)successFromComplement {
    //First, call loadCart, because this user can have a discount
    
    [self buyOrder];
}

- (void) closeShipAddress {
    
    [UIView animateWithDuration:.3 animations:^{
        self->_shipAdd.view.frame = CGRectMake(320, 0, self->_shipAdd.view.frame.size.width, self->_shipAdd.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self->_shipAdd.view removeFromSuperview];
            self.shipAdd = nil;
            [self registerForKeyboardEvents];
        }
    }];
}

- (void)requestAddProduct:(NSString *)strRequestAddProduct andCk:(NSString *)cookConn {
    
    LogNewCheck(@"[NewCartViewController - requestAddProduct] Response AddProduct: %@", strRequestAddProduct);
    LogNewCheck(@"[NewCartViewController - requestAddProduct] Cookie Product: %@", cookConn);
    
    [WMBCartManager parseCartAndToken:strRequestAddProduct];
}

- (void) continueShopping {
    LogInfo(@"Continue Shopping");
    [FlurryWM logEvent_cart_more_products_btn];
    [[WALMenuViewController singleton] dismissBackToRootViewController];
}

#pragma mark - errors

- (void) errorCheckout:(NSDictionary *) dictError {
    
    LogNewCheck(@"Error checkout: %@", dictError);
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    NSString *errorCode = @"";
    if ([dictError objectForKey:@"errorCode"]) {
        errorCode = [dictError objectForKey:@"errorCode"];
    }
    
    NSNumber *responseCode = ([dictError valueForKey:@"responseCode"]) ?: @0;
    
    [FlurryWM logEvent_checkout_err:@{@"response_code"  :   responseCode,
                                      @"error"          :   dictError,
                                      @"screen"         :   @"NewCartViewController",
                                      @"cartId"         :   ctId,
                                      @"method"         :   @"errorCheckout",
                                      @"tkCheckout"     :   tkCheck,
                                      @"errorCode"      :   errorCode
                                      }];
    
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:[dictError valueForKey:@"responseCode"] ?: @"" andResponseData:[dictError description] ?: @"" andUserMessage:@"" andScreen:@"NewCartViewController" andFragment:@"errorCheckout:"];
    
    NSString *strJson = [WMBCartManager dictionaryToJson:[dictError objectForKey:@"cart"]];
    
    if ([dictError objectForKey:@"errorLevel"]) {
        [self requestStringCart:strJson withError:YES andSellersId:@[[dictError objectForKey:@"sellerId"]] andTypeError:[dictError objectForKey:@"errorLevel"] andErrorCode:errorCode];
    } else {
        [self requestStringCart:strJson withError:YES andSellersId:@[[dictError objectForKey:@"sellerId"]] andTypeError:@"" andErrorCode:errorCode];
    }
    
    LogNewCheck(@"Str Json: %@", strJson);
    
    [self.navigationController.view hideSmartModalLoading];
}

#pragma mark - NewCartCardSimple delegate

- (void)showSellerDescriptionWithSellerId:(NSString *)sellerID {
    WMWebViewController *sellerDescription = [[WMWebViewController alloc] initWithURLStr:[[OFUrls new] getURLSellerDescriptionWithSellerId:sellerID] title:@"Detalhes"];
    WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:sellerDescription];
    [self presentViewController:container animated:YES completion:nil];
}

#pragma mark - NewCartOthersDelegate
- (void)cartOthersCellPressedSubmitCouponWithRedemptionCode:(NSString *)redemptionCode {
    if (redemptionCode.length == 0) {
        [self.navigationController.view showAlertWithMessage:COUPON_SUBMIT_FAILURE];
        return;
    }
    
    [self.navigationController.view showSmartModalLoading];
    
    [CartConnection submitCouponWithRedemptionCode:redemptionCode successBlock:^(NSDictionary *cart, NSDictionary *errorDict) {
        NSData *cartData = [NSJSONSerialization dataWithJSONObject:cart options:0 error:NULL];
        NSString *cartString = [[NSString alloc] initWithData:cartData encoding:NSUTF8StringEncoding];
        NSArray *sellersIds = errorDict[@"sellerId"] ? @[errorDict[@"sellerId"]] : @[];
        
        NSString *feedbackAlertMessage;
        FeedbackAlertKind feedbackAlertKind = SuccessAlert;
        
        NSString *warningMessage = @"";
        
        // If one of these keys exist, the user tried to add a coupon through updateCart service.
        NSNumber *newCouponAdded = cart[@"newCouponAdded"] ?: cart[@"newGiftCardAdded"];
        if (newCouponAdded) {
            NSArray *voucherStatus = cart[@"voucherStatus"];
            if (voucherStatus.count > 0 && [voucherStatus[0] isEqualToString:@"COUPON_ALLOWED_ONLY_FOR_WALMART"]) {
                warningMessage = COUPON_ALLOWED_ONLY_FOR_WALMART;
            }
            else {
                BOOL submittedCouponSuccess = [newCouponAdded boolValue];
                
                feedbackAlertKind = submittedCouponSuccess ? SuccessAlert : ErrorAlert;
                feedbackAlertMessage = submittedCouponSuccess ? COUPON_SUBMIT_SUCCESS : COUPON_SUBMIT_FAILURE;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            WMParser *ps = [WMParser new];
            ps.delegate = self;
            [ps parseNewCart:cartString withError:errorDict != nil andSeller:sellersIds andTypeError:errorDict[@"errorLevel"] andErrorCode:errorDict[@"errorCode"]];
            ps = nil;
            
            //_cartFooter.couponSubmitView.redemptionCode = @"";
            //_cartFooter.couponSubmitView.warningMessage = warningMessage;
            
            if (feedbackAlertMessage.length > 0) {
                [self.view showFeedbackAlertOfKind:feedbackAlertKind message:feedbackAlertMessage];
            }
            
            [self reloadFooter];
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController.view hideSmartModalLoading];
            [self.navigationController.view showAlertWithMessage:error.localizedDescription];
        });
    }];
    
}

- (void)removeCouponWithRedemptionCode:(NSString *)redemptionCode {
    [self.navigationController.view showSmartModalLoading];
    
    [CartConnection removeCouponWithRedemptionCode:redemptionCode successBlock:^(NSDictionary *cart, NSDictionary *errorDict) {
        NSArray *giftCards = cart[@"giftCards"];
        
        NSData *cartData = [NSJSONSerialization dataWithJSONObject:cart options:0 error:NULL];
        NSString *cartString = [[NSString alloc] initWithData:cartData encoding:NSUTF8StringEncoding];
        NSArray *sellersIds = errorDict[@"sellerId"] ? @[errorDict[@"sellerId"]] : @[];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            WMParser *ps = [WMParser new];
            ps.delegate = self;
            [ps parseNewCart:cartString withError:errorDict != nil andSeller:sellersIds andTypeError:errorDict[@"errorLevel"] andErrorCode:errorDict[@"errorCode"]];
            ps = nil;
            
            if (giftCards.count > 0) {
                [self.view showFeedbackAlertOfKind:ErrorAlert message:COUPON_REMOVE_FAILURE];
            }
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController.view hideSmartModalLoading];
            [self.navigationController.view showAlertWithMessage:error.localizedDescription];
        });
    }];
}

#pragma mark - Keyboard Handle
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    UIEdgeInsets tableViewContentInset = _tbCart.contentInset;
    tableViewContentInset.bottom = keyboardHeight;
    [_tbCart setContentInset:tableViewContentInset];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets tableViewContentInset = _tbCart.contentInset;
    tableViewContentInset.bottom = 0.0f;
    [_tbCart setContentInset:tableViewContentInset];
}

- (void)registerForKeyboardEvents
{
    if ([OFSetup backgroundEnable])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleActiveApplicationCart:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnteredBackgroundCart:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResignCart:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardEvents
{
    if ([OFSetup backgroundEnable])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)tappedView:(id)sender {
    [self.view endEditing:YES];
}

@end
