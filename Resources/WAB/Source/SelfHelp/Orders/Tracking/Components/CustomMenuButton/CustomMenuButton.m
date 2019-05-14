//
//  CustomMenuButton.m
//  Tracking
//
//  Created by Bruno Delgado on 4/29/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "CustomMenuButton.h"
#import "NSString+Additions.h"

static const CGFloat indicatorViewHeight = 3;

@interface CustomMenuButton ()

@property (nonatomic, strong) UIView *bottomIndicatorView;
@property (nonatomic, strong) NSString *menuName;

@end

@implementation CustomMenuButton

//Designated initializer
- (id)initWithButtonTitle:(NSString *)buttonTitle
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 44)];
    if (self)
    {
        self.menuName = buttonTitle;
        [self setup];
    }
    return self;
}

- (UIColor *)activeColor
{
    return RGBA(26, 117, 207, 1);
}

- (UIColor *)inactiveColor
{
    return RGBA(204, 204, 204, 1);
}

- (UIFont *)customButtonFont
{
    return [UIFont fontWithName:@"OpenSans-Semibold" size:14];
}

- (void)setup
{
    CGSize textSize = [self.menuName sizeForTextWithFont:[self customButtonFont] constrainedToSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, self.frame.size.height)];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [self customButtonFont];
    self.textLabel.textColor = [self activeColor];
    self.textLabel.text = self.menuName;
    [self addSubview:self.textLabel];
    
    self.frame = CGRectMake(0, 0, textSize.width, self.frame.size.height);
    
    self.bottomIndicatorView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width/2) - (textSize.width/2),
                                                                        self.frame.size.height - indicatorViewHeight,
                                                                        textSize.width,
                                                                        indicatorViewHeight)];
    self.bottomIndicatorView.backgroundColor = [self activeColor];
    [self addSubview:self.bottomIndicatorView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = self.textLabel.frame;
    [self addSubview:self.button];
}

- (void)setBlockForTouchUpInsideEvent:(ActionBlock)action
{
    self.actionBlock = [action copy];
    [self.button addTarget:self action:@selector(runActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)runActionBlock:(id)sender
{
    _actionBlock();
}

- (void)setActive:(BOOL)isActive
{
    _active = isActive;
    if (isActive)
    {
        self.textLabel.textColor = [self activeColor];
        self.bottomIndicatorView.backgroundColor = [self activeColor];
    }
    else
    {
        self.textLabel.textColor = [self inactiveColor];
        self.bottomIndicatorView.backgroundColor = [self inactiveColor];
    }
}

- (void)hidesBottomBar
{
    self.bottomIndicatorView.hidden = YES;
}

- (void)setLayout
{
    
}

@end
