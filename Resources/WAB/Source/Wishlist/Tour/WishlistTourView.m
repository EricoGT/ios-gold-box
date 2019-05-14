//
//  WishlistTourView.m
//  Walmart
//
//  Created by Renan Cargnin on 12/3/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WishlistTourView.h"

@interface WishlistTourView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//Note: We could do this better with customized assets for platform but we still support iOS 7 so it's not possible
//https://developer.apple.com/library/ios/recipes/xcode_help-image_catalog-1.0/chapters/CustomizingImageSets.html
@property (nonatomic, weak) IBOutlet UIImageView *firstImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondImageView;
@property (nonatomic, weak) IBOutlet UIImageView *thirdImageView;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *titleLabels;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *messageLabels;

@property (nonatomic, weak) IBOutlet WMButton *startUsingButton;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *imageHeightConstraints;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *posYImageTour;

@end

@implementation WishlistTourView

- (WishlistTourView *)initWithDelegate:(id<WishlistTourViewDelegate>)delegate
{
    if (self = [super init])
	{
		_delegate = delegate;
		
		if (IS_IPHONE_4_OR_LESS)
		{
            for (NSLayoutConstraint *imageHeightConstraint in _imageHeightConstraints)
            {
                imageHeightConstraint.constant = 244.0f;
            }
		}
        else if (IS_IPHONE_5)
        {
            for (NSLayoutConstraint *imageHeightConstraint in _imageHeightConstraints)
            {
                imageHeightConstraint.constant = 274.0f;
                _posYImageTour.constant = 15;
            }
        }
        [self setupImages];
	}
	return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == _pageControl || hitView.superview == _pageControl)
    {
        return _pageControl;
    }
    else if (hitView == _startUsingButton || hitView.superview == _startUsingButton)
    {
        return _startUsingButton;
    }
    else
    {
        return _scrollView;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat pageFloat = scrollView.contentOffset.x / scrollView.bounds.size.width;
	CGFloat pageDecimalPart = fmodf(pageFloat, 1.0f);
	NSUInteger page = roundf(pageFloat);
	
	_pageControl.currentPage = page;
	
	if ((page == 0 && pageDecimalPart <= 0.5f) || (page == _titleLabels.count - 1 && pageDecimalPart >= 0.5f) || (page > 0 && page < _titleLabels.count - 1))
	{
		NSUInteger hidingPage = pageDecimalPart >= 0.5f ? page - 1 : page + 1;
		
		CGFloat showingAlpha = pageDecimalPart >= 0.5f ? pageDecimalPart : 1.0f - pageDecimalPart;
		CGFloat hidingAlpha = 1.0f - showingAlpha;
		
		UILabel *showingTitleLabel = _titleLabels[page];
		UILabel *showingMessageLabel = _messageLabels[page];
		
		UILabel *hidingTitleLabel = _titleLabels[hidingPage];
		UILabel *hidingMessageLabel = _messageLabels[hidingPage];
		
		showingTitleLabel.alpha = showingMessageLabel.alpha = showingAlpha;
		hidingTitleLabel.alpha = hidingMessageLabel.alpha = hidingAlpha;
		
		_startUsingButton.alpha = showingTitleLabel == _titleLabels.lastObject ? showingAlpha : hidingTitleLabel == _titleLabels.lastObject ? hidingAlpha : 0.0f;
	}
}

#pragma mark - Images
- (void)setupImages
{
    //Note: We could do this better with customized assets for platform but we still support iOS 7 so it's not possible
    //https://developer.apple.com/library/ios/recipes/xcode_help-image_catalog-1.0/chapters/CustomizingImageSets.html

    if (IS_IPHONE_6)
    {
        for (NSLayoutConstraint *imageHeightConstraint in _imageHeightConstraints)
        {
            imageHeightConstraint.active = NO;
        }
        [_scrollView layoutIfNeeded];
        
        self.firstImageView.image = [UIImage imageNamed:@"img_wishtour_1_6"];
        self.secondImageView.image = [UIImage imageNamed:@"img_wishtour_2_6"];
        self.thirdImageView.image = [UIImage imageNamed:@"img_wishtour_3_6"];
        
        _posYImageTour.constant = 25;
    }
    else if(IS_IPHONE_6P || IS_IPHONE_X)
    {
        for (NSLayoutConstraint *imageHeightConstraint in _imageHeightConstraints)
        {
            imageHeightConstraint.active = NO;
        }
        [_scrollView layoutIfNeeded];
        
        self.firstImageView.image = [UIImage imageNamed:@"img_wishtour_1_6+"];
        self.secondImageView.image = [UIImage imageNamed:@"img_wishtour_2_6+"];
        self.thirdImageView.image = [UIImage imageNamed:@"img_wishtour_3_6+"];
        
        _posYImageTour.constant = 50;
    }
}

#pragma mark - IBAction
- (IBAction)changePage:(id)sender
{
	NSUInteger page = _pageControl.currentPage;
	[_scrollView setContentOffset:CGPointMake(page * _scrollView.bounds.size.width, _scrollView.contentOffset.y) animated:YES];
}

- (IBAction)pressedStartUsing:(id)sender
{
	if (_delegate && [_delegate respondsToSelector:@selector(wishlistTourViewPressedStartUsing)])
	{
		[_delegate wishlistTourViewPressedStartUsing];
	}
}

@end
