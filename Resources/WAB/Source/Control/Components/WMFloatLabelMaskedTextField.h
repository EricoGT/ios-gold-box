//
//  UIFloatLabelTextField.h
//  UIFloatLabelTextField
//
//  Created by Arthur Sabintsev on 3/3/14.
//  Copyright (c) 2014 Arthur Ariel Sabintsev. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A typedef that delineates the states of the float label
 */
#ifndef UIFloatLabelAnimationType
typedef NS_ENUM(NSUInteger, UIFloatLabelAnimationType)
{
    UIFloatLabelAnimationTypeShow = 0,
    UIFloatLabelAnimationTypeHide
};
#define UIFloatLabelAnimationType UIFloatLabelAnimationType
#endif

@interface WMFloatLabelMaskedTextField : UITextField

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

// A UILabel that @a floats above the contents of the UITextField
@property (nonatomic, strong) UILabel *floatLabel;

// The inactive color for the floatLabel.
@property (nonatomic, strong) UIColor *floatLabelPassiveColor UI_APPEARANCE_SELECTOR;

// The inactive color for the floatLabel.
@property (nonatomic, strong) UIColor *floatLabelActiveColor UI_APPEARANCE_SELECTOR;

// The animation duration when animating-in the float label.
@property (nonatomic, strong) NSNumber *floatLabelShowAnimationDuration UI_APPEARANCE_SELECTOR;

// The animation duration when animating-out the float label.
@property (nonatomic, strong) NSNumber *floatLabelHideAnimationDuration UI_APPEARANCE_SELECTOR;

// Toggles the float label using an animation
- (void)toggleFloatLabel:(UIFloatLabelAnimationType)animationType;

@property (nonatomic, assign) NSNumber *pastingEnabled UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSNumber *copyingEnabled UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSNumber *cuttingEnabled UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSNumber *selectEnabled UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSNumber *selectAllEnabled UI_APPEARANCE_SELECTOR;

// Text field's mask
// Examples -> Cell phone = (##) ##### #### -- CPF = ###.###.###.## -- Zip Code = #####-###
@property (nonatomic, strong) NSString *mask;

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)insertTextPreservingMask:(NSString *)text;
- (NSString *)raw;

+ (CGColorRef)enabledBoderColor;
+ (CGColorRef)disabledBorderColor;
- (CGColorRef)defaultBorderColor;

- (void)setup;
- (void)setErrorWithColor:(UIColor *)color;
- (void)removeError;

@end
