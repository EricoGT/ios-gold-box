//
//  ContactProductCollectionViewCell.m
//  Walmart
//
//  Created by Renan on 6/12/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ContactProductCollectionViewCell.h"

#import "UIImageView+WebCache.h"

@implementation ContactProductCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = RGBA(221, 221, 221, 1).CGColor;
}

- (void)setupWithImageUrl:(NSString *)urlStr {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.loader stopAnimating];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (!image)
        {
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME_3];
        }
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedAlphaView.hidden = !selected;
    self.layer.borderColor = selected ? RGBA(26, 117, 207, 1).CGColor : RGBA(221, 221, 221, 1).CGColor;
}

@end
