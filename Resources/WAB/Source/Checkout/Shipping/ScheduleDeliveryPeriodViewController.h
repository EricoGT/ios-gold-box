//
//  ScheduleDeliveryPeriodViewController.m
//  Table Navigation
//
//  Created by Diego Dias on 25/08/17.
//

#import <UIKit/UIKit.h>

@protocol ScheduleDeliveryPeriodViewControllerDelegate <NSObject>
@required
- (void)periodSelected:(NSDictionary *)period;
@end

@interface ScheduleDeliveryPeriodViewController : UIViewController

@property (weak) id <ScheduleDeliveryPeriodViewControllerDelegate> delegate;

- (ScheduleDeliveryPeriodViewController *)initWithPeriodsArray:(NSArray *)periodsArray selectedDate:(NSDate *)selectedDate;
@property (nonatomic, copy) void (^kDidEnterBackgroundNotification)(void);

@end
