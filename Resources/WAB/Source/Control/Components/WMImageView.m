//
//  WMImageView.m
//  Walmart
//
//  Created by Renan on 7/29/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMImageView.h"
#import "UIImageView+WebCache.h"
#import "WBRSetupManager.h"

IB_DESIGNABLE
@interface WMImageView ()

@property (strong, nonatomic) IBInspectable UIColor *loaderColor;
@property (strong, nonatomic) UIActivityIndicatorView *loader;

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *failureImageName;

@end

@implementation WMImageView

- (instancetype)initWithImageURL:(NSURL *)imageURL failureImageName:(NSString *)failureImageName {
    if (self = [super init]) {
        [self setup];
        [self setLoaderColor:RGBA(26, 117, 207, 1)];
        [self setImageWithURL:imageURL failureImageName:failureImageName];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setLoaderColor:RGBA(26, 117, 207, 1)];
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setLoaderColor:RGBA(26, 117, 207, 1)];
        [self setup];
    }
    return self;
}

- (void)setLoaderColor:(UIColor *)loaderColor
{
    _loaderColor = loaderColor;
}

- (void)setup {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _loader.translatesAutoresizingMaskIntoConstraints = NO;
    _loader.color = _loaderColor;
    _loader.hidesWhenStopped = YES;
    [self addSubview:_loader];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loader
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loader
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
}

- (void)setImageWithImageId:(NSString *)imageId failureImageName:(NSString *)failureImageName {
    
    if (imageId) {
        
        __weak typeof(self) weakSelf = self;
        [WBRSetupManager getBaseImages:^(ModelBaseImages *baseImagesModel) {
            
            NSString *pathImgShowcase = [NSString stringWithFormat:@"%@%@", baseImagesModel.products, imageId] ?: @"";
            pathImgShowcase = [pathImgShowcase stringByReplacingOccurrencesOfString:@" " withString:@""];
            [weakSelf setImageWithURLStr:pathImgShowcase failureImageName:failureImageName];
        } failure:^(NSDictionary *dictError) {
            
            weakSelf.image = [UIImage imageNamed:failureImageName];
        }];
    }
    else {
        self.image = [UIImage imageNamed:failureImageName];
    }
    
}

- (void)setImageWithURL:(NSURL *)url failureImageName:(NSString *)failureImageName {
    self.imageURL = url;
    self.failureImageName = failureImageName;
    
    [_loader startAnimating];
    __weak WMImageView *weakSelf = self;
    
    [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.loader stopAnimating];
        if (image) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(wmImageViewFinishedDownloadingImage:)]) {
                [weakSelf.delegate wmImageViewFinishedDownloadingImage:image];
            }
        }
        else {
            weakSelf.contentMode = UIViewContentModeScaleAspectFit;
            weakSelf.image = [UIImage imageNamed:weakSelf.failureImageName];
        }
    }];
}

- (void)setImageWithURLStr:(NSString *)urlStr failureImageName:(NSString *)failureImageName {
    [self setImageWithURL:[NSURL URLWithString:urlStr] failureImageName:failureImageName];
}

@end
