//
//  ShipmentOptions.m
//  Ofertas
//
//  Created by Marcelo Santos on 10/8/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "ShipmentOptions.h"
#import <QuartzCore/QuartzCore.h>
#import "OFShipmentTemp.h"
#import "OFAddressTemp.h"
#import "OFShippingsTemp.h"
#import "OFUrls.h"
#import "OFCartTemp.h"
#import "UIImage+Additions.h"
#import "ShippingDeliveries.h"
#import "NewShipmentCard.h"
#import "WMRetargetingConnection.h"
#import "UIView+Loading.h"

#import "WBRPaymentViewController.h"
#import "WMOmniture.h"
#import "WMParser.h"

#import "WMBaseNavigationController.h"
#import "WMWebViewController.h"

#import "NSNumber+Currency.h"

#import "ShippingCell.h"
#import "ShipAddressCell.h"

#import "OFAddressViewController.h"
#import "WBRNavigationBarButtonItemFactory.h"
#import "WBRShipment.h"
#import "WBRCheckoutManager.h"

#define timeAnimation 0.35f

@interface ShipmentOptions () <NewShipmentCardDelegate, pay2Delegate, UITableViewDelegate, UITableViewDataSource, ShippingCellDelegate, ShipAddressCellDelegate, addressAddDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *lblChoose;


@property (strong, nonatomic) NSDictionary *dictAddress;
@property (strong, nonatomic) NSDictionary *fullAddress;

@property (assign, nonatomic) float sizeOfCard;
@property (strong, nonatomic) UIView *viewTemp;

@property (nonatomic, retain) NSMutableArray *deliveryOptionsCards;
@property (nonatomic, strong) NSDictionary *deliveriesInfo;
@property (nonatomic, strong) SeparatePaymentAlertViewController *separatePaymentAlert;
@property (nonatomic, strong) WBRPaymentViewController *wp;
@property BOOL isExtendedWarranty;

@property (strong, nonatomic) ShippingDeliveries *shippingDeliveries;

@end

@implementation ShipmentOptions

- (ShipmentOptions *)initWithDictAddress:(NSDictionary *)addressDict fullAddress:(NSDictionary *)fullAdress delegate:(id <shipOptionsDelegate>)delegate
{
    self = [super initWithTitle:@"Quando receber?" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO];
    if (self) {
        _delegate = delegate;
        _dictAddress = addressDict;
        _fullAddress = fullAdress;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [WMOmniture trackDeliveryTypeInCheckout];
    
    self.navigationItem.rightBarButtonItem = [WBRNavigationBarButtonItemFactory createBarButtonItemWithImageString:@"imgCartShipNavbar" andFrameRect:CGRectMake(0, 0, 104, 44)];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShippingCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShippingCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShipAddressCell class]) bundle:nil] forCellReuseIdentifier:[ShipAddressCell reuseIdentifier]];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 162;

    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setTableHeaderView:_headerView];
    
    [self loadShipmentOptions];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self applyShadowViewBottom];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([OFSetup backgroundEnable]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleEnteredBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
}

- (void)handleEnteredBackground:(NSNotification *)notification {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)setShippingDeliveries:(ShippingDeliveries *)shippingDeliveries {
    _shippingDeliveries = shippingDeliveries;
    
    NSString *deliveryTypeName = [self.fullAddress objectForKey:@"type"];
    [WMOmniture trackDeliveryTypeNames:deliveryTypeName andDeliveryCount:self.shippingDeliveries.deliveries.count];
    [_tableView reloadData];
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

#pragma mark - Connection
- (void)loadShipmentOptions {
    [[OFShipmentTemp new] assignShipmentDictionary:_dictAddress];
    
    [WBRCheckoutManager getDeliveryOptions:[self.dictAddress objectForKey:@"id"] successBlock:^(NSString *dataString) {

        [self requestSelectOptions:dataString];

    } failure:^(NSError *error, NSString *dataString) {
        if (error.code == 401) {
            LogErro(@"401 received! Token expired Shipment Options! :(");
            [self errorCheckoutAuth];
        } else if (error.code == 400) {
            LogErro(@"400!");
            NSDictionary *msgError = [WMBCartManager getErrorCodeMsg:dataString];
            [self errorCheckout:msgError];
        } else {
            LogErro(@"Erro [%ld]!", (long)error.code);
            [self errorConnNewCheckout:error.localizedDescription];
        }
    }];
}

- (void)requestSelectOptions:(NSString *)strSelectOptions {
    [self.navigationController.view hideSmartLoading];
    [self verifyIfExtendedWarrantyInCart:strSelectOptions];
    
    NSError *parserError = nil;
    ShippingDeliveries *shippingInformation = [[ShippingDeliveries alloc] initWithString:strSelectOptions error:&parserError];

    if (!parserError)
    {
        [[OFShipmentTemp new] assignDeliveries:shippingInformation.deliveries];
        self.shippingDeliveries = shippingInformation;
        [[WMRetargetingConnection new] trackCheckoutOrder:@{@"ShippingDeliveries" : shippingInformation} step:CheckoutStepAddress];
    }
    else
    {
        [self errorConnectionShippings:[[OFMessages new] errorParserShippingOptions]];
    }
}

#pragma mark - Address Connection
- (void) getJsonFromServer {
    [WBRCheckoutManager getAddressList:^(NSString *dataString) {
        [self requestListAddress:dataString];
    } failure:^(NSError *error, NSString *dataString) {
        if (error.code == 401) {
            LogErro(@"401 received! Token expired!");
            [self errorTokenExpired];
        } else {
            LogErro(@"Erro [%ld]!", (long)error.code);
            [self errorConnNewCheckout:error.localizedDescription];
        }
    }];
}

- (void) requestListAddress:(NSString *) strListAddress
{
    LogNewCheck(@"List Address response: %@", strListAddress);
    
    //Fix Json List Address
    strListAddress = [NSString stringWithFormat:@"{\"addresses\":%@}", strListAddress];
    
    LogNewCheck(@"Str All Request: %@", strListAddress);
    
    if (strListAddress != NULL)
    {
        //Parse Splash
        WMParser *pa = [[WMParser alloc] init];
        pa.delegate = self;
        [pa parseJsonShipment:strListAddress];
    }
    else
    {
        [self.navigationController.view hideSmartLoading];
        LogErro(@"Json Content Shipment is null");
    }
}

- (void)dictShipmentAddressList:(NSArray *)addresses {
    [self.navigationController.view hideSmartLoading];
    if (addresses.count > 0) {
        for (NSDictionary *address in addresses) {
            if ([self.fullAddress[@"id"] isEqualToString:address[@"id"]]) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.fullAddress = address;
                    [self->_tableView reloadData];
                    [self.view showFeedbackAlertOfKind:SuccessAlert message:ADDRESS_SUCCESS_UPDATE];
                }];
                break;
            }
        }
    }
    else {
        [self.navigationController.view showAlertWithMessage:UPDATE_ADDRESS_ERROR dismissBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
        LogErro(@"Json Address Content is null");
    }
}

- (void)errorConnection:(NSString *)msgError
{
    LogInfo(@"Error retrieving Ship Address: %@", msgError);
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    [FlurryWM logEvent_checkout_err:@{@"screen"  :   @"OFShipAddressViewController",
                                      @"error"   :   msgError,
                                      @"method"  :   @"errorConnection",
                                      @"cartId"     :   ctId,
                                      @"tkCheckout" :   tkCheck}];
    
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:msgError andUserMessage:msgError andScreen:@"OFShipAddressViewController" andFragment:@"errorConnection:"];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.navigationController.view hideSmartLoading];
        [self.navigationController.view showAlertWithMessage:msgError dismissBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shippingDeliveries.deliveries.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Test for first Row to add AdreessCardCell
    if (indexPath.row == 0) {
//        UITableViewCell *headerCell = [[UITableViewCell alloc] init];
        ShipAddressCell *headerCell = [self.tableView dequeueReusableCellWithIdentifier:[ShipAddressCell reuseIdentifier]];
        [headerCell setupWithAddressDict:self.fullAddress enableEditControls:TRUE];
        headerCell.delegate = self;
        return headerCell;
    } else {
        ShippingCell *cell = [_tableView dequeueReusableCellWithIdentifier:[ShippingCell reuseIdentifier] forIndexPath:indexPath];
        [cell setDeliveryIndex:indexPath.row-1 total:_shippingDeliveries.deliveries.count];
        [cell setShippingDelivery:_shippingDeliveries.deliveries[indexPath.row-1]];
        [cell setDelegate:self];
        return cell;
    }
}

#pragma mark - ShipAddressCellDelegate
- (void)shipAddressCellPressedEdit:(ShipAddressCell *)cell {
    NSDictionary *dictShipment = _fullAddress;
    
    OFAddressViewController *addressController = [[OFAddressViewController alloc] initWithOperation:@"editAddress" dictAddress:dictShipment delegate:self];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:addressController];
    [self.navigationController presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - OFAddressViewControllerDelegate
- (void)addressViewController:(OFAddressViewController *)addressViewcontroller updatedAddress:(NSDictionary *)addressDict {
    [addressViewcontroller dismissViewControllerAnimated:YES completion:^{
        [self.navigationController.view showModalLoading];
        [self getJsonFromServer];
    }];
}

- (void)closeAddAddressController:(OFAddressViewController *)addressViewController {
    [addressViewController dismissViewControllerAnimated:YES completion:^{
        [self.navigationController.view hideSmartLoading];
    }];
}

#pragma mark - ShippingCellDelegate
- (void)shippingCellTappedSellerLabel:(ShippingCell *)shippingCell {
    NSInteger shippingCellIndexPath = [_tableView indexPathForCell:shippingCell].row - 1;
    if (shippingCellIndexPath < _shippingDeliveries.deliveries.count) {
        ShippingDelivery *delivery = _shippingDeliveries.deliveries[shippingCellIndexPath];
        NSString *sellerId = delivery.sellerId;
        if (sellerId.length > 0) {
            WMWebViewController *sellerDescription = [[WMWebViewController alloc] initWithURLStr:[[OFUrls new] getURLSellerDescriptionWithSellerId:sellerId] title:@"Detalhes"];
            WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:sellerDescription];
            [self presentViewController:container animated:YES completion:nil];
        }
    }
}

- (void)shippingCellPressedScheduledDeliveryButton:(ShippingCell *)shippingCell {
    NSInteger shippingCellIndexPath = [self.tableView indexPathForCell:shippingCell].row -1;
    if (shippingCellIndexPath < self.shippingDeliveries.deliveries.count) {
        ShippingDelivery *delivery = self.shippingDeliveries.deliveries[shippingCellIndexPath];
        DeliveryType *scheduleDelivery = [delivery scheduledDelivery];
        if (scheduleDelivery) {
            ScheduleDeliveryDateViewController *scheduleDeliveryViewController = [[ScheduleDeliveryDateViewController alloc] initWithDeliveryType:scheduleDelivery delegate:shippingCell];
            
            __weak typeof(self) weakSelf = self;
            scheduleDeliveryViewController.kDidEnterBackgroundNotification = ^{
                [weakSelf handleEnteredBackground:nil];
            };
            
            WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:scheduleDeliveryViewController];

            [self.navigationController presentViewController:navigation animated:YES completion:nil];
        }
    }
}

- (void)shippingCellPressedDeleteDeliveryButton:(ShippingCell *)shippingCell {
    
    WBRShipmentOptionsDeletePopupView *shipmentDeletePopup = [[WBRShipmentOptionsDeletePopupView alloc] initWithShippingIndexText:shippingCell.deliveryIndexLabel.text AndCartItems:shippingCell.shippingDelivery.cartItems];
    shipmentDeletePopup.delegate = self;
    
    [self.navigationController.view showSmartLoadingWithBackgroundColor:RGBA(33, 150, 243, 1)];
    [self.navigationController presentViewController:shipmentDeletePopup animated:YES completion:nil];
}

#pragma mark - ShipmentOptionDeleteDelegate 

- (void)didDeleteShipmentOption:(NSArray<CartItem> *)cartItems {
    [self deleteShipping:cartItems];
}

- (void)didDismissShipmentOptionDeletePopup {
    [self.navigationController.view hideSmartLoading];
}

- (NSArray<CartItem> *)getCartItemsToRemoveFrom:(NSArray<CartItem> *)cartItems {
    
    NSMutableArray<CartItem> *items = [[NSMutableArray<CartItem> alloc] init];
    
    for (CartItem *item in cartItems) {
        
        NSString *key = item.key;
        NSString *sellerId = item.sellerId;
        NSNumber *quantity = @0;
        
        [items addObject:[[CartItem alloc] initWithItemKey:key quantity:quantity sellerId:sellerId]];
    }
    
    return items;
}

- (void)deleteShipping:(NSArray<CartItem> *)cartItems {
    
    [self.navigationController.view showModalLoading];
    
    NSArray<CartItem> *items = [self getCartItemsToRemoveFrom:cartItems];
    ModelCheckoutDelivery *delivery = [[ModelCheckoutDelivery alloc] initWithItemsToDelete:items];
    
    WBRShipment *shipmentHub = [[WBRShipment alloc] init];
    [shipmentHub deleteShipment:delivery success:^{
        [self loadShipmentOptions];
    } failure:^(NSError *error, NSData *data) {
        [self.navigationController.view showFeedbackAlertOfKind:WarningAlert message:[[[OFMessages alloc] init] errorConnectionShippings]];
        [self.navigationController.view hideSmartModalLoading];
    }];
}


- (void)verifyIfExtendedWarrantyInCart:(NSString *) strContent {
    
    self.isExtendedWarranty = NO;
    
    NSError *error = nil;
    NSData *jsonData = [strContent dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    //Separating Products Info
    NSDictionary *dictCart = [jsonObjects valueForKey:@"cart"];
    NSArray *itemsProducts = [dictCart objectForKey:@"items"];
    
    for (int i=0;i<(int)[itemsProducts count];i++) {
        
        NSDictionary *dictItems = [itemsProducts objectAtIndex:i];
        
        //First, verify if this is a warranty extended
        if ([[dictItems objectForKey:@"service"] boolValue]) {
            self.isExtendedWarranty = YES;
        }
    }
}

- (void)errorCheckout:(NSDictionary *) dictError {
    
    LogNewCheck(@"Error ShipmentOptions: %@", dictError);
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    NSNumber *errorCode = ([dictError valueForKey:@"responseCode"]) ? [dictError valueForKey:@"responseCode"] : @0 ;
    
    [FlurryWM logEvent_checkout_err:@{@"response_error" : errorCode,
                                      @"screen"  :   @"ShipmentOptions",
                                      @"error"   :   dictError,
                                      @"method"  :   @"errorCheckout",
                                      @"cartId"     :   ctId,
                                      @"tkCheckout" :   tkCheck}];

    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:[dictError description] ?: @"" andUserMessage:@"" andScreen:@"ShipmentOptions" andFragment:@"errorCheckout:"];
    
    if ([dictError objectForKey:@"errorId"]) {
        
        NSString *errorCode = [dictError objectForKey:@"errorId"];

        //Yes, we have a code id
        NSString *msgError = [[OFMessages new] getMsgCheckout:errorCode];
        LogNewCheck(@"Error Shipment Options to user: %@", msgError);
        
        [self errorConnNewCheckout:msgError];
    }
    else if ([dictError objectForKey:@"errorMessage"]) {
        
        NSString *errorCode = [dictError objectForKey:@"errorMessage"];
        
        //Yes, we have an error code
        if ([errorCode isEqualToString:@"PREAUTH"]) {
            NSString *msgError = [[OFMessages new] getMsgCheckout:errorCode];
            LogNewCheck(@"Error Shipment Options to user: %@", msgError);
            
            [self errorConnNewCheckout:msgError];
        }
        else {
            [self errorConnNewCheckout:ERROR_CONNECTION_UNKNOWN];
        }
    }
    else {
        
        [self errorConnNewCheckout:ERROR_CONNECTION_UNKNOWN];
    }
}

- (void) errorTokenExpired {
    [self.navigationController.view hideSmartLoading];
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    [FlurryWM logEvent_checkout_err:@{@"screen"  :   @"ShipmentOptions",
                                      @"method"  :   @"errorTokenExpired",
                                      @"cartId"     :   ctId,
                                      @"tkCheckout" :   tkCheck}];
    
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:@"" andUserMessage:@"" andScreen:@"ShipmentOptions" andFragment:@"errorTokenExpired:"];
}

- (void)errorConnNewCheckout:(NSString *)msgError
{
    [self errorConnectionShippings:msgError];
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    [FlurryWM logEvent_checkout_err:@{@"screen"  :   @"ShipmentOptions",
                                      @"error"   :   msgError,
                                      @"method"  :   @"errorConnNewCheckout",
                                      @"cartId"     :   ctId,
                                      @"tkCheckout" :   tkCheck}];
    
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:msgError andUserMessage:@"" andScreen:@"ShipmentOptions" andFragment:@"errorConnNewCheckout:"];
}

#pragma - Scheduled delivery options
- (void)shipOptionsForDeliveryItemView:(DeliveryItemView *)deliveryItemView
{
    [[OFShippingsTemp new] setDeliveryType:deliveryItemView];
    self.shipbox = [[ShipmentBoxViewController alloc] initWithNibName:@"ShipmentBoxViewController" bundle:nil];
    _shipbox.delegate = self;
    [self.view addSubview:_shipbox.view];
}

- (void)loadSinglePaymentScreenWithHasExtendedWarranty:(BOOL)hasExtendedWarranty {
    self.wp = [[WBRPaymentViewController alloc] init];
    _wp.delegate = self;
    _wp.isSinglePaymentAndHasExtendedWarranty = hasExtendedWarranty;
    _wp.deliveries = self.deliveriesInfo;
    _wp.fullAddress = _fullAddress;
    [self.navigationController pushViewController:_wp animated:YES];
    
    //[_wp fillContentWithDeliveries:self.deliveriesInfo];
    //[self.view addSubview:_wp.view];
    //[self animateViewFromRightToLeft:_wp.view completion:nil];
}

- (void) simplePayment
{
    [_wp.view removeFromSuperview];
    self.wp = nil;
    
    self.wp = [[WBRPaymentViewController alloc] init];
    _wp.delegate = self;
    _wp.splitedPayment = _isExtendedWarranty;
    _wp.deliveries = self.deliveriesInfo;
    _wp.fullAddress = _fullAddress;
    [self.navigationController pushViewController:_wp animated:YES];
    
    //[_wp fillContentWithDeliveries:self.deliveriesInfo];
    //[self.view addSubview:_wp.view];
}

- (void)animateViewFromRightToLeft:(UIView *)view completion:(void (^)(void))finishBlock {
    view.frame = CGRectMake(self.view.frame.size.width, 0, view.frame.size.width, view.frame.size.height);
    
    float height = [WMDeviceType heightDevice];
    if ([WMDeviceType isOS6]) {
        height = height - 20;
    }
    
    [UIView animateWithDuration:.3 animations:^{
        view.frame = CGRectMake(0, 0, view.frame.size.width, height);
    } completion:^(BOOL finished) {
        if (finishBlock) {
            finishBlock();
        }
    }];
}

- (void) errorCheckoutAuth
{
    [[WMTokens new] deleteTokenOAuth];
    [[MDSSqlite new] deleteAllTokenCheckout];
    
    [self errorConnNewCheckout:ERROR_401_CHECKOUT];
}

- (void) closePaymentToCart {
    [_wp.view removeFromSuperview];
    self.wp = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) closePaymentFromSuccess {
    [_wp.view removeFromSuperview];
    self.wp = nil;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) closePayment {
    [self.navigationController.view hideSmartLoading];
    [UIView animateWithDuration:.3 animations:^{
        self->_wp.view.frame = CGRectMake(320, 0, self->_wp.view.frame.size.width, self->_wp.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self->_wp.view removeFromSuperview];
            self.wp = nil;
        }
    }];
}

- (void) closePaymentAndComeBack
{
    [_wp.view removeFromSuperview];
    self.wp = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)testInternet:(BOOL) sucess msg:(NSString *) msgInternetConnectionOk {
    [self.navigationController.view hideSmartLoading];
    [self.view showAlertWithMessage:msgInternetConnectionOk];
}

- (void)errorConnectionShippings:(NSString *) msgError {
    
    [self.navigationController.view hideSmartLoading];
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    [FlurryWM logEvent_checkout_err:@{@"screen"  :   @"ShipmentOptions",
                                      @"error"   :   msgError,
                                      @"method"  :   @"errorConnectionShippings",
                                      @"cartId"     :   ctId,
                                      @"tkCheckout" :   tkCheck}];
    
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:msgError andUserMessage:@"" andScreen:@"ShipmentOptions" andFragment:@"errorConnectionShippings:"];
    
    LogErro(@"Error call simulate shippings: %@", msgError);
    
    [self.navigationController.view showAlertWithMessage:msgError dismissBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - SeparatePaymentAlertViewController
- (void)chooseSinglePayment {
    //Tapped Yes in the pop-up
    //load payment screen with 1 card
    [self loadSinglePaymentScreenWithHasExtendedWarranty:YES];
}

- (void)chooseSeparatePayment
{
    self.wp = [[WBRPaymentViewController alloc] init];
    _wp.delegate = self;
    _wp.deliveries = self.deliveriesInfo;
    _wp.fullAddress = _fullAddress;
    _wp.splitedPayment = YES;
    [self.navigationController pushViewController:_wp animated:YES];
}

- (void)showWarrantyLicense
{
    ExtendedWarrantyLicenseViewController *warrantyLicense = [ExtendedWarrantyLicenseViewController new];
    
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:warrantyLicense];
    [self.navigationController presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - IBAction
- (IBAction)changeAddressPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continuePressed
{
    NSString *customDeliveryInformation = @"";
    
    for (ShippingDelivery *shippingDelivery in _shippingDeliveries.deliveries) {
        if (!shippingDelivery.selectedDelivery) {
            [self.navigationController.view showAlertWithMessage:SHIPMENT_DATE_OPTIONS];
            return;
        }
        else {
            if ([shippingDelivery.selectedDelivery isScheduledShipping] && shippingDelivery.selectedDelivery.selectedScheduledDeliveryPeriod == nil) {
                [self.navigationController.view showAlertWithMessage:SHIPMENT_DATE_SCHEDULE];
                return;
            }
        }
    }
    
    LogInfo(@"All deliveries options selected, we can continue to the payment");
    NSMutableArray *mutableDeliveries = [NSMutableArray new];
    double shipmentsTotalPrice = 0;
    BOOL isConcierge;

    for (ShippingDelivery *delivery in _shippingDeliveries.deliveries)
    {
        NSDictionary *currentShipment = delivery.selectedDeliveryDictionary;
        if (currentShipment)
        {
            [mutableDeliveries addObject:currentShipment];
            NSNumber *price = [currentShipment objectForKey:@"price"];
            shipmentsTotalPrice += price.doubleValue;
            if ([delivery.selectedDelivery isScheduledShipping])
            {
                customDeliveryInformation = delivery.selectedDelivery.selectedScheduledDeliveryFormattedString;
            }
            else
            {
                customDeliveryInformation = [delivery.selectedDelivery shippingEstimate];
            }
            
            isConcierge = [delivery.selectedDelivery isConcierge];
        }
    }
    
    self.deliveriesInfo = @{@"items" : @[],
                            @"selectedDeliveries" : mutableDeliveries.copy,
                            @"shipmentsTotalPrice" : [NSNumber numberWithDouble:shipmentsTotalPrice],
                            @"customDeliveryInformation" : customDeliveryInformation ?: @"",
                            @"isConcierge" : @(isConcierge)};
    
    LogInfo(@"DeliveriesInfo: %@", self.deliveriesInfo);
    LogInfo(@"Mutable deliveries: %@", mutableDeliveries);
    
    //Flurry
    NSArray *arrDeliveries = mutableDeliveries;
    //Get only 1st element
    if ((int) [arrDeliveries count] > 0) {
        for (int i=0;i<(int) [arrDeliveries count];i++) {
            
            NSDictionary *deliveryDict = [arrDeliveries objectAtIndex:i];
            
            if ([deliveryDict objectForKey:@"name"]) {
                
                NSString *nameDelivery = [NSString stringWithFormat:@"Entrega %i: %@", i, [deliveryDict objectForKey:@"name"]];
                LogInfo(@"Name Delivery: %@", nameDelivery);
                
                [FlurryWM logEvent_checkout_shipping_next_stepWithType:nameDelivery];
            }
        }
    }
    
    LogInfo(@"Extended Warranty? %i", _isExtendedWarranty);
    
    if (_isExtendedWarranty) {
        //Double Payment
        self.separatePaymentAlert = [[SeparatePaymentAlertViewController alloc] initWithNibName:@"SeparatePaymentAlertViewController" bundle:nil];
        self.separatePaymentAlert.delegate = self;
        self.separatePaymentAlert.view.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
        [self.navigationController.view addSubview:self.separatePaymentAlert.view];
    }
    else {
        [self loadSinglePaymentScreenWithHasExtendedWarranty:NO];
    }
}

@end
