//
//  OrderProductsBlock.m
//  Tracking
//
//  Created by Bruno Delgado on 4/28/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "OrderProductsBlock.h"
#import "ProductBlock.h"
#import "NSString+Additions.h"
#import "OFFormatter.h"
#import "ProductCustomView.h"

@interface OrderProductsBlock ()

@property (nonatomic, weak) IBOutlet UIView *productsView;
@property (nonatomic, weak) IBOutlet UIView *containerCardView;

@property (weak, nonatomic) IBOutlet UIView *sellerNameView;
@property (strong, nonatomic) TrackingSeller *seller;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productsHeightConstraint;

@end

@implementation OrderProductsBlock

- (void)setupWithOrderDelivery:(TrackingDeliveryDetail *)delivery kits:(NSArray *)kits
{
    CGFloat productViewTotalHeight = 0;
    
    self.seller = delivery.seller;
    
    //ITENS
    for (TrackingDeliveryDetailItem *item in delivery.items)
    {
        if (delivery.seller.sellerName.length > 0)
        {
            NSString *sellerString = [NSString stringWithFormat:SELLER_SOLD_AND_DELIVERED_BY_FORMAT, delivery.seller.sellerName];
            NSMutableAttributedString *attributedSellerString = [[NSMutableAttributedString alloc] initWithString:sellerString];
            [attributedSellerString addAttribute:NSForegroundColorAttributeName value:RGBA(26, 117, 207, 1) range:[sellerString rangeOfString:delivery.seller.sellerName]];
            self.shippingDoneBy.attributedText = attributedSellerString.copy;
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSellerLabel)];
            [_sellerNameView addGestureRecognizer:tapRecognizer];
        }
        else {
            _shippingDoneBy.text = @"";
        }
        
        if (delivery.expectedDeliveryDate)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
            NSString *strDate = [dateFormatter stringFromDate:delivery.expectedDeliveryDate];
            
            if (delivery.messageDate)
            {
                NSString *deliveryDateString = [NSString stringWithFormat:@"%@%@", delivery.messageDate, strDate];
                self.shippingEstimated.text = deliveryDateString;
            }
            else
            {
                NSString *deliveryMessage = [[OFMessages new] expectedOrderDeliveryDate];
                NSString *deliveryDateString = [NSString stringWithFormat:deliveryMessage,strDate];
                self.shippingEstimated.text = deliveryDateString;
            }
        }
        else
        {
            self.shippingEstimated.text = @"";
        }
        
        ProductCustomView *product = (ProductCustomView *)[ProductCustomView viewWithXibName:@"ProductCustomView"];
        [product setupWithDeliveryItem:item kits:kits];
        CGRect productFrame = product.frame;
        productFrame.origin.y = productViewTotalHeight;
        productFrame.size.width = self.frame.size.width;
        product.frame = productFrame;
        
        [self.productsView addSubview:product];
        productViewTotalHeight += product.frame.size.height;
        
        if ( [[delivery.items lastObject] isEqual:item] )
        {
            [product hideProductDivider:YES];
        }
        else
        {
            [product hideProductDivider:NO];
        }
    }
    
    _productsHeightConstraint.constant = productViewTotalHeight;
    [self layoutIfNeeded];
    
    [self setLayout];
    
    CGRect frame = self.frame;
    frame.size.height = [self systemLayoutSizeFittingSize:self.bounds.size].height;
    self.frame = frame;
}

- (void)setLayout
{
    self.containerCardView.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.containerCardView.layer.borderWidth = 1.0f;
    self.containerCardView.layer.cornerRadius = 0;
}

- (void)tappedSellerLabel {
    if (_delegate && [_delegate respondsToSelector:@selector(showSellerDescriptionWithSellerId:)]) {
        [_delegate showSellerDescriptionWithSellerId:_seller.sellerId];
    }
}

@end
