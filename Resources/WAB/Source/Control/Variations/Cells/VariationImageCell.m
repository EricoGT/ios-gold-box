//
//  VariationImageCell.m
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "VariationImageCell.h"

#import "VariationNode.h"
#import "WBRSetupManager.h"

@interface VariationImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation VariationImageCell

static NSString *baseImageURLString = @"";

+ (NSString *)reuseIdentifier
{
	return @"VariationImageCell";
}

+ (void)setBaseImageURLString:(NSString *)string
{
    baseImageURLString = string;
}

+ (NSString *)baseImageURLString
{
    return baseImageURLString;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.contentView.layer.borderWidth = self.selected ? 2.0f : 1.0f;
    self.contentView.layer.cornerRadius = 4.0f;
    self.contentView.layer.borderColor = selected ? [VariationCollectionViewCell selectedBorder].CGColor : [VariationCollectionViewCell deselectedBorder].CGColor;
}

- (void)setupWithVariationNode:(VariationNode *)variationNode delegate:(id<VariationCellDelegate>)delegate
{
	[super setupWithVariationNode:variationNode delegate:delegate];
	
    NSString *imageIdFromLeaf = [variationNode imageIdFromLeaf];
    
	if (imageIdFromLeaf.length > 0)
	{
		[_activityIndicator startAnimating];
		
        NSURL *imageURL = [[NSURL URLWithString:[WBRSetupManager baseImages].products] URLByAppendingPathComponent:imageIdFromLeaf];
        
        if (imageURL) {
            [_imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self->_activityIndicator stopAnimating];
                if (image)
                {
                    self->_imageView.contentMode = UIViewContentModeScaleToFill;
                } else {
                    [self showFailImage];
                }
            }];
        }
        else {
            [self showFailImage];
        }
	}
	else
	{
        [self showFailImage];
	}
}

- (void)showFailImage {
    [_activityIndicator stopAnimating];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = [UIImage imageNamed:@"ic_variations_sad_face"];
}

@end
