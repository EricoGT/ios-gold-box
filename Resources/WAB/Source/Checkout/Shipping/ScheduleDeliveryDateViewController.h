//
//  ScheduleDeliveryDateViewController.h
//  Table Navigation
//
//  Created by Diego Dias on 24/08/17.
//

#import <UIKit/UIKit.h>

@class DeliveryType, ScheduleDeliveryDateViewController;

@protocol ScheduleDeliveryDateViewControllerDelegate <NSObject>
@optional
- (void)scheduledDeliveryView:(ScheduleDeliveryDateViewController *)scheduledDeliveryView selectedDate:(NSDate *)date periodDictionary:(NSDictionary *)periodDictionary;
@end

@interface ScheduleDeliveryDateViewController : UIViewController

@property (weak) id <ScheduleDeliveryDateViewControllerDelegate> delegate;

- (ScheduleDeliveryDateViewController *)initWithDeliveryType:(DeliveryType *)deliveryType delegate:(id <ScheduleDeliveryDateViewControllerDelegate>)delegate;
@property (nonatomic, copy) void (^kDidEnterBackgroundNotification)(void);

@end
