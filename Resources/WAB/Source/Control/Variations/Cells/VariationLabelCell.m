//
//  VariationLabelCell.m
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "VariationLabelCell.h"

#import "VariationNode.h"

@implementation VariationLabelCell

static UIFont *labelFont;

+ (NSString *)reuseIdentifier
{
	return @"VariationLabelCell";
}

+ (UIFont *)labelFont
{
    if (!labelFont) labelFont = [UIFont fontWithName:@"Roboto-Regular" size:15.0f];
	return labelFont;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
    
	_label.textColor = selected ? [VariationCollectionViewCell selectedColor] : [VariationCollectionViewCell deselectedColor];
    _label.font = selected ? [UIFont fontWithName:@"Roboto-Medium" size:15.0f] : [UIFont fontWithName:@"Roboto-Regular" size:15.0f];
    self.contentView.layer.borderWidth = self.selected ? 2.0f : 1.0f;
    self.contentView.layer.cornerRadius = 4.0f;
    self.contentView.layer.borderColor = selected ? [VariationCollectionViewCell selectedBorder].CGColor : [VariationCollectionViewCell deselectedBorder].CGColor;
    self.contentView.layer.backgroundColor = selected ? [VariationCollectionViewCell selectdColorBackground].CGColor : nil;
    

}

- (void)setupWithVariationNode:(VariationNode *)variationNode delegate:(id<VariationCellDelegate>)delegate
{
	[super setupWithVariationNode:variationNode delegate:delegate];
	
	_label.text = variationNode.name;
}

@end
