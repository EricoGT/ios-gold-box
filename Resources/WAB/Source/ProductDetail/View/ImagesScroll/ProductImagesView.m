//
//  ProductImagesView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/18/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductImagesView.h"

#import "WMImageView.h"

@interface ProductImagesView () <UIScrollViewDelegate, WMImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) UIImage *firstImage;

@property (strong, nonatomic) NSString *basePath;
@property (strong, nonatomic) NSArray *imagesIds;

@end

@implementation ProductImagesView

- (ProductImagesView *)initWithImagesIds:(NSArray *)imagesIds basePath:(NSString *)basePath delegate:(id<ProductImagesViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        
        [self setup];
        [self setImagesIds:imagesIds basePath:basePath];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _scrollView.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView)];
    [_scrollView addGestureRecognizer:tapGesture];
    self.pageControl.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.08,1.08);
}

- (void)setImagesIds:(NSArray *)imagesIds basePath:(NSString *)basePath {
    self.imagesIds = imagesIds;
    self.basePath = basePath;
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    imagesIds = [imagesIds subarrayWithRange:NSMakeRange(0, imagesIds.count > 12 ? 12 : imagesIds.count)];
    _pageControl.numberOfPages = imagesIds.count;
    
    UIView *lastView = _scrollView;
    for (NSString *imageId in imagesIds) {
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", basePath, imageId]];
        WMImageView *imageView = [[WMImageView alloc] initWithImageURL:imageURL failureImageName:IMAGE_UNAVAILABLE_NAME_2];
        if (imageId == imagesIds.firstObject) {
            imageView.delegate = self;
        }
        [_scrollView addSubview:imageView];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:lastView
                                                                attribute:lastView == _scrollView ? NSLayoutAttributeLeading : NSLayoutAttributeTrailing
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        if (imageId == imagesIds.lastObject) {
            [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_scrollView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];
        }
        
        lastView = imageView;
    }
}

- (void)requestZoom {
    if (_delegate && [_delegate respondsToSelector:@selector(productImagesResquestedZoom)]) {
        [_delegate productImagesResquestedZoom];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger page = roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    _pageControl.currentPage = page;
}

#pragma mark - WMImageViewDelegate
- (void)wmImageViewFinishedDownloadingImage:(UIImage *)image {
    self.firstImage = image;
}

#pragma mark - UIGestureRecognizer
- (void)tappedScrollView {
    [self requestZoom];
}

#pragma mark - IBAction
- (IBAction)pressedMagnifying:(id)sender {
    [self requestZoom];
}

- (void) moveToFirstImage {
    
    _scrollView.contentOffset = CGPointMake(0, 0);
}


@end
