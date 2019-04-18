//
//  VIPhotoView.m
//  VIPhotoViewDemo
//
//  Created by Vito on 1/7/15.
//  Copyright (c) 2015 vito. All rights reserved.
//

#import "VIPhotoView.h"

@interface UIImage (VIUtil)

- (CGSize)sizeThatFits:(CGSize)size;

@end

@implementation UIImage (VIUtil)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = CGSizeMake(self.size.width / self.scale,
                                  self.size.height / self.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

@end

@interface UIImageView (VIUtil)

- (CGSize)contentSize;

@end

@implementation UIImageView (VIUtil)

- (CGSize)contentSize
{
    return [self.image sizeThatFits:self.bounds.size];
}

@end

@interface VIPhotoView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSObject<VIPhotoViewDelegate> *delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic) BOOL rotating;
@property (nonatomic) CGSize minSize;

@end

@implementation VIPhotoView

- (VIPhotoView*)initWithFrame:(CGRect)frame image:(UIImage *)image backgroundImage:(UIImage*)backgroundImage andDelegate:(NSObject<VIPhotoViewDelegate>*)controllerDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //Self:
        self.delegate = controllerDelegate;
        self.backgroundColor = nil;
        
        //Scroll View
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.delegate = self;
        self.scrollView.bouncesZoom = YES;
        [self addSubview:self.scrollView];
        
        // Add container view
        UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
        containerView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:containerView];
        self.containerView = containerView;
        
        //Background View
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundImageView.backgroundColor = [UIColor clearColor];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.image = backgroundImage;
        [self addSubview:self.backgroundImageView];
        [self sendSubviewToBack:self.backgroundImageView];
        
        // Add image view
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = containerView.bounds;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [containerView addSubview:imageView];
        self.imageView = imageView;
        [self.imageView layoutIfNeeded];
        
        //Close Button
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 30.0, 60.0, 60.0)];
        closeButton.backgroundColor = [UIColor whiteColor];
        [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *icon = [[UIImage imageNamed:@"icon-webview-stop"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [closeButton setImage:icon forState:UIControlStateNormal];
        [closeButton setImage:icon forState:UIControlStateHighlighted];
        closeButton.tintColor = [UIColor darkTextColor]; //[UIColor colorWithRed:16.0/255.0 green:81.0/255.0 blue:127.0/255.0 alpha:1.0];
        [ToolBox graphicHelper_ApplyShadowToView:closeButton withColor:[UIColor blackColor] offSet:CGSizeMake(2.0, 2.0) radius:2.0 opacity:0.75];
        [closeButton.layer setCornerRadius:30.0];
        [self addSubview:closeButton];
        [self bringSubviewToFront:closeButton];
        
        // Fit container view's size to image size
        CGSize imageSize = imageView.contentSize;
        self.containerView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
        imageView.center = CGPointMake(imageSize.width / 2, imageSize.height / 2);
        
        self.scrollView.contentSize = imageSize;
        self.minSize = imageSize;
        
        [self setMaxMinZoomScale];
        
        // Center containerView by set insets
        [self centerContent];
        
        // Setup other events
        [self setupGestureRecognizer];
        [self setupRotationNotification];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.rotating) {
        self.rotating = NO;
        
        // update container view frame
        CGSize containerSize = self.containerView.frame.size;
        BOOL containerSmallerThanSelf = (containerSize.width < CGRectGetWidth(self.bounds)) && (containerSize.height < CGRectGetHeight(self.bounds));
        
        CGSize imageSize = [self.imageView.image sizeThatFits:self.bounds.size];
        CGFloat minZoomScale = imageSize.width / self.minSize.width;
        self.scrollView.minimumZoomScale = minZoomScale;
        if (containerSmallerThanSelf || self.scrollView.zoomScale == self.scrollView.minimumZoomScale) { // 宽度或高度 都小于 self 的宽度和高度
            self.scrollView.zoomScale = minZoomScale;
        }
        
        // Center container view
        [self centerContent];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupRotationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_containerView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}

#pragma mark - GestureRecognizer

- (void)tapHandler:(UITapGestureRecognizer *)recognizer
{
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale) {
        CGPoint location = [recognizer locationInView:recognizer.view];
        CGRect zoomToRect = CGRectMake(0, 0, 100, 100);
        zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
        [self.scrollView zoomToRect:zoomToRect animated:YES];
    }
}

#pragma mark - Notification

- (void)orientationChanged:(NSNotification *)notification
{
    self.rotating = YES;
}

#pragma mark - Helper

- (void)setMaxMinZoomScale
{
    //CGSize imageSize = self.imageView.image.size;
    //CGSize imagePresentationSize = self.imageView.contentSize;
    //CGFloat maxScale = MAX(imageSize.height / imagePresentationSize.height, imageSize.width / imagePresentationSize.width);
    self.scrollView.maximumZoomScale = 20.0;//MAX(1, maxScale); // Should not less than 1
    self.scrollView.minimumZoomScale =  1.0;
}

- (void)centerContent
{
    CGRect frame = self.containerView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.scrollView.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width - self.scrollView.contentSize.width) * 0.5f;
    }
    if (self.scrollView.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height - self.scrollView.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

- (void)closeAction:(id)sender
{
    if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(photoViewDidHide:)]){
            [self.delegate photoViewDidHide:self];
        }
    }else{
        [self removeFromSuperview];
    }
}

@end
