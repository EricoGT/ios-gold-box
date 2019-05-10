//
//  HubOffersTableViewController.m
//  Walmart
//
//  Created by Bruno on 7/7/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "HubOffersViewController.h"
#import "WMLoadingView.h"
#import "ProductCardCell.h"
#import "SearchProductHubConnection.h"
#import "SearchProductVariation.h"
#import "HubConnection.h"
#import "WishlistConnection.h"
#import "OFLoginViewController.h"
#import "WMBaseNavigationController.h"
#import "VariationPopup.h"

#define kOmnitureWithlistOffersPageType @"offers"

@interface HubOffersViewController () <UITableViewDataSource, UITableViewDelegate, ProductCardCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WMLoadingView *loadingView;
@property (strong, nonatomic) HubConnection *connection;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSArray *offers;

@end

static NSString * const reuseIdentifier = @"HubOffersCell";

@implementation HubOffersViewController

- (HubOffersViewController *)initWithCategoryId:(NSString *)categoryId
{
    self = [super initWithNibName:@"HubOffersViewController" bundle:nil];
    if (self)
    {
        self.categoryId = categoryId;
        self.connection = [HubConnection new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wishlistDidChange:) name:kWishlistNotificationName object:nil];
    
    //Loading init
    self.loadingView = [WMLoadingView new];
    self.loadingView.loader.color = RGBA(26, 117, 207, 1);
    self.loadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.loadingView];
    
    //Register Nibs
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 10, 0);
    [self.tableView registerNib:[ProductCardCell nib] forCellReuseIdentifier:reuseIdentifier];

    //Table View configuration
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self loadOffers];
}

- (void)setOffers:(NSArray *)offers {
    _offers = offers;
    
    [self.tableView reloadData];
    if (offers.count == 0) {
        [self.view showEmptyViewWithMessage:HUB_EMPTY_OFFERS];
    }
}

#pragma mark - Load
- (void)loadOffers
{
    [self startLoading];
    [self.connection loadOffersWithHubId:self.categoryId completionBlock:^(NSArray *offers) {
        [self stopLoading];
        
        self.offers = offers;
    } failure:^(NSError *error) {
        [self stopLoading];
        
        [self.view showRetryViewWithMessage:error.localizedDescription retryBlock:^{
            [self loadOffers];
        }];
    }];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchProductHubConnection *product = [self.offers objectAtIndex:indexPath.row];
    return product.hasDiscount ? 196 : 182;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchProductHubConnection *product = [self.offers objectAtIndex:indexPath.row];
    ProductCardCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    [cell setupWithSearchProductHubConnection:product];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchProductHubConnection *product = [self.offers objectAtIndex:indexPath.row];
    
    UTMIModel *utmi = [WMUTMIManager UTMI];
    [utmi setSection:@"departamento" cleanOtherFields:YES];
    utmi.module = @"vitrine-ofertas";
    utmi.internalPosition = @(indexPath.row + 1).stringValue;
    utmi.internalLabel = product.productID.stringValue;
    [WMUTMIManager storeUTMI:utmi];
    
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(productSelectedOnHubOffer:)])
    {
        [self.delegate productSelectedOnHubOffer:product];
    }
}

#pragma mark - ProductCardCellDelegate
- (void)tappedHeartButtonInProductCell:(id)cell
{
    NSIndexPath *productIndexPath = [_tableView indexPathForCell:cell];
    if (productIndexPath && productIndexPath.row >= _offers.count) return;
    
    SearchProductHubConnection *product = _offers[productIndexPath.row];
    if (productIndexPath.row >= _offers.count) return;
    
    if (product.hasVariations && !product.wishlist)
    {
        VariationPopup *variationPopup = [[VariationPopup alloc] initWithProductId:product.productID.stringValue selectedSKUBlock:^(NSNumber *sku) {
            product.favoriteSKU = sku;
            [self addProductToWishlist:product];
        }];
        
        UIViewController *controller = self.navigationController ?: self;
        [controller.view addSubview:variationPopup];
    }
    else
    {
        product.wishlist ? [self removeProductFromWishlist:product] : [self addProductToWishlist:product];
    }
}

- (void)addProductToWishlist:(SearchProductHubConnection *)product
{
    if (![WALSession isAuthenticated])
    {
        WMBaseViewController *parent = (WMBaseViewController *)self.parentViewController;
        [parent presentLoginWithLoginSuccessBlock:^{
            [self addProductToWishlist:product];
        }];
        return;
    }
    
    NSString *productId = product.productID.stringValue;
    NSNumber *favoriteSKU = product.favoriteSKU;
    SearchProductVariation *variation = product.productVariations[0];
    NSString *sellerId = variation.sellerId;
    
    [self pulseHeart:YES forProduct:product];
    [[WishlistConnection new] addProductWithSKU:favoriteSKU.stringValue productID:productId sellerId:sellerId completion:^(BOOL success, NSError *error) {
        
        if (success) {
            product.wishlist = YES;
            [WMOmniture trackAddToWishlistWithSellerId:sellerId sku:favoriteSKU pageType:kOmnitureWithlistOffersPageType];
        }
        else {
            if (error.code == 400 || error.code == 401)
            {
                WMBaseViewController *parent = (WMBaseViewController *)self.parentViewController;
                [parent presentLoginWithLoginSuccessBlock:^{
                    [self addProductToWishlist:product];
                }];
            }
            else if (error.code == 409) {
                product.wishlist = YES;
            }
            else if (error.code == 422)
            {
                [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
            }
        }
        [self pulseHeart:NO forProduct:product];
    }];
}

- (void)removeProductFromWishlist:(SearchProductHubConnection *)product
{
    if (![WALSession isAuthenticated])
    {
        WMBaseViewController *parent = (WMBaseViewController *)self.parentViewController;
        [parent presentLoginWithLoginSuccessBlock:^{
            [self removeProductFromWishlist:product];
        }];
        return;
    }
    
    [self pulseHeart:YES forProduct:product];
    
    SearchProductVariation *variation = product.productVariations[0];
    NSString *sellerId = variation.sellerId;
    NSNumber *favoriteSKU = product.favoriteSKU;
    
    [[WishlistConnection new] removeProductWithSKU:favoriteSKU.stringValue productId:product.productID.stringValue completion:^(BOOL success, NSError *error) {
        if (success) {
            product.wishlist = NO;
            [WMOmniture trackRemoveFromWishlistWithSellerId:sellerId sku:favoriteSKU pageType:kOmnitureWithlistOffersPageType];
        }
        
        if (error.code == 400 || error.code == 401)
        {
            WMBaseViewController *parent = (WMBaseViewController *)self.parentViewController;
            [parent presentLoginWithLoginSuccessBlock:^{
                [self removeProductFromWishlist:product];
            }];
        }
        [self pulseHeart:NO forProduct:product];
    }];
}

- (void)pulseHeart:(BOOL)pulse forProduct:(SearchProductHubConnection *)product
{
    product.isRefreshingWishlistStatus = pulse;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_offers indexOfObject:product] inSection:0];
    ProductCardCell *cell = (ProductCardCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [cell updateHeartStatusHubConnection];
}

#pragma mark - Loading
- (void)startLoading
{
    self.tableView.hidden = YES;
    self.loadingView.hidden = NO;
}

- (void)stopLoading
{
    self.tableView.hidden = NO;
    self.loadingView.hidden = YES;
}

#pragma mark - Wishlist Notification
- (void)wishlistDidChange:(NSNotification *)notification {
    NSDictionary *notificationDictionary = notification.object;
    NSArray *productsIds = notificationDictionary[@"productsIds"];
    BOOL wishlist = [notificationDictionary[@"wishlist"] boolValue];
    
    for (NSString *productId in productsIds) {
        for (NSInteger i = 0; i < _offers.count; i++) {
            SearchProductHubConnection *product = _offers[i];
            if ([product.productID.stringValue isEqualToString:productId]) {
                product.wishlist = wishlist;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                });
                break;
            }
        }
    }
}

#pragma mark Bottom Banner
- (void)handleTableViewInsets:(UIEdgeInsets)insets {
    [self.tableView setContentInset:insets];
    [self.tableView reloadData];
}


@end
