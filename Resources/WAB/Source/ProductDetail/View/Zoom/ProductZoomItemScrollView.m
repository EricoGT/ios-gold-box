//
//  ProductZoomItemScrollView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/29/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductZoomItemScrollView.h"

#import "WMImageView.h"

@interface ProductZoomItemScrollView () <UIScrollViewDelegate>

@property (strong, nonatomic) WMImageView *imageView;

@end

@implementation ProductZoomItemScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (ProductZoomItemScrollView *)initWithImageURL:(NSURL *)imageURL {
    if (self = [super init]) {
        [self setup];
        [self setImageURL:imageURL];
    }
    return self;
}

- (void)setup {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 4.0f;
    self.delegate = self;
    
    UITapGestureRecognizer *doubleTapRecognizer;
    doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapRecognizer];
    
    self.imageView = [[WMImageView alloc] init];
    [self addSubview:_imageView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
}

- (void)setImageURL:(NSURL *)imageURL {
    [_imageView setImageWithURL:imageURL failureImageName:IMAGE_UNAVAILABLE_NAME_2];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)resetZoom
{
    self.zoomScale = 1.0;
}

- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)gesture
{
    float newScale = self.zoomScale * 4.0;
    if (self.zoomScale > self.minimumZoomScale)
    {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else
    {
        CGPoint center = [gesture locationInView:gesture.view];
        
        CGRect zoomRect;
        zoomRect.size.height = [_imageView frame].size.height / newScale;
        zoomRect.size.width = [_imageView frame].size.width / newScale;
        
        center = [_imageView convertPoint:center fromView:self];
        
        zoomRect.origin.x = center.x - ((zoomRect.size.width / 2.0));
        zoomRect.origin.y = center.y - ((zoomRect.size.height / 2.0));
        
        [self zoomToRect:zoomRect animated:YES];
    }
}


@end
