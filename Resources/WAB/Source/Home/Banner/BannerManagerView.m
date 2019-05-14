//
//  WMBannerViewController.m
//  Walmart
//
//  Created by Renan on 9/24/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "BannerManagerView.h"

//#import "BannerModel.h"
#import "ModelBannerContent.h"

@interface BannerManagerView () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *leftBannerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *middleBannerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rightBannerImageView;

@property (strong, nonatomic) IBOutlet UIView *pageIndicatorView;
@property (strong, nonatomic) IBOutlet UIView *pageIndicatorContainerView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pageIndicatorContainerViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pageIndicatorViewWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pageIndicatorViewLeadingSpaceConstraint;

@property (assign, nonatomic) NSInteger currentMiddleIndex;

@property (assign, nonatomic) NSTimeInterval lastScrollTime;

@property (assign, nonatomic) CGSize greatestBannerSize;

@property (strong, nonatomic) NSTimer *timer;

//When we have two real banners, we need to create copies of them to present the banners scroll view correctly. This property tells us when we have to make a special adjust in the page indicator.
@property (assign, nonatomic) BOOL twoBannersSpecialCase;

@end

@implementation BannerManagerView

- (void)setBannerModels:(NSMutableArray *)bannerModels {
    _bannerModels = bannerModels;
    
    LogInfo(@"isFooter: %i", _isFooter);
    
    if (_isFooter) {
    self.accessibilityIdentifier = @"bannerManager2";
    }
    else {
        self.accessibilityIdentifier = @"bannerManager";
    }
    
    __block NSUInteger loadedBannersCount = 0;
    self.greatestBannerSize = CGSizeZero;
    self.readyToDisplay = NO;
    
    for (ModelBannerContent *bannerModel in bannerModels) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:bannerModel.imageURLString] options:SDWebImageDownloaderContinueInBackground progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image) {
                bannerModel.image = image;
                
                CGFloat bannerHeight = image.size.height;
                if (bannerHeight > self->_greatestBannerSize.height) {
                    self.greatestBannerSize = image.size;
                }
            }
            loadedBannersCount++;
            if (loadedBannersCount == self->_bannerModels.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self finishedLoadingAllBanners];
                });
            }
        }];
    }
}


- (void)setupPageIndicatorView {
    CGFloat divider = _twoBannersSpecialCase ? 2.0f : _bannerModels.count;
    _pageIndicatorViewWidthConstraint.constant = [[UIScreen mainScreen] bounds].size.width / divider;
    
    self.readyToDisplay = YES;
    
    if ([_delegate respondsToSelector:@selector(bannerManagerView:loadedAllBannersWithContentSize:)]) {
        
        CGFloat height = _greatestBannerSize.height + _pageIndicatorContainerView.bounds.size.height;
        
        [_delegate bannerManagerView:self loadedAllBannersWithContentSize:CGSizeMake(_greatestBannerSize.width, height)];
    }
}


- (void)finishedLoadingAllBanners {
    for (ModelBannerContent *bannerModel in _bannerModels.copy) {
        if (bannerModel.image == nil) {
            [_bannerModels removeObject:bannerModel];
        }
    }
    
    BOOL shouldHidePageIndicator = _bannerModels.count <= 1;
    _pageIndicatorContainerViewHeightConstraint.constant = shouldHidePageIndicator ? 0.0f : 5.0f;
    
    if (_bannerModels.count > 0) {
        if (_bannerModels.count == 1) {
            _scrollView.scrollEnabled = NO;
            
            ModelBannerContent *bannerModel = _bannerModels[0];
            _leftBannerImageView.image = bannerModel.image;
            
            self.currentMiddleIndex = 0;
            [self setupPageIndicatorView];
        } else {
            
            _scrollView.scrollEnabled = YES;
            
            [self setupTimer];
            
            if (_bannerModels.count == 2) {
                self.twoBannersSpecialCase = YES;
                
                ModelBannerContent *firstBanner = _bannerModels[0];
                ModelBannerContent *secondBanner = _bannerModels[1];
                
                ModelBannerContent *firstBannerCopy = firstBanner.copy;
                ModelBannerContent *secondBannerCopy = secondBanner.copy;
                
                firstBannerCopy.image = firstBanner.image;
                secondBannerCopy.image = secondBanner.image;
                
                [_bannerModels addObjectsFromArray:@[firstBannerCopy, secondBannerCopy]];
            }
            
            [self setupPageIndicatorView];
            [self rearrangeBannersWithMiddleIndex:0];
            [self showNextBanner];
        }
    }
}

#pragma mark - Auto Refresh
- (void)rearrangeBannersWithMiddleIndex:(NSInteger)middleIndex {
    if (middleIndex < -1 || middleIndex > (NSInteger)_bannerModels.count + 1 || _bannerModels.count < 3) {
        return;
    } else if (middleIndex == -1) {
        middleIndex = _bannerModels.count + middleIndex;
    } else if (middleIndex >= _bannerModels.count) {
        middleIndex = middleIndex - _bannerModels.count;
    }
    self.currentMiddleIndex = middleIndex;
    
    NSInteger firstIndex = _currentMiddleIndex - 1;
    
    if (firstIndex < 0) {
        firstIndex = _bannerModels.count + firstIndex;
    }
    
    ModelBannerContent *leftBanner = _bannerModels[firstIndex];
    _leftBannerImageView.image = leftBanner.image;
    
    ModelBannerContent *middleBanner = _bannerModels[_currentMiddleIndex];
    _middleBannerImageView.image = middleBanner.image;
    
    
    NSInteger lastIndex = _currentMiddleIndex + 1;
    
    if (lastIndex >= _bannerModels.count) {
        lastIndex = lastIndex - _bannerModels.count;
    }
    
    ModelBannerContent *rightBanner = _bannerModels[lastIndex];
    _rightBannerImageView.image = rightBanner.image;
    
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);
//    _scrollView.contentOffset = CGPointMake(self.window.bounds.size.width, 0);
    
    [_scrollView layoutIfNeeded];
    
    [_pageIndicatorContainerView layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        NSUInteger baseIndex = (self->_twoBannersSpecialCase && self->_currentMiddleIndex > 1) ? (self->_currentMiddleIndex - 2) : self->_currentMiddleIndex;
        self->_pageIndicatorViewLeadingSpaceConstraint.constant = self->_pageIndicatorView.bounds.size.width * baseIndex;
        [self->_pageIndicatorContainerView layoutIfNeeded];
    }];
}

- (void)setupTimer {
    [_timer invalidate];
    self.lastScrollTime = [[NSDate date] timeIntervalSince1970];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduled) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)scheduled {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[NSDate date] timeIntervalSince1970] - self->_lastScrollTime > kBannerRefreshInterval) {
            self.lastScrollTime = [[NSDate date] timeIntervalSince1970];
            
            if (self->_bannerModels.count > 1) {
                [self showNextBanner];
            }
        }
    });
}

- (void)checkPageChanged {
    if (_bannerModels.count < 3) return;
    
    CGFloat pageWidth = _scrollView.bounds.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    switch (page) {
        case 0: {
            [self rearrangeBannersWithMiddleIndex:(_currentMiddleIndex - 1)];
            break;
        }
            
        case 2: {
            [self rearrangeBannersWithMiddleIndex:(_currentMiddleIndex + 1)];
            break;
        }
    }
    _scrollView.scrollEnabled = YES;
}

- (void)showNextBanner {
    _scrollView.scrollEnabled = NO;
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + _scrollView.bounds.size.width, _scrollView.contentOffset.y) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    _scrollView.scrollEnabled = NO;
    self.lastScrollTime = [[NSDate date] timeIntervalSince1970];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastScrollTime = [[NSDate date] timeIntervalSince1970];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.lastScrollTime = [[NSDate date] timeIntervalSince1970];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkPageChanged];
    self.lastScrollTime = [[NSDate date] timeIntervalSince1970];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self checkPageChanged];
    self.lastScrollTime = [[NSDate date] timeIntervalSince1970];
}

- (IBAction)handleBannerTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (_currentMiddleIndex < _bannerModels.count && [_delegate respondsToSelector:@selector(bannerManagerView:tappedBanner:)]) {
        [_delegate bannerManagerView:self tappedBanner:_bannerModels[_currentMiddleIndex]];
    }
}

@end
