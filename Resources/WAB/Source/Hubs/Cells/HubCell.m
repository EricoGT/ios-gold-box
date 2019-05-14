//
//  HubCell.m
//  Walmart
//
//  Created by Renan on 2/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "HubCell.h"
#import "UIImageView+WebCache.h"
#import "HubCategory.h"
#import "WMImageView.h"
#import "NSString+HTML.h"

@implementation HubCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // Initialization code
    self.layer.borderColor = RGBA(231, 231, 231, 1).CGColor;
    self.layer.borderWidth = 1.0f;
}

- (void)setupWithHubCategory:(HubCategory *)hubCategory {
    
    self.titleLabel.text = [hubCategory.text kv_decodeHTMLCharacterEntities];
    [_imageView setImageWithURLStr:hubCategory.imageURL failureImageName:IMAGE_UNAVAILABLE_NAME];
}

- (void)setHighlighted:(BOOL)highlighted {
    self.footerView.backgroundColor = highlighted ? RGBA(244, 123, 32, 1) : RGBA(221, 221, 221, 1);
    self.overlayView.hidden = !highlighted;
}

@end
