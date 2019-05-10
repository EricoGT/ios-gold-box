//
//  NewShipmentCard.m
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "NewShipmentCard.h"
#import "ShipmentOptions.h"
#import "ShippingCartItem.h"
#import "CartItem.h"

#import "DeliveryOptions.h"

#define kMargin 15
#define kCardSizeWithoutShipmentInfo 42
#define kCardSizeWithShipmentInfo 52


@interface NewShipmentCard ()

@property (nonatomic, strong) IBOutlet UIView *card;
@property (nonatomic, assign) IBOutlet UILabel *deliveryTitle;
@property (nonatomic, assign) IBOutlet UILabel *shippingEstimateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;

@property (strong, nonatomic) NSString *sellerId;
@property (strong, nonatomic) NSString *sellerName;

@end

@implementation NewShipmentCard

//Loading view from XIB
+ (UIView *)viewWithXibName:(NSString *)xibName
{
    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    if (xibArray.count > 0)
    {
        UIView *view = [xibArray firstObject];
        return view;
    }
    return nil;
}

- (void)setDeliveryTitleText:(NSString *)currentDeliveryFormatted
{
    self.deliveryTitle.text = currentDeliveryFormatted;
}

- (void)setupCardWithShippingDelivery:(ShippingDelivery *)shippingInfos simpleVersion:(BOOL)simpleVersion showShipmentInformation:(BOOL)showShipmentInformation showSellerName:(BOOL)showSellerName
{
    [self setLayout:simpleVersion];
    
    self.shippingEstimateLabel.hidden = !showShipmentInformation;
    self.sellerNameLabel.hidden = !showSellerName;
    
    self.shippingDelivery = shippingInfos;
    CGRect viewFrame = self.frame;
    viewFrame.size.height = (showShipmentInformation) ? kCardSizeWithShipmentInfo : kCardSizeWithoutShipmentInfo;
    self.frame = viewFrame;
    CGFloat currentPosition = viewFrame.size.height;
    
    //Divider
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, currentPosition - 1, viewFrame.size.width, 1)];
    divider.backgroundColor = RGBA(221, 221, 221, 1);
    [self.card addSubview:divider];
    currentPosition += divider.frame.size.height;
    
    CGRect sellerNameFrame = self.sellerNameLabel.frame;
    CGFloat centeredInDeliveryTitle = (self.deliveryTitle.frame.origin.y + (self.deliveryTitle.frame.size.height/2)) - (sellerNameFrame.size.height/2);
    
    sellerNameFrame.origin.y = (showShipmentInformation) ? self.shippingEstimateLabel.frame.origin.y : centeredInDeliveryTitle;
    self.sellerNameLabel.frame = sellerNameFrame;
    
    self.sellerId = shippingInfos.sellerId;
    self.sellerName = shippingInfos.sellerName;
    
    NSString *sellerNameStr = [NSString stringWithFormat:@"por %@", _sellerName];
    NSMutableAttributedString *sellerNameAttributed = [[NSMutableAttributedString alloc] initWithString:sellerNameStr];
    [sellerNameAttributed addAttribute:NSForegroundColorAttributeName value:RGBA(26, 117, 207, 1) range:[sellerNameStr rangeOfString:_sellerName]];
    
    self.sellerNameLabel.attributedText = sellerNameAttributed.copy;
    
    UIView *sellerTapView = [[UIView alloc] initWithFrame:self.sellerNameLabel.frame];
    sellerTapView.backgroundColor = [UIColor clearColor];
    [self addSubview:sellerTapView];
    
    UITapGestureRecognizer *sellerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSellerName)];
    [sellerTapView addGestureRecognizer:sellerTapGesture];
    
    //************************
    // Cart Products
    //************************
    NSArray *cartItems = self.shippingDelivery.cartItems;
    
    for (CartItem *cartItem in cartItems)
    {        
        ShippingCartItem *cartItemView = (ShippingCartItem *)[ShippingCartItem viewWithXibName:@"ShippingCartItem"];
        [cartItemView setupWithCartItem:cartItem];
        cartItemView.frame = CGRectMake(kMargin, currentPosition, cartItemView.frame.size.width, cartItemView.frame.size.height);
        [self.card addSubview:cartItemView];
        currentPosition += cartItemView.frame.size.height;
    }
    
    if (!simpleVersion)
    {
        //************************
        // Shipping Options
        //************************
        NSArray *deliveryTypes = self.shippingDelivery.deliveryTypes;
        
        DeliveryOptions *deliveriesBlock = (DeliveryOptions *)[DeliveryOptions viewWithXibName:@"DeliveryOptions"];
        deliveriesBlock.card = self;
        [deliveriesBlock setupWithDeliveryTypes:deliveryTypes];
        deliveriesBlock.frame = CGRectMake(kMargin, currentPosition, deliveriesBlock.frame.size.width, deliveriesBlock.frame.size.height);
        [self.card addSubview:deliveriesBlock];
        currentPosition += deliveriesBlock.frame.size.height;
    }
    
    //Setting the new frame for the view according to card information
    viewFrame.size.height = currentPosition;
    self.frame = viewFrame;
}

#pragma mark - Options
- (void)openDeliveryOptionsForDeliveryItemView:(DeliveryItemView *)item
{
    if (self.shipmentOptionsReference)
    {
        [self.shipmentOptionsReference shipOptionsForDeliveryItemView:item];
    }
}

#pragma mark - Shipping Estimate
- (void)setShippingEstimate:(NSString *)shippingEstimate
{
    self.shippingEstimateLabel.text = shippingEstimate;
    self.shippingEstimateLabel.hidden = NO;
}

#pragma mark - Layout
- (void)setLayout:(BOOL)isSimple
{
    self.card.layer.cornerRadius = 3;
    self.card.layer.masksToBounds = YES;
    self.card.layer.borderWidth = 1.0f;
    self.card.layer.borderColor = (isSimple) ? RGBA(221, 221, 221, 1).CGColor : RGBA(209, 209, 209, 1).CGColor;
    
    self.deliveryTitle.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    self.deliveryTitle.textColor = RGBA(102, 102, 102, 1);
    
    self.shippingEstimateLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    self.shippingEstimateLabel.textColor = RGBA(153, 153, 153, 1);
}

- (void)tappedSellerName {
    if (_delegate && [_delegate respondsToSelector:@selector(showSellerDescriptionWithSellerId:)]) {
        [_delegate showSellerDescriptionWithSellerId:_sellerId];
    }
}

@end
