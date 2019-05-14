//
//  ShippingDeliveryCell.m
//  Walmart
//
//  Created by Renan on 5/2/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ShippingDeliveryCell.h"
#import "ConciergeDeliveryButton.h"
#import "DeliveryType.h"
#import "WBRScheduleDeliveryUtils.h"

@interface ShippingDeliveryCell ()

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UIImageView *checkImageView;
@property (nonatomic, weak) IBOutlet ConciergeDeliveryButton *conciergeButton;

@property (nonatomic, weak) IBOutlet UIView *scheduledShippingView;
@property (nonatomic, weak) IBOutlet UIImageView *scheduledShippingImageView;
@property (nonatomic, weak) IBOutlet UILabel *scheduledShippingLabel;

@end

@implementation ShippingDeliveryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self.checkImageView setImage:[UIImage imageNamed:selected ? @"shipmentCheckOn" : @"shipmentCheckOff"]];
    
    if (!selected) {
        self.scheduledShippingImageView.image = [UIImage imageNamed:@"shipmentDateDeselected"];
        self.scheduledShippingLabel.hidden = YES;
        self.descriptionLabel.textColor = RGB(153, 153, 153);
    }
    else {
        self.descriptionLabel.textColor = RGB(102, 102, 102);
    }
}

- (void)setupWithDeliveryType:(DeliveryType *)deliveryType
{
    self.descriptionLabel.text = deliveryType.shippingEstimate;
    self.valueLabel.text = deliveryType.deliveryPrice;
    self.conciergeButton.hidden = !(deliveryType.deliveryTypeID.integerValue == ShippingTypeConcierge);

    [self showDeliveryDateIfNeededWithDeliveryType:deliveryType];
}

- (void)showDeliveryDateIfNeededWithDeliveryType:(DeliveryType *)deliveryType {
    
    if ([deliveryType isScheduledShipping]) {
        
        self.scheduledShippingView.hidden = NO;
        
        if (deliveryType.selectedScheduledDeliveryPeriod) {
            NSNumber *UTCTime = deliveryType.selectedScheduledDeliveryPeriod[@"startDateUtc"];
            NSString *scheduledShippingText = [NSString stringWithFormat:@"%@ - %@", [self formattedDataWithUTCTime:UTCTime], [WBRScheduleDeliveryUtils convertePeriodText:deliveryType.selectedScheduledDeliveryPeriod[@"period"]]];
            self.scheduledShippingLabel.text = scheduledShippingText;
            self.scheduledShippingImageView.image = [UIImage imageNamed:@"shipmentDateSelected"];
            self.scheduledShippingLabel.hidden = NO;
        }
        else {
            self.scheduledShippingImageView.image = [UIImage imageNamed:@"shipmentDateDeselected"];
            self.scheduledShippingLabel.hidden = YES;
        }
    }
    else {
        self.scheduledShippingView.hidden = YES;
    }
}

- (NSString *)formattedDataWithUTCTime:(NSNumber *)UTCTime {
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(UTCTime.doubleValue) / 1000.0];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM"];
    NSString *formattedDate = [dateFormatter stringFromDate:startDate];
    
    return formattedDate;
}

@end
