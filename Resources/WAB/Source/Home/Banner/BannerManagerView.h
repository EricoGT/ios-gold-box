//
//  WMBannerViewController.h
//  Walmart
//
//  Created by Renan on 9/24/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBannerRefreshInterval 4
#define kPageIndicatorHeight 5

@class BannerManagerView, ModelBanner;

@protocol BannerManagerViewDelegate <NSObject>
@optional
- (void)bannerManagerView:(BannerManagerView *)bannerManagerView loadedAllBannersWithContentSize:(CGSize)contentSize;
- (void)bannerManagerView:(BannerManagerView *)bannerManagerView tappedBanner:(ModelBanner *)banner;
@end

IB_DESIGNABLE
@interface BannerManagerView : WMView

@property (weak) IBOutlet id <BannerManagerViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *bannerModels;
@property (assign, nonatomic) BOOL readyToDisplay;
@property BOOL isFooter;

@end
