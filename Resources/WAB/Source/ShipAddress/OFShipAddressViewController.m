//
//  OFShipAddressViewController.m
//  Ofertas
//
//  Created by Marcelo Santos on 9/21/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFShipAddressViewController.h"
#import "WMParser.h"
#import "OFSkinInfo.h"
#import "OFUrls.h"
#import "WMConnectionNewCheckout.h"
#import "OFInfoTemp.h"
#import "ShippingDeliveries.h"
#import "WMOmniture.h"
#import "ShipAddressCell.h"
#import "MyAddressesConnection.h"

#define timeAnimation 0.35f

@interface OFShipAddressViewController () <UITableViewDataSource, UITableViewDelegate, ShipAddressCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//Labels
@property (weak, nonatomic) IBOutlet UILabel *lblProdShipment;
@property (weak, nonatomic) IBOutlet UILabel *lblNew;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@property (assign, nonatomic) int cellRemove;
@property (assign, nonatomic) BOOL isRemove;

@property (weak, nonatomic) IBOutlet UILabel *lblOps;
@property (weak, nonatomic) IBOutlet UILabel *lblMsgOps;
@property (weak, nonatomic) IBOutlet UIView *viewNoAddresses;

@property (strong, nonatomic) WMConnectionAddress *connectionAddress;

@property (strong, nonatomic) NSString *cellId;
@property (strong, nonatomic) NSString *addressId;


@property (nonatomic, strong) NSMutableArray *addresses;
@property (nonatomic, strong) NSNumber *cardsCount;
@property (nonatomic, weak) IBOutlet UIButton *buttonNewAddress;

@end

@implementation OFShipAddressViewController

- (instancetype)init {
    self = [super initWithTitle:@"Endereço" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setAddAddressButtonLayout];
    [FlurryWM logEvent_checkout_select_delivery_entering];
    
    [WMOmniture trackAddressListInCheckout];
    
    //Font custom
    float sizeFont = 11.0f;
    UIFont *fontCustom = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    _lblNew.font = fontCustom;
    
    sizeFont = 15.0f;
    UIFont *fontSemiBold = [UIFont fontWithName:@"OpenSans-Semibold" size:sizeFont];
    _lblProdShipment.font = fontSemiBold;
    
    sizeFont = 11.0f;
    fontSemiBold = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    _lblNew.font = fontSemiBold;
    
    sizeFont = 13.0f;
    UIFont *fontBold = [UIFont fontWithName:@"OpenSans-Bold" size:sizeFont];
    _lblAddress.font = fontBold;
    
    //Ship Address
    sizeFont = 25.0f;
    fontCustom = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    _lblOps.font = fontCustom;
    
    sizeFont = 12.0f;
    fontCustom = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    _lblMsgOps.font = fontCustom;
    
    OFMessages *msg = [[OFMessages alloc] init];
    _lblMsgOps.text = [msg errorNoShipAdd];

    [self getJsonFromServer];
    
    if ([OFSetup backgroundEnable]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleEnteredBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    self.connectionAddress = [WMConnectionAddress new];
    _connectionAddress.delegate = self;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShipAddressCell class]) bundle:nil] forCellReuseIdentifier:[ShipAddressCell reuseIdentifier]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setTableHeaderView:_headerView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (void)setAddresses:(NSMutableArray *)addresses {
    _addresses = addresses;
    
    [_tableView reloadData];
    _viewNoAddresses.hidden = addresses.count > 0;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShipAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:[ShipAddressCell reuseIdentifier] forIndexPath:indexPath];
    [cell setupWithAddressDict:_addresses[indexPath.row]];
    [cell setDelegate:self];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static ShipAddressCell *sizingCell = nil;
    static dispatch_once_t sizinceCellOnceToken;
    dispatch_once(&sizinceCellOnceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:[ShipAddressCell reuseIdentifier]];
    });
    
    [sizingCell setupWithAddressDict:_addresses[indexPath.row]];
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    return [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

#pragma mark - NSNotification
- (void)handleEnteredBackground:(NSNotification *)notification
{
    LogInfo(@"Background ofshipaddress");
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - Connection
- (void) getJsonFromServer
{
    [self.view showLoading];
    WMConnectionNewCheckout *wm = [[WMConnectionNewCheckout alloc] init];
    wm.delegate = self;
    [wm listAddress];
    wm = nil;
}

- (void) requestListAddress:(NSString *) strListAddress
{
    LogNewCheck(@"List Address response: %@", strListAddress);
    
    //Fix Json List Address
    strListAddress = [NSString stringWithFormat:@"{\"addresses\":%@}", strListAddress];
    
    self.strAllAddress = strListAddress;
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
        LogErro(@"Json Content Shipment is null");
    }
}

- (void)dictShipmentAddressList:(NSArray *)addresses
{
    self.addresses = addresses.mutableCopy;
    [self.view hideLoading];
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
    
    [self.view hideLoading];
    
    [self.navigationController.view showAlertWithMessage:msgError dismissBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)errorTokenExpired
{
    [self.view hideLoading];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self delegate] loadLoginScreenFromCart];
    });
}

- (void)errorConnNewCheckout:(NSString *) msgError
{
    LogInfo(@"Error New Checkout List Address: %@", msgError);
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    [FlurryWM logEvent_checkout_err:@{@"screen"  :   @"OFShipAddressViewController",
                                      @"error"   :   msgError,
                                      @"method"  :   @"errorConnNewCheckout",
                                      @"cartId"     :   ctId,
                                      @"tkCheckout" :   tkCheck}];
    
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:msgError andUserMessage:@"" andScreen:@"OFShipAddressViewController" andFragment:@"errorConnNewCheckout:"];
    
    [self.view hideLoading];
    
    [self.navigationController.view showAlertWithMessage:msgError dismissBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)checkForEmpty
{
    if (self.addresses.count > 0)
    {
        _viewNoAddresses.hidden = YES;
    }
    else
    {
        _viewNoAddresses.hidden = NO;
    }
}

- (void)deleteAddressWithAddressDict:(NSDictionary *)addressDict {
    [self.view showLoading];
    [[MyAddressesConnection new] deleteAddressWithAddressId:addressDict[@"id"] completionBlock:^{
        [self.view hideLoading];
        [_addresses removeObject:addressDict];
        [_tableView reloadData];
        
    } failure:^(NSString *error) {
        [self.view hideLoading];
        [self.navigationController.view showAlertWithMessage:error];
    }];
}

#pragma mark - ShipAddressCellDelegate
- (void)shipAddressCellPressedEdit:(ShipAddressCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSDictionary *dictShipment = _addresses[indexPath.row];
    
    OFAddressViewController *addressController = [[OFAddressViewController alloc] initWithOperation:@"editAddress" dictAddress:dictShipment delegate:self];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:addressController];
    [self.navigationController presentViewController:navigation animated:YES completion:nil];
}

- (void)shipAddressCellPressedDelete:(ShipAddressCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSDictionary *dictShipment = _addresses[indexPath.row];
    
    [self.view showPopupWithTitle:GREETING_OPS message:MSG_DELETE_ADDRESS cancelButtonTitle:CANCEL_BUTTON cancelBlock:nil actionButtonTitle:EXCLUDE_BUTTON actionBlock:^{
        [self deleteAddressWithAddressDict:dictShipment];
    }];
}

- (void)shipAddressCellSelected:(ShipAddressCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSDictionary *dictShipment = _addresses[indexPath.row];
    
    LogInfo(@"Choose this address: %@", dictShipment);
    
    //Make a dictionary with personal data
    NSString *refname = [dictShipment objectForKey:@"receiverName"];
    NSString *street = [dictShipment objectForKey:@"street"];
    NSString *number = [dictShipment objectForKey:@"number"];
    NSString *complement = [dictShipment objectForKey:@"complement"];
    NSString *address = [NSString stringWithFormat:@"%@, %@, %@", street, number, complement];
    if ([complement isEqualToString:@""]) {
        address = [NSString stringWithFormat:@"%@, %@", street, number];
    }
    NSString *neighbor = [dictShipment objectForKey:@"neighborhood"];
    NSString *city = [dictShipment objectForKey:@"city"];
    NSString *state = [dictShipment objectForKey:@"state"];
    NSString *addressComplement = [NSString stringWithFormat:@"%@ - %@, %@", neighbor, city, state];
    if ([neighbor isEqualToString:@""]) {
        addressComplement = [NSString stringWithFormat:@"%@, %@", city, state];
    }
    NSString *zipCode = [dictShipment objectForKey:@"postalCode"];
    NSString *refPoint = [dictShipment objectForKey:@"referencePoint"];
    NSString *idAddress = [dictShipment objectForKey:@"id"];
    
    [FlurryWM logEvent_checkout_shipping_select_address:state];
    
    LogNewCheck(@"Dict Address Shipment: %@", dictShipment);
    
    NSDictionary *dictAddress = [[NSDictionary alloc] initWithObjectsAndKeys:refname, @"receiverName", address, @"address", addressComplement, @"addressComplement", zipCode, @"zipCode", refPoint, @"refPoint", idAddress, @"id", nil];
    
    LogNewCheck(@"Shipment data: %@", dictAddress);
    
    LogInfo(@"Id address: %@", [dictAddress objectForKey:@"id"]);
    
    self.shopt = [[ShipmentOptions alloc] initWithNibName:@"ShipmentOptions" bundle:nil andDictAddress:dictAddress];
    _shopt.delegate = self;
    _shopt.view.frame = CGRectMake(320, 0, _shopt.view.frame.size.width, self.navigationController.view.bounds.size.height);
    [self.navigationController.view addSubview:_shopt.view];
    
    [UIView animateWithDuration:timeAnimation animations:^{
        CGRect frame = _shopt.view.frame;
        frame.origin.x = 0.0f;
        _shopt.view.frame = frame;
    } completion:nil];
}

- (void)closeShipOptionsToCart
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)closeShipOptionsFromSuccess
{
}

- (void) closeShipOptions
{
    [UIView animateWithDuration:timeAnimation animations:^{
        _shopt.view.frame = CGRectMake(320, 0, _shopt.view.frame.size.width, _shopt.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self.shopt.view removeFromSuperview];
            self.shopt = nil;
        }
    }];
}

- (void)closeShipOptionsAndGoBackToCart
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) requestSelectOptions:(NSString *) strSelectOptions {
    
    LogInfo(@"Select Options: %@", strSelectOptions);
    
    BOOL testPayment = NO;
    
    if (testPayment) {
        
        [self testPayment1];
        [self testPayment2];
    } else {
        [self testPayment2];
    }
}

- (void) testPayment2 {
    
    NSString *strJson = @"{\
    \"items\":[\
    ],\
    \"selectedDeliveries\":[\
    {\
    \"deliveryWindow\":{\
    \"price\": 174,\
    \"period\":\"MORNING\",\
    \"startDateUtc\": 1403856000000,\
    \"endDateUtc\": 1403870400000\
    },\
    \"itemsKeys\":[\
    \"2ipnubi0v0dcx0qo3rt7bnbkp\",\
    \"13srcskhj96cj30wzakx9stpq\",\
    \"bhsh4a69c49rmiq9htg7m9aor\"\
    ],\
    \"deliveryTypeId\":\"5\",\
    \"sellerId\":\"1\",\
    \"price\":174\
    }\
    ],\
    \"giftCard\":null\
    }";
    
    NSDictionary *dictOptions = @{@"delivery"  :   strJson};
    
    WMConnectionNewCheckout *conn = [WMConnectionNewCheckout new];
    [conn paymentWithCart:dictOptions];
    conn.delegate = self;

}

- (void) testPayment1 {
    
    WMConnectionNewCheckout *conn = [WMConnectionNewCheckout new];
    [conn paymentWithoutCart];
    conn.delegate = self;
}

- (void) requestPaymentWithoutCart:(NSString *) strPaymentWithoutCart {
    
    LogInfo(@"Request Payment w/o cart: %@", strPaymentWithoutCart);
}
- (void) requestPaymentWithCart:(NSString *) strPaymentWithCart {
    
    LogInfo(@"Request Payment with cart (ship): %@", strPaymentWithCart);
}

- (void) errorCheckout:(NSDictionary *) dictError {
    
    LogNewCheck(@"Error ShipAddress: %@", dictError);
    
    NSString *ctId = [[WMTokens new] getCartId];
    NSString *tkCheck = [[WMTokens new] getTokenCheckout];
    
    NSNumber *responseCode = ([dictError valueForKey:@"responseCode"]) ?: @0 ;
    
    [FlurryWM logEvent_checkout_err:@{@"response_code"  :   responseCode,
                                      @"error"          :   dictError,
                                      @"screen"         :   @"OFShipAddressViewController",
                                      @"cartId"         :   ctId,
                                      @"tkCheckout"     :   tkCheck,
                                      @"method"         :   @"errorCheckout" }];
   
    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CHECKOUT_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:[dictError valueForKey:@"responseCode"] ?: @"" andResponseData:[dictError description] ?: @"" andUserMessage:@"" andScreen:@"OFShipAddressViewController" andFragment:@"errorCheckout:"];
    
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

- (void) closeShipOptionsFromConfirmation {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) gotoCart
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)deleteAddress:(NSError *)error {
    [self.navigationController.view showAlertWithMessage:error.localizedDescription];
}

- (void) newAddress {
    
    [FlurryWM logEvent_checkoutNewAddressAddEditBtn];
    [FlurryWM logEvent_checkout_shipping_new_address];
    
    NSDictionary *dictTemp = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"nil", nil];
    
    self.oa = [[OFAddressViewController alloc] initWithOperation:@"addAddress" dictAddress:dictTemp delegate:self];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:_oa];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - OFAddressViewControllerDelegate
- (void)addressViewController:(OFAddressViewController *)addressViewcontroller updatedAddress:(NSDictionary *)addressDict {
    [addressViewcontroller dismissViewControllerAnimated:YES completion:^{
        [self getJsonFromServer];
    }];
}

- (void)addressViewController:(OFAddressViewController *)addressViewController addedNewAddress:(NSDictionary *)addressDict
{
    [addressViewController dismissViewControllerAnimated:YES completion:^{
        [self getJsonFromServer];
    }];
}

- (void)setAddAddressButtonLayout
{
    CGRect rect = CGRectMake(0, 0, self.buttonNewAddress.frame.size.width, self.buttonNewAddress.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    NSArray *cgColorsNormal = @[(id)RGBA(255, 255, 255, 1).CGColor, (id)RGBA(238, 238, 238, 1).CGColor];
    NSArray *cgColorsPressed = @[(id)RGBA(238, 238, 238, 1).CGColor, (id)RGBA(255, 255, 255, 1).CGColor];
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(0, rect.size.height);
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)cgColorsNormal, NULL);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)cgColorsPressed, NULL);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    UIImage *imagePressed = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean memory & End context
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    UIGraphicsEndImageContext();
    
    [self.buttonNewAddress setBackgroundImage:image forState:UIControlStateNormal];
    [self.buttonNewAddress setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
    
    self.buttonNewAddress.layer.cornerRadius = 3;
    self.buttonNewAddress.layer.borderWidth = 1.0f;
    self.buttonNewAddress.layer.borderColor = RGBA(221, 221, 221, 1).CGColor;
    self.buttonNewAddress.layer.masksToBounds = YES;
}

@end
