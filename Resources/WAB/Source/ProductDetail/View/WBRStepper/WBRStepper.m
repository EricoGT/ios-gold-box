//
//  WBRStepper.m
//  Walmart
//
//  Created by Cassio Sousa on 29/10/17.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WBRStepper.h"
#import "UIImage+Additions.h"

#define kElementWidth 40
#define kElementHeight 40

#define kStepperButtonNormalColor RGBA(255, 255, 255, 1)
#define kStepperButtonHighlightedColor RGBA(198, 198, 198, 1)
#define kStepperButtonBorderNormalColor RGBA(221, 221, 221, 1).CGColor
#define kStepperButtonBorderHighlightedColor RGBA(177, 177, 177, 1).CGColor
#define kStepperButtonBorderWidth 2.0
#define kStepperButtonRadius 3.0

@interface WBRStepperButton : UIButton
@end

@implementation WBRStepperButton

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.backgroundColor = kStepperButtonNormalColor;
}

@end

@interface WBRStepper ()

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) WBRStepperButton *minusButton;
@property (nonatomic, strong) WBRStepperButton *plusButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@property (nonatomic, assign) NSInteger minimumValue;
@property (nonatomic, assign) NSInteger maximumValue;

@end

@implementation WBRStepper

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        //Loading from XIB, so we set the default values, but they can be changed anytime
        self.maximumValue = 10;
        self.minimumValue = 1;
        self.stepValue = self.minimumValue;
        [self drawControl];
    }
    return self;
}

//*****
// Initalizes the control with default size and with min and max values provided
//*****
- (id)initWithMaximumValue:(NSInteger)max minimumValue:(NSInteger)min
{
    self = [super initWithFrame:CGRectMake(0, 0, kElementWidth * 3, kElementHeight)];
    if (self)
    {
        self.maximumValue = max;
        self.minimumValue = min;
        self.stepValue = self.minimumValue;
        [self drawControl];
    }
    return self;
}

//*****
// Initalizes the control with provided frame and width min and max values provided
//*****
- (id)initWithFrame:(CGRect)frame maximumValue:(NSInteger)max minimumValue:(NSInteger)min
{
    if (frame.size.width < (kElementWidth * 3))
    {
        LogInfo(@"WBRStepper width must have at least %d pixels. Resizing to minimum size", (kElementWidth * 3));
        frame.size.width = (kElementWidth * 3);
    }
    
    if (frame.size.height > kElementHeight)
    {
        LogInfo(@"WBRStepper height must have %d pixels. Resizing to correct size", kElementHeight);
        frame.size.height = kElementHeight;
    }
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.maximumValue = 10;
        self.minimumValue = 1;
        self.stepValue = self.minimumValue;
        [self drawControl];
    }
    return self;
}

- (void) setDisableWarranty
{
    [self.minusButton setImage:[UIImage imageNamed:@"UISharedStepperMinusDisable"] forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:@"UISharedStepperPlusDisable"] forState:UIControlStateNormal];
//    self.valueLabel.alpha = 0.7;
}

- (void)drawControl
{
    self.backgroundColor = [UIColor clearColor];
    
    //Minus Button
    self.minusButton = [WBRStepperButton buttonWithType:UIButtonTypeCustom];
    self.minusButton.frame = CGRectMake(0, 0, kElementWidth, self.frame.size.height);
    [self.minusButton setImage:[UIImage imageNamed:@"ic_wbrstepper_minus"] forState:UIControlStateNormal];
    [self.minusButton setImage:[UIImage imageNamed:@"ic_wbrstepper_minus_pressed"] forState:UIControlStateHighlighted];
    [self.minusButton setImage:[UIImage imageNamed:@"ic_wbrstepper_minus_disable"] forState:UIControlStateDisabled];
    [self.minusButton addTarget:self action:@selector(minusPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.minusButton setHighlighted:NO];
    self.minusButton.clipsToBounds = YES;

    [self addSubview:self.minusButton];
    
    //Minus Button
    self.plusButton = [WBRStepperButton buttonWithType:UIButtonTypeCustom];
    self.plusButton.frame = CGRectMake(self.frame.size.width - kElementWidth - 4, 0, kElementWidth, self.frame.size.height);
    [self.plusButton setImage:[UIImage imageNamed:@"ic_wbrstepper_plus"] forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:@"ic_wbrstepper_plus_pressed"] forState:UIControlStateHighlighted];
    [self.plusButton setImage:[UIImage imageNamed:@"ic_wbrstepper_plus_disable"] forState:UIControlStateDisabled];
    [self.plusButton addTarget:self action:@selector(plusPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.plusButton setHighlighted:NO];
    self.plusButton.layer.masksToBounds = YES;
    self.plusButton.clipsToBounds = YES;

    [self addSubview:self.plusButton];
    
    //Value Label
    CGFloat valueLabelWidth = ((self.frame.size.width - kElementWidth - 1) - kElementWidth);
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kElementWidth, 0, valueLabelWidth, self.frame.size.height)];
    self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.adjustsFontSizeToFitWidth = NO;
    self.valueLabel.numberOfLines = 1;
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:23];
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)self.stepValue];
    self.valueLabel.textColor = RGBA(102, 102, 102, 1);
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.valueLabel.frame.size.width, 1.0f);
//    topBorder.backgroundColor = kStepperButtonBorderNormalColor;
    [self.valueLabel.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.valueLabel.frame.size.height - 1.0f, self.valueLabel.frame.size.width, 1.0f);
    [self.valueLabel.layer addSublayer:bottomBorder];
    [self addSubview:self.valueLabel];
    
    [self checkValues];
}

- (void)checkValues
{
    self.minusButton.enabled = (self.stepValue != self.minimumValue);
    self.plusButton.enabled = (self.stepValue != self.maximumValue);
}

- (void)minusPressed
{
    self.stepValue --;
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)self.stepValue];
    [self checkValues];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)plusPressed
{
    self.stepValue ++;
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)self.stepValue];
    [self checkValues];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma Mark - Loading
- (void)showLoading
{
    self.minusButton.enabled = NO;
    self.plusButton.enabled = NO;
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.valueLabel.center;
    self.spinner.alpha = 0;
    [self.spinner startAnimating];
    [self addSubview:self.spinner];
    
    [UIView animateWithDuration:.2 animations:^{
        self.valueLabel.text = @"";
        self.spinner.alpha = 1;
    }];
}

- (void)stopLoadingAndUpdateCurrentValue:(NSInteger)value maximumValue:(NSInteger)max minimumValue:(NSInteger)min
{
    self.maximumValue = max;
    self.minimumValue = min;
    self.stepValue = value;
    [self checkValues];
    
    [UIView animateWithDuration:.2 animations:^{
        self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)self.stepValue];
        self.spinner.alpha = 0;
    } completion:^(BOOL finished) {
        [self.spinner removeFromSuperview];
        self.spinner = nil;
    }];
}

- (void)setCurrentValue:(NSInteger)value
{
    self.stepValue = value;
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)self.stepValue];
    [self checkValues];
}

- (void)setStepValue:(NSInteger)stepValue
{
    _stepValue = stepValue;
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)self.stepValue];
    [self checkValues];
}

- (void)setCurrentValue:(NSInteger)value maximumValue:(NSInteger)max minimumValue:(NSInteger)min
{
    self.maximumValue = max;
    self.minimumValue = min;
    self.stepValue = value;
    [self checkValues];
}

#pragma Mark - Helper
- (void)applyCornerRadiusForView:(UIView *)aView withRadius:(CGFloat)radius inCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = aView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    aView.layer.mask = maskLayer;
    
    CAShapeLayer *frameLayer = [CAShapeLayer layer];
    frameLayer.frame = aView.bounds;
    frameLayer.path = maskPath.CGPath;
    frameLayer.strokeColor = kStepperButtonBorderNormalColor;
    frameLayer.fillColor = nil;
    
    [aView.layer addSublayer:frameLayer];
}

@end
