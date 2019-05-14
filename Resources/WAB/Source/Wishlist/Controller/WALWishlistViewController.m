//
//  WALWishlistViewController.m
//  Walmart
//
//  Created by Bruno on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WALWishlistViewController.h"
#import "OFLoginViewController.h"
#import "WMBaseNavigationController.h"

#import "WishlistConnection.h"
#import "WishlistModel.h"
#import "WishlistCell.h"
#import "WMWebViewController.h"

#import "WishlistTourView.h"

#import "WMParser.h"
#import "WMExtendedViewController.h"

#import "WishlistHeaderView.h"
#import "WishlistActionHeaderView.h"

#import "FeedbackAlertView.h"
#import "WBRSetupManager.h"
#import "WBRCheckoutManager.h"

static NSString * const wishlistCellIdentifier = @"WishlistCellIdentifier";

@interface WALWishlistViewController () <UITableViewDataSource, UITableViewDelegate, WishlistTourViewDelegate, WishlistCellDelegate, WishlistHeaderViewDelegate, WishlistActionHeaderViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emptyViewTopSpaceConstraint;

@property (nonatomic, strong) WishlistConnection *connection;
@property (nonatomic, strong) WishlistModel *wishlist;
@property (nonatomic, strong) WishlistTourView *tour;

@property (strong, nonatomic) WishlistHeaderView *headerView;
@property (strong, nonatomic) WishlistActionHeaderView *actionHeaderView;

@property (strong, nonatomic) NSArray *filteredProducts;

@property (strong, nonatomic) NSDictionary *addCartProductDictionary;
@property (strong, nonatomic) WMExtendedViewController *extendedWarranty;

@property (assign, nonatomic) BOOL canPresentLoginWhenAppear;

@end

@implementation WALWishlistViewController

- (instancetype)init
{
    self = [super initWithTitle:@"Favoritos" isModal:YES searchButton:YES cartButton:YES wishlistButton:NO];
    if (self)
    {
        _connection = [WishlistConnection new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.canPresentLoginWhenAppear = YES;
    
    self.headerView = [[WishlistHeaderView alloc] initWithTotalItems:0 delegate:self];
    self.actionHeaderView = [[WishlistActionHeaderView alloc] initWithSuperview:self.navigationController.view ?: self.view selectedCount:0 delegate:self];
    
    _emptyViewTopSpaceConstraint.constant = _headerView.bounds.size.height + 50.0f;
    
    [self setupTableView];
    
    _tableView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([WALSession isAuthenticated]) {
        [self fetchWishlist];
    }
    else if (_canPresentLoginWhenAppear) {
        [self presentLoginWithLoginSuccessBlock:^{
            [self->_headerView setupUserNameLabel];
            [self fetchWishlist];
        } dismissBlock:^{
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_actionHeaderView hideAnimated:NO];
    [self deselectAllRows];
    
    if ([self.presentedViewController isKindOfClass:[WMBaseNavigationController class]]) {
        WMBaseNavigationController *presentedNavigationController = (WMBaseNavigationController *) self.presentedViewController;
        if (presentedNavigationController.viewControllers.count > 0) {
            UIViewController *firstController = presentedNavigationController.viewControllers.firstObject;
            self.canPresentLoginWhenAppear = ![firstController isKindOfClass:[OFLoginViewController class]];
        }
    }
    
    [self unregisterForKeyboardNotifications];
}

- (void)setupTableView
{
    [_tableView registerNib:WishlistCell.nib forCellReuseIdentifier:wishlistCellIdentifier];
    
	_tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = [UIView new];
    _tableView.delaysContentTouches = NO;
}

- (void)setWishlist:(WishlistModel *)wishlist {
    _wishlist = wishlist;
    
    [self deselectAllRows];
        
    self.filteredProducts = wishlist.products;
    
    [self filterWishlist:_headerView.selectedFilter];
    [self sortWishlist:_headerView.selectedSort];
    
    [_tableView reloadData];
    [_tableView setHidden:NO];
    
    if (_wishlist.products.count == 0) {
        [self showTour];
    }
}

- (void)setFilteredProducts:(NSArray *)filteredProducts {
    [_headerView setTotalItems:filteredProducts.count];
    _emptyView.hidden = filteredProducts.count > 0;
    self.tableView.scrollEnabled = filteredProducts.count > 0;
    
    _filteredProducts = filteredProducts;
}

#pragma mark - Connection
- (void)fetchWishlist
{
    if (![WALSession isAuthenticated]) {
        [self presentLoginWithLoginSuccessBlock:^{
            [self fetchWishlist];
        } dismissBlock:^{
            [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
        }];
        return;
    }
    
    _tableView.hidden = YES;
    [_tour removeFromSuperview];
    [self.view removeRetryView];
    _emptyView.hidden = YES;
    
    [self.view showLoading];
    
	[_connection wishlistProducts:^(WishlistModel *model) {
		[self.view hideLoading];
        
		self.wishlist = model;
	} failure:^(NSError *error) {
		[self.view hideLoading];
		
        if (error.code == 401)
        {
            [self presentLoginWithLoginSuccessBlock:^{
                [self->_headerView setupUserNameLabel];
                [self fetchWishlist];
            } dismissBlock:^{
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
        }
        else {
            self->_tableView.hidden = YES;
            self->_emptyView.hidden = YES;
            [self.view showRetryViewWithMessage:WISHLIST_REQUEST_ERROR retryBlock:^{
                [self fetchWishlist];
            }];
        }
    }];
}

- (void)alreadyBoughtSelectedProducts {
    if (![WALSession isAuthenticated]) {
        [self presentLoginWithLoginSuccessBlock:^{
            [self alreadyBoughtSelectedProducts];
        } dismissBlock:^{
            [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
        }];
        return;
    }
    
    NSArray *selectedProducts = [self selectedProducts];
    if (selectedProducts.count == 0) {
        return;
    }
    
    [_tableView setHidden:YES];
    [self.view showLoading];
    [_actionHeaderView hideAnimated:NO];
    [_tableView setContentOffset:CGPointZero animated:YES];
    
    NSArray *productsSKUs = [selectedProducts valueForKey:@"skuId"];
    NSArray *sellerIds = [selectedProducts valueForKey:@"sellerId"];
    
    [_connection alreadyBoughtProductsWithSKUs:productsSKUs success:^(WishlistModel *model) {
        [self.view hideLoading];
        [self->_tableView setHidden:NO];
        self.wishlist = model;
        [self.view showFeedbackAlertOfKind:SuccessAlert message:selectedProducts.count > 1 ? WISHLIST_ALREADY_BOUGHT_PRODUCTS_SUCCESS : WISHLIST_ALREADY_BOUGHT_PRODUCT_SUCCESS];
        [WMOmniture trackMoveProductsToPurchasedForSellerIds:sellerIds SKUs:productsSKUs];
        
    } failure:^(NSError *error) {
        
        if (error.code == 401)
        {
            [self presentLoginWithLoginSuccessBlock:^{
                [self->_headerView setupUserNameLabel];
                [self alreadyBoughtSelectedProducts];
            }];
        }
        else {
            [self.view hideLoading];
            [self->_tableView setHidden:NO];
            
            [self->_actionHeaderView show];
            [self.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
        }
    }];
}

- (void)removeProductsWithSKUs:(NSArray *)productsSKUs sellersIds:(NSArray *)sellersIds productsIds:(NSArray *)productsIds {
    if (![WALSession isAuthenticated]) {
        [self presentLoginWithLoginSuccessBlock:^{
            [self removeProductsWithSKUs:productsSKUs sellersIds:sellersIds productsIds:productsIds];
        } dismissBlock:^{
            [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
        }];
        return;
    }
    
    [_tableView setHidden:YES];
    [self.view showLoading];
    [_actionHeaderView hideAnimated:NO];
    
    [_connection removeProductsWithSKUs:productsSKUs productsIds:productsIds success:^(WishlistModel *model) {
        [self.view hideLoading];
        [self->_tableView setHidden:NO];
        self.wishlist = model;
        [self.view showFeedbackAlertOfKind:SuccessAlert message:productsSKUs.count > 1 ? WISHLIST_REMOVE_PRODUCTS_SUCCESS : WISHLIST_REMOVE_PRODUCT_SUCCESS];
        [WMOmniture trackRemoveProductsFromWishlistForSellerIds:sellersIds SKUs:productsSKUs];
        
    } failure:^(NSError *error) {
        if (error.code == 401)
        {
            [self presentLoginWithLoginSuccessBlock:^{
                [self->_headerView setupUserNameLabel];
                [self removeProductsWithSKUs:productsSKUs sellersIds:sellersIds productsIds:productsIds];
            }];
        }
        else {
            [self.view hideLoading];
            [self->_tableView setHidden:NO];
            
            [self->_actionHeaderView show];
            [self.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
        }
    }];
}
                          
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filteredProducts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WishlistProduct *product = _filteredProducts[indexPath.row];
    static WishlistCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:wishlistCellIdentifier];
    });
    
    CGFloat height = [sizingCell heightForProduct:product];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WishlistProduct *product = _filteredProducts[indexPath.row];
    
    WishlistCell *cell = (WishlistCell *)[tableView dequeueReusableCellWithIdentifier:wishlistCellIdentifier forIndexPath:indexPath];
//    [cell setupWithProduct:product baseImagePath:_wishlist.baseImageUrl];
    ModelBaseImages *baseImgs = [WBRSetupManager baseImages];
    [cell setupWithProduct:product baseImagePath:baseImgs.products];
    cell.delegate = self;
    return cell;
}

- (NSArray *)selectedProducts {
    NSMutableArray *selectedProducts = [NSMutableArray new];
    
    NSArray *selectedRowsIndexPaths = [_tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedRowsIndexPaths) {
        [selectedProducts addObject:_filteredProducts[indexPath.row]];
    }
    
    return selectedProducts.copy;
}

- (void)deselectAllRows {
    for (NSIndexPath *indexPath in [_tableView indexPathsForSelectedRows]) {
        [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    [_actionHeaderView setSelectedCount:0];
    [_actionHeaderView hideAnimated:YES];
}

#pragma mark - WishlistCell Delegate
- (void)didTapSellerName:(NSString *)sellerId
{
    [self.view endEditing:YES];
    WMWebViewController *sellerDescription = [[WMWebViewController alloc] initWithURLStr:[[OFUrls new] getURLSellerDescriptionWithSellerId:sellerId] title:@"Detalhes"];
    WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:sellerDescription];
    [self presentViewController:container animated:YES completion:nil];
}

- (void)didTapWishlistProduct:(NSString *)productId
{
    [self.view endEditing:YES];
    [super openProductWithID:productId];
    [self unregisterForKeyboardNotifications];
}

- (void)didTapAddToCart:(WishlistProduct *)product {
    [self.view endEditing:YES];
    
    if (product.hasExtendedWarranty) {
        
        ModelBaseImages *baseImgs = [WBRSetupManager baseImages];
        
        WMExtendedViewController *extendedWarranty = [[WMExtendedViewController alloc] initWithWishlistProduct:product baseImageURL:baseImgs.products pressedBuyBlock:^(NSArray *warrantiesIds) {
            [self addProductToCartWithWishlistProduct:product warrantiesIds:warrantiesIds];
        }];
//        WMExtendedViewController *extendedWarranty = [[WMExtendedViewController alloc] initWithWishlistProduct:product baseImageURL:_wishlist.baseImageUrl pressedBuyBlock:^(NSArray *warrantiesIds) {
//            [self addProductToCartWithWishlistProduct:product warrantiesIds:warrantiesIds];
//        }];
        [self.navigationController pushViewController:extendedWarranty animated:YES];
    }
    else {
        [self.navigationController.view showModalLoading];
        [self addProductToCartWithWishlistProduct:product warrantiesIds:nil];
    }
}

- (void)wishlistCellDidSelectProduct:(WishlistProduct *)product {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_filteredProducts indexOfObject:product] inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if (_actionHeaderView.hidden) {
        [_actionHeaderView show];
    }
    [_actionHeaderView setSelectedCount:[_tableView indexPathsForSelectedRows].count];
}

- (void)wishlistCellDidDeselectProduct:(WishlistProduct *)deselectedProduct {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_filteredProducts indexOfObject:deselectedProduct] inSection:0];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger selectedProductsCount = self.selectedProducts.count;
    if (selectedProductsCount == 0) {
        [_actionHeaderView hideAnimated:YES];
    }
    [_actionHeaderView setSelectedCount:selectedProductsCount];
}

#pragma mark - WishlistTourView
- (void)showTour
{
    [WMOmniture trackWishlistTour];
    [_tour removeFromSuperview];
    self.tour = [[WishlistTourView alloc] initWithDelegate:self];
    [self.view addSubview:_tour];
}

- (void)wishlistTourViewPressedStartUsing
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Cart
- (void)addProductToCartWithWishlistProduct:(WishlistProduct *)product warrantiesIds:(NSArray *)warrantiesIds {
    NSNumber *sku = product.defaultSKU;
    NSString *sellerId = product.defaultSellerOption.sellerId;
    NSUInteger quantity = 1;
    
    [self.navigationController.view showModalLoading];
    [WBRCheckoutManager addProductToCartWithSKU:sku sellerId:sellerId warrantiesId:warrantiesIds quantity:quantity success:^(NSArray *dataArray) {
        [self.navigationController.view hideModalLoading];
        [self showCartWithCompletion:^{
            [self.navigationController popViewControllerAnimated:NO];
        }];
    } failure:^(NSError *error) {
        [self.navigationController.view hideModalLoading];
        [self.view showAlertWithMessage:error.localizedDescription];
    }];
}

#pragma mark - Filter
- (void)filterWishlist:(WishlistFilterOption)filterOption {
    BOOL bought = filterOption == WishlistFilterOptionAlreadyBought;
    
    NSMutableArray *filteredProductsMutable = [NSMutableArray new];
    for (WishlistProduct *product in _wishlist.products) {
        if (product.bought.boolValue == bought) {
            [filteredProductsMutable addObject:product];
        }
    }
    self.filteredProducts = filteredProductsMutable.copy;
    
    NSMutableArray *sellersIds = [NSMutableArray new];
    NSMutableArray *skus = [NSMutableArray new];
    BOOL hasProductWithLowerPrice = NO;
    BOOL hasProductOutOfStock = NO;
    for (WishlistProduct *product in _filteredProducts) {
        [sellersIds addObject:product.sellerId];
        [skus addObject:product.skuId];
        if (product.isLowPrice) {
            hasProductWithLowerPrice = YES;
        }
        if (product.isOutOfStock) {
            hasProductOutOfStock = YES;
        }
    }
    
    if (!_tour.superview) {
        [WMOmniture trackWishlistProductsWithSellersIds:sellersIds.copy SKUs:skus.copy filterType:_headerView.selectedFilterForOmniture lowerPrice:hasProductWithLowerPrice outOfStock:hasProductOutOfStock];
    }
}

#pragma mark - Sort
- (void)sortWishlist:(WishlistSortOption)sortOption {
    NSString *sortKey = sortOption == WishlistSortOptionMostRecents || sortOption == WishlistSortOptionOlder ? @"date" : @"discountPrice";
    BOOL ascending = sortOption == WishlistSortOptionOlder || sortOption == WishlistSortOptionCheapest;
    
    NSMutableArray *filteredProductsMutable = _filteredProducts.mutableCopy;
    [filteredProductsMutable sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending]]];
    
    if (sortOption == WishlistSortOptionMostRecents) {
        NSArray *lowPriceProducts = [_filteredProducts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"statusPrice = %d", WishlistProductStatusPriceLow]];
        [filteredProductsMutable removeObjectsInArray:lowPriceProducts];
        [filteredProductsMutable insertObjects:lowPriceProducts atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, lowPriceProducts.count)]];
    }
    
    NSArray *notAvailableProducts = [_filteredProducts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"quantity = %d", 0]];
    [filteredProductsMutable removeObjectsInArray:notAvailableProducts];
    [filteredProductsMutable addObjectsFromArray:notAvailableProducts];
    
    self.filteredProducts = filteredProductsMutable.copy;
}

#pragma mark - WishlistHeaderViewDelegate
- (void)wishlistHeaderViewDidSelectFilterOption:(WishlistFilterOption)filterOption {
    [self deselectAllRows];
    [self filterWishlist:filterOption];
    //We need to sort again
    [self sortWishlist:_headerView.selectedSort];
    
    [_tableView reloadData];
    
    filterOption == WishlistFilterOptionAlreadyBought ? [_actionHeaderView hideAlreadyBoughtButton] : [_actionHeaderView showAlreadyBoughtButton];
}

- (void)wishlistHeaderViewDidSelectSortOption:(WishlistSortOption)sortOption {
    [self deselectAllRows];
    [self sortWishlist:sortOption];
    
    [_tableView reloadData];
}

#pragma mark - WishlistActionHeaderViewDelegate
- (void)wishlistActionHeaderTappedBack {
    [self deselectAllRows];
}

- (void)wishlistActionHeaderTappedAlreadyBought {
    [self alreadyBoughtSelectedProducts];
}

- (void)wishlistActionHeaderTappedRemove {
    NSArray *selectedProducts = [self selectedProducts];
    
    if (selectedProducts.count == 0) {
        return;
    }
    
    NSString *strMsg = selectedProducts.count > 1 ? WISHLIST_REMOVE_PRODUCTS_CONFIRMATION : WISHLIST_REMOVE_PRODUCT_CONFIRMATION;
    
    [self.navigationController.view showDeletePopupWithTitle:strMsg message:nil cancelBlock:nil deleteBlock:^{
        NSArray *productsSKUs = [selectedProducts valueForKey:@"skuId"];
        NSArray *sellerIds = [selectedProducts valueForKey:@"sellerId"];
        
        NSArray *productsIdsNumbers = [selectedProducts valueForKey:@"productId"];
        NSMutableArray *productsIds = [NSMutableArray new];
        for (NSNumber *productId in productsIdsNumbers) {
            [productsIds addObject:productId.stringValue];
        }
        
        [self->_tableView setContentOffset:CGPointZero animated:YES];
        
        [self removeProductsWithSKUs:productsSKUs sellersIds:sellerIds productsIds:productsIds.copy];
    }];
}

#pragma mark - UIGestureRecognizer
- (void)tappedView {
    [self.view endEditing:YES];
}

#pragma mark - Keyboard
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets tableViewContentInset = _tableView.contentInset;
    tableViewContentInset.bottom = 0;
    _tableView.contentInset = tableViewContentInset;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UIEdgeInsets tableViewContentInset = _tableView.contentInset;
    tableViewContentInset.bottom = keyboardHeight;
    _tableView.contentInset = tableViewContentInset;
}

@end
