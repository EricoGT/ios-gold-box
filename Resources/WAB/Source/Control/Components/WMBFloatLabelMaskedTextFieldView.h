//
//  WMBFloatLabelMaskedTextFieldView.h
//  Walmart
//
//  Created by Rafael Valim on 13/07/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFloatLabelMaskedTextField.h"

IB_DESIGNABLE

@interface WMBFloatLabelMaskedTextFieldView : UIView

@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *inputTextField;

- (void)startAnimatingActivityIndicator;
- (void)stopAnimatingActivityIndicator;

- (void)showErrorMessage:(NSString *)errorMessage;
- (void)clearErrorMessage;

@end
