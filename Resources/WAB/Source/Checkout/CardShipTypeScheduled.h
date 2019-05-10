//
//  CardShipTypeScheduled.h
//  Ofertas
//
//  Created by Marcelo Santos on 10/9/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chooseDateDelegate <NSObject>
@required
@optional
- (void) chooseDate;
@end

@interface CardShipTypeScheduled : WMBaseViewController

@property (weak) id <chooseDateDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andType:(NSString *) refType andTime:(NSString *) refTime andValue:(NSString *) refValue andIndex:(NSString *) indexCard;

- (IBAction) choosePeriod;
- (IBAction) select;

@end
