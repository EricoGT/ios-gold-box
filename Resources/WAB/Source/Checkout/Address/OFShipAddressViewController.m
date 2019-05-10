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
#import "ShippingDeliveries.h"
#import "WMOmniture.h"
#import "ShipAddressCell.h"
#import "MyAddressesConnection.h"
#import "WMBaseNavigationController.h"
#import "WBRNavigationBarButtonItemFactory.h"
#import "WBRCheckoutManager.h"

#define timeAnimation 0.35f

@interface OFShipAddressViewController () <UITableViewDataSource, UITableViewDelegate, ShipAddressCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (assign, nonatomic) BOOL checkSingleAddressAndContinue;
@property (assign, nonatomic) BOOL checkCameFromAddressFormAndNoAddressStored;

@property (strong, nonatomic) NSString *lastEditedAddressId;

@property (nonatomic, strong) NSMutableArray *addresses;
@property (nonatomic, strong) NSNumber *cardsCount;
@property (nonatomic, weak) IBOutlet UIButton *buttonNewAddress;
@property (weak, nonatomic) IBOutlet WMButtonRounded *continueButton;

@property (strong, nonatomic) NSIndexPath *previouslySelectedAddressIndex;

@end


static CGFloat const DisabledElementAlphaValue = 0.5f;
static CGFloat const EnabledElementAlphaValue = 1.0f;

@implementation OFShipAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [FlurryWM logEvent_checkout_select_delivery_entering];
    
    [WMOmniture trackAddressListInCheckout];
    
    [self customizeNavigationBar];
    
    self.checkSingleAddressAndContinue = NO;
    self.checkCameFromAddressFormAndNoAddressStored = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShipAddressCell class]) bundle:nil] forCellReuseIdentifier:[ShipAddressCell reuseIdentifier]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setTableHeaderView:_headerView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 162;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self applyShadowViewBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.tableView.indexPathForSelectedRow) {
        self.previouslySelectedAddressIndex = self.tableView.indexPathForSelectedRow;
    }
    
    [self registerNotifications];
    
    [self setContinueButtonEnabled:NO];
    
    if (!self.checkCameFromAddressFormAndNoAddressStored) {
        [self getJsonFromServer];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeNotifications];
}

- (void)customizeNavigationBar {
    
    self.navigationItem.rightBarButtonItem = [WBRNavigationBarButtonItemFactory createBarButtonItemWithImageString:@"imgCartAddressNavbar" andFrameRect:CGRectMake(0, 0, 62, 44)];
    
    self.title = @"Onde receber?";
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0f]}];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setContinueButtonEnabled:YES];
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
    [cell setupWithAddressDict:_addresses[indexPath.row] enableEditControls:TRUE];
    [cell setDelegate:self];
    return cell;
}

#pragma mark - NSNotification
- (void)handleEnteredBackground:(NSNotification *)notification
{
    LogInfo(@"Background ofshipaddress");
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)handleActiveApplicationCart:(NSNotification *)notification
{
    LogInfo(@"Background active ofshipaddress");
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - Connection
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

- (void)dictShipmentAddressList:(NSArray *)addresses {
    
    NSDictionary *oldAddresses = self.addresses.mutableCopy;
    self.addresses = addresses.mutableCopy;
    
    if (self.addresses.count > 0) {
        [_tableView reloadData];
        if (self.previouslySelectedAddressIndex) {
            [_tableView selectRowAtIndexPath:self.previouslySelectedAddressIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self setContinueButtonEnabled:YES];
        }
        else {
            
            __block NSUInteger defaultAddressPosition;
            __block BOOL hasDefaultAddress = NO;
            [self.addresses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *currentObject = (NSDictionary *)obj;
                BOOL isDefault = (BOOL) currentObject[@"default"];
                
                if (isDefault) {
                    defaultAddressPosition = idx;
                    hasDefaultAddress = YES;
                    *stop = YES;
                }
            }];
            
            if (hasDefaultAddress) {
                NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:defaultAddressPosition inSection:0];
                [self.tableView selectRowAtIndexPath:defaultIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self setContinueButtonEnabled:YES];
            }
        }
        
        //Added first address and should automatically continue to next step
        if (self.checkSingleAddressAndContinue) {
            
            [self.navigationController.view showModalLoading];
            
            NSInteger lastObjectIndex = 0;
            BOOL isNewAddress = false;
            
            for (NSDictionary* address in self.addresses) {
                isNewAddress = true;
                
                for (NSDictionary *oldAddress in oldAddresses) {
                    if ([oldAddress[@"id"] isEqualToString:address[@"id"]]) {
                        isNewAddress = false;
                    }
                }
                
                if (isNewAddress) {
                    lastObjectIndex = [addresses indexOfObject:address];
                    break;
                }
            }
            
            [self.navigationController.view hideModalLoading];
            [self gatherAddressInformationAndContinueForIndexPath:lastObjectIndex];
        }
        else {
            [self setSelectedEditedAddress];
            [self.navigationController.view hideSmartLoading];
        }
    }
    else {
        [self addNewAddress];
    }
}

- (void)errorTokenExpired
{
    [self.navigationController.view hideSmartLoading];
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
    
    [self.navigationController.view hideSmartLoading];
    
    [self.navigationController.view showAlertWithMessage:msgError dismissBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
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

- (void) gotoCart
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)newAddressAction:(id)sender {
    [self addNewAddress];
}

- (void)addNewAddress {
    
    [FlurryWM logEvent_checkoutNewAddressAddEditBtn];
    [FlurryWM logEvent_checkout_shipping_new_address];
    
    NSDictionary *dictTemp = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"nil", nil];
    
    self.oa = [[OFAddressViewController alloc] initWithOperation:@"addAddress" dictAddress:dictTemp delegate:self];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:_oa];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)setSelectedEditedAddress {
    for (NSInteger row = 0; row < self.addresses.count; row++) {
        if (self.addresses[row][@"id"] && [self.addresses[row][@"id"] isEqualToString: self.lastEditedAddressId]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
}

#pragma mark - OFAddressViewControllerDelegate
- (void)addressViewController:(OFAddressViewController *)addressViewcontroller updatedAddress:(NSDictionary *)addressDict {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.lastEditedAddressId = [addressViewcontroller getAddressId];
        self.checkSingleAddressAndContinue = NO;
    }];
    [addressViewcontroller dismissViewControllerAnimated:YES completion:^{
        [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:ADDRESS_SUCCESS_UPDATE];
    }];
}

- (void)addressViewController:(OFAddressViewController *)addressViewController addedNewAddress:(NSDictionary *)addressDict
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.checkSingleAddressAndContinue = YES;
    }];
    
    [addressViewController dismissViewControllerAnimated:YES completion:^{
        [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:ADDRESS_SUCCESS_ADD];
    }];
}

- (void)closeAddAddressController:(OFAddressViewController *)addressViewController {
    if (self.addresses.count > 0) {
        [addressViewController dismissViewControllerAnimated:YES completion:^{
            [self.navigationController.view hideSmartLoading];
        }];
    } else {
        self.checkCameFromAddressFormAndNoAddressStored = YES;
        [addressViewController dismissViewControllerAnimated:NO completion:^{
            [self.navigationController.view hideSmartLoading];
            [self gotoCart];
        }];
    }
}

#pragma mark - Setup Methods

- (void)registerNotifications {
    if ([OFSetup backgroundEnable]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleEnteredBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleActiveApplicationCart:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
}

- (void)removeNotifications {
    
    if ([OFSetup backgroundEnable]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    }
}

- (void)setContinueButtonEnabled:(BOOL)enabled {
    
    //If we are disabling, even before the animation is finished, the button should already be disabled
    if (!enabled) {
        [self.continueButton setUserInteractionEnabled:NO];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        if (enabled) {
            self.continueButton.alpha = EnabledElementAlphaValue;
        }
        else {
            self.continueButton.alpha = DisabledElementAlphaValue;
        }
    } completion:^(BOOL finished) {
        //If we are enabling the button, it should only be enabled after the animation finishes
        if (enabled) {
            [self.continueButton setUserInteractionEnabled:YES];
        }
    }];
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

#pragma mark - Continue Action
- (IBAction)continueAction:(id)sender {
    
    [self.navigationController.view showSmartModalLoading];
    
    if (self.tableView.indexPathForSelectedRow) {
        [self gatherAddressInformationAndContinueForIndexPath:self.tableView.indexPathForSelectedRow.row];
    }
}

- (void)gatherAddressInformationAndContinueForIndexPath:(NSInteger)index {
    
    self.checkSingleAddressAndContinue = NO;
    NSDictionary *dictShipment = self.addresses[index];
    
    LogInfo(@"Choose this address: %@", dictShipment);
    
    //Make a dictionary with personal data
    NSString *refname = [dictShipment objectForKey:@"receiverName"];
    NSString *street = [dictShipment objectForKey:@"street"];
    NSString *number = [dictShipment objectForKey:@"number"];
    NSString *complement = [dictShipment objectForKey:@"complement"];
    NSString *address = [NSString stringWithFormat:@"%@, %@ - %@", street, number, complement];
    if ([complement isEqualToString:@""]) {
        address = [NSString stringWithFormat:@"%@, %@", street, number];
    }
    NSString *neighborhood = [dictShipment objectForKey:@"neighborhood"];
    NSString *city = [dictShipment objectForKey:@"city"];
    NSString *state = [dictShipment objectForKey:@"state"];
    NSString *addressComplement = [NSString stringWithFormat:@"%@ - %@ - %@", neighborhood, city, state];
    if ([neighborhood isEqualToString:@""]) {
        addressComplement = [NSString stringWithFormat:@"%@, %@", city, state];
    }
    NSString *zipCode = [dictShipment objectForKey:@"postalCode"];
    NSString *refPoint = [dictShipment objectForKey:@"referencePoint"];
    NSString *addressDescription = [dictShipment objectForKey:@"description"];
    NSString *idAddress = [dictShipment objectForKey:@"id"];
    
    [FlurryWM logEvent_checkout_shipping_select_address:state];
    
    LogNewCheck(@"Dict Address Shipment: %@", dictShipment);
    
    NSDictionary *dictAddress = [[NSDictionary alloc] initWithObjectsAndKeys:refname, @"receiverName", address, @"address", addressComplement, @"addressComplement", zipCode, @"zipCode", refPoint, @"refPoint", idAddress, @"id", addressDescription, @"description", nil];
    LogNewCheck(@"Shipment data: %@", dictAddress);
    LogInfo(@"Id address: %@", [dictAddress objectForKey:@"id"]);
    
    ShipmentOptions *shipmentOptions = [[ShipmentOptions alloc] initWithDictAddress:dictAddress fullAddress:dictShipment delegate:self];
    [self.navigationController pushViewController:shipmentOptions animated:YES];
}


@end
