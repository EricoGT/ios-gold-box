//
//  SeparatePaymentAlertViewController.m
//  Walmart
//
//  Created by Renan Cargnin on 3/2/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "SeparatePaymentAlertViewController.h"
#import "OFColors.h"
#import "WMButtonRounded.h"

@implementation SeparatePaymentAlertViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        
//    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewAlert.layer.cornerRadius = 3;
}

- (IBAction)pressedLicense:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showWarrantyLicense)])
    {
        [self.delegate showWarrantyLicense];
    }
}

- (IBAction)yesPressed:(id)sender {
    [self.view removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseSinglePayment)]) {
        [self.delegate chooseSinglePayment];
        [FlurryWM logEvent_eventCheckoutPaymentChoice:@"conjunto"];
    }
}


- (IBAction)noPressed:(id)sender {
    [self.view removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseSeparatePayment)]) {
        [self.delegate chooseSeparatePayment];
        [FlurryWM logEvent_eventCheckoutPaymentChoice:@"separado"];
    }
}

@end
