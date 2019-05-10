//
//  DeliveryItemView.m
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "DeliveryItemView.h"
#import "DeliveryType.h"
#import "OFShipmentTemp.h"
#import "NewShipmentCard.h"
#import "OFShipmentTemp.h"
#import "WMButton.h"

#define kDeliveryItemSimpleSize 42
#define kDeliveryItemScheduledSize 90

@interface DeliveryItemView ()

@property (nonatomic, strong) IBOutlet UIButton *selectionButton;
@property (nonatomic, strong) IBOutlet UIView *scheduledView;
@property (nonatomic, strong) IBOutlet UILabel *scheduleDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *periodLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isSchedule;

- (IBAction)selectPressed:(id)sender;
- (IBAction)scheduledViewPressed:(id)sender;

@end

@implementation DeliveryItemView

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

- (void)setupWithDeliveryType:(DeliveryType *)deliveryType
{
    self.isSelected = NO;
    CGRect viewFrame = self.frame;
    
    self.dateLabel.text = @"";
    self.periodLabel.text = @"";
    self.dateLabel.hidden = YES;
    self.periodLabel.hidden = YES;
    
    self.currentDeliveryType = deliveryType;
    self.descriptionLabel.text = [deliveryType shippingEstimate];
    self.priceLabel.text = [deliveryType deliveryPrice];
    
    self.isSchedule = [deliveryType isScheduledShipping];
    if (self.isSchedule)
    {
        viewFrame.size.height = kDeliveryItemScheduledSize;
        self.scheduledView.hidden = NO;
    }
    else
    {
        viewFrame.size.height = kDeliveryItemSimpleSize;
        self.scheduledView.hidden = YES;
    }
    
    self.frame = viewFrame;
}

#pragma mark - Scheduled View
- (void)scheduledViewPressed:(id)sender
{
    if (self.isSchedule)
    {
        [self.optionsBlock showOptionsForDeliveryItemView:self];
    }
}

- (void)updateScheduledDeliverSelectedDate:(NSString *)date period:(NSString *)period
{
    if (self.isSchedule)
    {
        self.dateLabel.text = date ?: @"";
        self.periodLabel.text = period ? [NSString stringWithFormat:@"Período: %@", period] : @"";
        self.dateLabel.hidden = NO;
        self.periodLabel.hidden = NO;
        self.scheduleDateLabel.hidden = YES;
    }
}

- (void)resetSchedule
{
    if (self.isSchedule)
    {
        self.dateLabel.text = @"";
        self.periodLabel.text = @"";
        self.dateLabel.hidden = YES;
        self.periodLabel.hidden = YES;
        
        self.scheduleDateLabel.text = @"Escolha uma data";
        self.scheduleDateLabel.hidden = NO;
        
        [[OFShipmentTemp new] resetDeliveries];
    }
}

#pragma mark - Selection
- (void)selectPressed:(id)sender
{
    [[OFShipmentTemp new] resetDeliveries];
    
    [self selectItem];
    
    if (!self.isSchedule)
    {
        if (self.optionsBlock)
        {
            [self.optionsBlock resetScheduleDate];
        }
    }
}

- (void)selectItem
{
    [self deselectAll];
    [self.selectionButton setSelected:YES];
    self.isSelected = YES;
    [self storeSelectedShippingInfo];
}

- (void)deselectItem
{
    [self.selectionButton setSelected:NO];
    self.isSelected = NO;
}

- (void)deselectAll
{
    if (self.optionsBlock)
    {
        [self.optionsBlock deselectAllOptions];
    }
}

- (void)storeSelectedShippingInfo
{
    ShippingDelivery *shipppingDelivery = self.optionsBlock.card.shippingDelivery;
    NSArray *cartItems = shipppingDelivery.cartItems;
    NSMutableArray *mutableItemKeys = [NSMutableArray new];
    for (CartItem *cartItem in cartItems)
    {
        [mutableItemKeys addObject:cartItem.key];
    }
    
    NSArray *itemKeys = mutableItemKeys.copy;
    NSString *deliveryTypeId = self.currentDeliveryType.deliveryTypeID ?: @"";
    NSNumber *shippingEstimateInDays = self.currentDeliveryType.shippingEstimateInDays ?: @0;
    NSString *shippingEstimateTimeUnit = self.currentDeliveryType.shippingEstimateTimeUnit ?: @"";
    NSString *sellerID = shipppingDelivery.sellerId ?: @"";
    NSNumber *price = ([self.currentDeliveryType.priceMap objectForKey:self.currentDeliveryType.deliveryTypeID]) ?: [NSNumber numberWithInteger:0];
    NSString *name = self.currentDeliveryType.name;
    NSDictionary *deliveryInfo = nil;
    
    if (self.isSchedule)
    {
        NSDictionary *scheduledDeliveryInfo = [[OFShipmentTemp new] getSelectedShipmentDetails];
        if (scheduledDeliveryInfo)
        {
            NSMutableDictionary *mutableDeliveryInfo = [[NSMutableDictionary alloc] initWithDictionary:scheduledDeliveryInfo];
            [mutableDeliveryInfo setObject:price forKey:@"price"];
            
            deliveryInfo = @{@"deliveryWindow" : mutableDeliveryInfo.copy,
                             @"itemsKeys" : itemKeys,
                             @"deliveryTypeId" : deliveryTypeId,
                             @"sellerId" : sellerID,
                             @"price" : price,
                             @"name" : name,
                             @"shippingEstimateInDays" : shippingEstimateInDays,
                             @"shippingEstimateTimeUnit" : shippingEstimateTimeUnit};
        }
    }
    else
    {
        deliveryInfo = @{@"itemsKeys" : itemKeys,
                         @"deliveryTypeId" : deliveryTypeId,
                         @"sellerId" : sellerID,
                         @"price" : price,
                         @"name" : name,
                         @"shippingEstimateInDays" : shippingEstimateInDays,
                         @"shippingEstimateTimeUnit" : shippingEstimateTimeUnit};
    }
    
    [self.optionsBlock.card setCurrentShipmentDictionary:deliveryInfo];
    LogInfo(@"Payment Dictionary: %@", deliveryInfo);
}

@end
