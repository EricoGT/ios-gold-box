//
//  AllShoppingCell.m
//  Walmart
//
//  Created by Bruno Delgado on 12/2/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "AllShoppingCell.h"
#import "UIImageView+WebCache.h"
#import "DepartmentMenuItem.h"

@interface AllShoppingCell()

@property (nonatomic, weak) IBOutlet UILabel *departmentNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *departmentImageView;

@end

@implementation AllShoppingCell

@synthesize strName, strImage;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.departmentNameLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    self.departmentNameLabel.textColor = RGBA(26, 117, 207, 1);
}

- (void)setupCellWithDepartmentMenuItem:(DepartmentMenuItem *)item
{
    self.strName = item.name;
    self.departmentNameLabel.text = item.name;
    
    if (item.image)
    {
        self.strImage = item.image;
        [self.departmentImageView sd_setImageWithURL:[NSURL URLWithString:item.image]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}



@end
