//
//  PaymentSummaryViewController.h
//  Walmart
//
//  Created by Marcelo Santos on 6/23/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentSummaryViewController : WMBaseViewController {
    
    IBOutlet UIView *totalView;
    
    IBOutlet UILabel *lblTotalPay;
    IBOutlet UILabel *lblValueTotal;
    IBOutlet UIActivityIndicatorView *actTotalPay;
    
    NSDictionary *dictValuesCard;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withValues:(NSDictionary *) dictValues;

@end
