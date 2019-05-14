//
//  WMFloatLabelMaskedTextField.m
//  WMFloatLabelMaskedTextField
//
//  Created by Renan Cargnin on 17/04/15.
//  Copyright (c) 2014 Arthur Renan Cargnin. All rights reserved.
//

#import "WMFloatLabelMaskedTextField.h"

@interface WMFloatLabelMaskedTextField ()

@property (nonatomic, assign) CGFloat horizontalPadding;

@property (strong, nonatomic) UIColor *borderColorBeforeError;
@property (assign, nonatomic) BOOL hasError;

@end

@implementation WMFloatLabelMaskedTextField

#pragma mark - Initialization
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = placeholder;
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (![self isFirstResponder] && self.text.length == 0) {
        [self toggleFloatLabelProperties:UIFloatLabelAnimationTypeHide];
    }
    else if ([self.text length]) {
        [self toggleFloatLabelProperties:UIFloatLabelAnimationTypeShow];
    }
}

#pragma mark - Setup
- (void)setup
{
    // Build textField
    [self setupTextField];
    
    // Build floatLabel
    [self setupFloatLabel];
    
    // Enable default UIMenuController options
    [self setupMenuController];
}

- (void)setupTextField
{
    self.horizontalPadding = 10.0f;
    
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 4.0f;
    
    [self setEnabled:self.enabled];
    
    //forces attributedPlaceholder
    [self setPlaceholder:self.placeholder];
}

- (void)setupFloatLabel
{
    self.floatLabelShowAnimationDuration = @0.25f;
    self.floatLabelHideAnimationDuration = @0.25f;
    
    self.floatLabelPassiveColor = RGBA(204, 204, 204, 1); //Start with this color
    self.floatLabelActiveColor = RGBA(204, 204, 204, 1); //End with this color
    
    self.floatLabel = [UILabel new];
    _floatLabel.backgroundColor = RGBA(255, 255, 255, 0);
    _floatLabel.font =[UIFont fontWithName:@"Roboto-Regular" size:11.0f]; //Size of little text inside textView
    _floatLabel.text = self.placeholder;
    _floatLabel.textColor = _floatLabelPassiveColor;
    [_floatLabel sizeToFit];
    [_floatLabel setCenter:CGPointMake(_horizontalPadding, 0.0f)];
    [self addSubview:_floatLabel];
    
    if (self.enabled || self.text.length == 0) {
        _floatLabel.alpha = 0;
    }
}

- (void)setupMenuController
{
    self.pastingEnabled = @YES;
    self.copyingEnabled = @YES;
    self.cuttingEnabled = @YES;
    self.selectEnabled = @YES;
    self.selectAllEnabled = @YES;
}

#pragma mark - UIResponder
-(BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    [self toggleFloatLabel:UIFloatLabelAnimationTypeShow];
    _floatLabel.textColor = _floatLabelActiveColor;
    
    self.layer.borderColor = RGBA(153, 153, 153, 1).CGColor;
    
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    if (self.text.length > 0) {
        _floatLabel.textColor = _floatLabelPassiveColor;
    }
    else {
        [self toggleFloatLabel:UIFloatLabelAnimationTypeHide];
    }
    
    self.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
//    if (action == @selector(paste:)) { // Toggle Pasting
//        return ([_pastingEnabled boolValue]) ? YES : NO;
//    } else if (action == @selector(copy:)) { // Toggle Copying
//        return ([_copyingEnabled boolValue]) ? YES : NO;
//    } else if (action == @selector(cut:)) { // Toggle Cutting
//        return ([_cuttingEnabled boolValue]) ? YES : NO;
//    } else if (action == @selector(select:)) { // Toggle Select
//        return ([_selectEnabled boolValue]) ? YES : NO;
//    } else if (action == @selector(selectAll:)) { // Toggle Select All
//        return ([_selectAllEnabled boolValue]) ? YES : NO;
//    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - Animation
- (void)toggleFloatLabel:(UIFloatLabelAnimationType)animationType
{
    self.placeholder = (animationType == UIFloatLabelAnimationTypeShow) ? @"" : [_floatLabel text];
    
    // Common animation parameters
    UIViewAnimationOptions easingOptions = (animationType == UIFloatLabelAnimationTypeShow) ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn;
    UIViewAnimationOptions combinedOptions = UIViewAnimationOptionBeginFromCurrentState | easingOptions;
    void (^animationBlock)(void) = ^{
        [self toggleFloatLabelProperties:animationType];
    };
    
    // Toggle floatLabel visibility via UIView animation
    CGFloat duration = (animationType == UIFloatLabelAnimationTypeShow) ? [_floatLabelShowAnimationDuration floatValue] : [_floatLabelHideAnimationDuration floatValue];
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:combinedOptions
                     animations:animationBlock
                     completion:nil];
}

- (void)toggleFloatLabelProperties:(UIFloatLabelAnimationType)animationType
{
    _floatLabel.alpha = (animationType == UIFloatLabelAnimationTypeShow) ? 1.0f : 0.0f;
    CGFloat yOrigin = (animationType == UIFloatLabelAnimationTypeShow) ? 3.0f : 0.5f * CGRectGetHeight([self frame]);
    _floatLabel.frame = CGRectMake(_horizontalPadding,
                                   yOrigin,
                                   CGRectGetWidth([_floatLabel frame]),
                                   CGRectGetHeight([_floatLabel frame]));
}

#pragma mark - Border Colors

+ (CGColorRef)enabledBoderColor {
    return RGBA(204, 204, 204, 1).CGColor;
}

+ (CGColorRef)disabledBorderColor {
    return RGBA(204, 204, 204, 1).CGColor;
}

- (CGColorRef)defaultBorderColor {
    if (self.enabled) {
        return [WMFloatLabelMaskedTextField enabledBoderColor];
    }
    else {
        return [WMFloatLabelMaskedTextField disabledBorderColor];
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (self.enabled) {
        self.backgroundColor = RGBA(255, 255, 255, 1);
        self.layer.borderColor = [WMFloatLabelMaskedTextField enabledBoderColor];
    }
    else {
        self.backgroundColor = RGBA(238, 238, 238, 1);
        self.layer.borderColor = [WMFloatLabelMaskedTextField disabledBorderColor];
    }
}

#pragma mak - Placeholder

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    if (placeholder.length > 0) {
        self.floatLabel.text = placeholder;
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: RGBA(33, 150, 243, 1),
              NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:12.0]}];
    }
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect defaultRect = [super placeholderRectForBounds:bounds];
    float yPosition = self.frame.size.height / 2 - defaultRect.size.height / 2;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
        yPosition = 0;
    }
    
    return CGRectMake(_horizontalPadding, yPosition, bounds.size.width , bounds.size.height);
}

#pragma mark - Mask treatment

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * currentTextDigited = [self.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length == 0) {
        while (currentTextDigited.length > 0 && !isnumber([currentTextDigited characterAtIndex:currentTextDigited.length-1])) {
            currentTextDigited = [currentTextDigited substringToIndex:[currentTextDigited length] - 1];
        }
        self.text = currentTextDigited;
        return NO;
    }
    
    NSMutableString * returnText = [[NSMutableString alloc] init];
    if (currentTextDigited.length > _mask.length) {
        return NO;
    }
    
    int last = 0;
    BOOL needAppend = NO;
    for (int i = 0; i < currentTextDigited.length; i++) {
        unichar  currentCharMask = [_mask characterAtIndex:i];
        unichar  currentChar = [currentTextDigited characterAtIndex:i];
        if (isnumber(currentChar) && currentCharMask == '#') {
            [returnText appendString:[NSString stringWithFormat:@"%c",currentChar]];
        }
        else {
            if (currentCharMask == '#') {
                break;
            }
            if (isnumber(currentChar) && currentChar != currentCharMask) {
                needAppend = YES;
            }
            [returnText appendString:[NSString stringWithFormat:@"%c",currentCharMask]];
        }
        last = i;
    }
    
    for (int i = last+1; i < _mask.length; i++) {
        unichar currentCharMask = [_mask characterAtIndex:i];
        if (currentCharMask != '#') {
            [returnText appendString:[NSString stringWithFormat:@"%c",currentCharMask]];
        }
        if (currentCharMask == '#') {
            break;
        }
    }
    if (needAppend) {
        [returnText appendString:string];
    }
    self.text = returnText;
    return NO;
}

- (void)insertTextPreservingMask:(NSString *)text {
    for (int i=0; i<text.length; i++) {
        NSString *character = [NSString stringWithFormat:@"%c", [text characterAtIndex:i]];
        [self shouldChangeCharactersInRange:NSMakeRange(self.text.length, 0) replacementString:character];
    }
}

#pragma mark - Helpers

- (UIEdgeInsets)floatLabelInsets
{
    return UIEdgeInsetsMake(_floatLabel.font.lineHeight,
                            _horizontalPadding,
                            0.0f,
                            _horizontalPadding);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], [self floatLabelInsets]);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect([super editingRectForBounds:bounds], [self floatLabelInsets]);
}

- (NSString *)raw {
    if (self.mask.length > 0) {
        NSMutableString *raw = [NSMutableString new];
        for (int i = 0; i < self.mask.length; i++)
        {
            unichar c = [self.mask characterAtIndex:i];
            if (c == '#' && self.text.length > i)
            {
                [raw appendFormat:@"%c", [self.text characterAtIndex:i]];
            }
        }
        return raw.copy;
    }
    else {
        return self.text;
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (!self.isFirstResponder) {
        [self toggleFloatLabel:UIFloatLabelAnimationTypeHide];
    }
}

#pragma mark - Error
- (void)setErrorWithColor:(UIColor *)color {
    if (!_hasError) {
        self.borderColorBeforeError = [UIColor colorWithCGColor:self.layer.borderColor];
    }
    self.layer.borderColor = color.CGColor;
    self.hasError = YES;
}

- (void)removeError {
    if (_borderColorBeforeError) self.layer.borderColor = _borderColorBeforeError.CGColor;
    self.hasError = NO;
}

@end
