//
//  VariationCell.m
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "VariationCollectionViewCell.h"

#import "VariationNode.h"

@implementation VariationCollectionViewCell

static UIColor *selectedColor;
static UIColor *selectedColorBackground;
static UIColor *deselectedColor;
static UIColor *deselectedColorBackground;
static UIColor *highlightedColor;
static UIColor *selectedBorder;
static UIColor *deselectedBorder;

+ (UIColor *)selectedColor
{
	if (!selectedColor) selectedColor = RGBA(255, 255, 255, 1);
	return selectedColor;
}

+ (UIColor *)deselectedColor
{
	if (!deselectedColor) deselectedColor = RGBA(33, 150, 243, 1);
	return deselectedColor;
}

+ (UIColor *)selectdColorBackground
{
    if(!selectedColorBackground) selectedColorBackground = RGBA(255, 152, 0, 1);
    return selectedColorBackground;
}

+ (UIColor *) deselectedColorBackground{
    if (!deselectedColorBackground) deselectedColorBackground = RGBA(255, 255, 255, 1);
    return deselectedColorBackground;
}

+ (UIColor *)selectedBorder
{
    if(!selectedColorBackground) selectedColorBackground = RGBA(255, 152, 0, 1);
    return selectedColorBackground;
}

+ (UIColor *) deselectedBorder{
    if (!deselectedColorBackground) deselectedColorBackground = RGBA(204, 204, 204, 1);
    return deselectedColorBackground;
}

+ (UIColor *)highlightedColor
{
	if (!highlightedColor) highlightedColor = RGBA(244, 123, 32, 1);
	return highlightedColor;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setupWithVariationNode:(VariationNode *)variationNode delegate:(id<VariationCellDelegate>)delegate
{
    self.selected = variationNode.selected;
    
	self.delegate = delegate;
	self.variationNode = variationNode;
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
    

}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	
	if (self.selected) return;
	
	self.layer.borderColor = highlighted ? [VariationCollectionViewCell highlightedColor].CGColor : [VariationCollectionViewCell deselectedColor].CGColor;
}

@end
