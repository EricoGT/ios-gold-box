//
//  PaymentPickerViewController.h
//  CustomComponents
//
//  Created by Marcelo Santos on 2/12/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol comboPickerDelegate <NSObject>
@optional
- (void) closePicker;
- (void) fillTextFieldWithContent:(NSDictionary *) dictContentField;
@end

@interface PaymentPickerViewController : WMBaseViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    __weak id <comboPickerDelegate> delegate;
}

@property (weak) id delegate;

- (void) fillPicker:(NSDictionary *) content;
- (IBAction)back:(id)sender;
- (IBAction)fillTextField;

@end
