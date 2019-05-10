//
//  OrderCalculationsBlock.m
//  Walmart
//
//  Created by Danilo on 10/21/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OrderCalculationsBlock.h"
#import "TrackingOrderPayment.h"
#import "TrackingDeliveryDetailItem.h"
#import "OFFormatter.h"
#import "NSString+Additions.h"

#define kSpaceBetweenLabels 14.0f

@interface OrderCalculationsBlock()

@property (weak, nonatomic) IBOutlet UILabel *subtotalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingLabel;
@property (weak, nonatomic) IBOutlet UILabel *importTaxTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *importTaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicesLabel;
@property (weak, nonatomic) IBOutlet UILabel *warrantyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *warrantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIView *footer;

@end

@implementation OrderCalculationsBlock

- (void)setupCalculationsWithDetails:(TrackingOrderDetail *)details
{
    [self setBorders];
    
    //Subtotal
    NSNumber *itemsCount = [NSNumber numberWithInt:0];
    
    for (TrackingDeliveryDetail *delivery in details.deliveries)
    {
        for (TrackingDeliveryDetailItem *item in delivery.items) {
            itemsCount = [NSNumber numberWithFloat:[itemsCount floatValue] + [item.acquiredQuantity floatValue]];
        }
    }
    
    NSNumberFormatter *formatter = [[OFFormatter sharedInstance] currencyFormatter];
    NSString *subtotalAmount = [formatter stringFromNumber:details.payment.orderTotal.itemsPrice];
    
    self.subtotalTitleLabel.text = [NSString stringWithFormat:@"Subtotal (%@ %@)",itemsCount ,([itemsCount isEqualToNumber:@1]) ? @"item" : @"itens"];
    self.subtotalLabel.text = subtotalAmount;
    
    //Freight
    NSString *shipping = details.payment.orderTotal.shipping.floatValue > 0.0f ? [formatter stringFromNumber:details.payment.orderTotal.shipping] : SHIPMENT_VALUE_FREE;
    self.shippingLabel.text = shipping;
    
    /*
    BOOL hasGlobal = NO;
    for (TrackingDeliveryDetail *delivery in details.deliveries)
    {
        for (TrackingDeliveryDetailItem *item in delivery.items) {
            if ( ! [item.originCountry isEqualToString:@"pt-BR"]) {
                hasGlobal = YES;
            }
        }
    }
    */
    
    CGFloat lastPosition = self.shippingTitleLabel.frame.origin.y + self.shippingTitleLabel.frame.size.height + kSpaceBetweenLabels;
    
    //Tax Import
    if (details.payment.orderTotal.taxImport.integerValue > 0) {
        NSString *taxImport = [formatter stringFromNumber:details.payment.orderTotal.taxImport];
        self.importTaxLabel.text = taxImport;
        lastPosition = self.importTaxTitleLabel.frame.origin.y + self.importTaxTitleLabel.frame.size.height + kSpaceBetweenLabels;
    }
    else {
        self.importTaxTitleLabel.hidden = YES;
        self.importTaxLabel.hidden = YES;
    }
    
    //Services
    if (details.payment.orderTotal.services.integerValue > 0) {
        NSString *services = [formatter stringFromNumber:details.payment.orderTotal.services];
        self.servicesLabel.text = services;
        
        [self updateViewFrame:self.servicesTitleLabel withLastPosition:lastPosition];
        [self updateViewFrame:self.servicesLabel withLastPosition:lastPosition];
        
        lastPosition = self.servicesTitleLabel.frame.origin.y + self.servicesTitleLabel.frame.size.height + kSpaceBetweenLabels;
    }
    else {
        self.servicesTitleLabel.hidden = YES;
        self.servicesLabel.hidden = YES;
    }
    
    //Extended Warranty
    if (details.payment.orderTotal.warranty.integerValue > 0) {
        NSString *warranty = [formatter stringFromNumber:details.payment.orderTotal.warranty];
        self.warrantyLabel.text = warranty;
        
        [self updateViewFrame:self.warrantyTitleLabel withLastPosition:lastPosition];
        [self updateViewFrame:self.warrantyLabel withLastPosition:lastPosition];
        
        lastPosition = self.warrantyTitleLabel.frame.origin.y + self.warrantyTitleLabel.frame.size.height + kSpaceBetweenLabels;
    }
    else {
        self.warrantyTitleLabel.hidden = YES;
        self.warrantyLabel.hidden = YES;
    }
    
    //Discounts
    if (details.payment.orderTotal.discount.integerValue > 0)
    {
        details.payment.orderTotal.discount = [NSNumber numberWithFloat:details.payment.orderTotal.discount.floatValue];
        NSString *discounts = [formatter stringFromNumber:details.payment.orderTotal.discount];
        self.discountsLabel.text = discounts;
        
        [self updateViewFrame:self.discountsTitleLabel withLastPosition:lastPosition];
        [self updateViewFrame:self.discountsLabel withLastPosition:lastPosition];
        
        lastPosition = self.discountsTitleLabel.frame.origin.y + self.discountsTitleLabel.frame.size.height + kSpaceBetweenLabels;
    }
    else {
        self.discountsTitleLabel.hidden = YES;
        self.discountsLabel.hidden = YES;
    }
    
    //Valor Total
    NSString *total = [formatter stringFromNumber:details.payment.orderTotal.currencyAmount];
    self.totalLabel.text = total;
    [self updateViewFrame:self.totalTitleLabel withLastPosition:lastPosition];
    [self updateViewFrame:self.totalLabel withLastPosition:lastPosition];
    lastPosition = self.totalTitleLabel.frame.origin.y + self.totalTitleLabel.frame.size.height + kSpaceBetweenLabels;
    
    CGRect frame = self.frame;
    frame.size.height = lastPosition + self.footer.frame.size.height;
    self.frame = frame;
}

- (void)updateViewFrame:(UIView *)view withLastPosition:(CGFloat)lastPosition {
    CGRect viewFrame = view.frame;
    viewFrame.origin.y = lastPosition;
    view.frame = viewFrame;
}

- (void)setBorders
{
    self.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 0;
}

@end
