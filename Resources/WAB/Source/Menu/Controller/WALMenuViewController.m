//
//  WALMenuViewController.m
//  Walmart
//
//  Created by Bruno on 8/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WALMenuViewController.h"
#import "MenuImports.h"
#import "User.h"
#import "OrdersViewController.h"
#import "WBRFacebookLoginManager.h"

#import "WBRButton.h"

#import "WBRUserManager.h"
#import "WBRMenuManager.h"

#import "WBRContactTicketMessageViewController.h"

#define kMenuDeltaOpened 50
#define kMenuAnimationDuration .3
#define kMenuAnimationDurationTotal kMenuAnimationDuration * 2

#define kMenuLoginViewOnlineHeight 84
#define kMenuLoginViewOfflineHeight 45

@interface WALMenuViewController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate, ContactRequestDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tbMenu;
@property (nonatomic, weak) IBOutlet UILabel *username;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet WBRButton *yourAccountButton;
@property (weak, nonatomic) IBOutlet WBRButton *currentOrdersButton;
@property (weak, nonatomic) IBOutlet WBRButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;

@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (weak, nonatomic) IBOutlet UIView *offlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuTopViewHeightConstraint;

@property (strong, nonatomic) NSMutableArray *exploreSectionMutableItems;
@property (strong, nonatomic) OFMessages *messagesInstance;
@property (strong, nonatomic) NSArray *shoppingDepartments;
@property (strong, nonatomic) MenuDataSource *menuDataSource;
@property (strong, nonatomic) MenuDelegate *menuDelegate;
@property (strong, nonatomic) WMBaseNavigationController *containerNavigationController;

@property BOOL menuDone;

@end

@implementation WALMenuViewController

+ (instancetype)singleton
{
    static WALMenuViewController *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[WALMenuViewController alloc] initWithNibName:@"WALMenuViewController" bundle:nil];
    });
    return singleton;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccessNotification:) name:kLoginSuccessNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutNotification:) name:kLogoutNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSharedUserChangedNotification:) name:kSharedUserChangedNotificationName object:nil];
    }
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupProfileImageView];
    [self setupSignInButton];
    
    [MDSTime start:@"menu"];
    
    self.navigationController.delegate = self;
    
    self.departments = @[@"Início"];
    self.messagesInstance = [OFMessages new];
    
    [self setLayout];
    [self updateDepartments];
    [self setupMenuTableView];
    [self presentInitialController];
    
    _menuDone = YES;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setUserAuthenticated:[WALSession isAuthenticated]];
    [self updateUserInformation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_containerNavigationController.viewControllers.firstObject) {
        [self presentInitialController];
    }
    
    [self checkMenuSelection];
    [self checkDeepLinkActions];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:(viewController == self) animated:animated];
}

- (void)presentInitialController
{
    [self presentHomeWithAnimation:NO reset:NO];
    
    [MDSTime stop:@"menu"];
}

- (void)setUserAuthenticated:(BOOL)userAuthenticated {
    
    _userAuthenticated = userAuthenticated;
    float height;
    if (userAuthenticated) {
        [self.onlineView setHidden:NO];
        [self.offlineView setHidden:YES];
        height = kMenuLoginViewOnlineHeight;
    }
    else {
        [self.onlineView setHidden:YES];
        [self.offlineView setHidden:NO];
        height = kMenuLoginViewOfflineHeight;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.menuTopViewHeightConstraint.constant = height;
        [self.view layoutIfNeeded];
    }];
}

- (void)updateUserInformation {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        User *currentUser = [User sharedUser];
        
        [self updateUserName:currentUser];
        [self updateUserImageWithSocial:currentUser.social];
    }];
}

- (void)updateUserName:(User *)currentUser {
    
//    [self.username setAttributedText:NSA];
    NSMutableAttributedString *usernameString = [[NSMutableAttributedString alloc] initWithString:@"Olá, " attributes: @{NSFontAttributeName: [UIFont fontWithName: @"Roboto-Regular" size: 18.0f], NSForegroundColorAttributeName: [UIColor colorWithWhite: 1.0f alpha: 1.0f]}];
    
    if (![currentUser.firstName isEqualToString:@""] && currentUser.firstName != nil) {
        [usernameString appendAttributedString:[[NSAttributedString alloc] initWithString:currentUser.firstName attributes:@{NSFontAttributeName: [UIFont fontWithName: @"Roboto-Bold" size: 18.0f]}]];
    }
    
    [self.username setAttributedText:usernameString];
}

- (void)updateUserImageWithSocial:(NSDictionary *)socialDictionary {
    
    if ([socialDictionary objectForKey:@"id"]) {
        NSString *strSocialSnId = [socialDictionary objectForKey:@"id"];
        [WBRFacebookLoginManager getImageFacebook:strSocialSnId completionBlock:^(NSString *profilePictureUrl) {
            [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:profilePictureUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (image) {
                        self.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
                    } else {
                        self.profileImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
                    }
                }];
            }];
        } failure:^(NSError *error, NSHTTPURLResponse *failResponse) {
            self.profileImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
        }];
    } else {
        self.profileImageView.image = [UIImage imageNamed:@"img_selfhelp_unissex"];
    }
}

#pragma mark - Refresh
- (void)updateDepartments {
    LogMicro(@"Services: %@", _services);
    
    if (_services.showDepartmentsOnMenu.boolValue) {
        [WBRMenuManager getAndUpdateMenuItemsWithSuccessBlock:nil failureBlock:nil];
    } else {
        self.departments = @[@"Início"];
        self.messagesInstance = [OFMessages new];
        [self setupMenuTableView];
    }
}

#pragma mark - Menu Animations
- (void)unselectHeaderButtons {
    
    [self.yourAccountButton setSelected:NO];
    [self.currentOrdersButton setSelected:NO];
    [self.contactButton setSelected:NO];
    
}

- (void)showMenuItem:(UIViewController *)menuItem animated:(BOOL)animated completion:(void (^)())completionBlock
{
    if (!_containerNavigationController)
    {
        self.containerNavigationController = [[WMBaseNavigationController alloc] initWithRootViewController:menuItem];
        _containerNavigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        _containerNavigationController.view.layer.shadowOffset = CGSizeMake(-10, 0);
        _containerNavigationController.view.layer.shadowOpacity = 0.4;
        _containerNavigationController.view.layer.shadowRadius = 5;

        _containerNavigationController.view.frame = self.parentViewController.parentViewController.view.bounds;
        [self.parentViewController.parentViewController addChildViewController:_containerNavigationController];
        [self.parentViewController.parentViewController.view addSubview:_containerNavigationController.view];
        [_containerNavigationController didMoveToParentViewController:self.parentViewController.parentViewController];
        
        [self setPanGesture];
        
        return;
    }
    
    if ([self isControllerOpeningTheSameOpened:menuItem])
    {
        [self closeMenuAnimated:YES completion:^{
            if (completionBlock) completionBlock();
        }];
        return;
    }
    
    if (animated)
    {
        _tbMenu.userInteractionEnabled = NO;
        __block CGRect contentViewFrame = _containerNavigationController.view.frame;
        contentViewFrame.origin.x = contentViewFrame.size.width;
        
        [UIView animateWithDuration:kMenuAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self->_containerNavigationController.view.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            [self setNewMenuItem:menuItem];
            
            contentViewFrame.origin.x = 0;
            [UIView animateWithDuration:kMenuAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->_containerNavigationController.view.frame = contentViewFrame;
            } completion:^(BOOL finished) {
                self->_tbMenu.userInteractionEnabled = YES;
                [self enableInteractionOnCurrentViewController:YES];
                if (completionBlock) completionBlock();
            }];
        }];
    }
    else
    {
        [self setNewMenuItem:menuItem];
        [self enableInteractionOnCurrentViewController:YES];
        if (completionBlock) completionBlock();
    }
}

- (BOOL)isControllerOpeningTheSameOpened:(UIViewController *)menuItem
{
    UIViewController *currentController = _containerNavigationController.viewControllers.firstObject;
    UIViewController *newController = menuItem;
    if ([newController isKindOfClass:UINavigationController.class])
    {
        UINavigationController *navigationController = (UINavigationController *)newController;
        newController = navigationController.viewControllers.firstObject;
    }
    
    if ([newController isKindOfClass:OFHubViewController.class])
        return NO;
    else
        return [newController isKindOfClass:currentController.class];
}

- (void)setNewMenuItem:(UIViewController *)controller
{
    UIViewController *currentController = _containerNavigationController.viewControllers.firstObject;
    if ([currentController isKindOfClass:WMMyAccountViewController.class]) {
        [WMOmniture trackSelfHelpHomeExit];
    }
    
    [currentController.view removeFromSuperview];
    [currentController removeFromParentViewController];
    [_containerNavigationController setViewControllers:@[controller] animated:NO];
    
    self.menuOpen = NO;
}

- (void)openMenuWithCompletion:(void (^)())completionBlock
{
    [self dismissAnyKeyboard];
    
    CGRect contentViewFrame = _containerNavigationController.view.frame;
    contentViewFrame.origin.x = contentViewFrame.size.width - kMenuDeltaOpened;
    [UIView animateWithDuration:kMenuAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self->_containerNavigationController.view.frame = contentViewFrame;
    } completion:^(BOOL finished) {
        self.menuOpen = YES;
        [self enableInteractionOnCurrentViewController:NO];
        if (completionBlock) completionBlock();
    }];
}

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)())completionBlock
{
    CGRect contentViewFrame = _containerNavigationController.view.frame;
    contentViewFrame.origin.x = 0;
    [UIView animateWithDuration:animated ? kMenuAnimationDuration : 0.0f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->_containerNavigationController.view.frame = contentViewFrame;
    } completion:^(BOOL finished) {
        self.menuOpen = NO;
        [self enableInteractionOnCurrentViewController:YES];
        [self resetMenuAnimated:NO];
        if (completionBlock) completionBlock();
    }];
}

- (void)enableInteractionOnCurrentViewController:(BOOL)enable
{
    UIViewController *currentController = _containerNavigationController.viewControllers.firstObject;
    
    if ([currentController respondsToSelector:@selector(enableInteraction:)]) {
        [(WALMenuItemViewController *)currentController enableInteraction:enable];
    }
}

- (void)dismissAnyKeyboard
{
    UIViewController *currentController = _containerNavigationController.viewControllers.firstObject;
    [currentController.view endEditing:YES];
}

#pragma mark - Pan Gesture
-(void)setPanGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = self;
    [_containerNavigationController.view addGestureRecognizer:panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    BOOL willHandle = _containerNavigationController.viewControllers.count == 1;
    
    if (willHandle) {
        CGPoint translation = [gesture translationInView:self.view];
        CGFloat newPosition = gesture.view.frame.origin.x + translation.x;
        
        CGFloat maxMenuPosition = self.view.frame.size.width - kMenuDeltaOpened;
        newPosition = (newPosition < 0) ? 0 : newPosition;
        newPosition = (newPosition > maxMenuPosition) ? maxMenuPosition : newPosition;
        
        CGRect recognizerViewFrame = gesture.view.frame;
        recognizerViewFrame.origin.x = newPosition;
        gesture.view.frame = recognizerViewFrame;
        
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
        
        if (gesture.state == UIGestureRecognizerStateEnded)
        {
            (newPosition > self.view.frame.size.width/2) ? [self openMenuWithCompletion:nil] : [self closeMenuAnimated:YES completion:nil];
        }
    }
}

#pragma mark - Departments
- (void)refreshWithNewDepartments:(NSDictionary *)departmentsDictionary
{
    NSArray *departmentsFromServer = [departmentsDictionary objectForKey:@"mainDepartments"];
    NSMutableArray *allDepartments = [[NSMutableArray alloc] initWithArray:departmentsFromServer];
    if (_departments.count > 0) {
        [allDepartments insertObject:_departments[0] atIndex:0];
    }
    
    self.departments = allDepartments.copy;
    self.shoppingDepartments = [departmentsDictionary objectForKey:@"allDepartments"];
    
    if (_menuDataSource) _menuDataSource.departments = _departments;
    [_tbMenu reloadData];
    [self checkMenuSelection];
}

#pragma mark - Login/Logout
- (IBAction)presentLogin {
    [self presentLoginAnimated:YES];
}

- (void)presentLoginAnimated:(BOOL)animated
{
    self.currentIndexPath = nil;
    [self checkMenuSelection];
    WALMenuItemViewController *controller = (WALMenuItemViewController *)_containerNavigationController.viewControllers.firstObject;
    
    [self closeMenuAnimated:YES completion:^{
        [controller presentLoginWithLoginSuccessBlock:^{
            [self presentHomeWithAnimation:YES reset:NO];
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self checkMenuSelection];
        }];
    }];
}

- (void)logoutAndShowHomeCalabash:(BOOL)showHome
{
    [WBRUserManager logoutUser];
    
    if (showHome) {
        [self presentHomeWithAnimation:YES reset:YES];
    }
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self checkMenuSelection];
}


- (void)logoutAndShowHome:(BOOL)showHome
{
    [WBRUserManager logoutUser];
    
    if (showHome) {
        [self presentHomeWithAnimation:YES reset:NO];
    }
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self checkMenuSelection];
}

#pragma mark - My account
- (void)presentMyAccount
{
    [self unselectHeaderButtons];
    
    BOOL activeSession = [WALSession isAuthenticated];

    if (activeSession) {
        self.currentIndexPath = nil;
    }
    [self checkMenuSelection];
    
    [self.yourAccountButton setSelected:YES];
    [self presentMyAccountWithOrderId:nil];
}

- (void)presentMyAccountWithOrderId:(NSString *)orderId
{
    BOOL activeSession = [WALSession isAuthenticated];
    if (activeSession)
    {
        [self loadOrderControllerWithOrderID:orderId];
    }
    else
    {
        WALMenuItemViewController *controller = (WALMenuItemViewController *)_containerNavigationController.viewControllers.firstObject;
        [self closeMenuAnimated:YES completion:^{
            [controller presentLoginWithLoginSuccessBlock:^{
                [self loadOrderControllerWithOrderID:orderId];
            } dismissBlock:^{
                [self unselectHeaderButtons];
                [self checkMenuSelection];
            }];
        }];
    }
}

- (void)loadOrderControllerWithOrderID:(NSString *)orderId {
    self.currentIndexPath = nil;
    [self checkMenuSelection];
    BOOL animated = YES;
    
    WALMenuItemViewController *controller = (WALMenuItemViewController *)_containerNavigationController.viewControllers.firstObject;
    WMMyAccountViewController *myAccountViewController;
    if ([controller isKindOfClass:WMMyAccountViewController.class])
    {
        myAccountViewController  = (WMMyAccountViewController *)controller;
        if (orderId)
        {
            Order *order = [Order new];
            order.orderId = orderId;
            myAccountViewController.orderFromPush = order;
            [myAccountViewController checkOrderPushNotification];
        }
        [self closeMenuAnimated:YES completion:nil];
    }
    else
    {
        myAccountViewController = [WMMyAccountViewController new];
        if (orderId)
        {
            Order *order = [Order new];
            order.orderId = orderId;
            myAccountViewController.orderFromPush = order;
            animated = NO;
        }
        [self dismissBackToRootViewController];
        [self showMenuItem:myAccountViewController animated:animated completion:nil];
    }
}

#pragma mark - Orders

- (IBAction)currentOrdersAction:(id)sender {
    
    [self unselectHeaderButtons];
    
    BOOL activeSession = [WALSession isAuthenticated];

    if (activeSession) {
        self.currentIndexPath = nil;
    }

    [self checkMenuSelection];
    
    [self.currentOrdersButton setSelected:YES];
    [self presentOrdersViewController];
    
}

- (void)presentOrdersViewController {
    
    BOOL activeSession = [WALSession isAuthenticated];
    
    if (activeSession) {
        [self loadOrdersViewController];
    }
    else {
        WALMenuItemViewController *controller = (WALMenuItemViewController *)_containerNavigationController.viewControllers.firstObject;
        [self closeMenuAnimated:YES completion:^{
            [controller presentLoginWithLoginSuccessBlock:^{
                self.currentIndexPath = nil;
                [self loadOrdersViewController];
            } dismissBlock:^{
                [self unselectHeaderButtons];
                [self checkMenuSelection];
            }];
        }];
    }
}

- (void)loadOrdersViewController {
    OrdersViewController *orderViewController = [[OrdersViewController alloc] initWithNibName:@"OrdersViewController" bundle:nil];
    [self showMenuItem:orderViewController animated:YES completion:^{
        [self checkMenuSelection];
    }];
}

#pragma mark - Contact

- (IBAction)openContactAction {
    [self unselectHeaderButtons];
    self.currentIndexPath = nil;
    [self checkMenuSelection];
    
    [self.contactButton setSelected:YES];
    [self presentContact];

    [WMOmniture trackOpenTicketSideMenu];
}

- (void)presentContact
{
    ContactRequestViewController *contact = [[ContactRequestViewController alloc] initFromMenu:YES andThankyouPageSuccessButtonTitle:@"Voltar"];
    contact.delegate = self;
    [self showMenuItem:contact animated:YES completion:nil];
}

#pragma mark - Home
- (void)presentHomeWithAnimation:(BOOL)animated reset:(BOOL)reset
{
    [FlurryWM logEvent_menu_category:@"Início"];
    if (!_home || reset) {
        self.home = [WALHomeViewController new];
    }
    _home.state = HomeStateShowcases;
    [self showMenuItem:_home animated:animated completion:^{
        [self unselectHeaderButtons];
        NSIndexPath *homeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.currentIndexPath = homeIndexPath;
        [self checkMenuSelection];
    }];
}

- (void)reloadHome {
    _home.isLoadingHome = NO;
    [_home loadHome];
}

#pragma mark - Departments
- (void)presentDepartment:(DepartmentMenuItem *)department
{
    [FlurryWM logEvent_menu_shopping_root:department.name];
    WMSubcategoriesViewController *controller = [[WMSubcategoriesViewController alloc] initWithDepartment:department];
    
    CategoryMenuItem *seeAll = [CategoryMenuItem new];
    seeAll.categoryId = department.departmentId;
    seeAll.name = [NSString stringWithFormat:@"Tudo em %@", department.name];
    seeAll.url = department.url;
    seeAll.useHub = department.useHub;
    seeAll.isSeeAll = @YES;
    seeAll.imageSelected = department.imageSelected;
    
    controller.seeAllItem = seeAll;
    controller.hideIcon = NO;
    
    [WMOmniture trackMenuDepartmentTap:department.name];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ALL Shopping
- (void)presentAllShopping
{
    AllShoppingViewController *allShopping = [[AllShoppingViewController alloc] initWithCategories:nil];
    [self showMenuItem:allShopping animated:YES completion:nil];
}

#pragma mark - HUBs
- (void)presentHubWithID:(NSString *)hubId title:(NSString *)hubTitle otherCategories:(NSArray *)otherCategories
{
    self.currentIndexPath = nil;
    [self checkMenuSelection];
    
    OFHubViewController *hub = [[OFHubViewController alloc] initWithHubId:hubId hubTitle:hubTitle otherCategories:otherCategories];
    [self showMenuItem:hub animated:YES completion:^{
        [self resetMenuAnimated:NO];
    }];
}

#pragma mark - Notifications
- (void)presentNotifications
{
    OFNotificationsViewController *notifications = [OFNotificationsViewController new];
    [self showMenuItem:notifications animated:YES completion:nil];
}

#pragma mark - How to use
- (void)presentHowToUse
{
    OFHelp *help = [OFHelp new];
    [self showMenuItem:help animated:YES completion:nil];
}

#pragma mark - Feedback
- (void)presentFeedback
{
    OFFeedback *feedback = [[OFFeedback alloc] initWithIsModal:NO];
    [self showMenuItem:feedback animated:YES completion:nil];
}

#pragma mark - App store rate
- (void)rateInAppStore
{
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=781817589&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - About
- (void)presentAbout
{
    OFAboutViewController *about = [OFAboutViewController new];
    [self showMenuItem:about animated:YES completion:nil];
}

#pragma mark - Internal Control
- (void)presentInternalControl {
    
    InternalControlViewController *control = [InternalControlViewController new];
    [self showMenuItem:control animated:YES completion:nil];
}

#pragma mark - Walmart.com
- (void)presentWalmartWebsite
{
    [FlurryWM logEvent_menu_mobile_site_btn];
    [self presentHomeWithAnimation:YES reset:NO];
    
    NSString *launchURL = @"https://m.walmart.com.br";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:launchURL]];
}

#pragma mark - Query
- (void)loadQueryOnCurrentViewController:(NSString *)query
{
    WALMenuItemViewController *controller = (WALMenuItemViewController *)_containerNavigationController.viewControllers.firstObject;
    [controller openSearchWithQuery:query completionBlock:^{
        [self closeMenuAnimated:YES completion:nil];
    }];
}

#pragma mark - Product
- (void)loadProductOnCurrentViewControllerForProductId:(NSString *)productId
{
    WALMenuItemViewController *controller = (WALMenuItemViewController *)_containerNavigationController.viewControllers.firstObject;
    LogInfo(@"Controller opening product with product id: %@", controller);
    if (controller.search && controller.search.isViewLoaded && controller.search.view.window) {
        [controller.search openProductWithID:productId];
    } else {
        [controller openProductWithID:productId];
    }
}

- (void)loadProductOnCurrentViewControllerForProductSku:(NSString *)productSku
{
    WALMenuItemViewController *controller = (WALMenuItemViewController *)_containerNavigationController.viewControllers.firstObject;
    LogInfo(@"Controller opening product with product sku: %@", controller);
    if (controller.search && controller.search.isViewLoaded && controller.search.view.window) {
        [controller.search openProductWithSKU:productSku];
    } else {
        [controller openProductWithSKU:productSku];
    }
    
}

#pragma mark - Layout

- (void)setupSignInButton {
    
    NSAttributedString *signInAttributedString = [[NSAttributedString alloc] initWithString:@"Entre" attributes:@{
                                                                                                                 NSFontAttributeName: [UIFont fontWithName:@"Roboto-Medium" size:18],
                                                                                                                 NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                                 }];
    NSAttributedString *orAttributedString = [[NSAttributedString alloc] initWithString:@" ou " attributes:@{
                                                                                                                                       NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:15],
                                                                                                                                       NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                                                       }];
    NSAttributedString *signUpAttributedString = [[NSAttributedString alloc] initWithString:@"Cadastre-se" attributes:@{
                                                                                                             NSFontAttributeName: [UIFont fontWithName:@"Roboto-Medium" size:18],
                                                                                                             NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                             }];
    
    NSMutableAttributedString *userAttributedString = [[NSMutableAttributedString alloc] init];
    [userAttributedString appendAttributedString:signInAttributedString];
    [userAttributedString appendAttributedString:orAttributedString];
    [userAttributedString appendAttributedString:signUpAttributedString];
    
    self.signinButton.titleLabel.attributedText = userAttributedString;
}

- (void)setupProfileImageView {
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 2.0f;
}

- (void)setLayout
{
    UIColor *customBlueColor = RGBA(33, 150, 243, 1);
//    UIColor *customBlueColorSelected = RGBA(20, 120, 200, 1);
//    UIImage *customBlueImage = [UIImage imageWithColor:customBlueColor];
//    UIImage *customBlueImageSelected = [UIImage imageWithColor:customBlueColorSelected];
    
//    self.view.backgroundColor = customBlueColor;
//    _viewLogin.backgroundColor = customBlueColor;
//    _viewLogout.backgroundColor = customBlueColor;
    self.tbMenu.backgroundColor = customBlueColor;
    
    NSMutableAttributedString *customLoginTitle = [[NSMutableAttributedString alloc] initWithString:@"Entre ou Cadastre-se"];
    UIFont *font1 = [UIFont fontWithName:@"Roboto-Bold" size:18];
    UIFont *font2 = [UIFont fontWithName:@"Roboto-Light" size:18];
    
    NSRange fullRange = NSMakeRange(0, customLoginTitle.length);
    NSRange enterRange = NSMakeRange(0, 5);
    NSRange orRange = NSMakeRange(6, 2);
    NSRange signInRange = NSMakeRange(9, 11);
    
    [customLoginTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
    [customLoginTitle addAttribute:NSFontAttributeName value:font1 range:enterRange];
    [customLoginTitle addAttribute:NSFontAttributeName value:font2 range:orRange];
    [customLoginTitle addAttribute:NSFontAttributeName value:font1 range:signInRange];
    
//    [_butMyAccount setBackgroundImage:customBlueImage forState:UIControlStateNormal];
//    [_butMyAccount setBackgroundImage:customBlueImageSelected forState:UIControlStateHighlighted];
    
//    [_butLogin setBackgroundImage:customBlueImage forState:UIControlStateNormal];
//    [_butLogin setBackgroundImage:customBlueImageSelected forState:UIControlStateHighlighted];
//    [_butLogin setAttributedTitle:customLoginTitle.copy forState:UIControlStateNormal];
//    [_butLogin setAttributedTitle:customLoginTitle.copy forState:UIControlStateHighlighted];
}

- (void)setupMenuTableView
{
    [_tbMenu registerNib:[DepartmentMenuItemCell nib] forCellReuseIdentifier:@"cellDepartmentMenuItem"];
    _tbMenu.rowHeight = 44;
    
    self.menuDataSource = [[MenuDataSource alloc] initWithDepartments:_departments];
    self.menuDelegate = [[MenuDelegate alloc] initWithMenuReference:self];
    _tbMenu.dataSource = _menuDataSource;
    _tbMenu.delegate = _menuDelegate;
    
    NSIndexPath *homeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.currentIndexPath = homeIndexPath;
    [_tbMenu selectRowAtIndexPath:homeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [_tbMenu reloadData];
}

- (void)checkMenuSelection
{
    if (_currentIndexPath)
    {
        [_tbMenu selectRowAtIndexPath:_currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        NSIndexPath *selectedIndexPath = [_tbMenu indexPathForSelectedRow];
        if (selectedIndexPath) {
            [_tbMenu deselectRowAtIndexPath:selectedIndexPath animated:YES];
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_tbMenu respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tbMenu setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tbMenu respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tbMenu setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Reset
- (void)resetMenuAnimated:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Dismiss modals
- (void)dismissBackToRootViewController
{
    [(OFAppDelegate *)[[UIApplication sharedApplication] delegate] dismissModalViews];
}

#pragma mark - Deep Link
- (void)checkDeepLinkActions {
    if (_deepLink && _containerNavigationController.viewControllers.firstObject)
    {
        switch (_deepLink.type) {
            case DeepLinkTypeProductId:
                [self loadProductOnCurrentViewControllerForProductId:_deepLink.parameter];
                break;
            case DeepLinkTypeProductSku:
                [self loadProductOnCurrentViewControllerForProductSku:_deepLink.parameter];
                break;
            case DeepLinkTypeSearch:
                [self loadQueryOnCurrentViewController:_deepLink.parameter];
                break;
                
            default:
                break;
        }
        _deepLink = nil;
    }
}

#pragma mark - UTMI
- (NSString *)currentUTMIIdentifier {
    WALMenuItemViewController *controller = (WALMenuItemViewController *)_containerNavigationController.viewControllers.firstObject;
    return controller.UTMIIdentifier;
}

- (WALMenuItemViewController *)currentController {
    return (WALMenuItemViewController *)_containerNavigationController.viewControllers.firstObject;
}

#pragma mark - Notification
- (void)handleLoginSuccessNotification:(NSNotification *)notification {
    [[WALMenuViewController singleton] setUserAuthenticated:YES];
}

- (void)handleLogoutNotification:(NSNotification *)notification {
    [self unselectHeaderButtons];
    [[WALMenuViewController singleton] setUserAuthenticated:NO];
}

- (void)handleSharedUserChangedNotification:(NSNotification *)notification {
    [self updateUserInformation];
}

@end
