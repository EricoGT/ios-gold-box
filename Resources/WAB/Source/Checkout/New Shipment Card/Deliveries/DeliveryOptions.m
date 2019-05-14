//
//  DeliveryOptions.m
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "DeliveryOptions.h"
#import "DeliveryItemView.h"
#import "NewShipmentCard.h"

@interface DeliveryOptions ()

@property (nonatomic, strong) NSMutableArray *deliveryOptionsViews;
@property (nonatomic, weak) IBOutlet UILabel *deliveriesTitleLabel;

@end

@implementation DeliveryOptions

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

- (void)setupWithDeliveryTypes:(NSArray *)deliveryTypes
{
    CGRect viewFrame = self.frame;
    CGFloat currentPosition = viewFrame.size.height;
    
    self.deliveryOptionsViews = [NSMutableArray new];
    for (DeliveryType *deliveryOption in deliveryTypes)
    {
        DeliveryItemView *optionView = (DeliveryItemView *)[DeliveryItemView viewWithXibName:@"DeliveryItemView"];
        optionView.optionsBlock = self;
        
        if (self.card) deliveryOption.priceMap = self.card.shippingDelivery.deliveryTypePriceMap;
        [optionView setupWithDeliveryType:deliveryOption];
        optionView.frame = CGRectMake(0, currentPosition, optionView.frame.size.width, optionView.frame.size.height);
        [self addSubview:optionView];
        [self.deliveryOptionsViews addObject:optionView];
        currentPosition += optionView.frame.size.height;
    }
    
    [self selectCheapestDelivery];
    
    //Setting the new frame for the view according to card information
    viewFrame.size.height = currentPosition;
    self.frame = viewFrame;
}

#pragma mark - Cheapest
- (void)selectCheapestDelivery
{
    DeliveryItemView *cheapestDelivery;
    for (DeliveryItemView *item in self.deliveryOptionsViews)
    {
        if (![item .currentDeliveryType isScheduledShipping])
        {
            if (!cheapestDelivery) cheapestDelivery = item;
            double cheapestPrice = cheapestDelivery.currentDeliveryType.price.doubleValue;
            double currentPrice = item.currentDeliveryType.price.doubleValue;
            if (currentPrice < cheapestPrice) cheapestDelivery = item;
        }
    }
    
    if (cheapestDelivery) [cheapestDelivery selectItem];
}

#pragma mark - Items Control
- (void)deselectAllOptions
{
    [self.deliveryOptionsViews makeObjectsPerformSelector:@selector(deselectItem)];
}

- (void)resetScheduleDate
{
    [self.deliveryOptionsViews makeObjectsPerformSelector:@selector(resetSchedule)];
}

- (void)showOptionsForDeliveryItemView:(DeliveryItemView *)item
{
    if (self.card)
    {
        [self.card openDeliveryOptionsForDeliveryItemView:item];
    }
}

@end
