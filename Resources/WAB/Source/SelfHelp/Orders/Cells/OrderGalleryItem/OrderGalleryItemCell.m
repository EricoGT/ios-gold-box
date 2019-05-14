//
//  OrderGalleryItemCell.m
//  Walmart
//
//  Created by Renan Cargnin on 2/11/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "OrderGalleryItemCell.h"

#import "UIImageView+WebCache.h"

@interface OrderGalleryItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation OrderGalleryItemCell

+ (NSString *)reuseIdentifier {
    return @"OrderGalleryItemCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProductImageURL:(NSString *)imageURL {
    [_activityIndicator startAnimating];
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self->_productImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self->_activityIndicator stopAnimating];
        if (!image) {
            self->_productImageView.contentMode = UIViewContentModeCenter;
            self->_productImageView.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME];
        }
    }];
}

@end
