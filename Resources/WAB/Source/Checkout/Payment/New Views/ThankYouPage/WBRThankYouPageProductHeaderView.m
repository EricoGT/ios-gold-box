//
//  WBRThankYouPageProductHeaderView.m
//  Walmart
//
//  Created by Rafael Valim on 22/09/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRThankYouPageProductHeaderView.h"

@interface WBRThankYouPageProductHeaderView ()

@property (strong, nonatomic) ShippingDelivery *shippingDelivery;

@end

@implementation WBRThankYouPageProductHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"WBRThankYouPageProductHeaderView"
                                                         owner:self
                                                       options:nil];
        UIView *nibView = [objects firstObject];
        UIView *contentView = self.contentView;
        nibView.frame = contentView.bounds;
        [contentView addSubview:nibView];
    }
    return self;
}

#pragma mark - Private Methods

- (void)didTapSellerTitle {
    [self.delegate WBRThankYouPageProductHeaderView:self didChooseSeller:self.shippingDelivery];
}

#pragma mark - Custom Setter

- (void)setShippingDelivery:(ShippingDelivery *)shippingDelivery
                  onSection:(NSInteger)section
                    ofTotal:(NSInteger)sections
           withDeliveryInfo:(NSDictionary *)deliveryInformation {
    
    self.shippingDelivery = shippingDelivery;
    
    NSString *sellerNamePrefix = @"Vendido e entregue por";
    NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", sellerNamePrefix, self.shippingDelivery.sellerName]];
    
    [mutableAttrString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:11.0f] range:NSMakeRange(0, mutableAttrString.string.length)];
    [mutableAttrString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Medium" size:11.0f] range:[mutableAttrString.string rangeOfString:self.shippingDelivery.sellerName]];
    
    [mutableAttrString addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(0, mutableAttrString.string.length)];
    [mutableAttrString addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:[mutableAttrString.string rangeOfString:self.shippingDelivery.sellerName]];
    
    [self.deliverSequenceLabel setText:[NSString stringWithFormat:@"Entrega %ld de %lu", ((long)section + 1), (long)sections]];
    
    [self.deliveryEstimateLabel setText:((NSString *)[deliveryInformation objectForKey:shippingDelivery.sellerId])];
    
    [self.sellerNameLabel setAttributedText:mutableAttrString];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSellerTitle)];
    [self.sellerNameLabel addGestureRecognizer:tapGestureRecognizer];
    self.sellerNameLabel.userInteractionEnabled = YES;
}

+ (NSString *)reuseIdentifier {
    return @"cellThankYouPageProductTableViewHeader";
}

@end
