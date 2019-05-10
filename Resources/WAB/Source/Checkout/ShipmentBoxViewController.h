//
//  ShipmentBoxViewController.h
//  Ofertas
//
//  Created by Marcelo Santos on 17/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol shipDelegate <NSObject>
@optional
- (void) openPayment;
@end


@interface ShipmentBoxViewController : WMBaseViewController

@property (weak) id <shipDelegate> delegate;

- (IBAction) cancel;
- (IBAction) continueToPayment;

- (IBAction) chooseMorning;
- (IBAction) chooseAfternoon;
- (IBAction) chooseNight;

- (NSString *)formattedScheduledDate;


@end
