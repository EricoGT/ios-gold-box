//
//  WMMyAccountViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 4/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMMyAccountViewController.h"
#import "UserSession.h"
#import "UIImage+Additions.h"
#import "TrackingConnection.h"
#import "OFMessages.h"
#import "WMDeviceType.h"
#import "TrackingEntity.h"
#import "WMButton.h"
#import "OrdersViewController.h"
#import "Order.h"
#import "WMButtonRounded.h"
#import "OrdersDetailViewController.h"
#import "SHPOrdersTableViewCell.h"
#import "SHPMenuTableViewCell.h"
#import "PersonalDataViewController.h"
#import "FeedbackAlertView.h"
#import "MyAddressesTableViewController.h"
#import "ExtendedWarrantyListViewController.h"
#import "WALMenuViewController.h"
#import "ModelServices.h"
#import "WMBaseNavigationController.h"
#import "WALTouchIDManager.h"
#import "WALHomeCache.h"
#import "WALFavoritesCache.h"
#import "User.h"
#import "WBRFacebookLoginManager.h"
#import "WBRUser.h"
#import "WBRCreditCardsViewController.h"
#import "WBRContactTicketViewController.h"

#import "WBRUserManager.h"

#define MARGIN 15
static NSString *orderCellIdentifier = @"SHPOrdersCell";
static NSString *menuCellIdentifier = @"SHPMenuCell";
static CGFloat menuBaseHeight = 394;
static CGFloat menuItemHeight = 44;

@interface WMMyAccountViewController () <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, personalDataDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIView *cardView;
@property (nonatomic, weak) IBOutlet UIView *ordersHeaderView;

@property (nonatomic, weak) IBOutlet UITableView *ordersTableView;
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;

@property (nonatomic, weak) IBOutlet UIView *errorView;
@property (nonatomic, weak) IBOutlet UILabel *errorMessageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *errorImageView;
@property (nonatomic, weak) IBOutlet WMButtonRounded *retryButton;
@property (nonatomic, weak) IBOutlet WMButtonRounded *startBuyingButton;

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *logoutButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *ordersActivityIndicator;

@property (nonatomic, strong) OrdersViewController *ordersViewController;
@property (nonatomic, strong) OFMessages *messages;

@property (nonatomic, strong) TrackingEntity *tracking;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, strong) NSArray *singleOrderArray;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) BOOL ordersEnabled;

@property (nonatomic, strong) ExtendedWarrantyListViewController *extendedWarrantiesScreen;
@property (nonatomic, strong) MyAddressesTableViewController *myAddressesScreen;
@property (nonatomic, strong) PersonalDataViewController *personalDataScreen;
@property (nonatomic, strong) WBRCreditCardsViewController *creditCardScreen;
@property (nonatomic, strong) WBRContactTicketViewController *contactTicketsViewController;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *errorViewVerticalSpacing;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *ordersTableVerticalSpacing;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *cardViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

- (IBAction)logout:(id)sender;
- (IBAction)retryOrders;

@end

@implementation WMMyAccountViewController

- (WMMyAccountViewController *)init {
    self = [super initWithTitle:@"Minha conta" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLogoutNotification) name:@"LogoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLogoutLocalNotification) name:@"LocalLogoutNotification" object:nil];
    
    //First, fill with default image
    //    self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
    
    //verify if there is a Facebook image
    [self performSelector:@selector(updateImageFromFacebook) withObject:nil afterDelay:0.5];
    
    [super viewWillAppear:animated];
}

- (void) updateImageFromFacebook {
    
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 50;
    _userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImageView.layer.borderWidth = 2;
    
    User *user = [User sharedUser];
    if ([user.social objectForKey:@"id"]) {
        NSString *strSocialSnId = [user.social objectForKey:@"id"];

        [WBRFacebookLoginManager getImageFacebook:strSocialSnId completionBlock:^(NSString *profilePictureUrl) {
            [self setImage: profilePictureUrl];
        } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
            self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
        }];

    } else {
        self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LogoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LocalLogoutNotification" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WMOmniture trackSelfHelpHomeEnter];
    
    [self setLayout];
    [self setupTableViews];
    [self setup];
    [self run];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkOrderPushNotification];
}

- (void)viewDidLayoutSubviews
{
    //There's no need to layout scroll view frame ou content size according to device size/type
    //UI was lovely made with auto layout, so everythings works like magic :-)
    
    //Adding a simple margin in the bottom
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, MARGIN, 0.0);
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark - Setups
- (void)setup
{
    self.messages = [OFMessages new];
    self.title = [self.messages myAccountTitle];
    
    self.ordersEnabled = YES;
    self.ordersTableView.hidden = YES;
    self.errorView.hidden = YES;
    self.ordersActivityIndicator.hidden = NO;
    self.errorView.hidden = YES;
    [self showOrdersHeaderView:NO];
    
    self.topViewHeight.constant = menuBaseHeight;
    NSMutableArray *menuItems = [NSMutableArray new];
    
    SHPMenuItem *menuItem1 = [[SHPMenuItem alloc] initWithName:@"Pedidos"
                                                          icon:[UIImage imageNamed:@"ic_pedidos"]
                                                  selectedIcon:[UIImage imageNamed:@"ic_pedidos"]];
    [menuItems addObject:menuItem1];
    
    if ([WALMenuViewController singleton].services.showTickets.boolValue) {
        SHPMenuItem *menuItem2 = [[SHPMenuItem alloc] initWithName:@"Histórico de atendimento"
                                                              icon:[UIImage imageNamed:@"ic_atendimento"]
                                                      selectedIcon:[UIImage imageNamed:@"ic_atendimento"]];
        [menuItems addObject:menuItem2];
        self.topViewHeight.constant += menuItemHeight;
    }
    
    SHPMenuItem *menuItem3 = [[SHPMenuItem alloc] initWithName:@"Dados pessoais"
                                                          icon:[UIImage imageNamed:@"ic_dadospessoais"]
                                                  selectedIcon:[UIImage imageNamed:@"ic_dadospessoais"]];
    [menuItems addObject:menuItem3];
    
    SHPMenuItem *menuItem4 = [[SHPMenuItem alloc] initWithName:@"Endereços"
                                                          icon:[UIImage imageNamed:@"ic_enderecos"]
                                                  selectedIcon:[UIImage imageNamed:@"ic_enderecos"]];
    [menuItems addObject:menuItem4];
    
    SHPMenuItem *menuItem5 = [[SHPMenuItem alloc] initWithName:@"Cartões"
                                                          icon:[UIImage imageNamed:@"ic_cartoes"]
                                                  selectedIcon:[UIImage imageNamed:@"ic_cartoes"]];
    [menuItems addObject:menuItem5];
    
    if ([WALMenuViewController singleton].services.showWarranties.boolValue) {
        SHPMenuItem *menuItem6 = [[SHPMenuItem alloc] initWithName:@"Garantia estendida"
                                                              icon:[UIImage imageNamed:@"ico_warranty"]
                                                      selectedIcon:[UIImage imageNamed:@"ico_warranty_pressed"]];
        [menuItems addObject:menuItem6];
        self.topViewHeight.constant += menuItemHeight;
    }
    
    SHPMenuItem *menuItem7 = [[SHPMenuItem alloc] initWithName:@"Sair"
                                                          icon:[UIImage imageNamed:@"ico_logout"]
                                                  selectedIcon:[UIImage imageNamed:@"ico_logout_pressed"]];
    [menuItems addObject:menuItem7];
    
    self.menuItems = [menuItems copy];
}

- (void)setupTableViews
{
    self.menuTableView.scrollEnabled = NO;
    self.ordersTableView.scrollEnabled = NO;
    
    self.menuTableView.rowHeight = 44;
    self.ordersTableView.rowHeight = 230;
    
    self.menuTableView.tableFooterView = [UIView new];
    self.ordersTableView.tableFooterView = [UIView new];
    
    [self.menuTableView registerNib:[SHPMenuTableViewCell nib] forCellReuseIdentifier:menuCellIdentifier];
    [self.ordersTableView registerNib:[SHPOrdersTableViewCell nib] forCellReuseIdentifier:orderCellIdentifier];
}

#pragma mark - Header
- (void)showOrdersHeaderView:(BOOL)show
{
    if (show)
    {
        self.ordersHeaderView.hidden = NO;
        self.errorViewVerticalSpacing.constant = self.ordersHeaderView.frame.size.height;
        self.ordersTableVerticalSpacing.constant = self.errorViewVerticalSpacing.constant;
    }
    else
    {
        self.ordersHeaderView.hidden = YES;
        self.errorViewVerticalSpacing.constant = 0;
        self.ordersTableVerticalSpacing.constant = self.errorViewVerticalSpacing.constant;
    }
}

#pragma mark - Run Logic
- (void)run
{
    if ([WALSession isAuthenticated])
    {
        self.scrollView.hidden = NO;
        [self checkUserName];
        [self loadOrders];
    }
    else
    {
        [self showLogin];
    }
}

#pragma mark - Orders
- (void)loadOrders
{
    LogInfo(@"Load Orders");
    [[UserSession sharedInstance] setCurrentPage:@0];
    
    [[TrackingConnection sharedInstance] getTrackingInformationFromCurrentUserWithCompletionBlock:^(TrackingEntity *trackingInfo)
     {
         self.tracking = trackingInfo;
         self.orders = [NSArray new];
         self.singleOrderArray = [NSArray new];
         
         self.orders = trackingInfo.orders;
         if (self.orders.count > 0)
         {
             [self showOrdersHeaderView:YES];
             [self.view setNeedsLayout];
             self.singleOrderArray = @[self.orders.firstObject];
         }
         else
         {
             [self showOrdersHeaderView:NO];
             [self.view setNeedsLayout];
         }
         
         [self reloadUIWithError:nil];
     }
                                                                                     failureBlock:^(NSError *error)
     {
         LogInfo(@"ERROR (%ld): %@", (long)error.code, error.localizedDescription);
         [self showOrdersHeaderView:NO];
         [self reloadUIWithError:error];
     }];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 0;
    if (tableView == self.menuTableView)
    {
        sections = 1;
    }
    else if (tableView == self.ordersTableView)
    {
        sections = 1;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (tableView == self.menuTableView)
    {
        rows = self.menuItems.count;
    }
    else if (tableView == self.ordersTableView)
    {
        rows = self.singleOrderArray.count;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.menuTableView)
    {
        SHPMenuTableViewCell *cell = (SHPMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
        [cell setupWithMenuItem:[self.menuItems objectAtIndex:indexPath.row]];
        cell.bottomSeparator.hidden = NO;
        
        if (indexPath.row == self.menuItems.count - 1)
        {
            cell.bottomSeparator.hidden = YES;
        }
        return cell;
    }
    else if (tableView == self.ordersTableView)
    {
        SHPOrdersTableViewCell *cell = (SHPOrdersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:orderCellIdentifier forIndexPath:indexPath];
        [cell configureWithOrder:[self.singleOrderArray objectAtIndex:indexPath.row]];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableView Delegate methods
- (void)showOrdersAction {
    if (self.ordersEnabled)
    {
        [FlurryWM logTracking_event_order_list_entering];
        self.ordersViewController = [[OrdersViewController alloc] initWithNibName:@"OrdersViewController" bundle:nil];
        self.ordersViewController.tracking = self.tracking;
        self.ordersViewController.orders = self.orders;
        [self.navigationController pushViewController:self.ordersViewController animated:YES];
    }
}

- (void)showContactTicketsAction {
    self.contactTicketsViewController = [[WBRContactTicketViewController alloc] initWithNibName:@"WBRContactTicketViewController" bundle:nil];
    [self.navigationController pushViewController:self.contactTicketsViewController animated:YES];
}

- (void)showPersonalDataAction {
    self.personalDataScreen = [[PersonalDataViewController alloc] initWithNibName:@"PersonalDataViewController" bundle:nil];
    self.personalDataScreen.delegate = self;
    [self.navigationController pushViewController:self.personalDataScreen animated:YES];
}

- (void)showAddressAction {
    self.myAddressesScreen = [[MyAddressesTableViewController alloc] initWithNibName:@"MyAddressesTableViewController" bundle:nil];
    [self.navigationController pushViewController:self.myAddressesScreen animated:YES];
}

- (void)showCreditCardAction {
    self.creditCardScreen = [[WBRCreditCardsViewController alloc] initWithNibName:@"WBRCreditCardsViewController" bundle:nil];
    [self.navigationController pushViewController:self.creditCardScreen animated:YES];
}

- (void)showExtendedWarrantyAction {
    self.extendedWarrantiesScreen = [[ExtendedWarrantyListViewController alloc] initWithNibName:@"ExtendedWarrantyListViewController" bundle:nil];
    self.extendedWarrantiesScreen.myAccountReference = self;
    [self.navigationController pushViewController:self.extendedWarrantiesScreen animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.menuTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        if ([WALMenuViewController singleton].services.showWarranties.boolValue &&
            [WALMenuViewController singleton].services.showTickets.boolValue) {
            switch (indexPath.row) {
                case 0:
                    [self showOrdersAction];
                    break;
                case 1:
                    [self showContactTicketsAction];
                    break;
                case 2:
                    [self showPersonalDataAction];
                    break;
                case 3:
                    [self showAddressAction];
                    break;
                case 4:
                    [self showCreditCardAction];
                    break;
                case 5:
                    [self showExtendedWarrantyAction];
                    break;
                case 6:
                    [self logout:self];
                    break;
                default:
                    break;
            }
        } else if (![WALMenuViewController singleton].services.showWarranties.boolValue &&
                   [WALMenuViewController singleton].services.showTickets.boolValue) {
            switch (indexPath.row) {
                case 0:
                    [self showOrdersAction];
                    break;
                case 1:
                    [self showContactTicketsAction];
                    break;
                case 2:
                    [self showPersonalDataAction];
                    break;
                case 3:
                    [self showAddressAction];
                    break;
                case 4:
                    [self showCreditCardAction];
                    break;
                case 5:
                    [self logout:self];
                    break;
                default:
                    break;
            }
        } else if ([WALMenuViewController singleton].services.showWarranties.boolValue &&
                   ![WALMenuViewController singleton].services.showTickets.boolValue) {
            switch (indexPath.row) {
                case 0:
                    [self showOrdersAction];
                    break;
                case 1:
                    [self showPersonalDataAction];
                    break;
                case 2:
                    [self showAddressAction];
                    break;
                case 3:
                    [self showCreditCardAction];
                    break;
                case 4:
                    [self showExtendedWarrantyAction];
                    break;
                case 5:
                    [self logout:self];
                    break;
                default:
                    break;
            }
        } else {
            switch (indexPath.row) {
                case 0:
                    [self showOrdersAction];
                    break;
                case 1:
                    [self showPersonalDataAction];
                    break;
                case 2:
                    [self showAddressAction];
                    break;
                case 3:
                    [self showCreditCardAction];
                    break;
                case 4:
                    [self logout:self];
                    break;
                default:
                    break;
            }
        }
    }
    else if (tableView == self.ordersTableView)
    {
        OrdersDetailViewController *detail = [[OrdersDetailViewController alloc] initWithNibName:@"OrdersDetailViewController" bundle:nil];
        detail.order = [self.singleOrderArray firstObject];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - Login Methods
- (void)showLogin
{
    [self presentLoginWithLoginSuccessBlock:^{
        [self checkOrderPushNotification];
        [self run];
    } dismissBlock:^{
        [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
    }];
}

#pragma mark - Push Stuff
- (void)checkOrderPushNotification
{
    LogInfo(@"checkOrderPushNotification");
    if (_orderFromPush.orderId.length > 0)
    {
        if ([WALSession isAuthenticated])
        {
            [self performSelector:@selector(showOrderDetailForOrder:) withObject:_orderFromPush afterDelay:.5];
        }
        else
        {
            LogInfo(@"Tracking notification received but the user is not logged");
            LogInfo(@"We will try to take him to the current order after a successful login");
        }
    }
}

- (void)showOrderDetailForOrder:(Order *)order
{
    OrdersDetailViewController *detail = [[OrdersDetailViewController alloc] initWithNibName:@"OrdersDetailViewController" bundle:nil];
    detail.order = self.orderFromPush;
    [self.navigationController pushViewController:detail animated:YES];
    self.orderFromPush = nil;
}

#pragma mark - Navigation Controller Helper
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[navigationController.navigationBar subviews] makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    });
}

#pragma mark - Errors
- (void)reloadUIWithError:(NSError *)error
{
    LogErro(@"Error reloadUIWithEerror: %@", error);
    if (error)
    {
        //Error when loading orders
        LogInfo(@"Exibir erro");
        self.errorImageView.image = [UIImage imageNamed:@"UISharedSadface.png"];
        self.errorMessageLabel.text = [self.messages errorOrders];
        self.ordersTableView.hidden = YES;
        self.ordersActivityIndicator.hidden = YES;
        self.retryButton.hidden = NO;
        self.errorView.hidden = NO;
        self.startBuyingButton.hidden = YES;
        
        self.cardView.userInteractionEnabled = YES;
        self.errorView.userInteractionEnabled = YES;
        
        if (error.code == 1009)
        {
            self.errorMessageLabel.text = ERROR_CONNECTION_INTERNET;
        }
        else if (error.code == 408) {
            self.errorMessageLabel.text = ERROR_CONNECTION_TIMEOUT;
        }
        else if (error.code == 401) {
            [self showLogin];
        }
        else {
            self.errorMessageLabel.text = ERROR_CONNECTION_UNKNOWN;
        }
        self.cardViewHeight.constant = self.errorView.frame.size.height;
    }
    else
    {
        if (self.singleOrderArray.count > 0)
        {
            //Success and we have orders
            LogInfo(@"Success");
            self.retryButton.hidden = YES;
            self.startBuyingButton.hidden = YES;
            self.errorView.hidden = YES;
            self.ordersActivityIndicator.hidden = YES;
            self.ordersTableView.hidden = NO;
            
            self.cardViewHeight.constant = 230 + self.ordersHeaderView.frame.size.height;
            [self.ordersTableView reloadData];
        }
        else
        {
            //Success but the user don't have any orders in this account
            self.errorImageView.image = [UIImage imageNamed:@"ic_sem_pedidos.png"];
            self.errorMessageLabel.text = [self.messages emptyOrders];
            self.ordersActivityIndicator.hidden = YES;
            self.ordersTableView.hidden = YES;
            self.retryButton.hidden = YES;
            self.startBuyingButton.hidden = NO;
            self.errorView.hidden = NO;
            self.cardViewHeight.constant = self.errorView.frame.size.height;
        }
    }
}

#pragma mark - Retry
- (void)retryOrders
{
    self.retryButton.hidden = YES;
    self.startBuyingButton.hidden = YES;
    self.errorView.hidden = YES;
    self.ordersTableView.hidden = YES;
    self.ordersActivityIndicator.hidden = NO;
    [self loadOrders];
}

#pragma mark - Logout
- (void)logout:(id)sender
{
    [FlurryWM logTracking_event_logout];
    [WBRUserManager logoutUser];
    [[MDSSqlite new] cleanCart];
    [[WMTokens new] deleteTokenOAuth];
    [WALFavoritesCache clean];
    [WALHomeCache clean];
    [self willLogoutLocalNotification];
    [[WALMenuViewController singleton] logoutAndShowHome:YES];
    [WBRFacebookLoginManager logoutFacebook];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"showcaseHeart"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"searchHeart"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetWishlistStatus" object:nil];
    [WBRUser removePIDFromUser];
    
    //Added to remove the My Account view when this is accessed by search bar and the user selected Logout.
    if ([self.navigationController viewControllers].count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)willLogoutNotification
{
    self.orders = nil;
    self.singleOrderArray = nil;
    
    self.userNameLabel.text = @"";
    self.errorMessageLabel.text = @"";
    self.ordersActivityIndicator.hidden = NO;
    self.ordersTableView.hidden = YES;
    self.retryButton.hidden = YES;
    self.startBuyingButton.hidden = YES;
    self.errorView.hidden = YES;
}

- (void)willLogoutLocalNotification
{
    [self willLogoutNotification];
}


#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Removing bounce from top
    if (scrollView.contentOffset.y <= 0)
    {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}

#pragma mark - Layout
- (void)setLayout
{
    self.logoutButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 6.0);
    self.logoutButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    [self.logoutButton setImage:[UIImage imageNamed:@"ico_logout"] forState:UIControlStateNormal];
    [self.logoutButton setImage:[UIImage imageNamed:@"ico_logout_pressed"] forState:UIControlStateHighlighted];
    [self.logoutButton setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:RGBA(244, 123, 32, 1) forState:UIControlStateHighlighted];
    
    self.ordersActivityIndicator.color = RGBA(26, 117, 207, 1);
    
    //We need to get the gender. Waiting API to return when the user logs in
    [self updateUserGender:nil];
}

- (void)checkUserName
{
    User *user = [User sharedUser];
    NSString *nmUs = user.firstName.length > 0 ? user.firstName : @"";
    [self updateUserName:nmUs];
}

- (void)updateUserName:(NSString *)name
{
    if (name.length > 0)
    {
        NSString *helloMessage = [NSString stringWithFormat:@"Olá, %@", name];
        NSRange nameRange = [helloMessage rangeOfString:name];
        
        NSMutableAttributedString *attributedHelloMessage = [[NSMutableAttributedString alloc] initWithString:helloMessage];
        [attributedHelloMessage addAttribute:NSForegroundColorAttributeName value:RGBA(243, 183, 0, 1) range:NSMakeRange(0, attributedHelloMessage.length)];
        [attributedHelloMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans" size:18] range:NSMakeRange(0, attributedHelloMessage.length)];
        [attributedHelloMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:18] range:nameRange];
        self.userNameLabel.attributedText = attributedHelloMessage.copy;
    }
    else
    {
        self.userNameLabel.text = @"";
    }
}

- (void)updateUserGender:(NSString *)gender
{
    /*
     if ([gender.lowercaseString isEqualToString:@"male"]) {
     self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_man"];
     }
     else if ([gender.lowercaseString isEqualToString:@"female"]) {
     self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_woman"];
     }
     else {
     self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
     }
     */
    
    //    _userImageView.layer.masksToBounds = YES;
    //    _userImageView.layer.cornerRadius = 50;
    //    _userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    _userImageView.layer.borderWidth = 2;
    //
    //    User *user = [User sharedUser];
    //    if ([user.social objectForKey:@"id"]) {
    //
    //        NSString *strSocialSnId = [user.social objectForKey:@"id"];
    //        LogInfo(@"Social: %@", strSocialSnId);
    //
    //        [self setImage:[NSString stringWithFormat:@"%@%@/picture?width=200&height=200", URL_IMG_USER_FACEBOOK, strSocialSnId]];
    //    }
    //    else {
    //
    //        self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
    //    }
    
    
    
    //    [[FacebookConnection new] getUserInformationsWithCompletion:^(FaceUser *user) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            LogInfo(@"[FACE] Selfhelp: User        : %@", user.name);
    //            LogInfo(@"[FACE] Selfhelp: E-mail      : %@", user.email);
    //            LogInfo(@"[FACE] Selfhelp: Access Token: %@", user.tokenFacebook);
    //            LogInfo(@"[FACE] Selfhelp: Image       : %@", user.picture_url);
    //
    //            //Content texfields
    //            [self setImage:user.picture_url];
    //        });
    //
    //    } failure:^(NSError *error) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            LogErro(@"[FACE] Error: %@", [error description]);
    //
    //            //For now we are just showing the unissex image until we have login with Facebook to get gender and picture
    //            self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
    //        });
    //    }];
    
    
    //    //For now we are just showing the unissex image until we have login with Facebook to get gender and picture
    //    self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
}

- (void) setImage:(NSString *) urlImage {
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:urlImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self->_userImageView.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            self.userImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
        }
    }];
}


#pragma Mark - PersonalData Delegate
- (void)saveUserPersonalDataSucessWithUserData:(User *)userPersonalData
{
    //Update user name
    [self updateUserName:userPersonalData.firstName];
    [[WALMenuViewController singleton] updateUserInformation];
    
    //Update gender
    [self updateUserGender:userPersonalData.gender];
}

#pragma mark - IBAction
- (IBAction)handleStartBuyingPress:(id)sender {
    [[WALMenuViewController singleton] presentHomeWithAnimation:YES reset:NO];
}

#pragma mark - UTMI
- (NSString *)UTMIIdentifier {
    return @"minha-conta";
}

@end
