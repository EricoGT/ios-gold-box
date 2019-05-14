//
//  WMPickerTextField.m
//  Walmart
//
//  Created by Renan on 6/15/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMPickerTextField.h"

#import "WMPicker.h"
#import "NSString+Additions.h"

@interface WMPickerTextField () <WMPickerDelegate>

@property (strong, nonatomic) NSString *textBeforeBecomingFirstResponder;

@end

@implementation WMPickerTextField

- (WMPickerTextField *)init {
    self = [super init];
    if (self) {
        [self setupPicker];
    }
    return self;
}

- (WMPickerTextField *)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPicker];
    }
    return self;
}

- (WMPickerTextField *)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPicker];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.textColor = RGBA(102, 102, 102, 1);
    [self setupRightView];
}

#pragma mark - Layout

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect defaultRect = [super rightViewRectForBounds:bounds];
    defaultRect.origin.x -= 10.0f;
    return defaultRect;
}

//Disables selection
- (UITextRange *)selectedTextRange {
    return nil;
}

//Disables all controls
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

//Disables caret
- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

//Disables magnifying glass
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        gestureRecognizer.enabled = NO;
    }
    [super addGestureRecognizer:gestureRecognizer];
}

#pragma mark - Setup
- (void)setupRightView {
    self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_picker"]];
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (BOOL)becomeFirstResponder {
    
    if ([self.wmPickerTextFieldDelegate respondsToSelector:@selector(pickerTextFieldShouldOpenPicker:)]) {
        BOOL shouldOpenPicker = [self.wmPickerTextFieldDelegate pickerTextFieldShouldOpenPicker:self];
        
        if (shouldOpenPicker) {
            [self openPicker];
        }
        else {
            
            if ([self.wmPickerTextFieldDelegate respondsToSelector:@selector(pickerTextFieldDidSelect:)]) {
                [self.wmPickerTextFieldDelegate pickerTextFieldDidSelect:self];
            }
            
            return NO;
        }
    }
    else {
        [self openPicker];
    }
   
    return YES;
}

- (void)openPicker {
    if (!self.isFirstResponder) {
        [super becomeFirstResponder];
        self.textBeforeBecomingFirstResponder = self.text;
        if (self.options.count > 0) {
            self.text = self.options[self.selectedOptionIndex];
            [self.picker selectRow:self.selectedOptionIndex inComponent:0 animated:NO];
        }
    }
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    [self didFinishSelecting];
    return YES;
}

- (void)didFinishSelecting {
    if (![self.text isEqualToString:self.textBeforeBecomingFirstResponder]) {
        if ([self.wmPickerTextFieldDelegate respondsToSelector:@selector(pickerTextField:didFinishSelectingOption:)]) {
            [self.wmPickerTextFieldDelegate pickerTextField:self didFinishSelectingOption:self.options[self.selectedOptionIndex]];
        }
        
        if ([self.wmPickerTextFieldDelegate respondsToSelector:@selector(pickerTextField:didFinishSelectingIndex:)]) {
            [self.wmPickerTextFieldDelegate pickerTextField:self didFinishSelectingIndex:self.selectedOptionIndex];
        }
    }
}

#pragma mark - Picker

- (void)setupPicker {
    self.picker = [WMPicker new];
    self.picker.wmPickerDelegate = self;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.inputView = self.picker.inputView;
}

- (void)setOptions:(NSArray *)options {
    _options = options;
    [self setupPicker];
    [self.picker reloadAllComponents];
}

- (void)pressedOk {
    [super resignFirstResponder];
    if (self.picker) {
        [self didFinishSelecting];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.options.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.options[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.isFirstResponder) {
        self.text = self.options[row];
        self.selectedOptionIndex = row;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        NSString *optionStr = self.options[row];
        CGSize size = [optionStr sizeForTextWithFont:self.picker.font constrainedToSize:CGSizeMake(self.picker.bounds.size.width, CGFLOAT_MAX)];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = optionStr;
        label.font = self.picker.font;
    }
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    CGFloat rowHeight = 0;
    for (NSString *optionStr in self.options) {
        CGFloat height = [optionStr sizeForTextWithFont:self.picker.font constrainedToSize:CGSizeMake(self.picker.bounds.size.width, CGFLOAT_MAX)].height;
        if (height > rowHeight) {
            rowHeight = height;
        }
    }
    return rowHeight;
}

- (void)selectFirstOption {
    if (self.options.count == 0) return;
    [self.picker selectRow:0 inComponent:0 animated:NO];
    self.selectedOptionIndex = 0;
    self.text = self.options.firstObject;
}

- (void)resetPicker {
    self.text = @"";
    self.selectedOptionIndex = 0;
}

@end
