//
//  SHPMenuTableViewCell.m
//  Walmart
//
//  Created by Bruno Delgado on 4/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "SHPMenuTableViewCell.h"

@interface SHPMenuTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *menuTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *menuIconImageView;

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *iconSelected;
@property (nonatomic, weak) IBOutlet UIView *customBackground;

@end

@implementation SHPMenuTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topSeparator.hidden = YES;
    self.bottomSeparator.hidden = NO;
}

- (void)setupWithMenuItem:(SHPMenuItem *)item
{
    self.icon = item.menuIcon;
    self.iconSelected = item.menuIconSelected;
    
    self.menuTitleLabel.text = item.menuName;
    self.menuIconImageView.image = item.menuIcon;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self configureCellForState:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self configureCellForState:selected];
}

- (void)configureCellForState:(BOOL)enabled
{
    self.customBackground.backgroundColor = (enabled) ? RGBA(255, 255, 255, 0.05) : [UIColor clearColor];
    self.menuTitleLabel.textColor = (enabled) ? [self menuSelectedTextColor] : [self menuTextColor];
//    self.menuIconImageView.image = (enabled) ? self.iconSelected : self.icon;
}

- (UIColor *)menuTextColor
{
    return RGBA(255, 255, 255, 1);
}

- (UIColor *)menuSelectedTextColor
{
    return RGBA(246, 180, 40, 1);
}

@end
