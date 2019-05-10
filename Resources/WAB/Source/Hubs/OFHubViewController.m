//
//  OFHubViewController.m
//  Walmart
//
//  Created by Renan on 2/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "OFHubViewController.h"
#import "HubCategory.h"
#import "HubCell.h"

#import "OFMessages.h"
#import "UIImageView+WebCache.h"
#import "WMVerticalMenu.h"
#import "CustomMenuButton.h"

#import "HubCategoriesCollectionViewController.h"
#import "CategoryMenuItem.h"

#import "HubOffersViewController.h"
#import "SearchProductHubConnection.h"
#import "WMOmniture.h"

#import "WBRStampCampaign.h"
#import "WBRSetupManager.h"
#import "WMWebViewController.h"

@interface OFHubViewController () <WMVerticalMenuDelegate, UIScrollViewDelegate, HubCategoriesDelegate, HubOffersDelegate>

@property RetryErrorView *errorView;
@property UIActivityIndicatorView *loader;
@property (nonatomic,assign) BOOL forcingScroll;
@property (strong, nonatomic) HubCategoriesCollectionViewController *hubCategories;
@property (strong, nonatomic) HubOffersViewController *hubOffers;

@property (strong, nonatomic) IBOutlet UIView *bottomBannerView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBannerImageView;
@property (strong, nonatomic) WBRStampCampaign *stampCampaign;
@property (assign, nonatomic) BOOL showBottomBanner;

@end

@implementation OFHubViewController

@synthesize delegate;

- (OFHubViewController *)initWithHubId:(NSString *)hubId hubTitle:(NSString *)hubTitle otherCategories:(NSArray *)otherCategories {
    self = [super initWithTitle:hubTitle isModal:NO searchButton:YES cartButton:YES wishlistButton:NO];
    if (self) {
        self.hubId = hubId;
        self.hubTitle = hubTitle;
        self.otherCategories = otherCategories;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupContent];
}

#pragma mark - Setup Menu
- (void)setupContent
{
    //Menu
    self.verticalMenu.delegate = self;
    
    //Content
    self.hubCategories = [[HubCategoriesCollectionViewController alloc] initWithHubId:self.hubId otherCategories:self.otherCategories];
    [self addChildViewController:self.hubCategories];
    _hubCategories.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.hubCategories.view];
    [self.hubCategories willMoveToParentViewController:self];
    self.hubCategories.delegate = self;
    
    self.hubOffers = [[HubOffersViewController alloc] initWithCategoryId:self.hubId];
    [self addChildViewController:self.hubOffers];
    _hubOffers.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.hubOffers.view];
    [self.hubOffers willMoveToParentViewController:self];
    self.hubOffers.delegate = self;
    
    NSDictionary *viewsDictionary = @{@"scrollView": _scrollView,
                                      @"hubCategories": _hubCategories.view,
                                      @"hubOffers": _hubOffers.view};
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[hubCategories(==scrollView)]-0-[hubOffers(==scrollView)]-0-|"
                                                                        options:NSLayoutFormatDirectionLeadingToTrailing
                                                                        metrics:nil
                                                                          views:viewsDictionary]];
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[hubCategories(==scrollView)]-0-|"
                                                                        options:NSLayoutFormatDirectionLeadingToTrailing
                                                                        metrics:nil
                                                                          views:viewsDictionary]];
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[hubOffers(==scrollView)]-0-|"
                                                                        options:NSLayoutFormatDirectionLeadingToTrailing
                                                                        metrics:nil
                                                                          views:viewsDictionary]];
    
    CustomMenuButton *menuItem1 = [[CustomMenuButton alloc] initWithButtonTitle:HUB_MENU_TITLE_CATEGORIES];
    CustomMenuButton *menuItem2 = [[CustomMenuButton alloc] initWithButtonTitle:HUB_MENU_TITLE_OFFERS];
    [_verticalMenu setLayout];
    [_verticalMenu addButtons:@[menuItem1, menuItem2]];
    
    self.showBottomBanner = YES;
    [self setImageBottomBanner];
}

#pragma mark - WMVerticalMenu Delegate
- (void)WMVerticalMenu:(WMVerticalMenu *)menu didChangeToIndex:(NSInteger)index item:(CustomMenuButton *)menuItem
{
    self.forcingScroll = YES;
    
    [UIView animateWithDuration:.25 animations:^{
        [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frame.size.width, 0)];
    }];
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.forcingScroll)
    {
        NSInteger page = round(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
        [self.verticalMenu activateMenuAtIndex:page];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.forcingScroll = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.forcingScroll = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.forcingScroll = NO;
}

#pragma mark - Hub Offers Delegate
- (void)productSelectedOnHubOffer:(SearchProductHubConnection *)product
{
    UTMIModel *utmi = [WMUTMIManager UTMI];
    utmi.department = _hubTitle;
    [WMUTMIManager storeUTMI:utmi];
    
    [self openProductWithID:product.productID ? product.productID.stringValue : @""];
}

#pragma mark - Hub Categories Delegate
- (void)selectedHubCategory:(HubCategory *)hubCategory
{
    UTMIModel *utmi = [WMUTMIManager UTMI];
    utmi.department = _hubTitle;
    [WMUTMIManager storeUTMI:utmi];
    
    [WMOmniture trackHubTap:self.hubTitle hubCategory:hubCategory.text];
    
    if (hubCategory.useHub)
    {
        OFHubViewController *nextHub = [[OFHubViewController alloc] initWithHubId:hubCategory.searchParameter hubTitle:hubCategory.text otherCategories:nil];
        [self.navigationController pushViewController:nextHub animated:YES];
    }
    else
    {
        [self openSearchWithQuery:hubCategory.searchParameter completionBlock:nil];
    }
}

- (void)selectedOtherCategory:(CategoryMenuItem *)category
{
    UTMIModel *utmi = [WMUTMIManager UTMI];
    utmi.department = _hubTitle;
    [WMUTMIManager storeUTMI:utmi];
    
    [WMOmniture trackMenuCategoryTap:_hubTitle category:category.name];
    
    [self openSearchWithQuery:category.url completionBlock:nil];
}

#pragma mark - UTMI
- (NSString *)UTMIIdentifier {
    return @"departamento";
}

#pragma mark - Bottom Banners
- (void)setImageBottomBanner {
    BOOL isBottomBannerActive = [[WALMenuViewController singleton].services.masterCampaign boolValue];

    __weak OFHubViewController *weakSelf = self;
    [WBRSetupManager getStampCampaign:^(WBRStampCampaign *stampModel) {
        weakSelf.stampCampaign = stampModel;
        if (isBottomBannerActive && weakSelf.showBottomBanner) {
            [weakSelf.bottomBannerImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.stampCampaign.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [weakSelf handleBottomBanner:weakSelf.showBottomBanner];
                }
            }];
        }
    } failure:^(NSDictionary *dictError) {
        LogErro(@"Stamp Campaign Error");
    }];
}

- (void)handleBottomBanner:(BOOL)showBanner {
    if (showBanner) {
        [self showBottomBannerView];
    } else {
        [self hideBottomBannerView];
    }
}

- (void)hideBottomBannerView {
    [UIView animateWithDuration:.2
                     animations:^{
                         [self.bottomBannerView setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                         [self.bottomBannerView setHidden:YES];
                         [self.hubCategories handleTableViewInsets:(UIEdgeInsetsZero)];
                         [self.hubOffers handleTableViewInsets:(UIEdgeInsetsZero)];
                     }];
}

- (void)showBottomBannerView {
    [UIView animateWithDuration:.2
                     animations:^{
                         [self.bottomBannerView setAlpha:1.0];
                     
                     } completion:^(BOOL finished){
                         [self.bottomBannerView setHidden:NO];
                         [self.hubCategories handleTableViewInsets:(UIEdgeInsetsMake(0, 0, self.bottomBannerView.frame.size.height + 10, 0))];
                         [self.hubOffers handleTableViewInsets:(UIEdgeInsetsMake(0, 0, self.bottomBannerView.frame.size.height + 10, 0))];
                         
                     }];
}

- (IBAction)tapCloseBottomBanner:(id)sender {
    self.showBottomBanner = NO;
    [self hideBottomBannerView];
}

- (IBAction)tapOpenBottomBanner:(id)sender {
    
    __weak OFHubViewController *weakSelf = self;
    [WBRSetupManager getStampCampaign:^(WBRStampCampaign *stampModel) {
        NSString *masterCardInfoCampaingText = [NSString stringWithFormat:@"<span style=\"font-family: Roboto-Regular; font-size: 35\">%@</span>", stampModel.disclaimer];
        
        WMWebViewController *disclaimerInfoWebView = [[WMWebViewController alloc] initWithHtmlString:masterCardInfoCampaingText title:stampModel.title];
        WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:disclaimerInfoWebView];
        [weakSelf presentViewController:container animated:YES completion:nil];
        
    } failure:^(NSDictionary *dictError) {
        LogErro(@"Open Stamp Campaign Error");
    }];
    
}

@end
