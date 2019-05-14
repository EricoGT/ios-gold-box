//
//  ProductSellersView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductSellersView.h"

#import "ProductSellerView.h"
#import "SellerOptionModel.h"

@interface ProductSellersView () <ProductSellerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *sellersContainerView;

@end

@implementation ProductSellersView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (ProductSellersView *)initWithSellers:(NSArray *)sellers delegate:(id<ProductSellersViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        
        [self setup];
        [self setSellers:sellers];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
}

- (void)setSellers:(NSArray *)sellers {
    [_sellersContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (SellerOptionModel *seller in sellers) {
        UIView *topView = _sellersContainerView.subviews.count > 0 ? _sellersContainerView.subviews.lastObject : _sellersContainerView;
        
        ProductSellerView *sellerView = [[ProductSellerView alloc] initWithSeller:seller delegate:self];
        [_sellersContainerView addSubview:sellerView];
        
        [_sellersContainerView addConstraint:[NSLayoutConstraint constraintWithItem:sellerView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:topView
                                                                          attribute:topView == _sellersContainerView ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                                         multiplier:1.0f
                                                                           constant:topView == _sellersContainerView ? 0.0f : 0.0f]];
        
        [_sellersContainerView addConstraint:[NSLayoutConstraint constraintWithItem:sellerView
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_sellersContainerView
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1.0f
                                                                           constant:0.0f]];
        
        [_sellersContainerView addConstraint:[NSLayoutConstraint constraintWithItem:sellerView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_sellersContainerView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0f
                                                                           constant:0.0f]];
    }
    
    UIView *lastSubview = _sellersContainerView.subviews.lastObject;
    [_sellersContainerView addConstraint:[NSLayoutConstraint constraintWithItem:lastSubview
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_sellersContainerView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f
                                                                       constant:0.0f]];
}

#pragma mark - ProductSellerViewDelegate
- (void)productSellerDidTapWithSellerId:(NSString *)sellerId {
    if (_delegate && [_delegate respondsToSelector:@selector(productSellersDidTapWithSellerId:)]) {
        [_delegate productSellersDidTapWithSellerId:sellerId];
    }
}

- (void)productSellerPressedCartWithSeller:(SellerOptionModel *)seller {
    if (_delegate && [_delegate respondsToSelector:@selector(productSellersBuyProductWithSellerId:)]) {
        [_delegate productSellersBuyProductWithSellerId:seller.sellerId];
    }
}

@end
