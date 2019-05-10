//
//  ProductZoomCell.m
//  Walmart
//
//  Created by Renan Cargnin on 1/28/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductZoomCell.h"

#import "WMImageView.h"

@interface ProductZoomCell ()

@property (weak, nonatomic) IBOutlet WMImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@end

@implementation ProductZoomCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([ProductZoomCell class]);
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 3.0f;
    self.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _overlayView.hidden = !highlighted;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.layer.borderColor = selected ? RGBA(244, 123, 32, 1).CGColor : RGBA(204, 204, 204, 1).CGColor;
}

- (void)setImageURL:(NSURL *)imageURL {
    [_imageView setImageWithURL:imageURL failureImageName:IMAGE_UNAVAILABLE_NAME_2];
}

@end
