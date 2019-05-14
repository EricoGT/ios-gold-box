//
//  ButtonWithArrow.m
//  Tracking
//
//  Created by Bruno Delgado on 4/24/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "FilterButton.h"
#import "UIImage+Additions.h"
#import "OFColors.h"

@implementation FilterButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUp];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

#pragma mark - SetUp
- (void)setUp
{
    [self createButton];
    //[self addLeftMargin];
}

- (void)createButton
{
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.button];
    
    [self addRightArrow];
    [self adjustLayout];
}

- (void)addRightArrow
{
    CGSize imageSize = CGSizeMake(13.0f, 13.0f);
    UIImage *arrow = [UIImage imageNamed:@"UISharedAccessoryArrow"];
    [self.button setImage:arrow forState:UIControlStateNormal];
    
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageSize.width + 13);
    self.button.imageEdgeInsets = UIEdgeInsetsMake(0, self.frame.size.width - 13 - imageSize.width, 0, 0);
}

- (void)adjustLayout
{
    self.backgroundColor = [UIColor clearColor];
    [self.button setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
    
    self.button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    [self.button setBackgroundImage:[UIImage imageWithColor:RGBA(255, 255, 255, 1)] forState:UIControlStateNormal];
    [self.button setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1)] forState:UIControlStateHighlighted];
    [self.button setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1)] forState:UIControlStateSelected];
    [self.button setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1)] forState:UIControlStateSelected | UIControlStateHighlighted];
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.button.layer.cornerRadius = 3;
    self.button.clipsToBounds = YES;
    self.button.layer.borderWidth = 1.0f;
    self.button.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)activate
{
    [self setSelected:YES];
}

- (void)deactivate
{
    [self setSelected:NO];
}

#pragma mark - Handle Button Methods
- (void)setSelected:(BOOL)selected
{
    [self.button setSelected:selected];
    if (selected)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.button.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.button.imageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

- (BOOL)isSelected
{
    return self.button.selected;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [self.button setTitle:title forState:state];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

@end
