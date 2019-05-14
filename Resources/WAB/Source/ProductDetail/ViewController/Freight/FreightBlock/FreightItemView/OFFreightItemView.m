//
//  OFFreightItemView.m
//  Walmart
//
//  Created by Bruno Delgado on 8/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFFreightItemView.h"
#import "OFFormatter.h"
#import "DeliveryType.h"
#import "ConciergeDeliveryButton.h"

@interface OFFreightItemView ()

@property (nonatomic, weak) IBOutlet UIView *freightView;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) IBOutlet UIView  *failFreightView;
@property (nonatomic, weak) IBOutlet UILabel *infoFailFreightLabel;

@end

@implementation OFFreightItemView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    return self;
}

- (void)setupWithDeliveryType:(DeliveryType *)deliveryType {

    if (!deliveryType) {
        [self.failFreightView setHidden:NO];
        [self.freightView setHidden:YES];
        [self.infoFailFreightLabel setText:@"Indisponível para entrega na sua região."];

    } else {
        [self.failFreightView setHidden:YES];
        [self.freightView setHidden:NO];

        
        NSString *optionDescription;
        if (deliveryType.deliveryTypeID && deliveryType.deliveryTypeID.integerValue == ShippingTypeScheduled) {
            optionDescription = @"Agendada";
        }
        else
        {
            if (deliveryType.shippingEstimateInDays.integerValue == 0)
            {
                optionDescription = DELIVERY_SAME_DAY;
            }
            else
            {
                NSString *days = (deliveryType.shippingEstimate.integerValue == 1) ? @"dia útil" : @"dias úteis";
                optionDescription = [NSString stringWithFormat:@"Em até %@ %@", deliveryType.shippingEstimateInDays, days];
            }
        }
        
        NSNumber *price = (deliveryType.price) ? [NSNumber numberWithDouble:[deliveryType.price doubleValue]/100] :
        [NSNumber numberWithDouble:[deliveryType.firstAvailableWindow.price doubleValue]/100];
        
        self.descriptionLabel.text = optionDescription;
        if (price)
        {
            if (price.integerValue == 0)
            {
                self.priceLabel.text = @"Grátis";
            }
            else
            {
                NSNumberFormatter *formatter = [[OFFormatter sharedInstance] currencyFormatter];
                self.priceLabel.text = [formatter stringFromNumber:price];
            }
        }
        
        [self.descriptionLabel sizeToFit];
        
        if (deliveryType.isConcierge)
        {
            CGFloat conciergeButtonPositionX = self.descriptionLabel.frame.origin.x + self.descriptionLabel.frame.size.width + 5;
            CGFloat conciergeButtonPositionY = self.descriptionLabel.frame.origin.y;
            
            ConciergeDeliveryButton *conciergeInfoButton = [[ConciergeDeliveryButton alloc] initWithFrame:CGRectMake(conciergeButtonPositionX, conciergeButtonPositionY, 16, 16)];
            [self addSubview:conciergeInfoButton];
        }
        
        CGRect frame = self.frame;
        frame.size.height = self.descriptionLabel.frame.size.height;
        self.frame = frame;
    }
}

#pragma mark - View Helper
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

@end
