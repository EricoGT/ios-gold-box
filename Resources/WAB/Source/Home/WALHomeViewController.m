//
//  WALHomeViewController.m
//  Walmart
//
//  Created by Renan on 8/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WALHomeViewController.h"
#import "WALMenuViewController.h"

#import "HomeModel.h"

#import "WBRHomeManager.h"
#import "WishlistConnection.h"

#import "VariationPopup.h"

#import "ModelBannerContent.h"
#import "BannerManagerView.h"
#import "HomeShowcaseTableViewCell.h"
#import "FeedbackBannerView.h"
#import "ErrataView.h"
#import "ThemeManager.h"
#import "WalmartTheme.h"
#import "FeedbackAlertView.h"

#import "OFFeedback.h"
#import "PushHandler.h"

#import "ShowcaseTrackerModel.h"
#import "WALShowcaseTrackerManager.h"

#import "ProductDetailConnection.h"

#import "WALHomeCache.h"
#import "WALDynamicShowcasesCache.h"

#import "WMBSearchView.h"
#import "SearchOrchestrator.h"

#import "WBRSetupManager.h"
#import "WBRHomeManager.h"
#import "TimeManager.h"
#import "WALHomeCache.h"
#import "WMWebViewController.h"
#import "OrdersViewController.h"
#import "WMMyAccountViewController.h"
#import "WBRStampCampaign.h"
#import "WBRCustomSearchBar.h"

#define kOmnitureWithlistHomePageType @"home"
#define kRetryToleranceInterval 30

typedef enum HomeSections : NSInteger {
    HeaderBannerSection = 0,
    ShowcasesSection = 1,
    ShowcasesSeparatorSection = 2,
    FooterBannerSection = 3,
    FeedbackSection = 4,
    ErrataSection = 5
} HomeSections;

@interface WALHomeViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, HomeShowcaseTableViewCellDelegate, BannerManagerViewDelegate, SearchOrchestratorDelegate>

@property (weak, nonatomic) IBOutlet WBRCustomSearchBar *customSearchBar;
@property (strong, nonatomic) IBOutlet UIView *showcasesView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *retryView;
@property (strong, nonatomic) IBOutlet WMBSearchView *searchView;

@property (strong, nonatomic) IBOutlet UIView *bottomBannerView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBannerImageView;
@property (strong, nonatomic) WBRStampCampaign *stampCampaign;

@property (strong, nonatomic) SearchOrchestrator *searchOrchestrator;

@property (strong, nonatomic) NSMutableDictionary *collectionViewsContentOffsets;

@property (strong, nonatomic) BannerManagerView *headerBannerViewController;
@property (strong, nonatomic) UIView *showcasesSeparator;
@property (strong, nonatomic) FeedbackBannerView *feedbackBanner;
@property (strong, nonatomic) BannerManagerView *footerBannerViewController;
@property (strong, nonatomic) ErrataView *errataView;

@property (strong, nonatomic) NSArray *dynamicShowcases;
@property (strong, nonatomic) NSArray *allShowcases;

@property (strong, nonatomic) NSDate *lastRetryDate;

@property (assign, nonatomic) BOOL isLoadingStaticHome;
@property (assign, nonatomic) BOOL isLoadingDynamicHome;
@property (assign, nonatomic) BOOL showBottomBanner;

@end

@implementation WALHomeViewController

static NSString * const showcaseCellReuseIdentifier = @"HomeShowcaseTableViewCell";

- (WALHomeViewController *)init {
    BOOL enableWishlist = [OFSetup enableWishlist];
    self = [super initWithTitle:nil isModal:NO searchButton:NO cartButton:YES wishlistButton:enableWishlist];
    if (self) {
        _collectionViewsContentOffsets = [NSMutableDictionary new];
        
        _searchOrchestrator = [SearchOrchestrator new];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [WMUTMIManager clean];
    
    dispatch_async(dispatch_get_main_queue(), ^{    
        if ([WALHomeCache homeFromCache]) {
            [WBRHomeManager registerShowcases:self.home.showcases];
        }
        if ([WALDynamicShowcasesCache dynamicShowcasesFromCache]) {
            [WBRHomeManager registerShowcases:self.dynamicShowcases];
        }
    });
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkCustomOpens];
    [FlurryWM logEvent_home_entering];
    _isLoadingHome = NO;
    [WMOmniture trackHomeEntering];
    
//    [self refreshHome];
    [self loadHome];
    [WALHomeCache setCustomRefreshTime:EXPIRE_SECONDS_HOME_STATIC];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showBottomBanner = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wishlistDidChange:) name:kWishlistNotificationName object:nil];
    
    // TODO: improve this
    CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.navigationController.navigationBar.frame), CGRectGetWidth(self.navigationController.navigationBar.frame), 1.0f);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
    [bottomBorder setBackgroundColor:RGB(26, 117, 207)];
    [self.navigationController.navigationBar addSubview:bottomBorder];
    
    if (self.title.length == 0) {
        UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_walmart_home"]];
        [logoView setFrame:CGRectMake(-40, 0, 108, 24)];
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoView];
        UIBarButtonItem *blankSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        blankSpace.width = -20;
        
        if (self.navigationItem.leftBarButtonItems.count > 0) {
            UIBarButtonItem *menuBarButton = self.navigationItem.leftBarButtonItems.firstObject;
            self.navigationItem.leftBarButtonItems = @[menuBarButton, blankSpace, barButtonItem];
        }
    }
    
    [[PushHandler new] registerForPushNotificationsOnWalmartServer];
    [_tableView registerNib:[UINib nibWithNibName:@"HomeShowcaseTableViewCell" bundle:nil] forCellReuseIdentifier:showcaseCellReuseIdentifier];
    
    self.feedbackBanner = [[FeedbackBannerView alloc] initWithWithButtonPressedBlock:^{
        [self pressedFeedback];
    }];
    
    [self applyTheme];
    
    _searchOrchestrator.searchBar = self.customSearchBar;
    _searchOrchestrator.searchView = _searchView;
    _searchOrchestrator.presenterController = self;
    _searchOrchestrator.delegate = self;
    
    self.state = HomeStateShowcases;
}

#pragma mark Bottom Banner
- (void)setImageBottomBanner {
    BOOL isBottomBannerActive = [[WALMenuViewController singleton].services.masterCampaign boolValue];

    __weak WALHomeViewController *weakSelf = self;
    [WBRSetupManager getStampCampaign:^(WBRStampCampaign *stampModel) {
        weakSelf.stampCampaign = stampModel;
        if (isBottomBannerActive && weakSelf.showBottomBanner) {
            [weakSelf.bottomBannerImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.stampCampaign.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [weakSelf handleBottomBanner:weakSelf.showBottomBanner];
                }
            }];
        }
    } failure:^(NSDictionary *dictError) {
        LogErro(@"Stamp Campaign Error");
    }];
    
    
}

- (void)handleBottomBanner:(BOOL)showBanner {
    
    if (showBanner) {
        [self showBottomBannerView];
    } else {
        [self hideBottomBannerView];
    }
}

- (void)hideBottomBannerView {
    [UIView animateWithDuration:.2
                     animations:^{
                         [self.bottomBannerView setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                         [self.bottomBannerView setHidden:YES];
                         [self.tableView setContentInset:(UIEdgeInsetsZero)];
                     }];
}

- (void)showBottomBannerView {
    [UIView animateWithDuration:.2
                     animations:^{
                         [self.bottomBannerView setAlpha:1.0];
                     }
                     completion:^(BOOL finished){
                         [self.bottomBannerView setHidden:NO];
                         [self.tableView setContentInset:(UIEdgeInsetsMake(0, 0, self.bottomBannerView.frame.size.height + 10, 0))];
                     }];
}

- (IBAction)tapCloseBottomBanner:(id)sender {
    self.showBottomBanner = NO;
    [self hideBottomBannerView];
}

- (IBAction)tapOpenBottomBanner:(id)sender {
    
    __weak WALHomeViewController *weakSelf = self;
    [WBRSetupManager getStampCampaign:^(WBRStampCampaign *stampModel) {
        NSString *masterCardInfoCampaingText = [NSString stringWithFormat:@"<span style=\"font-family: Roboto-Regular; font-size: 35\">%@</span>", stampModel.disclaimer];

        WMWebViewController *disclaimerInfoWebView = [[WMWebViewController alloc] initWithHtmlString:masterCardInfoCampaingText title:stampModel.title];
        WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:disclaimerInfoWebView];
        [weakSelf presentViewController:container animated:YES completion:nil];

    } failure:^(NSDictionary *dictError) {
        LogErro(@"Open Stamp Campaign Error");
    }];
    
}

#pragma mark - Refresh Home
- (void) refreshHome {
    _isLoadingHome = NO;
    [self loadHome];
    [self updateAllShowcasesArray];
}


- (void)setState:(HomeState)state {
    _showcasesView.hidden = state != HomeStateShowcases;
    _searchView.hidden = state != HomeStateSearch;
    
    if (state == HomeStateShowcases) {
        [_searchOrchestrator resetSearch];
    }
    
    _state = state;
}

- (void)updateAllShowcasesArray {
    LogInfo(@"Table update: updateAllShowcasesArray entered");
    NSMutableArray *allShowcasesMutable = [NSMutableArray new];
    [allShowcasesMutable addObjectsFromArray:_dynamicShowcases ?: @[]];
    [allShowcasesMutable addObjectsFromArray:_home.showcases ?: @[]];
    
    NSSortDescriptor *showcasesSort = [NSSortDescriptor sortDescriptorWithKey:@"orderId" ascending:YES];
    self.allShowcases = [allShowcasesMutable sortedArrayUsingDescriptors:@[showcasesSort]];
    LogInfo(@"Table update: RELOAD SECTIONS");
    
    if (!_isLoadingStaticHome && !_isLoadingDynamicHome) {
        LogInfo(@"Table update: updateAllShowcasesArray - not loading static and dynamic");
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:ShowcasesSection] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        
        if (_allShowcases.count > 0) {
            // TODO: find a way to remove the flick caused by table view animation
            [_showcasesView performSelector:@selector(hideLoading) withObject:nil afterDelay:0.5f];
        }
        else {
            [self showRetry];
        }
        
        self.isLoadingHome = NO;
    }
}

- (void)setHome:(HomeModel *)home {
    LogInfo(@"Table update: setHome");
    
    _home = home;
    
    [self applySkin];
    
    if (!_headerBannerViewController) {
        self.headerBannerViewController = [BannerManagerView new];
        _headerBannerViewController.delegate = self;
    }
    
    if (!_footerBannerViewController) {
        self.footerBannerViewController = [BannerManagerView new];
//        _footerBannerViewController.accessibilityIdentifier = @"bannerManager2";
        [_footerBannerViewController setIsFooter:YES];
        _footerBannerViewController.delegate = self;
        
    }
    
    //Verify by banners
    __weak WALHomeViewController *weakSelf = self;
    [WBRSetupManager getBanners:^(ModelBanner *bannerModel) {
        
        LogMicro(@"\n\n[BANNERS] Banners Model: %@", bannerModel);
        [weakSelf.headerBannerViewController setBannerModels:bannerModel.top.mutableCopy];
        [weakSelf.footerBannerViewController setBannerModels:bannerModel.bottom.mutableCopy];
        [weakSelf.footerBannerViewController setIsFooter:YES];
        [weakSelf setImageBottomBanner];

    } failure:^(NSDictionary *dictError) {
        
        [weakSelf.headerBannerViewController setBannerModels:nil];
        [weakSelf.footerBannerViewController setBannerModels:nil];
    }];
    
    
    self.showcasesSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 15.0f)];
    
    
    //Verify if there is an errata or not
    [WBRSetupManager getErrata:^(ModelErrata *errataModel) {
        
        LogMicro(@"\n\n[ERRATA] Errata Model: %@", errataModel);
        
        if (errataModel) {
            weakSelf.errataView = [[ErrataView alloc] initWithErrataModel:errataModel tappedBlock:^{
                [weakSelf tappedErrata:errataModel];
            }];
        }
        else {
            weakSelf.errataView = nil;
        }
        
    } failure:^(NSDictionary *dictError) {
        
        LogErro(@"[ERRATA] Error: %@", dictError);
        
        weakSelf.errataView = nil;
    }];
    
    self.isLoadingStaticHome = NO;
    
    [self updateAllShowcasesArray];
}

- (void)setDynamicShowcases:(NSArray *)dynamicShowcases {
    LogInfo(@"Table update: setDynamicShowcases");
    _dynamicShowcases = dynamicShowcases;
    
    self.isLoadingDynamicHome = NO;
    [self updateAllShowcasesArray];
}

#pragma mark - Connection
- (void)loadHome {
    if (_isLoadingHome) return;
    
    self.isLoadingHome = YES;
    
    if (!_retryView.hidden) {
        _retryView.hidden = YES;
        [_showcasesView showLoadingWithLoaderColor:[ThemeManager theme].headerColor];
    }
    
    HomeModel *homeFromCache = [WALHomeCache homeFromCache];
    if (homeFromCache) {
        if (!_home) {
            [self setHome:homeFromCache];
        }
    }
    else {
        [self loadStaticHome];
    }
    
    NSArray *dynamicShowcasesFromCache = [WALDynamicShowcasesCache dynamicShowcasesFromCache];
    if (dynamicShowcasesFromCache) {
        if (!_dynamicShowcases) {
            [self setDynamicShowcases:dynamicShowcasesFromCache];
        }
    }
    else {
        
        //Verify if dynamic home must be loaded
        __weak WALHomeViewController *weakSelf = self;
        [WBRSetupManager getServices:^(ModelServices *servicesModel) {
            LogMicro(@"\n\n[SERVICES] Services Model: %@", servicesModel);
            
            if (servicesModel.showDynamicHomeIos.boolValue) {
                [weakSelf loadDynamicHome];
            }
            
        } failure:^(NSDictionary *dictError) {
            LogErro(@"[SERVICES] Error: %@", dictError);
        }];
    }
}

- (void)loadStaticHome {
    if (_isLoadingStaticHome) return;
    
    self.isLoadingStaticHome = YES;
    
    [_showcasesView showLoadingWithLoaderColor:[ThemeManager theme].headerColor];
    
    LogInfo(@"From Class: %@", NSStringFromClass([self class]));
    NSString *previousMethod = [self getCallerStackSymbol];
    LogMicro(@"Previous Method: %@", previousMethod);
    
    __weak WALHomeViewController *weakSelf = self;
    [WBRHomeManager loadStaticHomeWithSuccessBlock:^(HomeModel *home) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setHome:home];
            [WALHomeCache save:home];
            [WBRHomeManager registerShowcases:home.showcases];
        });
    } failureBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setHome:nil];
        });
    }];
}

- (void)loadDynamicHome {
    if (_isLoadingDynamicHome) return;
    
    self.isLoadingDynamicHome = YES;
    
    if (_allShowcases.count > 0) {
        NSMutableArray *refreshingShowcasesIndexPaths = [NSMutableArray new];
        for (ShowcaseModel *showcase in _allShowcases) {
            if (showcase.dynamic) {
                showcase.isRefreshing = YES;
                NSIndexPath *showcaseIndexPath = [NSIndexPath indexPathForRow:[_allShowcases indexOfObject:showcase] inSection:ShowcasesSection];
                [refreshingShowcasesIndexPaths addObject:showcaseIndexPath];
            }
        }
        
        if (refreshingShowcasesIndexPaths.count > 0) {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:refreshingShowcasesIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }
    else {
        [_showcasesView showLoadingWithLoaderColor:[ThemeManager theme].headerColor];
    }
    
    __weak WALHomeViewController *weakSelf = self;
    [WBRHomeManager loadDynamicHomeWithSuccessBlock:^(NSArray *dynamicShowcases) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setDynamicShowcases:dynamicShowcases];
            if (dynamicShowcases.count > 0) {
                [WALDynamicShowcasesCache save:dynamicShowcases];
                [WBRHomeManager registerShowcases:dynamicShowcases];
            } else {
                [WALDynamicShowcasesCache clean];
            }
        });
    } failureBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setDynamicShowcases:nil];
        });
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        //We have to reset the positions dictionary here because the tableView delegate executes didEndDisplayingCell: before cellForRowAtIndexPath: when we call reloadData
        self.collectionViewsContentOffsets = [NSMutableDictionary new];
        return 7;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView && section == ShowcasesSection) {
        return _allShowcases.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LogInfo(@"Cell for row at indexpath row count: %ld", (unsigned long) _allShowcases.count);
    ShowcaseModel *showcase = _allShowcases[indexPath.row];
    HomeShowcaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showcaseCellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.collectionView.tag = indexPath.row;
    if (_collectionViewsContentOffsets[showcase.showcaseId]) {
        CGFloat xPosition = [_collectionViewsContentOffsets[showcase.showcaseId] floatValue];
        cell.collectionView.contentOffset = CGPointMake(xPosition, 0);
    }
    else {
        cell.collectionView.contentOffset = CGPointZero;
    }
    [cell setupWithShowcase:showcase];
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ShowcasesSection && _allShowcases.count > indexPath.row) {
        ShowcaseModel *showcase = _allShowcases[indexPath.row];
        HomeShowcaseTableViewCell *showcaseCell = (HomeShowcaseTableViewCell *)cell;
        UICollectionView *collection = showcaseCell.collectionView;
        _collectionViewsContentOffsets[showcase.showcaseId] = @(collection.contentOffset.x);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView;
    switch (section) {
        case HeaderBannerSection:
            headerView = _headerBannerViewController.readyToDisplay ? _headerBannerViewController : nil;
            break;
            
        case ShowcasesSection:
            headerView = nil;
            break;
            
        case ShowcasesSeparatorSection:
            headerView = _showcasesSeparator;
            break;
            
        case FeedbackSection:
            headerView = _feedbackBanner;
            break;
            
        case FooterBannerSection:
            headerView = _footerBannerViewController.readyToDisplay ? _footerBannerViewController : nil;
            break;
            
        case ErrataSection:
            headerView = _errataView;
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UIView *headerView;
    switch (section) {
        case HeaderBannerSection:
            headerView = _headerBannerViewController.readyToDisplay ? _headerBannerViewController : nil;
            break;
            
        case ShowcasesSection:
            headerView = nil;
            break;
            
        case ShowcasesSeparatorSection:
            headerView = _showcasesSeparator;
            break;
            
        case FeedbackSection:
            headerView = _feedbackBanner;
            break;
            
        case FooterBannerSection:
            headerView = _footerBannerViewController.readyToDisplay ? _footerBannerViewController : nil;
            break;
            
        case ErrataSection:
            headerView = _errataView;
            break;
    }
    return headerView.bounds.size.height;
}

#pragma mark - HomeShowcaseTableViewCellDelegate
- (void)selectedProduct:(NSString *)productId showcase:(ShowcaseModel *)showcase {
    for (NSInteger i = 0; i < _allShowcases.count; i++) {
        ShowcaseModel *homeShowcase = _allShowcases[i];
        if ([homeShowcase.showcaseId isEqualToString:showcase.showcaseId]) {
            UTMIModel *utmi = [WMUTMIManager UTMI];
            utmi.modulePosition = @(i + 1).stringValue;
            [WMUTMIManager storeUTMI:utmi];
            break;
        }
    }
    
    if (showcase.showcaseId.length > 0) {
        ShowcaseTrackerModel *showcaseTracker = [ShowcaseTrackerModel new];
        showcaseTracker.showcaseId = showcase.showcaseId;
        showcaseTracker.showcaseName = showcase.name;
        [WALShowcaseTrackerManager storeShowcaseTracking:showcaseTracker];
    }
    [self openProductWithID:productId fromShowcaseId:showcase.showcaseId];
}

- (void)homeShowcaseCell:(id)homeShowcaseCell tappedHeartButtonForProductAtIndex:(NSUInteger)productIndex {
    NSIndexPath *showcaseIndexPath = [_tableView indexPathForCell:homeShowcaseCell];
    if (showcaseIndexPath && showcaseIndexPath.row >= _allShowcases.count) return;
    
    ShowcaseModel *showcase = _allShowcases[showcaseIndexPath.row];
    
    if (productIndex >= showcase.products.count) return;
    
    ShowcaseProductModel *product = showcase.products[productIndex];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:product];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"showcaseHeart"];
    
    if (product.hasSkuOptions.boolValue && !product.wishlist) {
        VariationPopup *variationPopup = [[VariationPopup alloc] initWithProductId:product.productId.stringValue selectedSKUBlock:^(NSNumber *sku) {
            product.favoriteSKU = sku;
            [self favoriteProduct:product completionBlock:nil];
        }];
        
        UIViewController *controller = self.navigationController ?: self;
        [controller.view addSubview:variationPopup];
    }
    else {
        product.wishlist ? [self unfavoriteProduct:product completionBlock:nil] : [self favoriteProduct:product completionBlock:nil];
    }
}

- (void)favoriteProduct:(ShowcaseProductModel *)product completionBlock:(void (^)())completionBlock {
    if (![WALSession isAuthenticated]) {
        [self presentLoginWithLoginSuccessBlock:^{
            [self favoriteProduct:product completionBlock:^{
                [self performSelector:@selector(loadDynamicHome) withObject:nil afterDelay:1.0f];
            }];
        }];
        return;
    }
    
    NSString *productId = product.productId.stringValue;
    NSNumber *cardSKU = product.skuId;
    NSNumber *favoriteSKU = product.favoriteSKU;
    NSString *sellerId = product.sellerId;
    
    [self setPulse:YES forProductsWithSKU:cardSKU];
    
    [[WishlistConnection new] addProductWithSKU:favoriteSKU.stringValue productID:productId sellerId:sellerId completion:^(BOOL success, NSError *error) {
        if (success) {
            [WMOmniture trackAddToWishlistWithSellerId:sellerId sku:favoriteSKU pageType:kOmnitureWithlistHomePageType];
        }
        else {
            if (error.code == 409) {
                [self setFavorite:YES forProductsWithSKU:cardSKU];
            } else {
                [self setPulse:NO forProductsWithSKU:cardSKU];
                if (error.code == 401) {
                    [self presentLoginWithLoginSuccessBlock:^{
                        [self favoriteProduct:product completionBlock:nil];
                    }];
                    return;
                }
                else if (error.code == 422)
                {
                    [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
                }
            }
        }
        if (completionBlock) completionBlock();
    }];
}

- (void)unfavoriteProduct:(ShowcaseProductModel *)product completionBlock:(void (^)())completionBlock {
    if (![WALSession isAuthenticated]) {
        [self presentLoginWithLoginSuccessBlock:^{
            [self unfavoriteProduct:product completionBlock:nil];
        }];
        return;
    }
    
    NSNumber *cardSKU = product.skuId;
    NSNumber *favoriteSKU = product.favoriteSKU;
    NSString *sellerId = product.sellerId;
    
    [self setPulse:YES forProductsWithSKU:cardSKU];
    
    [[WishlistConnection new] removeProductWithSKU:favoriteSKU.stringValue productId:product.productId.stringValue completion:^(BOOL success, NSError *error) {
        if (success) {
            [WMOmniture trackRemoveFromWishlistWithSellerId:sellerId sku:favoriteSKU pageType:kOmnitureWithlistHomePageType];
        }
        else {
            [self setPulse:NO forProductsWithSKU:cardSKU];
            if (error.code == 401) {
                
                [self presentLoginWithLoginSuccessBlock:^{
                    [self unfavoriteProduct:product completionBlock:nil];
                    return;
                }];
            }
        }
        if (completionBlock) completionBlock();
    }];
}

- (void)setPulse:(BOOL)pulse forProductsWithSKU:(NSNumber *)sku {
    for (ShowcaseModel *showcase in _allShowcases) {
        for (ShowcaseProductModel *product in showcase.products) {
            if ([product.skuId isEqual:sku]) {
                product.isRefreshingWishlistStatus = pulse;
                break;
            }
        }
    }
    [self refreshProductsWithSKU:sku];
}

- (void)setFavorite:(BOOL)favorite forProductsWithSKU:(NSNumber *)sku {
    for (ShowcaseModel *showcase in _allShowcases) {
        for (ShowcaseProductModel *product in showcase.products) {
            if ([product.skuId isEqual:sku]) {
                product.wishlist = favorite;
                break;
            }
        }
    }
    [self refreshProductsWithSKU:sku];
}

- (void)refreshProductsWithSKU:(NSNumber *)sku {
    for (UITableViewCell *cell in _tableView.visibleCells) {
        if ([cell isKindOfClass:[HomeShowcaseTableViewCell class]]) {
            HomeShowcaseTableViewCell *showcaseCell = (HomeShowcaseTableViewCell *) cell;
            [showcaseCell refreshProductsWithSKU:sku];
        }
    }
}

#pragma mark - Retry
- (void)showRetry {
    [_showcasesView hideLoading];
    _retryView.hidden = NO;
}

- (IBAction)retry {
    NSDate *now = [NSDate date];
    if (!_lastRetryDate || ([now timeIntervalSince1970] - [_lastRetryDate timeIntervalSince1970] > kRetryToleranceInterval)) {
        self.lastRetryDate = now;
        [self loadHome];
    }
}

#pragma mark - WALBannerViewControllerDelegate
- (void)bannerManagerView:(BannerManagerView *)bannerManagerView loadedAllBannersWithContentSize:(CGSize)contentSize {
    
    if (contentSize.width > 0) {
        bannerManagerView.frame = CGRectMake(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.width / contentSize.width * contentSize.height);
        [_tableView reloadData];
    }
}

- (void)bannerManagerView:(BannerManagerView *)bannerManagerView tappedBanner:(ModelBannerContent *)banner {
    NSString *bannerName = banner.name;
    
    NSString *separator = @"|";
    NSString *moduleLabel;
    NSString *internalLabel;
    
    if ([banner.name rangeOfString:separator].location != NSNotFound) {
        NSUInteger pipeIndex = [bannerName rangeOfString:separator].location;
        moduleLabel = [bannerName substringToIndex:pipeIndex];
        internalLabel = [bannerName substringFromIndex:pipeIndex + 1];
    }
    else {
        moduleLabel = banner.name;
    }
    
    NSArray *banners = bannerManagerView == _headerBannerViewController ? _home.topBanners : _home.bottomBanners;
    
    UTMIModel *UTMI = [WMUTMIManager UTMI];
    [UTMI setType:UTMITypeBan];
    [UTMI setSection:[self UTMIIdentifier] cleanOtherFields:YES];
    [UTMI setModule:bannerManagerView == _headerBannerViewController ? @"banner-topo" : @"banner-footer"];
    [UTMI setModuleLabel:moduleLabel];
    [UTMI setModulePosition:@([banners indexOfObject:banner] + 1).stringValue];
    [UTMI setInternalLabel:internalLabel];
    [WMUTMIManager storeUTMI:UTMI];
    
    if (banner.productId) {
        [self openProductWithID:banner.productId.stringValue];
    }
    else if (banner.target.length > 0) {
        LogInfo(@"Banner link: %@", banner.target);
        [self openSearchWithQuery:banner.target completionBlock:nil];
    }
    else if (banner.url.length > 0) {
        NSURL *url = [NSURL URLWithString:banner.url];
        UIApplication *application = [UIApplication sharedApplication];
        if ([application canOpenURL:url]) {
            [application openURL:url];
        }
    }
}

#pragma mark - DiscountStampsViewControllerDelegate
- (void)selectedMenuGroupItemWithTarget:(NSString *)target {
    [self openSearchWithQuery:target completionBlock:nil];
}

#pragma mark - FeedbackBannerViewDelegate
- (void)pressedFeedback {
    LogInfo(@"Pressed feedback");
    
    OFFeedback *feedback = [[OFFeedback alloc] initWithIsModal:YES];
    WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:feedback];
    [self presentViewController:container animated:YES completion:nil];
}

#pragma mark - ErrataViewDelegate
- (void)tappedErrata:(ModelErrata *) errataModel {
    if (errataModel.url.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:errataModel.url]];
    }
}

#pragma mark - SeachOrchestratorDelegate
- (void)searchOrchestratorSearchBarDidBeginEditing {
    self.state = HomeStateSearch;
}

- (void)searchOrchestratorSearchBarCancelButtonClicked {
    self.state = HomeStateShowcases;
}

- (void)searchOrchestratorSearchBarOpenOrders {
    
    BOOL activeSession = [WALSession isAuthenticated];
    
    if (activeSession) {
        [self openOrders];
    } else {
        __weak WALHomeViewController *weakSelf = self;
        [self presentLoginWithLoginSuccessBlock:^{
            if (weakSelf != nil) {
                [self openOrders];
            }
        }];
    }
}

- (void)searchOrchestratorSearchBarOpenMyAccount {
    
    BOOL activeSession = [WALSession isAuthenticated];
    
    if (activeSession) {
        [self openMyAccount];
    } else {
        __weak WALHomeViewController *weakSelf = self;
        [self presentLoginWithLoginSuccessBlock:^{
            if (weakSelf != nil) {
                [weakSelf openMyAccount];
            }
        }];
    }
}

- (void)openOrders {
    OrdersViewController *orderViewController = [[OrdersViewController alloc] initWithNibName:@"OrdersViewController" bundle:nil];
    [self.navigationController pushViewController:orderViewController animated:YES];
}

- (void)openMyAccount {
    WMMyAccountViewController *myAccountViewController = [[WMMyAccountViewController alloc] initWithNibName:@"WMMyAccountViewController" bundle:nil];
    [self.navigationController pushViewController:myAccountViewController animated:YES];
}

#pragma mark - UTMI
- (NSString *)UTMIIdentifier {
    return @"home";
}

#pragma mark - Skin
- (void) applySkin {
    
    //Skin
    __weak WALHomeViewController *weakSelf = self;
    [WBRSetupManager getSkin:^(ModelSkin *skinModel) {
        
        if (skinModel) {
            
            WalmartTheme *theme = [WalmartTheme new];
            
            UIColor *bgColor = RGBA([skinModel.bgColor.r floatValue], [skinModel.bgColor.g floatValue], [skinModel.bgColor.b floatValue], [skinModel.bgColor.a floatValue]);
            UIColor *headerColor = RGBA(skinModel.textShowcaseColor.r.floatValue, skinModel.textShowcaseColor.g.floatValue, skinModel.textShowcaseColor.b.floatValue, skinModel.textShowcaseColor.a.floatValue);
           UIColor *pageControlHighlightColor = RGBA(skinModel.textShowcaseColor.r.floatValue, skinModel.textShowcaseColor.g.floatValue, skinModel.textShowcaseColor.b.floatValue, skinModel.textShowcaseColor.a.floatValue);
            UIColor *pageControlColor = RGBA(skinModel.textShowcaseColor.r.floatValue, skinModel.textShowcaseColor.g.floatValue, skinModel.textShowcaseColor.b.floatValue, skinModel.textShowcaseColor.a.floatValue);
            
            theme.backgroundColor = bgColor;
            theme.headerColor = headerColor;
            theme.pageControlColor =pageControlColor;
            theme.pageControlHighlightColor = pageControlHighlightColor;
            
            weakSelf.view.backgroundColor = bgColor;
            
            [ThemeManager setTheme:theme];
        }
        else {
            [ThemeManager setTheme:[ThemeManager defaultTheme]];
        }
        
        [weakSelf applyTheme];
        
        LogMicro(@"\n\n[SKIN] Skin Model: %@", skinModel);
        LogMicro(@"[SKIN] Skin Model TextShowcaseColor: %@", skinModel.textShowcaseColor);
        LogMicro(@"[SKIN] Skin Model BgColor: %@", skinModel.bgColor);
        
    } failure:^(NSDictionary *dictError) {
        LogErro(@"[SKIN] Error: %@", dictError);
        
        [ThemeManager setTheme:[ThemeManager defaultTheme]];
        [weakSelf applyTheme];
        
    }];
}

//#pragma mark - Theme
//- (void)setupTheme:(HomeSkinModel *)skin {
//    if (skin) {
//        WalmartTheme *theme = [WalmartTheme new];
//        theme.backgroundColor = skin.bgColor;
//        theme.headerColor = skin.headerColor;
//        [ThemeManager setTheme:theme];
//    }
//    else {
//        [ThemeManager setTheme:[ThemeManager defaultTheme]];
//    }
//    
//    [self applyTheme];
//}

- (void)applyTheme {
    WalmartTheme *theme = [ThemeManager theme];
    _showcasesView.backgroundColor = theme.backgroundColor;
    _retryView.backgroundColor = theme.backgroundColor;
}

#pragma mark - Wishlist Notifications
- (void)wishlistDidChange:(NSNotification *)notification {
    NSDictionary *notificationDictionary = notification.object;
    NSArray *productsIds = notificationDictionary[@"productsIds"];
    BOOL wishlist = [notificationDictionary[@"wishlist"] boolValue];
    
    for (NSString *productId in productsIds) {
        for (NSInteger i = 0; i < _allShowcases.count; i++) {
            ShowcaseModel *showcase = _allShowcases[i];
            for (NSInteger j = 0; j < showcase.products.count; j++) {
                ShowcaseProductModel *product = showcase.products[j];
                if ([product.productId.stringValue isEqualToString:productId]) {
                    product.wishlist = wishlist;
                    
                    NSIndexPath *showcaseIndexPath = [NSIndexPath indexPathForRow:i inSection:ShowcasesSection];
                    NSIndexPath *productIndexPath = [NSIndexPath indexPathForItem:j inSection:0];
                    HomeShowcaseTableViewCell *showcaseCell = [_tableView cellForRowAtIndexPath:showcaseIndexPath];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [showcaseCell.collectionView reloadItemsAtIndexPaths:@[productIndexPath]];
                    });
                }
            }
        }
    }
}

#pragma mark - Background event
- (void)handleApplicationWillEnterForeground:(NSNotification *)notification {
    
#if defined CONFIGURATION_DebugCalabash
    [self.customSearchBar resignFirstResponder];
    [_searchOrchestrator dismissSearchSort];
    _showcasesView.hidden = NO;
    _searchView.hidden = YES;
    [_searchOrchestrator resetSearch];
    _state = YES;
#endif
    
    
    [self refreshHome];
}



- (NSString *)getCallerStackSymbol {
    
    NSString *callerStackSymbol = @"Could not track caller stack symbol";
    
    NSArray *stackSymbols = [NSThread callStackSymbols];
    if(stackSymbols.count >= 2) {
        callerStackSymbol = [stackSymbols objectAtIndex:2];
        if(callerStackSymbol) {
            NSMutableArray *callerStackSymbolDetailsArr = [[NSMutableArray alloc] initWithArray:[callerStackSymbol componentsSeparatedByString:@" "]];
            NSUInteger callerStackSymbolIndex = callerStackSymbolDetailsArr.count - 3;
            if (callerStackSymbolDetailsArr.count > callerStackSymbolIndex && [callerStackSymbolDetailsArr objectAtIndex:callerStackSymbolIndex]) {
                callerStackSymbol = [callerStackSymbolDetailsArr objectAtIndex:callerStackSymbolIndex];
                callerStackSymbol = [callerStackSymbol stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }
        }
    }
    
    return callerStackSymbol;
}

@end
