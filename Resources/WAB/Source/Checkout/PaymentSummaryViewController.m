//
//  PaymentSummaryViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 6/23/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "PaymentSummaryViewController.h"
#import "PaymentSummaryItem.h"

@interface PaymentSummaryViewController ()

@end

@implementation PaymentSummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withValues:(NSDictionary *) dictValues
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        dictValuesCard = dictValues;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSDictionary *dictValues = @{@"vlProducts"  :   [NSString stringWithFormat:@"%f", vlProducts],
//                                 @"vlShipments" :   [NSString stringWithFormat:@"%f", vlShipments],
//                                 @"vlDiscounts"    :   [NSString stringWithFormat:@"%f", vlDiscounts],
//                                 @"vlGlobal"    :   [NSString stringWithFormat:@"%f", vlGlobal]
//                                 };
    
    LogNewCheck(@"Dict Card Summary: %@", dictValuesCard);
    CGFloat position = 0;
    
    //Products
    float vlProducts = [dictValuesCard[@"vlProducts"] floatValue];
    
    PaymentSummaryItem *productsItem = (PaymentSummaryItem *)[PaymentSummaryItem setup];
    [productsItem setLayout];
    productsItem.summaryTitleLabel.text = @"Produtos";
    productsItem.summaryValueLabel.text = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:vlProducts]];
    productsItem.frame = CGRectMake(0, position, productsItem.frame.size.width, productsItem.frame.size.height);
    [self.view addSubview:productsItem];
    position += productsItem.frame.size.height;
    
    //Discount
    float vlDiscounts = [dictValuesCard[@"vlDiscounts"] floatValue];
    if (vlDiscounts > 0)
    {
        PaymentSummaryItem *discountItem = (PaymentSummaryItem *)[PaymentSummaryItem setup];
        [discountItem setLayout];
        discountItem.summaryTitleLabel.text = @"Desconto";
        discountItem.summaryValueLabel.text = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:vlDiscounts]];
        discountItem.frame = CGRectMake(0, position, discountItem.frame.size.width, discountItem.frame.size.height);
        [self.view addSubview:discountItem];
        position += discountItem.frame.size.height;
    }
    
    //Shipment
    float vlShipments = [dictValuesCard[@"vlShipments"] floatValue];
    PaymentSummaryItem *shipmentItem = (PaymentSummaryItem *)[PaymentSummaryItem setup];
    [shipmentItem setLayout];
    shipmentItem.summaryTitleLabel.text = @"Entrega";
    if (vlShipments > 0) {
        shipmentItem.summaryValueLabel.text = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:vlShipments]];
    } else {
        shipmentItem.summaryValueLabel.text = SHIPMENT_VALUE_FREE;
    }
    shipmentItem.frame = CGRectMake(0, position, shipmentItem.frame.size.width, shipmentItem.frame.size.height);
    [self.view addSubview:shipmentItem];
    position += shipmentItem.frame.size.height;
    
    //Extended Warranty
    float vlServices = [dictValuesCard[@"vlServices"] floatValue];
    if (vlServices > 0)
    {
        PaymentSummaryItem *servicesItem = (PaymentSummaryItem *)[PaymentSummaryItem setup];
        [servicesItem setLayout];
        servicesItem.summaryTitleLabel.text = @"Seguro Garantia Estendida Original";
        servicesItem.summaryValueLabel.text = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:vlServices]];
        servicesItem.frame = CGRectMake(0, position, servicesItem.frame.size.width, servicesItem.frame.size.height);
        [self.view addSubview:servicesItem];
        position += servicesItem.frame.size.height;
    }
    
    actTotalPay.hidden = YES;
    lblValueTotal.hidden = NO;
    float vlGlobal = [dictValuesCard[@"vlGlobal"] floatValue];
    lblValueTotal.text = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:vlGlobal]];
    [self.view bringSubviewToFront:totalView];
    
    //Adjusting total size
    position += totalView.frame.size.height;
    CGRect correctFrame = self.view.frame;
    correctFrame.size.height = position - 4;
    self.view.frame = correctFrame;
}

//Currency
- (NSString *) currencyFormat:(float) value {
    
    NSNumber *amount = [[NSNumber alloc] initWithFloat:value];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"R$"];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *newFormat = [numberFormatter stringFromNumber:amount];
    
    LogInfo(@"Number: %@", newFormat);
    
    //Remove currency symbol
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"R$" withString:@""];
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    return newFormat;
}

@end
