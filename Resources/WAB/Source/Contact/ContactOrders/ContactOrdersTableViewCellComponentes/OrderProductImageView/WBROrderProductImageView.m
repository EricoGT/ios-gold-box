//
//  WBROrderProductImageView.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/6/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBROrderProductImageView.h"

@implementation WBROrderProductImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = RGBA(204, 204, 204, 1.0).CGColor;
}

- (void)setImageId:(NSString *)imageId {
    [self setImageWithImageId:imageId failureImageName:IMAGE_UNAVAILABLE_NAME_2];
}

@end
