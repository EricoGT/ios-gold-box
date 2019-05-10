//
//  SeparatePaymentAlertViewController.h
//  Walmart
//
//  Created by Renan Cargnin on 3/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol separatePaymentDelegate <NSObject>
@optional
- (void)chooseSinglePayment;
- (void)chooseSeparatePayment;
- (void)showWarrantyLicense;
@end

@class WMButtonRounded;

@interface SeparatePaymentAlertViewController : WMBaseViewController {
    __weak id <separatePaymentDelegate> delegate;
}

@property (weak) id delegate;
@property (weak, nonatomic) IBOutlet UIView *viewAlert;
@property (weak, nonatomic) IBOutlet UIButton *btShowLicense;
@property (strong, nonatomic) IBOutlet WMButtonRounded *btYes;
@property (strong, nonatomic) IBOutlet WMButtonRounded *btNo;

- (IBAction)pressedLicense:(id)sender;

@end
