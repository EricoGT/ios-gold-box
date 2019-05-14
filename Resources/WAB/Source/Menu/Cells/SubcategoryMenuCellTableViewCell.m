//
//  SubcategoryMenuCellTableViewCell.m
//  Walmart
//
//  Created by Bruno Delgado on 2/9/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "SubcategoryMenuCellTableViewCell.h"
#import "CategoryMenuItem.h"
#import "NSString+HTML.h"
#import "UIImageView+WebCache.h"

@interface SubcategoryMenuCellTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *categoryNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *categoryCountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImageView;

@end

@implementation SubcategoryMenuCellTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *bgColorViewNormal = [[UIView alloc] init];
    bgColorViewNormal.backgroundColor = RGBA(33, 150, 243, 1);
    
    UIView *bgColorViewSelected = [[UIView alloc] init];
    bgColorViewSelected.backgroundColor = RGBA(20, 120, 200, 1);
    
    self.backgroundView = bgColorViewNormal;
    self.selectedBackgroundView = bgColorViewSelected;
}

- (void)setupCellWithCategory:(CategoryMenuItem *)item count:(NSNumber *)count hideIcon:(BOOL)hideIcon
{
    //Check for first resize depending on showing quantity or not
    BOOL shouldResizeNameLabelToShowCount = NO;
    BOOL isHiddenArrow = YES;
    
    if (count) {
        shouldResizeNameLabelToShowCount = YES;
    }
    
    CGRect nameLabelFrame = self.categoryNameLabel.frame;
    if (shouldResizeNameLabelToShowCount)
    {
        nameLabelFrame.size.width = 156;
        self.categoryCountLabel.hidden = NO;
        self.categoryCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count.integerValue];
    }
    else
    {
        self.categoryCountLabel.hidden = YES;
        nameLabelFrame.size.width = 196;
    }
    
    if (hideIcon)
    {
        nameLabelFrame.origin.x = 24;
        nameLabelFrame.size.width += 32;
    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.imageSelected]];
    self.categoryNameLabel.frame = nameLabelFrame;
    self.categoryNameLabel.text = [item.name kv_decodeHTMLCharacterEntities];
    
    if (count || item.isSeeAll) {
        isHiddenArrow = YES;
    } else {
        isHiddenArrow = NO;
    }
    [self.arrowImageView setHidden:isHiddenArrow];

    UIColor *textColor = (item.isSeeAll.boolValue) ? RGBA(253, 187, 48, 1) : RGBA(255, 255, 255, 1);
    
    self.categoryNameLabel.textColor = textColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
