//
//  WMPickerTextField.h
//  Walmart
//
//  Created by Renan on 6/15/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMFloatLabelMaskedTextField.h"

@protocol WMPickerTextFieldDelegate <NSObject>
@optional
- (BOOL)pickerTextFieldShouldOpenPicker:(id)pickerTextField;
- (void)pickerTextFieldDidSelect:(id)pickerTextField;
- (void)pickerTextField:(id)pickerTextField didFinishSelectingOption:(NSString *)option;
- (void)pickerTextField:(id)pickerTextField didFinishSelectingIndex:(NSInteger)index;
@end

@class WMPicker;

@interface WMPickerTextField : WMFloatLabelMaskedTextField <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong,nonatomic) WMPicker *picker;
@property (strong, nonatomic) NSArray *options;
@property (assign, nonatomic) NSInteger selectedOptionIndex;
@property (weak) id <WMPickerTextFieldDelegate> wmPickerTextFieldDelegate;

- (void)selectFirstOption;
- (void)resetPicker;

@end
