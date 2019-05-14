//
//  HomeViewController.m
//  Tracking
//
//  Created by Bruno Delgado on 4/16/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "OrdersViewController.h"
#import "TrackingEntity.h"
#import "LoadMoreCell.h"
#import "OrdersDetailViewController.h"
#import "UserSession.h"
#import "PushHandler.h"
#import "TrackingConnection.h"
#import "UIImage+Additions.h"
#import "FilterButton.h"
#import "CustomPickerView.h"
#import "NSDate+DateTools.h"
#import "OFMessages.h"
#import "WMButton.h"
#import "SHPOrdersTableViewCell.h"
#import "WMMyAccountViewController.h"
#import "WMDeviceType.h"
#import "OFColors.h"
#import "PSLog.h"
#import "WMButtonRounded.h"

#define TableViewContentDisplaySection 0
#define TableViewLoadMoreSection 1

@interface OrdersViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *ordersTableView;

@property (nonatomic, weak) IBOutlet WMButton *buyButton;
@property (nonatomic, weak) IBOutlet WMButtonRounded *tryAgainButton;
@property (nonatomic, weak) IBOutlet FilterButton *statusFilterButton;
@property (nonatomic, weak) IBOutlet FilterButton *periodFilterButton;
@property (nonatomic, strong) FilterButton *filterButton;
@property (nonatomic, strong) UIRefreshControl *pullToRefreshControl;

@property (nonatomic, strong) NSArray *statusOptions;
@property (nonatomic, strong) NSArray *periodOptions;

@property (nonatomic, assign) BOOL isLoadingOrders;
@property (nonatomic, assign) BOOL isLoadingMore;
@property (nonatomic, assign) BOOL endOfOrdersReached;
@property (nonatomic, assign) BOOL cancelLoadMore;
@property (nonatomic, assign) NSUInteger pageBeforePull;

@property (nonatomic, strong) OFMessages *messages;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

- (IBAction)goToShopping;
- (IBAction)reload;

@end

@implementation OrdersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    [WMOmniture trackOrdersList];

    [self setUpContent];
    [self setLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[PushHandler registerForPushNotifications];
    [[PushHandler singleton] cleanBadge];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderUpdatePushNotificationReceived:) name:OrderUpdatePushNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLogoutNotification) name:@"LogoutNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OrderUpdatePushNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LogoutNotification" object:nil];
}

- (void)willLogoutNotification
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self performSelector:@selector(triggerLocalLogout) withObject:nil afterDelay:0.4];
}

- (void)triggerLocalLogout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalLogoutNotification" object:nil];
}

#pragma mark - TableView
- (void)setUpContent
{
    self.emptyView.hidden = YES;
    self.messages = [OFMessages new];
    UserSession *session = [UserSession sharedInstance];

    if (self.orders.count == 0)
    {
        [session setCurrentPage:@0];
    }
    else
    {
        [session setCurrentPage:@1];
    }
    
    [self setupTableView];
    [self setupPullToRefresh];
    [self setupFilters];
    
    if (self.orders.count == 0)
    {
        [self loadOrders];
    }
    else
    {
        [self reloadUI];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
        });
    }
}

- (void)setupTableView
{
    if (!self.ordersTableView.tableFooterView)
    {
        self.ordersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ordersTableView.frame.size.width, 15)];
    }
    
    [self.ordersTableView registerNib:[SHPOrdersTableViewCell nib] forCellReuseIdentifier:@"OrdersCell"];
    [self.ordersTableView registerNib:[LoadMoreCell nib] forCellReuseIdentifier:@"LoadMoreCell"];
    [self hideTableViewHeader];
}

- (void)showTableViewHeader
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"OrdersListHeader" owner:self options:nil];
    if (nibViews.count > 0)
    {
        self.ordersTableView.tableHeaderView = nibViews.firstObject;
    }
}

- (void)hideTableViewHeader
{
    self.ordersTableView.tableHeaderView = nil;
}

- (void)removePullToRefresh
{
    if (self.pullToRefreshControl)
    {
        [self.pullToRefreshControl removeFromSuperview];
        self.pullToRefreshControl = nil;
    }
}

- (void)setupPullToRefresh
{
    if (!self.pullToRefreshControl)
    {
        self.pullToRefreshControl = [UIRefreshControl new];
        self.pullToRefreshControl.tintColor = RGBA(26, 117, 207, 1);
        [self.pullToRefreshControl addTarget:self action:@selector(reloadOrders:) forControlEvents:UIControlEventValueChanged];
        [self.ordersTableView addSubview:self.pullToRefreshControl];
    }
}

#pragma mark - Orders
- (void)loadOrders
{
    if (self.isLoadingOrders) return;
    self.isLoadingOrders = YES;
    
    if (!self.isLoadingMore)
    {
        self.emptyView.hidden = YES;
        if (self.pullToRefreshControl.isRefreshing == FALSE)
        {
            [self showLoading];
        }
    }
    
    [[TrackingConnection sharedInstance] getTrackingInformationFromCurrentUserWithCompletionBlock:^(TrackingEntity *trackingInfo)
    {
        [self hideLoading];
        self.tracking = trackingInfo;
        if (self.isLoadingMore)
        {
            if (!self.cancelLoadMore) {
                UserSession *userSession = [UserSession sharedInstance];
                if (userSession.currentPage.integerValue == 0)
                {
                    self.orders = [NSArray new];
                }
                
                NSMutableArray *multipleOrders = [[NSMutableArray alloc] initWithArray:self.orders];
                [multipleOrders addObjectsFromArray:self.tracking.orders];
                self.orders = multipleOrders.copy;
                if (self.tracking.orders.count > 0)
                {
                    [self increasePage];
                }
                else
                {
                    self.endOfOrdersReached = YES;
                }
            }
        }
        else
        {
            self.orders = [NSArray new];
            self.orders = trackingInfo.orders;
         
            if (self.orders.count == 0)
            {
                [self setEmptyState];
            }
            else
            {
                [self updatePageForLoadMore];
            }
        }
         
        [self reloadUI];
    }
    failureBlock:^(NSError *error)
    {
        [self hideLoading];
        self.isLoadingOrders = NO;
        LogInfo(@"ERRO: %@ (%ld)",error.localizedDescription, (long)error.code);
        if (error.code == 401) {
            [self presentLoginWithLoginSuccessBlock:^{
                [self loadOrders];
            } dismissBlock:^{
                [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
            }];
        }
        else {
            if (self.isLoadingMore)
            {
                [self.loadMoreCell deactivate];
                
                self.retryButton.hidden = NO;
                self.isLoadingMore = NO;
                self.cancelLoadMore = NO;
            }
            else
            {
                [self setErrorState:error];
                [[UserSession sharedInstance] setCurrentPage:[NSNumber numberWithInteger:self.pageBeforePull]];
                [self reloadUI];
            }
        }
    }];
}

- (void)setEmptyState
{
    self.tryAgainButton.hidden = YES;
    self.buyButton.hidden = NO;
    [self setErrorMessage:[self.messages emptyOrders]];
    self.errorImageView.image = [UIImage imageNamed:@"ic_sem_pedidos"];
}

- (void)setErrorState:(NSError *)error
{
    self.tryAgainButton.hidden = NO;
    self.buyButton.hidden = YES;
    [self setErrorMessage:error.localizedDescription];
    self.errorImageView.image = [UIImage imageNamed:@"UISharedSadface.png"];
}

- (void)increasePage
{
    UserSession *userSession = [UserSession sharedInstance];
    [userSession setCurrentPage:[NSNumber numberWithInteger:(userSession.currentPage.integerValue) + 1]];
}

- (void)updatePageForLoadMore
{
    UserSession *userSession = [UserSession sharedInstance];
    if (userSession.currentPage.integerValue == 0)
    {
        [[UserSession sharedInstance] setCurrentPage:[NSNumber numberWithInteger:(userSession.currentPage.integerValue) + 1]];
    }
}

- (void)reloadOrders:(UIRefreshControl *)refreshControl
{
    self.endOfOrdersReached = NO;
    
    if (self.isLoadingMore)
    {
        self.cancelLoadMore = YES;
    }
    
    self.pageBeforePull = [[[UserSession sharedInstance] currentPage] integerValue];
    [[UserSession sharedInstance] resetPagination];
    [self loadOrders];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.endOfOrdersReached) ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == TableViewLoadMoreSection ? 1 : self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == TableViewLoadMoreSection ? 60 : 230;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == TableViewLoadMoreSection)
    {
        static NSString *cellIdentifier = @"LoadMoreCell";
        LoadMoreCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [loadMoreCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.retryButton.hidden = YES;
        self.retryButton.center = loadMoreCell.contentView.center;
        [loadMoreCell.contentView addSubview:self.retryButton];
        
        self.loadMoreCell = loadMoreCell;
        cell = loadMoreCell;
    }
    else
    {
        static NSString *cellIdentifier = @"OrdersCell";
        SHPOrdersTableViewCell *ordersCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [ordersCell configureWithOrder:[self.orders objectAtIndex:indexPath.row]];
        cell = ordersCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TableViewLoadMoreSection && indexPath.row == 0)
    {
        if ((self.orders.count > 0) && (!self.endOfOrdersReached))
        {
            [(LoadMoreCell *)cell activate];
            self.isLoadingMore = YES;
            [self loadOrders];
        }
        else
        {
            [(LoadMoreCell *)cell deactivate];
        }
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TableViewContentDisplaySection)
    {
        OrdersDetailViewController *detail = [[OrdersDetailViewController alloc] initWithNibName:@"OrdersDetailViewController" bundle:nil];
        detail.order = [self.orders objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - Text Fields
- (void)setupFilters
{
    NSDate *today = [NSDate date];
    NSString *oneYearBefore = [NSString stringWithFormat:@"%ld",(long)[[today dateBySubtractingYears:1] year]];
    NSString *twoYearsBefore = [NSString stringWithFormat:@"%ld",(long)[[today dateBySubtractingYears:2] year]];
    NSString *threeYearsBefore = [NSString stringWithFormat:@"%ld",(long)[[today dateBySubtractingYears:3] year]];
    NSString *fourYearsBefore = [NSString stringWithFormat:@"%ld",(long)[[today dateBySubtractingYears:4] year]];
    
    self.statusOptions = @[@"Todos", @"Ativos", @"Entregues", @"Cancelados", @"Vale Troca"];
    self.periodOptions = @[@"Todos", @"30 dias", @"6 meses", oneYearBefore, twoYearsBefore, threeYearsBefore, fourYearsBefore];
    
    [self.statusFilterButton setTitle:self.statusOptions.firstObject forState:UIControlStateNormal];
    [self.periodFilterButton setTitle:self.periodOptions.firstObject forState:UIControlStateNormal];
    
    [self.statusFilterButton addTarget:self action:@selector(statusFilterPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.periodFilterButton addTarget:self action:@selector(periodFilterPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)statusFilterPressed
{
    self.filterButton = self.statusFilterButton;
    [self.filterButton activate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerWillDismiss) name:CustomPickerViewWillDismissNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerWillSelect:) name:CustomPickerViewWillSelectNotification object:nil];
    [CustomPickerView presentPickerViewWithOptions:self.statusOptions];
}

- (void)periodFilterPressed
{
    self.filterButton = self.periodFilterButton;
    [self.filterButton activate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerWillDismiss) name:CustomPickerViewWillDismissNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerWillSelect:) name:CustomPickerViewWillSelectNotification object:nil];
    [CustomPickerView presentPickerViewWithOptions:self.periodOptions];
}

#pragma mark - Custom Picker
- (void)pickerWillDismiss
{
    [self dismissCustomPickerView];
}

- (void)pickerWillSelect:(NSNotification *)notification
{
    NSDictionary *infos = notification.userInfo;
    NSNumber *selectedIndex = [infos objectForKey:CustomPickerViewSelectedIndexKey];
    NSString *titleSelected;
    
    if (selectedIndex)
    {
        if (self.filterButton == self.statusFilterButton)
        {
            titleSelected = self.statusOptions[selectedIndex.integerValue];
        }
        else
        {
            titleSelected = self.periodOptions[selectedIndex.integerValue];
        }
        
        [self dismissCustomPickerView];
        [self.filterButton setTitle:titleSelected forState:UIControlStateNormal];
    }
}

- (void)dismissCustomPickerView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CustomPickerViewWillDismissNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CustomPickerViewWillSelectNotification object:nil];
    [self.filterButton deactivate];
}

#pragma mark - Reload
- (void)reload
{
    [self loadOrders];
}

#pragma mark - Layout
- (void)reloadUI
{
    if (self.orders.count <= 0)
    {
        self.emptyView.hidden = NO;
        self.ordersTableView.hidden = YES;
    }
    else
    {
        self.emptyView.hidden = YES;
        self.ordersTableView.hidden = NO;
        [self.ordersTableView reloadData];
    }
    
    self.isLoadingOrders = NO;
    self.isLoadingMore = NO;
    self.cancelLoadMore = NO;
    
    if (self.pullToRefreshControl != nil && self.pullToRefreshControl.isRefreshing == TRUE)
    {
        [self.pullToRefreshControl endRefreshing];
    }
}

- (void)setLayout
{
    self.title = [self.messages ordersTitle];    
    [self.buyButton setup];
    
    if ([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.retryButton = [[WMButtonRounded alloc] initWithFrame:CGRectMake(0, 0, 210, 34)];
    self.retryButton.roundedButtonStyle = 8;
    [self.retryButton addTarget:self action:@selector(retryButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [[self.retryButton titleLabel] setFont:[UIFont fontWithName:@"Roboto-Regular" size:14]];
    [self.retryButton setTitle:@"Tentar novamente" forState:UIControlStateNormal];
}

- (void)retryButtonTouched {

    [self.loadMoreCell activate];
    self.retryButton.hidden = YES;
    self.isLoadingMore = YES;
    [self loadOrders];

}

#pragma mark - Push
- (void)orderUpdatePushNotificationReceived:(NSNotification *)notification
{
    if (notification.userInfo)
    {
        Order *order = [Order new];
        order.orderId = notification.userInfo[OrderIDKey];
        if (![order.orderId isEqualToString:@""])
        {
            OrdersDetailViewController *detail = [[OrdersDetailViewController alloc] initWithNibName:@"OrdersDetailViewController" bundle:nil];
            detail.order = order;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[navigationController.navigationBar subviews] makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    });
}

- (void)showLoading
{
    self.orders = @[];
    [self.ordersTableView reloadData];
    [self hideTableViewHeader];
    [self removePullToRefresh];
    [_loader startAnimating];
}

- (void)hideLoading
{
    [self showTableViewHeader];
    [self setupPullToRefresh];
    
    [_loader stopAnimating];
}

#pragma mark - Go To Shopping
- (void)goToShopping
{
    [[WALMenuViewController singleton] presentHomeWithAnimation:YES reset:NO];
}

#pragma mark - Error
- (void)setErrorMessage:(NSString *)message
{
    self.emptyMessageLabel.text = message.length > 0 ? message : [self.messages errorMyAccount];
}

- (void)showErrorWithMessage:(NSString *)message
{
    [self.navigationController.view showAlertWithMessage:message.length > 0 ? message : [_messages errorMyAccount]];
}

@end
