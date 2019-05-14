//
//  ChangePasswordViewController.h
//  Walmart
//
//  Created by Renan on 4/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"

@class WMButton, WMFloatLabelMaskedTextField, FormAlertView;

@interface ChangePasswordViewController : WMBaseViewController

@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtCurrentPass;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtNewPass;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *txtNewPassConfirmation;

- (NSArray *)validateAndGetInvalidFields;

- (IBAction)saveChangesPressed:(id)sender;

@end
