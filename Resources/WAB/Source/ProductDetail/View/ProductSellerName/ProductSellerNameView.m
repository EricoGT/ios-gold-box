//
//  ProductSellerNameView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductSellerNameView.h"

#import "SellerOptionModel.h"

@interface ProductSellerNameView ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) SellerOptionModel *seller;

@end

@implementation ProductSellerNameView

- (ProductSellerNameView *)initWithSeller:(SellerOptionModel *)seller delegate:(id<ProductSellerNameViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        
        [self setup];
        [self setSeller:seller];
    }
    return self;
}

- (void)layoutSubviews {
    _label.preferredMaxLayoutWidth = _label.bounds.size.width;
    
    [super layoutSubviews];
}

- (void)setup {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLabel)];
    [_label addGestureRecognizer:tapGesture];
    _label.userInteractionEnabled = YES;
}

- (void)setSeller:(SellerOptionModel *)seller {
    NSString *availableStatusString = seller.available ? @"Em estoque" : @"ESGOTADO";
    
    NSMutableString *strMutable = [[NSMutableString alloc] initWithString:@"Vendido e entregue por:\n"];
    [strMutable appendFormat:@"%@ | %@", seller.name, availableStatusString];
    NSString *str = strMutable.copy;
    
    NSMutableAttributedString *mutableAttributed = [[NSMutableAttributedString alloc] initWithString:str];
    [mutableAttributed addAttribute:NSForegroundColorAttributeName value:RGBA(33, 150, 243, 1) range:[str rangeOfString:seller.name]];
    [mutableAttributed addAttribute:NSForegroundColorAttributeName value:RGBA(76, 175, 80, 1) range:[str rangeOfString:availableStatusString]];
    
    self.label.attributedText = mutableAttributed.copy;
    
    _seller = seller;
}

- (void)tappedLabel {
    if (_delegate && [_delegate respondsToSelector:@selector(productSellerNameDidTapWithSellerId:)]) {
        [_delegate productSellerNameDidTapWithSellerId:_seller.sellerId];
    }
}

@end
