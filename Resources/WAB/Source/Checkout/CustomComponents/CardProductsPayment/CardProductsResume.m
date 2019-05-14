//
//  CardProductsResume.m
//  CustomComponents
//
//  Created by Marcelo Santos on 3/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "CardProductsResume.h"
#import "CardProductsView.h"
#import "CardWarrantyView.h"
#import "OFSetupCustomCheckout.h"
#import "DeliveryEstimateInteractor.h"

@interface CardProductsResume ()

@property (nonatomic, weak) IBOutlet UIView *viewLine;
@property (nonatomic, weak) IBOutlet UILabel *lblProducts;
@property (nonatomic, weak) IBOutlet UIButton *btEdit;

- (IBAction)editProductsInCart:(id)sender;

@end

@implementation CardProductsResume
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lblProducts.font = [UIFont fontWithName:fontSemiBold size:sizeFont15];
    [self formatView:self.view];
    [self fillCardProductsWithContent:[self products]];
}

- (NSDictionary *)products
{
    NSDictionary *dictCart = [_paymentDictionary valueForKey:@"cart"];
    NSArray *items = [dictCart objectForKey:@"items"];
    
    NSMutableArray *mutableProducts = [NSMutableArray new];
    for (NSDictionary *item in items)
    {
        //First, verify if this is a warranty extended
        BOOL service = [item[@"service"] boolValue];
        if (service)
        {
            //_hasExtendedWarranty = YES;
            NSString *description = item[@"productName"] ?: @"";
            NSString *extendedType = item[@"description"] ?: @"";
            
            NSMutableDictionary *warranty = [NSMutableDictionary new];
            [warranty setObject:description forKey:@"description"];
            [warranty setObject:extendedType forKey:@"extendedType"];
            [warranty setObject:@"warranty" forKey:@"typeProduct"];
            [warranty setObject:@(YES) forKey:@"enableEdit"];
            [mutableProducts addObject:warranty.copy];
        }
        else
        {
            NSString *fullDescription = item[@"description"] ?: @"";
            NSString *quantity = item[@"quantity"] ?: @"";
            NSString *sellerName = item[@"sellerName"] ?: @"";
            NSString *sellerId = item[@"sellerId"] ?: @"";
            NSString *imageURL = item[@"originalImageUrl"] ?: @"";
            
            NSDictionary *productDelivery;
            NSArray *deliveriesArray = [_paymentDictionary objectForKey:@"selectedDeliveries"];
            for (NSDictionary *delivery in deliveriesArray) {
                NSArray *itemsKeys = delivery[@"itemsKeys"];
                if ([itemsKeys containsObject:item[@"key"]]) {
                    productDelivery = delivery;
                    break;
                }
            }
            
            if (!productDelivery) productDelivery = deliveriesArray[0];
            
            NSString *estimatedBestShippingEstimate = productDelivery[@"shippingEstimateInDays"] ?: @"";
            
            NSNumber *deliveryEstimateInDays = productDelivery[@"shippingEstimateInDays"];
            NSString *deliveryEstimateTimeUnit = productDelivery[@"shippingEstimateTimeUnit"];
            NSString *customDeliveryInformation = [DeliveryEstimateInteractor deliveryEstimateWithDays:deliveryEstimateInDays.unsignedIntegerValue unit:deliveryEstimateTimeUnit];
            
            BOOL isConcierge = _paymentDictionary[@"isConcierge"] ? [_paymentDictionary[@"isConcierge"] boolValue] : NO;
            
            NSMutableDictionary *product = [NSMutableDictionary new];
            [product setObject:fullDescription forKey:@"description"];
            [product setObject:quantity forKey:@"quantity"];
            [product setObject:sellerName forKey:@"deliveryInfo"];
            [product setObject:sellerId forKey:@"sellerId"];
            [product setObject:estimatedBestShippingEstimate forKey:@"deliveryTime"];
            [product setObject:customDeliveryInformation forKey:@"customDeliveryInformation"];
            [product setObject:imageURL forKey:@"idImage"];
            [product setObject:@"product" forKey:@"typeProduct"];
            [product setObject:@(YES) forKey:@"enableEdit"];
            [product setObject:@(isConcierge) forKey:@"isConcierge"];
            [mutableProducts addObject:product.copy];
        }
    }
    
    return @{@"products" : mutableProducts.copy, @"enableEdit" : @(YES)};
}

- (void)updateContentWithProducts:(NSDictionary *)dictContentProducts;
{
    [self fillCardProductsWithContent:dictContentProducts];
}

- (void)fillCardProductsWithContent:(NSDictionary *)dictContentProducts
{
    LogInfo(@"Products to fill card: \n%@\n", dictContentProducts);
    
    if (![[dictContentProducts objectForKey:@"enableEdit"] boolValue])
    {
        _btEdit.hidden = YES;
    }
    
    NSArray *arrProducts = [dictContentProducts objectForKey:@"products"];
    int ttProducts = (int) [arrProducts count];
    
    float initialPosition = _viewLine.frame.origin.y;
    float lastHeightCardProducts = 0;
    
    for (int i=0;i<ttProducts;i++)
    {
        if ([[[arrProducts objectAtIndex:i] objectForKey:@"typeProduct"] isEqualToString:@"warranty"])
        {
            CardWarrantyView *cw = [[CardWarrantyView alloc] initWithNibName:@"CardWarrantyView" bundle:nil];
            cw.view.frame = CGRectMake(0, initialPosition, cw.view.frame.size.width, cw.view.frame.size.height);
            [cw fillContentExtended:[arrProducts objectAtIndex:i]];
            cw.view.frame = CGRectMake(0, initialPosition, cw.view.frame.size.width, cw.view.frame.size.height);
            LogInfo(@"Extended Card Height when creating the card: %f", cw.view.frame.size.height);

            [self addChildViewController:cw];
            [self.view addSubview:cw.view];

            lastHeightCardProducts = lastHeightCardProducts + cw.view.frame.size.height;
            initialPosition = initialPosition + cw.view.frame.size.height;
        }
        else
        {
            CardProductsView *cp = [[CardProductsView alloc] initWithNibName:@"CardProductsView" bundle:nil];
            cp.delegate = self;
            cp.view.frame = CGRectMake(0, initialPosition, cp.view.frame.size.width, cp.view.frame.size.height);
            [cp fillContentWithProduct:[arrProducts objectAtIndex:i]];

            [self addChildViewController:cp];
            [self.view addSubview:cp.view];

            lastHeightCardProducts = lastHeightCardProducts + cp.view.frame.size.height;
            initialPosition = initialPosition + cp.view.frame.size.height;
        }
    }
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, lastHeightCardProducts + _viewLine.frame.origin.y);
}

- (void) formatView:(UIView *)viewToRounded
{
    viewToRounded.layer.masksToBounds = YES;
    viewToRounded.layer.borderWidth = 1.0f;
    viewToRounded.layer.cornerRadius = 3.0f;
    viewToRounded.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
}

- (void) editProductsInCart:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(backToCartFromCardProducts)])
    {
        [self.delegate backToCartFromCardProducts];
    }
}

- (void) backToSelectDeliveryFromCardProducts
{
    if ([self.delegate respondsToSelector:@selector(backToSelectDeliveries)])
    {
        [self.delegate backToSelectDeliveries];
    }
}

- (void)removeEdition
{
    self.btEdit.hidden = YES;
    for (id controller in self.childViewControllers)
    {
        if ([controller isKindOfClass:CardProductsView.class])
        {
            [(CardProductsView *)controller removeEdition];
        }
    }
}

@end
