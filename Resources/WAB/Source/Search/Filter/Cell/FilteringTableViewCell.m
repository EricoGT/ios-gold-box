//
//  FilteringTableViewCell.m
//  Walmart
//
//  Created by Danilo on 9/10/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "FilteringTableViewCell.h"

@interface FilteringTableViewCell ()

@property (nonatomic, strong) CALayer *bottomBorder;

@end

@implementation FilteringTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setLayout];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.quantityContainer.backgroundColor = RGBA(26, 117, 207, 1);
    [self setUpForActiveState:highlighted];
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.quantityContainer.backgroundColor = RGBA(26, 117, 207, 1);
    [self setUpForActiveState:selected];
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.quantityContainer.backgroundColor = RGBA(26, 117, 207, 1);
}

- (void)setUp
{
    [self setUpForActiveState:NO];
}

- (void)setUpForActiveState:(BOOL)active
{
    self.contentView.backgroundColor = RGBA(238, 238, 238, 1);
    self.containerView.backgroundColor = (active) ? RGBA(247, 247, 247, 1) : RGBA(255, 255, 255, 1);
    UIFont *font = (self.isParent) ? [UIFont fontWithName:@"OpenSans-Semibold" size:15.0] : [UIFont fontWithName:@"OpenSans" size:15.0];
    UIColor *color;
    if (self.isSelectable)
    {
        color = (active) ? RGBA(244, 123, 32, 1) : RGBA(26, 117, 207, 1);
    }
    else
    {
        color = (active) ? RGBA(244, 123, 32, 1) : RGBA(102, 102, 102, 1);
    }
    
    self.filterNameLabel.font = font;
    self.filterNameLabel.textColor = color;
    
    if (!self.isParent)
    {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"– %@", self.filterName]];
        [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedText.length)];
        
        if (active)
        {
            [attributedText addAttribute:NSForegroundColorAttributeName value:RGBA(204, 204, 204, 1) range:NSMakeRange(0, 1)];
        }
        else
        {
            [attributedText addAttribute:NSForegroundColorAttributeName value:RGBA(204, 204, 204, 1) range:NSMakeRange(0, 1)];
        }
        
        self.filterNameLabel.attributedText = attributedText.copy;
    }
    else
    {
        self.filterNameLabel.textColor = color;
        self.filterNameLabel.font = font;
        self.filterNameLabel.text = self.filterName;
    }
}

- (void)setLayout
{
    UIFont *font = (self.isParent) ? [UIFont fontWithName:@"OpenSans-Bold" size:15.0] : [UIFont fontWithName:@"OpenSans" size:15.0];
    self.filterNameLabel.font = font;
    self.filterNameLabel.textColor = RGBA(26, 117, 207, 1);
    
    self.quantityLabel.textAlignment = NSTextAlignmentCenter;
    self.quantityLabel.textColor = [UIColor whiteColor];
    self.quantityLabel.font = [UIFont fontWithName:@"OpenSans" size:11.0];
    
    self.quantityContainer.backgroundColor = RGBA(26, 117, 207, 1);
    self.quantityContainer.layer.borderColor = [RGBA(26, 117, 207, 1) CGColor];
    self.quantityContainer.layer.cornerRadius = 10;
}

- (void)hideQuantityView:(BOOL)hide
{
    self.quantityContainer.hidden = hide;
}

- (void)hideFilterCheckmark:(BOOL)hide
{
    self.filterCheckmark.hidden = hide;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

- (void)roundTop
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft
                                                         cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.containerView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.containerView.layer.mask = maskLayer;
    self.customDivider.hidden = NO;
    self.containerView.layer.borderWidth = 0.0f;
}

- (void)roundBottom
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.containerView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.containerView.layer.mask = maskLayer;
}

- (void)roundTopAndBottom
{
    self.containerView.layer.cornerRadius = 3;
    self.containerView.layer.borderWidth = 0.0f;
    self.customDivider.hidden = YES;
}

- (void)removeRoundness
{
    self.containerView.layer.cornerRadius = 0;
    self.containerView.layer.borderWidth = 0.0f;
    self.customDivider.hidden = NO;
}

@end
