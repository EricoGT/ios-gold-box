//
//  ProductSellerView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductSellerView.h"

#import "SellerOptionModel.h"
#import "NSNumber+Currency.h"

@interface ProductSellerView ()

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSupplier;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;

@property (strong, nonatomic) SellerOptionModel *seller;

@end

@implementation ProductSellerView

- (ProductSellerView *)initWithSeller:(SellerOptionModel *)seller delegate:(id <ProductSellerViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        
        [self setup];
        [self setSeller:seller];
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

- (void)setup {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setSeller:(SellerOptionModel *)seller {
    _lblPrice.text = [seller.discountPrice currencyFormatWithCurrencySymbol:@"R$ "];
    
    NSString *strNameSupplier = seller.name;
    strNameSupplier = [strNameSupplier stringByReplacingOccurrencesOfString:@"Fornecido por " withString:@""];
    _lblSupplier.text = [NSString stringWithFormat:SELLER_SOLD_AND_DELIVERED_BY_FORMAT, strNameSupplier];
    
    _sellerNameLabel.text = seller.name;
    
    _seller = seller;
}

#pragma mark - IBAction
- (IBAction)pressedCart {
    if (_delegate && [_delegate respondsToSelector:@selector(productSellerPressedCartWithSeller:)])
    {
        [_delegate productSellerPressedCartWithSeller:_seller];
    }
}

#pragma mark - UIGestureRecognizer
- (void)tappedView {
    if (_delegate && [_delegate respondsToSelector:@selector(productSellerDidTapWithSellerId:)]) {
        [_delegate productSellerDidTapWithSellerId:_seller.sellerId];
    }
}

@end
