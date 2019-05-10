//
//  WALProductDetailViewController.m
//  Walmart
//
//  Created by Renan Cargnin on 1/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WALProductDetailViewController.h"
#import "UIViewController+Login.h"

#import "ProductDetailConnection.h"
#import "WishlistConnection.h"

#import "ProductDetailModel.h"

#import "ProductImagesView.h"
#import "VariationTreeView.h"
#import "ProductOptionsView.h"
#import "ProductStampView.h"
#import "ProductSellerNameView.h"
#import "ProductPriceView.h"
#import "ProductUnavailableView.h"

#import "WBRCompleteRatingView.h"
#import "WBRFloatingBuyView.h"


//Options
#import "WMProdDetailPaymentViewController.h"
#import "OFFreightViewController.h"
#import "ProductDescriptionViewController.h"
#import "ProductSpecificationViewController.h"

#import "ProductZoomView.h"
#import "WMExtendedViewController.h"
#import "WMWebViewController.h"

#import "NSString+Share.h"
#import "RetryErrorView.h"
#import "WMHeartButton.h"

#import "WMBaseNavigationController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "WBRSetupManager.h"
#import "WBRRetargeting.h"
#import "FXKeychain.h"

#import "WBRProductConnection.h"
#import "WBRWishlist.h"
#import "WALFavoritesCache.h"

#import "WBRQuantityView.h"
#import "WBRSellersView.h"

#import "WBRReviewViewController.h"
#import "WBRFreightView.h"
#import "WBRProductDetailReviewView.h"
#import "WBRReviewsModel.h"

#import "WBRProduct.h"
#import "UIViewController+Login.h"

#import "WBRCheckoutManager.h"

#import "WBRNoReviewView.h"
#import "WBRCreateReviewViewController.h"

#import "WBRInstallCampaign.h"

@interface WALProductDetailViewController () <ProductImagesViewDelegate, VariationTreeViewDelegate, ProductOptionsViewDelegate, ProductStampViewDelegate, ProductSellerNameViewDelegate, ProductUnavailableViewDelegate,WBRCompleteRatingViewDelegate, WBRFloatingBuyViewDelegate, WBRSellersViewDelegate, WBRFreightViewDelegate, WBRProductDetailReviewViewDelegate, WBRNoViewViewDelegate, freightViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ProductImagesView *productImagesView;
@property (weak, nonatomic) IBOutlet UIView *contentStackView;
@property (nonatomic, weak) IBOutlet WMHeartButton *favoriteButton;
@property (weak, nonatomic) IBOutlet WBRCompleteRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIView *viewSeparator;
@property (weak, nonatomic) IBOutlet WBRFloatingBuyView *floatingBuyView;

@property (strong, nonatomic) VariationTreeView *variationsTreeView;
@property (strong, nonatomic) ProductOptionsView *optionsView;
@property (strong, nonatomic) WBRQuantityView *quantityView;
@property (strong, nonatomic) WBRSellersView *sellersView;
@property (strong, nonatomic) WBRProductDetailReviewView *wbrProdReviewView;
@property (strong, nonatomic) WBRReviewsModel *reviewsModel;

@property (strong, nonatomic) WBRInstallCampaign *installCampaign;
@property (strong, nonatomic) ProductStampView *installStampCampaignView;

@property (strong, nonatomic) ProductDetailModel *productDetail;
@property (strong, nonatomic) SellerOptionModel *sellerOptionSelected;

@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *sku;
@property (strong, nonatomic) NSString *showcaseId;
@property (strong, nonatomic) NSString *zipCodeSearched;

@property BOOL blockFacebookEvent;
@property BOOL isVisible;
@property BOOL isDoneToFacebookEvent;
@property BOOL alreadyRetargeting;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *floatingBuyViewHeightConstraint;

@end

@implementation WALProductDetailViewController

- (WALProductDetailViewController *)initWithProductId:(NSString *)productId showcaseId:(NSString *)showcaseId {
    if (self = [super initWithTitle:@"Detalhe do produto" isModal:NO searchButton:YES cartButton:YES wishlistButton:NO]) {
        _productId = productId;
        _showcaseId = showcaseId;
    }
    return self;
}

- (WALProductDetailViewController *)initWithSKU:(NSString *)sku showcaseId:(NSString *)showcaseId {
    if (self = [super initWithTitle:@"Detalhe do produto" isModal:NO searchButton:YES cartButton:YES wishlistButton:NO]) {
        _sku = sku;
        _showcaseId = showcaseId;
    }
    return self;
}

- (WALProductDetailViewController *)initWithProductId:(NSString *)productId {
    self = [self initWithProductId:productId showcaseId:nil];
    
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //We are now invisible
    _isVisible = NO;
    
    _alreadyRetargeting = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //We are now visible
    _isVisible = YES;
    
    if (!_blockFacebookEvent && _isDoneToFacebookEvent) {
        [self sendEventWithSellerOption:_productDetail.defaultSeller];
    }
    else {
        _blockFacebookEvent = NO;
        _isDoneToFacebookEvent = YES;
    }
    
    if (_productDetail && !_alreadyRetargeting) {
        [self retargeting];
        _alreadyRetargeting = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillEnterForegroundDetail:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [super viewWillDisappear:animated];
}



- (void)retargeting {
    
    LogRtg(@"[RETARGETING] Product Detail: %@", _productDetail);
    
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSNumber *strProdId = _productDetail.productId;
    NSNumber *strSku = _productDetail.standardSku; //ProdId is a SKU
    SellerOptionModel *som = _productDetail.sellerOptions[0];
    NSNumber *nbPrice = som.discountPrice;
    NSNumber *isAvailable = som.available;
    NSNumber *departmentId = _productDetail.departmentId;
    NSNumber *categoryId = _productDetail.categoryId;
    NSNumber *subCategoryId = _productDetail.subCategoryId;
    
    NSString *strParam = [NSString stringWithFormat:@"/webevent/rtg.gif?&Name=app&WMVisitorIDWalMartSite=guid=%@&PageType=Product&ProdId=%@&ProdPrice=%@&ProdAvailable=%@&PageDepartamentId=%@&PageCategoryId=%@&PageSubCategoryId=%@&Channel=APP", deviceId, strSku, nbPrice, isAvailable, departmentId, categoryId, subCategoryId];
    
    FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];;
    NSString *strGuid = [keychainItem objectForKey:kGUIDkey];

    if (strGuid && strGuid.length > 0) {
        strParam = [strParam stringByAppendingString:[NSString stringWithFormat:@"&CustGuid=%@", strGuid]];
    }
    
    [[WBRRetargeting new] retargetingShowcases:[NSString stringWithFormat:@"%@%@", RETARGETING_TRACKING_URL, strParam] success:^(NSHTTPURLResponse *httpResponse) {
        LogRtg(@"[RETARGETING] Success: %@", httpResponse);
    } failure:^(NSDictionary *dictError) {
        LogErro(@"[RETARGETING] Error: %@", dictError);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wishlistDidChange:) name:kWishlistNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWithFacebook:) name:@"faceFavoriteDetail" object:nil];
    
    _productImagesView.delegate = self;
    
    [self verifyInstallCampaignStamp];
    
    [self addBorderForFloatingView];
    
    [self loadProduct];
}

- (void)handleApplicationWillEnterForegroundDetail:(NSNotification *)notification {
    
    [self sendEventWithSellerOption:_productDetail.defaultSeller];
    [self retargeting];
}

- (void)viewDidLayoutSubviews {
    _nameLabel.preferredMaxLayoutWidth = _nameLabel.bounds.size.width;
    
    [super viewDidLayoutSubviews];
}

- (void)loadProduct {
    [self.view showLoading];
    [self hideFloatingBuyBoxForUnavailableProduct];
    
    if (_productId.length > 0) {
        [[ProductDetailConnection new] loadProductDetailWithProductId:_productId showcaseId:_showcaseId success:^(ProductDetailModel *productDetail) {
            [self loadProductSuccess:productDetail];
        } failure:^(NSDictionary *error) {
            [self loadProductFailure:error];
        }];
    }
    else if (_sku) {
        [[ProductDetailConnection new] loadProductDetailWithSKU:_sku showcaseId:_showcaseId success:^(ProductDetailModel *productDetail) {
            [self loadProductSuccess:productDetail];
        } failure:^(NSDictionary *error) {
            [self loadProductFailure:error];
        }];
    }
    
}

- (void)loadProductSuccess:(ProductDetailModel *)productDetail {
    [WMOmniture trackProduct:productDetail];
    
    [self.view hideLoading];
    
    [self setProductDetail:productDetail];
    
    if (productDetail.variationsTree.selectedSKU) {
        [self reloadProductWithSKU:productDetail.variationsTree.selectedSKU];
    }
    
    if(productDetail.isAvailable) {
        
        _isDoneToFacebookEvent = NO;
        [self sendEventWithSellerOption:_productDetail.defaultSeller];
        [self showFloatingBuyBoxForUnavailableProduct];
    }
}

- (void)loadProductFailure:(NSDictionary *)error {
    [self.view hideLoading];
    [_scrollView setHidden:YES];
    
    [self.view showRetryViewWithMessage:[error objectForKey:@"message" ?: ERROR_CONNECTION_UNKNOWN] retryBlock:^{
        [self loadProduct];
        [self->_scrollView setHidden:NO];
    }];
}

- (void)reloadProductWithSKU:(NSNumber *)sku {
    [self.navigationController.view showModalLoading];
    [[ProductDetailConnection new] loadSellerOptionsWithSKU:sku success:^(NSArray *sellerOptions, ProductDetailModel *productDetail) {
        
        self.productDetail.sellerOptions = productDetail.sellerOptions;
        self.productDetail.imagesIds = productDetail.imagesIds;
        
        self.productDetail.title = productDetail.title;
        [self setProductDetail:self.productDetail];
        
        [self.navigationController.view hideModalLoading];
        
        [self sendEventWithSellerOption:self->_productDetail.defaultSeller];
        
    } failure:^(NSError *error) {
        [self.navigationController.view hideModalLoading];
        [self.navigationController.view showAlertWithMessage:error.localizedDescription];
        [self->_variationsTreeView deselectLastSelectedNode];
        
        [self sendEventWithSellerOption:self->_productDetail.defaultSeller];
    }];
}

- (void)updateImagesFromVariations:(NSArray *) imageIds {
    
    __weak WALProductDetailViewController *weakSelf = self;
    [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {
        
        NSString *pathBaseImage = baseImagesModel.products ?: @"";
        pathBaseImage = [pathBaseImage stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        LogMicro(@"Base Img: %@", pathBaseImage);
        LogMicro(@"Imgs Ids: %@", imageIds);
        
        [weakSelf.productImagesView setImagesIds:imageIds basePath:pathBaseImage];
        
    } failure:^(NSDictionary *dictError) {
    }];

}

- (void)setProductDetail:(ProductDetailModel *)productDetail {
    _productDetail = productDetail;
    
    if (!_alreadyRetargeting) {
        [self retargeting];
        _alreadyRetargeting = YES;
    }
    
    _nameLabel.text = productDetail.title;
    
   
    
    __block NSString *pathBaseImage = @"";
    
    [_productImagesView moveToFirstImage];
    
    __weak WALProductDetailViewController *weakSelf = self;
    [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {
        
        pathBaseImage = baseImagesModel.products ?: @"";
        pathBaseImage = [pathBaseImage stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        LogMicro(@"Base Img: %@", pathBaseImage);
        LogMicro(@"Imgs Ids: %@", productDetail.imagesIds);
//        LogMicro(@"Selected Imgs: %@", _variationsTreeView.);
        
        [weakSelf.productImagesView setImagesIds:productDetail.imagesIds basePath:pathBaseImage];
        
    } failure:^(NSDictionary *dictError) {
    }];
    
    
    
    //Determine favorite
//    _productDetail.isFavorite ? [_favoriteButton favoriteAnimated:NO] : [_favoriteButton unfavoriteAnimated:NO];
    
    LogInfo(@"standar sku: %@", productDetail.standardSku);
    LogInfo(@"default sku: %@", productDetail.defaultSKU);
    LogInfo(@"array favorites: %@", [WALFavoritesCache favorites]);
    LogInfo(@"sku selected: %@", _variationsTreeView.selectedSKU);
    LogInfo(@"is Favorite?: %i", [WALFavoritesCache isFavorite:productDetail.standardSku]);
    
    [_favoriteButton unfavoriteAnimated:NO];
    
    BOOL isFavorited = [self isFavoritedSku:_variationsTreeView.selectedSKU.stringValue] ?: [self isFavoritedSku:_productDetail.standardSku.stringValue];
    
    if (isFavorited) {
        
        [_favoriteButton favoriteAnimated:NO];
    }
    
    NSMutableArray *productViews = [NSMutableArray new];
    
    if (productDetail.variationsTree.options.count > 0) {
        self.variationsTreeView = [[VariationTreeView alloc] initWithVariationRootNode:productDetail.variationsTree baseImageURL:pathBaseImage delegate:self];
        [_variationsTreeView disableScroll];
        self.variationsTreeView.tag = VARIATIONS_TREE_VIEW;
        [productViews addObject:_variationsTreeView];
        self.viewSeparator.hidden = NO;
    }else{
        self.viewSeparator.hidden = YES;
    }
    
    
    [self setupRatingViewWithRating:productDetail.rating];
    
    //create reviews
    if(self.productDetail.isReview){
        self.wbrProdReviewView = [WBRProductDetailReviewView new];
        self.wbrProdReviewView.hidden = YES;
        self.wbrProdReviewView.delegate = self;
        [self loadReviews];
    }
    
    if(productDetail.isAvailable) {
        if (productDetail.stampUrl.length > 0) {
            ProductStampView *stampView = [[ProductStampView alloc] initWithUrl:productDetail.stampUrl title:productDetail.stampTitle description:productDetail.stampDescription fullDescription:productDetail.stampFullDescription delegate:self];
            stampView.tag = STAMP_VIEW_TAG;
            [productViews insertObject:stampView atIndex: 0];
            self.viewSeparator.hidden = YES;
            if(productDetail.variationsTree.options.count == 0)
            {
                [stampView hideSeparator];
            }
        }
        
        [self.floatingBuyView setupWithSellerOption:self.productDetail.defaultSeller];
        self.floatingBuyView.delegate = self;
        [self calculateFloatingSellerNameHeight:self.productDetail.defaultSeller];
        
        //add quantity view
        self.quantityView = [WBRQuantityView new];
        [productViews addObject:self.quantityView];
        
        //freight view
        WBRFreightView *freightView = [[WBRFreightView alloc] initWithDelegate:self];
        freightView.tag = FREIGHT_VIEW_TAG;
        [productViews addObject:freightView];
        
        self.sellersView = [WBRSellersView new];
        [self.sellersView setupSellers:productDetail.sellerOptions];
        self.sellersView.delegate = self;
        [productViews addObject:self.sellersView];
        
        if (self.installCampaign) {
            self.installStampCampaignView = [[ProductStampView alloc] initWithUrl:self.installCampaign.imageUrl title:nil description:self.installCampaign.descriptionText fullDescription:nil delegate:self];
            [self.installStampCampaignView hideSeparator];
            [productViews addObject:self.installStampCampaignView];
            [self.installStampCampaignView hideView];
            
            if ((self.productDetail.defaultSeller.discountPrice.doubleValue > self.installCampaign.minValue.doubleValue)) {
                [self.installStampCampaignView showView];
            }
        }
        
        //add reviews
        if(self.wbrProdReviewView){
            [productViews addObject:self.wbrProdReviewView];
        }
        else {
            WBRNoReviewView *noReviewView = (WBRNoReviewView *)[[[NSBundle mainBundle] loadNibNamed:@"WBRNoReviewView" owner:self options:nil] firstObject];
            noReviewView.delegate = self;
            [productViews addObject:noReviewView];
        }
        [self showFloatingBuyBoxForUnavailableProduct];
        
        self.optionsView = [[ProductOptionsView alloc] initWithDelegate:self showPaymentMethods:YES];
        self.optionsView.tag = OPTIONS_VIEW;
        [productViews addObject:_optionsView];
    }
    else {
        
        //add reviews
        if(self.wbrProdReviewView){
            [productViews addObject:self.wbrProdReviewView];
        }
        
        self.optionsView = [[ProductOptionsView alloc] initWithDelegate:self showPaymentMethods:NO];
        self.optionsView.tag = OPTIONS_VIEW;
        [productViews addObject:_optionsView];
        
        [self hideFloatingBuyBoxForUnavailableProduct];
        
        ProductUnavailableView *unavailableView = [[ProductUnavailableView alloc] initWithSKU:productDetail.defaultSKU delegate:self];
        unavailableView.tag = PRODUCT_UNAVAILABLE_VIEW_TAG;
        if(productDetail.variationsTree.options.count == 0)
        {
            
            [productViews insertObject:unavailableView atIndex:0];
        }else
        {
            
            [productViews insertObject:unavailableView atIndex:1];
        }
        
        //Facebook Analytics
        _isDoneToFacebookEvent = NO;
        float value = 0.0f;
        LogInfo(@"[FACE] logViewedContentEvent (unavailable) - Sku: %@ | Value: %f", productDetail.defaultSKU.stringValue, (double)value);
        [self logViewedContentEvent:@"product" contentId:productDetail.defaultSKU.stringValue currency:@"BRL" valToSum:(double) value];
        
        [[NSUserDefaults standardUserDefaults] setObject:@[productDetail.defaultSKU.stringValue, @"0"] forKey:@"facebookViewedContent"];
    }
    
    [self setupStackViewWithViews:productViews.copy];
}

-(void) hideFloatingBuyBoxForUnavailableProduct
{
    self.floatingBuyView.hidden = YES;
    self.scrollViewBottomConstraint.constant = 0;
}

-(void) showFloatingBuyBoxForUnavailableProduct
{
    self.floatingBuyView.hidden = NO;
    self.scrollViewBottomConstraint.constant = 72;
}

- (void)sendEventWithSellerOption:(SellerOptionModel *)sellerOption {

    //Facebook Analytics
    float value = sellerOption.discountPrice.floatValue;
    LogInfo(@"[FACE] logViewedContentEvent - Sku: %@ | Value: %.2f", sellerOption.sku.stringValue, (double) value);
    [self logViewedContentEvent:@"product" contentId:sellerOption.sku.stringValue currency:@"BRL" valToSum:(double) value];
}

- (void)setupRatingViewWithRating:(WBRRatingModel *)rating {
    
    self.ratingView.isRatingActionEnabled = NO;
    if(self.productDetail.isReview){
        self.ratingView.isRatingActionEnabled = YES;
        self.ratingView.delegate = self;
    }
    
    
    if (rating.totalOfRatings && rating) {
        self.ratingView.hidden = NO;
        self.ratingView.rating = rating;
    }
    else {
        self.ratingView.hidden = YES;
    }
}
#pragma mark - Install Stamp Campaign
- (void)verifyInstallCampaignStamp {
    BOOL isInstallCampaignEnabled = [WALMenuViewController singleton].services.installCampaign.boolValue;
    if (isInstallCampaignEnabled) {
        __weak WALProductDetailViewController *weakSelf = self;
        [WBRSetupManager getInstallCampaign:^(WBRInstallCampaign *installCampaignModel) {
            if (installCampaignModel) {
                weakSelf.installCampaign = installCampaignModel;
            }
        } failure:^(NSDictionary *dictError) {}];
    }
}

#pragma mark - Other Payment Options

- (void)openOtherPaymentOptions:(SellerOptionModel *)sellerOptions {
    
    NSString *strDiscountPrice = [NSString stringWithFormat:@"%.2f", [sellerOptions.discountPrice doubleValue]];
    _blockFacebookEvent = YES;
    
    WMProdDetailPaymentViewController *paymentForms = [[WMProdDetailPaymentViewController alloc] initWithStandardSKU:sellerOptions.sku.stringValue price:strDiscountPrice sellerId:sellerOptions.sellerId delegate:nil];
    
    [self.navigationController pushViewController:paymentForms animated:YES];
}

#pragma mark - Facebook Analytics

- (void)logViewedContentEvent:(NSString*)contentType
                    contentId:(NSString*)contentId
                     currency:(NSString*)currency
                    valToSum :(double)price {
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     contentType, FBSDKAppEventParameterNameContentType,
     contentId, FBSDKAppEventParameterNameContentID,
     currency, FBSDKAppEventParameterNameCurrency,
     nil];
    [FBSDKAppEvents logEvent: FBSDKAppEventNameViewedContent
                  valueToSum: price
                  parameters: params];
}

#pragma mark -

- (void)setupStackViewWithViews:(NSArray *)views {
    [_contentStackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
    for (UIView *view in views) {
        UIView *topView = _contentStackView.subviews.count == 0 ? _contentStackView : _contentStackView.subviews.lastObject;
       
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_contentStackView addSubview:view];
        


        [_contentStackView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                            toItem:_contentStackView
                                                                        attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0f
                                                                          constant:0.0f]];
        
        if(view.tag == VARIATIONS_TREE_VIEW ){
            [_contentStackView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:topView
                                                                          attribute:topView == _contentStackView ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:TOP_VARIATIONS_TREE_VIEW]];
        }else if(view.tag == OPTIONS_VIEW && topView.tag != VARIATIONS_TREE_VIEW){
            [_contentStackView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:topView
                                                                          attribute:topView == _contentStackView ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:TOP_OPTIONS_VIEW]];
        }
        else{
            [_contentStackView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:topView
                                                                          attribute:topView == _contentStackView ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:topView == _contentStackView ? 0.0f : 15.0f]];
        }
        
        
        
        if(view.tag == PRODUCT_UNAVAILABLE_VIEW_TAG)
        {
            NSLayoutConstraint *bottomConstraint;
            for (NSLayoutConstraint *constraint in self.contentStackView.superview.constraints) {
                if ([constraint.identifier isEqualToString:@"contentStackBottomConstraint"]) {
                    bottomConstraint = constraint;
                    bottomConstraint.constant = 0.0f;
                    break;
                }
            }
        }
       
        
        [_contentStackView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeTrailing
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_contentStackView
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1.0f
                                                                       constant:0.0f]];
        
        if (view == views.lastObject && view.tag != PRODUCT_UNAVAILABLE_VIEW_TAG) {
            [_contentStackView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentStackView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:-15.0f]];
        }else if (view == views.lastObject) {
            [self.contentStackView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentStackView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:0.0]];
        }
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - Buy Product
- (void)buyProductWithSellerOption:(SellerOptionModel *)sellerOption {
    if (sellerOption == nil) return;
    
    if (sellerOption.hasExtendedWarranty) {

        LogInfo(@"DefaultSeller.sku: %@", _productDetail.defaultSeller.sku);
        LogInfo(@"Sku: %@", _variationsTreeView.selectedSKU);
        
        NSNumber *skuSelected = _productDetail.hasVariations ? _variationsTreeView.selectedSKU : _productDetail.defaultSeller.sku;
        
        LogInfo(@"Sku Selected: %@", skuSelected);
        
        WMExtendedViewController *extendedWarranty = [[WMExtendedViewController alloc] initWithSKU:skuSelected productDetail:_productDetail pressedBuyBlock:^(NSArray *warrantiesIds) {
            [self addProductToCartWithSellerOption:sellerOption warrantiesIds:warrantiesIds];
        }];
        
        [self.navigationController pushViewController:extendedWarranty animated:YES];
    }
    else {
        [self addProductToCartWithSellerOption:sellerOption warrantiesIds:nil];
    }
    
    //Facebook Analytics
    float value = sellerOption.discountPrice.floatValue;
    LogInfo(@"[FACE] logAddedToCartEvent - Sku: %@ | Value: %f", sellerOption.sku.stringValue, sellerOption.discountPrice.doubleValue);

    [self logAddedToCartEvent:sellerOption.sku.stringValue contentType:@"product" currency:@"BRL" valToSum:(double) value];
}

#pragma mark - Facebook Analytics

- (void)logAddedToCartEvent:(NSString*)contentId
                contentType:(NSString*)contentType
                   currency:(NSString*)currency
                  valToSum :(double)price {
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     contentId, FBSDKAppEventParameterNameContentID,
     contentType, FBSDKAppEventParameterNameContentType,
     currency, FBSDKAppEventParameterNameCurrency,
     nil];
    [FBSDKAppEvents logEvent: FBSDKAppEventNameAddedToCart
                  valueToSum: price
                  parameters: params];
}

#pragma mark -

- (void)addProductToCartWithSellerOption:(SellerOptionModel *)sellerOption warrantiesIds:(NSArray *)warrantiesIds {
    __block NSNumber *sku = _productDetail.hasVariations ? _variationsTreeView.selectedSKU : _productDetail.defaultSKU;
    NSString *sellerId = sellerOption.sellerId;
    __block NSUInteger quantity = self.quantityView.quantity;
    
    [self.navigationController.view showModalLoading];
    
    [WBRCheckoutManager addProductToCartWithSKU:sku sellerId:sellerId warrantiesId:warrantiesIds quantity:quantity success:^(NSArray *dataArray) {
        [self.navigationController.view hideModalLoading];
        [self showCartWithCompletion:^{
            [self.navigationController popViewControllerAnimated:NO];
        }];
    } failure:^(NSError *error) {
        [self.navigationController.view hideModalLoading];
        [self.navigationController.view showAlertWithMessage:error.localizedDescription];
    }];
}

#pragma mark - Share
- (IBAction)shareProduct:(id)sender {
    //Cleaning product title
    NSString *productTitle = _productDetail.title;
    if (productTitle.length > 0)
    {
        NSString *shareAction = [productTitle shareString];
        NSString *shareMessage = [NSString stringWithFormat:@"%@ - https://m.walmart.com.br/%@/%@/pr", productTitle, shareAction, _productDetail.productId.stringValue];
        LogInfo(@"Share: %@", shareMessage);
        
        UIImage *imageToShare = _productImagesView.firstImage;
        
        NSArray *activityItems = imageToShare ? @[shareMessage, imageToShare] : @[shareMessage];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                                         UIActivityTypeAddToReadingList,UIActivityTypeAirDrop];
        
        UIViewController *controller = self.parentViewController ?: self;
        [controller presentViewController:activityViewController animated:YES completion:nil];
    }
}

#pragma mark - OFFreightViewController Delegate
- (void)closeFreightFromProductDetail:(NSArray<Freight *> *)freights andZipCode:(NSString *)zipCodeSearched {
    self.zipCodeSearched = zipCodeSearched;
    
    for (SellerOptionModel *sellerOptionModel in self.productDetail.sellerOptions) {
        [freights enumerateObjectsUsingBlock:^(Freight * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.sellerId lowercaseString] isEqualToString:[sellerOptionModel.sellerId lowercaseString]]) {
                if (obj.items.count > 0) {
                    FreightItem *freightItemTemp = (FreightItem *) obj.items[0];
                    NSArray<DeliveryType> *deliveryTypeItemsTemp = [NSArray<DeliveryType> arrayWithArray:freightItemTemp.deliveryTypes];
                    sellerOptionModel.deliveryTypes = [NSArray<DeliveryType> arrayWithArray:[freightItemTemp bestDeliveryTypeOption:deliveryTypeItemsTemp]];
                    *stop = YES;
                }
            }
        }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sellersView setupSellers:self.productDetail.sellerOptions];
        [self.sellersView reloadCells];
    });
}


#pragma mark - ProductImagesViewDelegate
- (void)productImagesResquestedZoom {
    
    __weak WALProductDetailViewController *weakSelf = self;
    [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {
        
        NSString *pathBaseImage = baseImagesModel.products ?: @"";
        pathBaseImage = [pathBaseImage stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        ProductZoomView *zoomView = [[ProductZoomView alloc] initWithImagesIds:self->_productDetail.imagesIds basePath:pathBaseImage dismissBlock:^{}];
        zoomView.alpha = 0.0f;
        [weakSelf.navigationController.view addSubview:zoomView];
        
        [UIView animateWithDuration:0.5f animations:^{
            zoomView.alpha = 1.0f;
        } completion:nil];
        
    } failure:^(NSDictionary *dictError) {
    }];
}

#pragma mark - VariationTreeViewDelegate
- (void)variationTreeDidChangeSelectedSKU:(NSNumber *)selectedSKU {
    if (selectedSKU) {
        
        [self reloadProductWithSKU:selectedSKU];
    }
}

#pragma mark - ProductOptionsViewDelegate
- (void)productOptionsPressedPaymentForms {

    _blockFacebookEvent = YES;

    NSString *strDiscountPrice;
    NSString *sku;
    NSString *sellerId;
    
    if (self.sellerOptionSelected) {
        strDiscountPrice = [NSString stringWithFormat:@"%.2f", [self.sellerOptionSelected.discountPrice doubleValue]];
        sku = self.sellerOptionSelected.sku.stringValue;
        sellerId = self.sellerOptionSelected.sellerId;
    } else {
        strDiscountPrice = [NSString stringWithFormat:@"%.2f", [_productDetail.defaultSeller.discountPrice doubleValue]];
        sku = self.productDetail.defaultSKU.stringValue;
        sellerId = self.productDetail.defaultSeller.sellerId;
    }
    
    WMProdDetailPaymentViewController *paymentForms = [[WMProdDetailPaymentViewController alloc] initWithStandardSKU:sku price:strDiscountPrice sellerId:sellerId delegate:nil];
    
    [self.navigationController pushViewController:paymentForms animated:YES];
}

- (void)productOptionsPressedCalculateFreight {
    
    _blockFacebookEvent = YES;
    
    OFFreightViewController *freight = [[OFFreightViewController alloc] initWithStandardSKU:self.productDetail.standardSku.stringValue andSearchedZipcode:nil delegate:self];
    [self.navigationController pushViewController:freight animated:YES];
}

- (void)productOptionsPressedDescription {
    
    _blockFacebookEvent = YES;
    
    ProductDescriptionViewController *descriptionController = [[ProductDescriptionViewController alloc] initWithProductId:_productDetail.productId.stringValue];
    [self.navigationController pushViewController:descriptionController animated:YES];
}

- (void)productOptionsPressedFeatures {
    
    _blockFacebookEvent = YES;
    
    ProductSpecificationViewController *specificationController = [[ProductSpecificationViewController alloc] initWithProductId:_productDetail.productId.stringValue];
    [self.navigationController pushViewController:specificationController animated:YES];
}

#pragma mark - ProductStampViewDelegate
- (void)productStampDidTapWithStampURLPath:(NSString *)stampURLPath {
    
    NSURL *url = [NSURL URLWithString:stampURLPath];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        WMWebViewController *stampDescription = [[WMWebViewController alloc] initWithURLStr:stampURLPath title:@"Selo"];
        WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:stampDescription];
        [self presentViewController:container animated:YES completion:nil];
    }
}


#pragma mark - ProductSellerNameViewDelegate
- (void)productSellerOtherPaymentDidTap:(SellerOptionModel *)sellerOption {
    [self openOtherPaymentOptions:sellerOption];
}

- (void)productSellerNameDidTapWithSellerId:(NSString *)sellerId {
    
    _blockFacebookEvent = YES;
    
    WMWebViewController *sellerDescription = [[WMWebViewController alloc] initWithURLStr:[[OFUrls new] getURLSellerDescriptionWithSellerId:sellerId] title:@"Detalhes"];
    WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:sellerDescription];
    [self presentViewController:container animated:YES completion:nil];
}

- (void)productSellerMoreFreightOptions {
    _blockFacebookEvent = YES;
    
    OFFreightViewController *freight = [[OFFreightViewController alloc] initWithStandardSKU:self.productDetail.standardSku.stringValue andSearchedZipcode:self.zipCodeSearched delegate:self];
    [self.navigationController pushViewController:freight animated:YES];
}


#pragma mark - ProductUnavailableDelegate
- (void)productUnavailablePressedSendWithInvalidFields:(NSString *) msg andMessageType:(FeedbackAlertKind)type{
    [self.view showFeedbackAlertOfKind:type message:msg];
}

#pragma mark - Wishlist
- (IBAction)heartPressed {
    BOOL allVariationsSelected = [_productDetail hasVariations] ? _variationsTreeView.selectedSKU ? YES : NO : YES;
    if (allVariationsSelected) {
        if ([WALSession isAuthenticated]) {
            [self favoriteAction];
        }
        else {
            [self presentLogin];
        }
    }
    else {
        [self.navigationController.view showAlertWithMessage:WISHLIST_EMPTY_VARIATIONS];
    }
}

- (BOOL) isFavoritedSku:(NSString *) skuToFavorite {
    
    BOOL alreadyFavorited = NO;
    
    if (_variationsTreeView.selectedSKU) {
        
        NSArray *arrFavorites = [WALFavoritesCache favorites] ?: @[];
        NSString *skuSelected = _variationsTreeView.selectedSKU.stringValue;
        
        if (arrFavorites.count > 0) {
            
            for (int i=0;i<arrFavorites.count;i++) {
                
                NSString *skuWishlist = [[arrFavorites objectAtIndex:i] stringValue];
                
                if ([skuWishlist isEqualToString:skuSelected]) {
                    alreadyFavorited = YES;
                }
            }
        }
    }
    else {
        
        NSNumber *sku = [NSNumber numberWithInt:[skuToFavorite intValue]];
        
        if ([WALFavoritesCache isFavorite:sku]) {
            
             alreadyFavorited = YES;
        }
    }

    return alreadyFavorited;
}

- (void)favoriteAction
{
    LogInfo(@"sku selected: %@", _variationsTreeView.selectedSKU);
    
    BOOL isFavorited = [self isFavoritedSku:_variationsTreeView.selectedSKU.stringValue] ?: [self isFavoritedSku:_productDetail.standardSku.stringValue];
    
    LogInfo(@"Favorited: %i", isFavorited);
    
    NSNumber *targetSku = _variationsTreeView.selectedSKU ?: _productDetail.defaultSKU;
    
    if (isFavorited) {
        
        [_favoriteButton pulseFullHeart];
        [self unfavoriteProductWithSKU:targetSku];
    }
    else {
        
        [_favoriteButton pulseEmptyHeart];
        [self performSelector:@selector(favoriteProductWithSKU:) withObject:targetSku afterDelay:1];
    }
}

- (void) loginWithFacebook:(NSNotification *)notification {
    
    [self favoriteAction];
}

- (void)favoriteProductWithSKU:(NSNumber *)sku
{
    WishlistConnection *wishlistConnection = [WishlistConnection new];
    NSString *sellerId = _productDetail.defaultSeller.sellerId;
    [wishlistConnection addProductWithSKU:sku.stringValue productID:_productDetail.productId.stringValue sellerId:sellerId completion:^(BOOL success, NSError *error) {
        if (error) {
            [self->_favoriteButton stopPulsing];
            LogInfo(@"Error adding product to the wishlist (%ld)", (long)error.code);
            
            if (self.isViewLoaded && self.view.window) {
                [self->_favoriteButton unfavoriteAnimated:YES];
                
                if (error.code == 400 || error.code == 401) {
                    [self presentLogin];
                } else {
                    [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
                }
            }
        } else {
            [self->_favoriteButton favoriteAnimated:YES];
            self->_productDetail.isFavorite = YES;
        }
    }];
}

- (void)unfavoriteProductWithSKU:(NSNumber *)sku
{
    WishlistConnection *wishlistConnection = [WishlistConnection new];
    [wishlistConnection removeProductWithSKU:sku.stringValue productId:_productDetail.productId.stringValue completion:^(BOOL success, NSError *error) {
        if (error) {
            [self->_favoriteButton stopPulsing];
            LogInfo(@"Error removing product from the wishlist (%ld)", (long)error.code);
            
            if (self.isViewLoaded && self.view.window) {
                [self->_favoriteButton favoriteAnimated:YES];
                
                if (error.code == 400 || error.code == 401) {
                    [self presentLogin];
                } else {
                    [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
                }
            }
        } else {
            [self->_favoriteButton unfavoriteAnimated:YES];
            self->_productDetail.isFavorite = NO;
        }
    }];
}

- (void)presentLogin
{
    [self presentLoginWithLoginSuccessBlock:^{
        [self favoriteAction];
    }];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.scrollView.contentInset = contentInset;
}

#pragma mark - Gesture Notification

- (IBAction)handleTap:(UITapGestureRecognizer *)recognize {
    if(self.productDetail.isAvailable){
        [self.view endEditing:YES];
    }
    
}

#pragma mark - Wishlist Notification
- (void)wishlistDidChange:(NSNotification *)notification {
    NSDictionary *notificationDictionary = notification.object;
    NSArray *productsIds = notificationDictionary[@"productsIds"];
    BOOL wishlist = [notificationDictionary[@"wishlist"] boolValue];
    
    for (NSString *productId in productsIds) {
        if ([productId isEqualToString:_productDetail.productId.stringValue]) {
            wishlist ? [_favoriteButton favoriteAnimated:NO] : [_favoriteButton unfavoriteAnimated:NO];
        }
    }
}

#pragma mark - Floating BuyBox addToCart Button
- (void)floatingProductBuyPressedBuyButton:(NSString *)sellerId
{
    if (self.productDetail.hasVariations && self.variationsTreeView.selectedSKU == nil) {
        [self.navigationController.view showAlertWithMessage:PRODUCT_VARIATIONS_NO_CHOOSED];
    }
    else {
        [self buyProductWithSellerOption:[_productDetail sellerWithId:sellerId]];
    }
}

- (void)navigateToReview{
    [self.navigationController pushViewController: [[WBRReviewViewController alloc] initWithReviews:self.reviewsModel ratingModel:self.productDetail.rating productId:self.productId] animated:YES];
    
}

-(void) addBorderForFloatingView{
    self.floatingBuyView.layer.masksToBounds = NO;
    self.floatingBuyView.layer.shadowColor = RGBA(0, 0, 0, 0.8).CGColor;
    self.floatingBuyView.layer.shadowOpacity = 0.08;
    self.floatingBuyView.layer.shadowOffset = CGSizeMake(0, -10);
}

-(void) selectSeller:(SellerOptionModel *)sellerOption
{
    self.sellerOptionSelected = sellerOption;
    
    [self.floatingBuyView setupWithSellerOption:sellerOption];
    
    [self calculateFloatingSellerNameHeight:sellerOption];

    [self updateInstallCampaignStampView];
    
}

-(void)calculateFloatingSellerNameHeight:(SellerOptionModel *)sellerOption{
    CGFloat defaultFloatingHeight = 61.0;
    CGFloat defaultBuyButtonWidth = 150.0;
    CGFloat defaultBuyButtonRightMargin = 15.0;
    CGFloat defaultMarginsSellerLabel = 25.0;
    
    UIFont *sellerNameFont = [UIFont fontWithName:@"Roboto-Regular" size:11];
    CGSize rect = CGSizeMake(self.floatingBuyView.frame.size.width - (defaultBuyButtonWidth + defaultMarginsSellerLabel + defaultBuyButtonRightMargin), FLT_MAX);
    
    CGRect sellerNameSize = [sellerOption.name boundingRectWithSize:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: sellerNameFont} context:nil ];
   
    self.floatingBuyViewHeightConstraint.constant = ceil(sellerNameSize.size.height) + defaultFloatingHeight;
    [self.floatingBuyView layoutIfNeeded];
}

- (void)updateInstallCampaignStampView {
    if (self.installCampaign) {
        if (self.sellerOptionSelected.discountPrice.doubleValue > self.installCampaign.minValue.doubleValue) {
            [self.installStampCampaignView showView];
        } else {
            [self.installStampCampaignView hideView];
        }
    }
}

#pragma mark - Load Reviews
-(void)loadReviews{
    if(self.productDetail.isReview){
        __weak typeof(self) weakSelf =self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProductDetailConnection new] loadProductReviews:weakSelf.productId  pageNumber:@(1) success:^(WBRReviewsModel *reviewModel) {
                
                weakSelf.reviewsModel = reviewModel;
                [weakSelf.wbrProdReviewView setupReview:weakSelf.productDetail.rating reviewModelArray:weakSelf.reviewsModel.results];
                weakSelf.wbrProdReviewView.hidden = NO;
            } failure:^(NSDictionary *error) {
                weakSelf.wbrProdReviewView.hidden = YES;
                [weakSelf.wbrProdReviewView removeFromSuperview];
                weakSelf.wbrProdReviewView = nil;
                
                NSUInteger objectIndex = [weakSelf.contentStackView subviews].count;
                
                if (objectIndex >= 2) {
                    UIView* penultimateView = [[weakSelf.contentStackView subviews] objectAtIndex:[weakSelf.contentStackView subviews].count -2];
                    
                    if (penultimateView != nil) {
                        [weakSelf.contentStackView addConstraint:[NSLayoutConstraint constraintWithItem:penultimateView
                                                                                              attribute:NSLayoutAttributeBottom
                                                                                              relatedBy:NSLayoutRelationEqual
                                                                                                 toItem:weakSelf.optionsView
                                                                                              attribute:NSLayoutAttributeTop
                                                                                             multiplier:1.0f
                                                                                               constant:0]];
                    }
                }
                [weakSelf.contentStackView layoutIfNeeded];
                LogMicro(@"Can't load reviews.");
            }];
        });
    }
}

#pragma mark - WBRProductDetailReviewViewDelegate
- (void)showMoreReviews{
     [self.navigationController pushViewController: [[WBRReviewViewController alloc] initWithReviews:self.reviewsModel ratingModel:self.productDetail.rating productId:self.productId] animated:YES];
}

- (void)submitReviewEvaluation:(BOOL)evaluation reviewIndexPath:(NSIndexPath *)reviewIndexPath {
    
    WBRReviewModel *selectedReview = [self.reviewsModel.results objectAtIndex:reviewIndexPath.row];
    selectedReview.voteCount = [NSNumber numberWithInteger:[selectedReview.voteCount integerValue] + 1];
    
    if (evaluation) {
        selectedReview.voteRelevant = [NSNumber numberWithInteger:[selectedReview.voteRelevant integerValue] + 1];
        selectedReview.reviewEvaluated = kReviewEvaluatedPositiveEvaluation;
    } else {
        selectedReview.reviewEvaluated = kReviewEvaluatedNegativeEvaluation;
    }
    
    [self.wbrProdReviewView setupReview:self.productDetail.rating reviewModelArray:self.reviewsModel.results];
    
    [[WBRProduct new] postReviewEvaluation:[NSNumber numberWithBool:evaluation] ofProduct:self.productDetail.productId forReview:selectedReview.reviewId successBlock:^(NSDictionary *dataJson) {
        
        LogInfo(@"Success to post review evaluation. ProductID: %@ reviewId: %@", self.productDetail.productId, reviewIndexPath);
    } failure:^(NSDictionary *dictError) {
        
        LogInfo(@"Error to post review evaluation. ProductID: %@ reviewId: %@", self.productDetail.productId, reviewIndexPath);
        
        selectedReview.reviewEvaluated = kReviewEvaluatedNoEvaluation;
        selectedReview.voteCount = [NSNumber numberWithInteger:[selectedReview.voteCount integerValue] -1];
        if (evaluation) {
                selectedReview.voteRelevant = [NSNumber numberWithInteger:[selectedReview.voteRelevant integerValue] -1];
        }
        
        [self.wbrProdReviewView setupReview:self.productDetail.rating reviewModelArray:self.reviewsModel.results];
        
        if ([dictError objectForKey:@"errorMessage"] != nil) {
            NSString *errorMessage = [dictError objectForKey:@"errorMessage"];
            [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:errorMessage];
        }
    }];
}

- (void)productDetailReviewCellDidEvaluateReviewIndexPath:(NSIndexPath *)reviewIndexPath withEvaluation:(BOOL)evaluation {

    if ([WALSession isAuthenticated]) {
        [self submitReviewEvaluation:evaluation reviewIndexPath:reviewIndexPath];
    }
    else {
        [self presentLoginWithLoginSuccessBlock:^{
            [self submitReviewEvaluation:evaluation reviewIndexPath:reviewIndexPath];
        } dismissBlock:^{}];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)WBRNoReviewViewDidSelectEvaluateProduct {
    
    BOOL activeSession = [WALSession isAuthenticated];
    if (activeSession) {
        WBRCreateReviewViewController *createReviewViewController = [[WBRCreateReviewViewController alloc] init];
        createReviewViewController.productId = self.productId;
        [self.navigationController pushViewController:createReviewViewController animated:YES];
    }
    else {
        [self presentLoginWithLoginSuccessBlock:^{
            WBRCreateReviewViewController *createReviewViewController = [[WBRCreateReviewViewController alloc] init];
            createReviewViewController.productId = self.productId;
            [self.navigationController pushViewController:createReviewViewController animated:YES];
        }];
    }
}

@end
