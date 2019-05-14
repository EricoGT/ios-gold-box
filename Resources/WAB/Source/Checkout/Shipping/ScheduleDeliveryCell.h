//
//  ScheduleDeliveryDateCell.h
//  Table Navigation
//
//  Created by Diego Batista Dias Leite on 25/08/17.
//  Copyright © 2017 Diego Batista Dias Leite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleDeliveryCell : UITableViewCell

- (void)bindScheduleDate:(NSDictionary *)scheduleDate;
- (void)bindSchedulePeriod:(NSString *)periodString startHour:(NSString *)startHour endHour:(NSString *)endHour;

+ (NSString *)reuseIdentifier;

@end
