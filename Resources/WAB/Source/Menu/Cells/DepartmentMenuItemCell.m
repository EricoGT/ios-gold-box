//
//  DepartmentMenuItemCell.m
//  Walmart
//
//  Created by Bruno Delgado on 11/25/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "DepartmentMenuItemCell.h"
#import "DepartmentMenuItem.h"
#import "UIImageView+WebCache.h"

@interface DepartmentMenuItemCell()

@property (nonatomic, weak) IBOutlet UILabel *departmentNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *departmentImageView;

@end

@implementation DepartmentMenuItemCell

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = RGBA(33, 150, 243, 1);
    UIView *normalView = [[UIView alloc] initWithFrame:self.frame];
    normalView.backgroundColor = RGBA(33, 150, 243, 1);
    
    UIView *highlightedView = [[UIView alloc] initWithFrame:self.frame];
    highlightedView.backgroundColor = RGBA(20, 120, 200, 1);
    
    self.backgroundView = normalView;
    self.selectedBackgroundView = highlightedView;
}

- (void)setupWithDepartmentMenuItem:(DepartmentMenuItem *)item
{
    self.departmentNameLabel.text = item.name;
    if (item.image)
    {
        [self.departmentImageView sd_setImageWithURL:[NSURL URLWithString:item.image]];
    }
    else
    {
        [self.departmentImageView setImage:[UIImage imageNamed:item.imageName]];
    }
}

- (void)setupWithMenuName:(NSString *)name image:(UIImage *)image
{
    self.departmentNameLabel.text = name;
    [self.departmentImageView setImage:image];
}

- (void)setupWithMenuName:(NSString *)name imageURL:(NSURL *)imageURL
{
    self.departmentNameLabel.text = name;
    [self.departmentImageView sd_setImageWithURL:imageURL];
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
