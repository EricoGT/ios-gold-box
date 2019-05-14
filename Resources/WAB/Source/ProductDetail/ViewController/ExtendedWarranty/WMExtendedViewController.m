//
//  WMExtendedViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 1/7/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMExtendedViewController.h"
#import "WMExtendProduct.h"
#import "WMExtendOptions.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Additions.h"

#import "ProductDetailConnection.h"
#import "ProductDetailModel.h"
#import "WishlistProduct.h"
#import "ExtendedWarrantyProduct.h"

#import "WMBaseNavigationController.h"

#import "UITapGestureRecognizer+DetectTap.h"

#import "WBRSetupManager.h"

#define firstPositionWarranty 149.0f
#define timeAnimationCombos .5f

static NSString * const knowMoreString = @"Saiba mais.";

@interface WMExtendedViewController ()

@property (weak, nonatomic) IBOutlet UIView *productsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *importantTextLabel;

@property (strong, nonatomic) NSDictionary *dictParam;
@property (strong, nonatomic) NSDictionary *dictWarranty;
@property (strong, nonatomic) NSArray *arrWarranty;

@property (strong, nonatomic) NSNumber *sku;
@property (strong, nonatomic) ExtendedWarrantyProduct *extendedWarrantyProduct;
@property (strong, nonatomic) ProductDetailModel *prodDetail;

@property (copy, nonatomic) void (^pressedBuyBlock)(NSArray *warrantiesIds);

@property (strong, nonatomic) NSString *productTitle;
@property (strong, nonatomic) NSString *productImage;

@property (nonatomic, strong) WishlistProduct *wishProd;

@property BOOL isFromWishlist;

@end

@implementation WMExtendedViewController

- (WMExtendedViewController *)initWithSKU:(NSNumber *)sku productDetail:(ProductDetailModel *)productDetail pressedBuyBlock:(void (^)(NSArray *))pressedBuyBlock {
    if (self = [super initWithTitle:@"Garantia Estendida" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO]) {
        _isFromWishlist = NO;
        _sku = sku;
        _prodDetail = productDetail;
        
        __weak WMExtendedViewController *weakSelf = self;
        [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {
            
            NSString *pathBaseImage = baseImagesModel.products ?: @"";
            pathBaseImage = [pathBaseImage stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            weakSelf.productImage = [NSString stringWithFormat:@"%@%@", pathBaseImage, productDetail.imagesIds.firstObject];
            
        } failure:^(NSDictionary *dictError) {
        }];
        
        _productTitle = productDetail.title;
        _pressedBuyBlock = pressedBuyBlock;
    }
    return self;
}

- (WMExtendedViewController *)initWithWishlistProduct:(WishlistProduct *)wishlistProduct baseImageURL:(NSString *)baseImageURL pressedBuyBlock:(void (^)(NSArray *))pressedBuyBlock {
    if (self = [super initWithTitle:@"Garantia Estendida" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO]) {
        _isFromWishlist = YES;
        _wishProd = wishlistProduct;
        _sku = wishlistProduct.defaultSKU;
        _productTitle = wishlistProduct.defaultName;
        _productImage = [NSString stringWithFormat:@"%@%@", baseImageURL, wishlistProduct.firstImageId];
        _pressedBuyBlock = pressedBuyBlock;
    }
    return self;
}

- (void)loadExtendedWarrantyProduct {
    [self.view showLoading];
    
    NSArray *arrSellers = _prodDetail.sellerOptions;
    
    if (_isFromWishlist) {
        arrSellers = _wishProd.sellerOptions;
    }
    
    SellerOptionModel *som = arrSellers[0];
    NSString *sellerId = som.sellerId;
    NSNumber *sellPrice = som.discountPrice;
    
    LogInfo(@"[EXTENDED] sellerId: %@", sellerId);
    LogInfo(@"[EXTENDED] sellPrice: %@", sellPrice);
    LogInfo(@"[EXTENDED] sku: %@", _sku);
    
    [[ProductDetailConnection new] loadExtendedWarrantyWithSKU:_sku sellerId:sellerId sellPrice:sellPrice success:^(ExtendedWarrantyProduct *extendedWarrantyProduct) {
        [self setExtendedWarrantyProduct:extendedWarrantyProduct];
    } failure:^(NSError *error) {
        if (self->_pressedBuyBlock) self->_pressedBuyBlock(nil);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableString *importantTextMutable = _importantTextLabel.text.mutableCopy;
    [importantTextMutable appendString:[NSString stringWithFormat:@" %@", knowMoreString]];
    NSMutableAttributedString *importantTextAttributed = [[NSMutableAttributedString alloc] initWithString:importantTextMutable.copy];
    [importantTextAttributed addAttribute:NSForegroundColorAttributeName value:RGBA(26, 117, 207, 1) range:[importantTextMutable rangeOfString:knowMoreString]];
    _importantTextLabel.attributedText = importantTextAttributed.copy;
    _importantTextLabel.userInteractionEnabled = YES;
    [_importantTextLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
    
    [self loadExtendedWarrantyProduct];
}

- (void)handleTapOnLabel:(UITapGestureRecognizer *)tapGesture {
    if ([tapGesture didTapAttributedTextInLabel:_importantTextLabel inRange:[_importantTextLabel.attributedText.string rangeOfString:knowMoreString]]) {
        [self presentKnowMore];
    }
}

- (void)setExtendedWarrantyProduct:(ExtendedWarrantyProduct *)extendedWarrantyProduct {
    _extendedWarrantyProduct = extendedWarrantyProduct;
    
//    BOOL isKit = extendedWarrantyProduct.isKit;
//    NSArray *products = isKit ? extendedWarrantyProduct.kitItems : @[extendedWarrantyProduct];
    NSArray *products = @[extendedWarrantyProduct];
    
    NSInteger totalWarranties = 0;
    for (ExtendedWarrantyProduct *product in products) {
        totalWarranties += product.warranties.count;
    }
    
    // If we only have the "No warranty" option, we should proceed to cart
//    if (totalWarranties <= products.count) {
    if (totalWarranties <= 0) {
        if (_pressedBuyBlock) _pressedBuyBlock(nil);
    }
    else {
        for (ExtendedWarrantyProduct *product in products) {
//            if (product.warranties.count <= 1) continue;
             if (product.warranties.count < 1) continue;
            
            //Get product name
//            NSString *productName = isKit ? product.title : _productTitle;
            NSString *productName = _productTitle;
            NSString *productImage = _productImage;
            
            UIView *topView = _productsContainerView.subviews.count > 0 ? _productsContainerView.subviews.lastObject : _productsContainerView;
            
            WMExtendProduct *productView = [[WMExtendProduct alloc] initWithProductName:productName image:productImage extendedWarranties:product.warranties];
            [_productsContainerView addSubview:productView];
            
            [_productsContainerView addConstraints:@[[NSLayoutConstraint constraintWithItem:productView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:topView
                                                                                  attribute:topView == _productsContainerView ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                                 multiplier:1.0f
                                                                                   constant:topView == _productsContainerView ? 0.0f : 15.0f],
                                                     [NSLayoutConstraint constraintWithItem:productView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:topView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1.0f
                                                                                   constant:0.0f],
                                                     [NSLayoutConstraint constraintWithItem:productView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:topView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                 multiplier:1.0f
                                                                                   constant:0.0f]]];
        }
        
        [_productsContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_productsContainerView.subviews.lastObject
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_productsContainerView
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0f
                                                                            constant:0.0f]];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
        for (WMExtendProduct *productsView in _productsContainerView.subviews) {
            for (WMExtendOptions *optionsView in productsView.warrantiesOptionsContainerView.subviews) {
                [optionsView setSelected:NO animated:NO];
            }
        }
        
        [self.view hideLoading];
    }
}

- (void)buyProduct
{
    NSMutableArray *selectedWarrantiesIds = [NSMutableArray new];
    for (WMExtendProduct *extendedProductView in _productsContainerView.subviews)
    {
        [selectedWarrantiesIds addObject:extendedProductView.selectedWarrantyId];
    }
    
    if ([selectedWarrantiesIds containsObject:@""])
    {
        LogErro(@"Missing options selected ;(");
        [self.view showFeedbackAlertOfKind:WarningAlert message:EXTENDED_WARRANTY_ERROR_OPTIONS_NO_SELECTED];
        //[self.navigationController.view showAlertWithMessage:EXTENDED_WARRANTY_ERROR_OPTIONS_NO_SELECTED];
    }
    else
    {
        //Flurry
        //NSString *extendName = [[NSUserDefaults standardUserDefaults] stringForKey:@"extendSelected"];
        //LogInfo(@"extendName: %@", extendName);
        //[FlurryWM logEvent_eventDetailsWarranty:extendName];
        if (_pressedBuyBlock) _pressedBuyBlock(selectedWarrantiesIds);
    }
}

- (void)presentKnowMore {
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:[WMKnowMoreViewController new]];
    [self.navigationController presentViewController:navigation animated:YES completion:nil];
}

@end
