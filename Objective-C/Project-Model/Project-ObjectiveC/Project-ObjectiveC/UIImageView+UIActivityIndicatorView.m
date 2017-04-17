//
//  UIImageView+UIActivityIndicatorView.m
//  AlbumShow
//
//  Created by Erico GT on 13/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "UIImageView+UIActivityIndicatorView.h"

@interface UIImageView_UIActivityIndicatorView()

@property (nonatomic, strong) DGActivityIndicatorView *indicatorView;

@end

@implementation UIImageView_UIActivityIndicatorView

@synthesize indicatorView;

- (void)activityIndicatorTintColor:(UIColor*)color
{
    if (indicatorView == nil){
        [self createActivityIndicatorView];
    }
    //
    indicatorView.tintColor = color;
}

- (void)startActivityIndicator
{
    if (indicatorView == nil){
        [self createActivityIndicatorView];
    }
    //
    if (self.frame.size.width > 2.0 && self.frame.size.height > 2.0){
        CGFloat newSize = (CGFloat)(MIN(self.frame.size.width, self.frame.size.height)) / 2.0;
        newSize = newSize / 40.0; //original size = 37 x 37 pt
        indicatorView.frame = CGRectMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0, indicatorView.frame.size.width, indicatorView.frame.size.height);
        indicatorView.transform = CGAffineTransformMakeScale(newSize, newSize);
        //
        indicatorView.hidden = NO;
        [indicatorView startAnimating];
    }
}

- (void)stopActivityIndicator
{
    if (indicatorView == nil){
        [self createActivityIndicatorView];
    }
    //
    [indicatorView stopAnimating];
    indicatorView.hidden = YES;
}

- (void)createActivityIndicatorView
{
    indicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScale];
    //indicatorView.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicatorView.tintColor = [UIColor whiteColor];
    indicatorView.hidden = NO;
    [indicatorView startAnimating];
    //
    [self addSubview:indicatorView];
}

@end
