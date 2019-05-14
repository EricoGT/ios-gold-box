//
//  WMBContactRequestThankYouPageViewController.h
//  Walmart
//
//  Created by Rafael Valim dos Santos on 06/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMBContactRequestThankYouPageViewControllerDelegate <NSObject>
@optional
- (void)thankyouPageTicketFinish;
- (void)thankyouPageTicketListTouched;
@end

@interface WMBContactRequestThankYouPageViewController : UIViewController

@property (weak) id <WMBContactRequestThankYouPageViewControllerDelegate> delegate;


- (instancetype)initWithRequestId:(NSString *)requestId andFromMenu:(BOOL)fromMenu andButtonTitleString:(NSString *)buttonTitle;

@end
