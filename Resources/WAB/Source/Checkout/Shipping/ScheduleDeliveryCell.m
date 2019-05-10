//
//  ScheduleDeliveryDateCell.m
//  Table Navigation
//
//  Created by Diego Batista Dias Leite on 25/08/17.
//  Copyright © 2017 Diego Batista Dias Leite. All rights reserved.
//

#import "ScheduleDeliveryCell.h"

@interface ScheduleDeliveryCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *cardView;

@end

@implementation ScheduleDeliveryCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([ScheduleDeliveryCell class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.cardView.layer.cornerRadius = 4.0f;
    self.cardView.layer.masksToBounds = YES;
    
    [self setBorderColorGray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self setBorderColorBlue];
    } else {
        [self setBorderColorGray];
    }
}

- (void)bindScheduleDate:(NSString *)stringDate {
    NSDateFormatter *originalFormatter = [NSDateFormatter new];
    [originalFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [originalFormatter dateFromString:stringDate];
    
    NSDateFormatter *customFormatter = [NSDateFormatter new];
    [customFormatter setDateFormat:@"dd/MM"];
    
    NSString *dateString = [customFormatter stringFromDate:date];

    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    [customFormatter setDateFormat:@"EEEE"];
    [customFormatter setLocale:locale];
    NSString *dayOfWeekString = [self sentenceCapitalizedString:[[customFormatter stringFromDate:date] capitalizedString]];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", dateString, dayOfWeekString];
}

- (NSString *)sentenceCapitalizedString:(NSString *)stringWeekDay {
    
    NSString *uppercase = [[stringWeekDay substringToIndex:1] uppercaseString];
    NSString *lowercase = [[stringWeekDay substringFromIndex:1] lowercaseString];
    return [uppercase stringByAppendingString:lowercase];
}

- (void)bindSchedulePeriod:(NSString *)periodString startHour:(NSString *)startHour endHour:(NSString *)endHour {
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@ às %@", periodString, startHour, endHour];
}

- (void)setBorderColorBlue {
    self.cardView.layer.borderWidth = 2.0f;
    self.cardView.layer.borderColor =  RGBA(33, 150, 243, 1).CGColor;
}

- (void)setBorderColorGray {
    self.cardView.layer.borderWidth = 1.0f;
    self.cardView.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
}

@end
