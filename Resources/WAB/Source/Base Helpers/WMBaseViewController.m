//
//  WMBaseViewController.m
//  Walmart
//
//  Created by Bruno on 6/18/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"
#import "OFColors.h"
#import "NewCartViewController.h"
#import "OFSearchViewController.h"
#import "WALWishlistViewController.h"
#import "WALProductDetailViewController.h"
#import "UIImage+Additions.h"
#import "OFLoginViewController.h"
#import "PushHandler.h"
#import "OFAppDelegate.h"
#import "QASkuViewController.h"
#import "WBRPaymentViewController.h"
#import "WBRProduct.h"
#import "ModelProductFull.h"

@interface WMBaseViewController ()

@property (strong, nonatomic) OFMessages *messages;
@property (strong, nonatomic) NSArray *rightButtonItems;

@end

@implementation WMBaseViewController

- (WMBaseViewController *)initWithTitle:(NSString *)title isModal:(BOOL)isModal searchButton:(BOOL)searchButton cartButton:(BOOL)cartButton wishlistButton:(BOOL)wishlistButton {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.title = title;
        
        NSMutableArray *rightItems = [NSMutableArray new];
        
        float szIcons = 24;
        
        if (cartButton) {
            UIButton *cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cartButton addTarget:self action:@selector(tappedCart) forControlEvents:UIControlEventTouchUpInside];
            [cartButton setImage:[UIImage imageNamed:@"ic_cart"] forState:UIControlStateNormal];
            [cartButton setFrame:CGRectMake(0, 0, szIcons, szIcons)];
            
            UIBarButtonItem *cartItem = [[UIBarButtonItem alloc] initWithCustomView:cartButton];
            [rightItems addObject:cartItem];
            
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spacer.width = 20;
            [rightItems addObject:spacer];
        }
        
        if (searchButton) {
            UIImage *searchIcon = [UIImage imageNamed:@"UINavigationBarSearchIcon"];
            UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [searchButton addTarget:self action:@selector(tappedSearch) forControlEvents:UIControlEventTouchUpInside];
            [searchButton setImage:searchIcon forState:UIControlStateNormal];
            [searchButton setFrame:CGRectMake(0, 0, szIcons, szIcons)];
            
            UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
            [rightItems addObject:searchItem];
            
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spacer.width = 20;
            [rightItems addObject:spacer];
        }
        
        if (wishlistButton) {
            
            UIImage *wishlistIcon = [UIImage imageNamed:@"ic_navbar_heart"];
            UIButton *wishlistButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [wishlistButton addTarget:self action:@selector(tappedWishlist) forControlEvents:UIControlEventTouchUpInside];
            [wishlistButton setImage:wishlistIcon forState:UIControlStateNormal];
            [wishlistButton setFrame:CGRectMake(0, 0, szIcons, szIcons)];
            
            UIBarButtonItem *wishlistItem = [[UIBarButtonItem alloc] initWithCustomView:wishlistButton];
            [rightItems addObject:wishlistItem];
        }
        
        LogInfo(@"From Class: %@", NSStringFromClass([self class]));
        
 #if !defined CONFIGURATION_Release && !defined CONFIGURATION_EnterpriseTK
        
        if (wishlistButton) {
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spacer.width = 20;
            [rightItems addObject:spacer];
        }

        
        if ([NSStringFromClass([self class]) isEqualToString:@"WALHomeViewController"]) {
            
//            if (wishlistButton) {
//                UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//                spacer.width = 20;
//                [rightItems addObject:spacer];
//            }
            
            UIButton *skuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [skuButton addTarget:self action:@selector(openSku) forControlEvents:UIControlEventTouchUpInside];
            [skuButton setTitle:@"PD" forState:UIControlStateNormal];
            [skuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [skuButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:9]];
            skuButton.backgroundColor = RGBA(246, 180, 40, 1);
            skuButton.layer.masksToBounds = YES;
            skuButton.layer.borderWidth = 1.0f;
            skuButton.layer.cornerRadius = 12.0f;
            skuButton.layer.borderColor = RGBA(246, 180, 40, 1).CGColor;
            [skuButton setFrame:CGRectMake(0, 0, 24, 24)];
            
            UIBarButtonItem *skuItem = [[UIBarButtonItem alloc] initWithCustomView:skuButton];
            [rightItems addObject:skuItem];
            
            

        }
        
        
        //From all class
        
        BOOL enableTokenButton = NO;
        
        if (enableTokenButton) {
            
            UIButton *tokenButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [tokenButton addTarget:self action:@selector(tappedExpireTokenOAuth) forControlEvents:UIControlEventTouchUpInside];
            [tokenButton setTitle:@"TK" forState:UIControlStateNormal];
            [tokenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tokenButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:9]];
            tokenButton.backgroundColor = RGBA(145, 221, 84, 1);
            tokenButton.layer.masksToBounds = YES;
            tokenButton.layer.borderWidth = 1.0f;
            tokenButton.layer.cornerRadius = 12.0f;
            tokenButton.layer.borderColor = RGBA(145, 221, 84, 1).CGColor;
            [tokenButton setFrame:CGRectMake(0, 0, 24, 24)];
            
            UIBarButtonItem *tokenItem = [[UIBarButtonItem alloc] initWithCustomView:tokenButton];
            [rightItems addObject:tokenItem];
        }
#endif

        _rightButtonItems = rightItems.copy;
    }
    return self;
}

- (void)openSku {
    
    LogInfo(@"Open SKU");
    
    QASkuViewController *cart = [QASkuViewController new];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:cart];
    [self.navigationController presentViewController:navigation animated:YES completion:nil];
    
    
    //Just for test
    
//    WBRHome *whs = [WBRHome new];
//    
//    //Banners
//    [whs getCampaigns:^(ModelCampaigns *campaigns) {
////        LogMicro(@"\n\n[STATIC HOME] Campaigns: %@", campaigns.top[1]);
//        for (int i=0;i<campaigns.top.count;i++) {
//            
//            LogMicro(@"Banner %i: %@", i+1, campaigns.top[i]);
//        }
//        
//    } failure:^(NSDictionary *dictError) {
//        
//    }];
//    
//    //Showcases
//    [whs getShowcases:^(NSArray <ModelShowcases> *showcases) {
//        LogMicro(@"\n\n[STATIC HOME] Showcases: %@", showcases[0]);
//        
//        ModelShowcases *msc = showcases[0];
//        LogMicro(@"Name 1: %@", msc.name);
//        LogMicro(@"Shelf 1: %@", msc.shelfItems[0]);
//        
//        ModelShelfItems *msi = msc.shelfItems[0];
//        
//        ModelPrice *mpc = msi.price;
//        LogMicro(@"List Price 1: %@", mpc.listPrice);
//        LogMicro(@"Sell Price 1: %@", mpc.sellPrice);
//        
//    } failure:^(NSDictionary *dictError) {
//        
//    }];
    

//    [[WBRProduct new] getSearch:^(NSData *dataJson) {
//        
//        ModelProductFull *prod = [[ModelProductFull alloc] initWithData:dataJson error:nil];
//        
//        for (int i=0;i<prod.products.count;i++) {
//            
//            ModelProducts *products = prod.products[i];
//            LogMicro(@"Search: %@", products.title);
//        }
//        
//    } failure:^(NSDictionary *dictError) {
//        
//    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self basicSetup];
}

#pragma mark - Setup
- (void)basicSetup
{
    self.messages = [OFMessages new];
    
    if (self.navigationController.viewControllers.count > 0)
    {
        if (self.navigationController.viewControllers.firstObject == self && self.navigationController.presentingViewController)
        {
            UIImage *modalBack = [UIImage imageNamed:@"ic_ignore"];
            UIButton *modalBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [modalBackButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            [modalBackButton setImage:modalBack forState:UIControlStateNormal];
            [modalBackButton setFrame:CGRectMake(0, 0, modalBack.size.width, modalBack.size.height)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:modalBackButton];
        }
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationItem setRightBarButtonItems:_rightButtonItems];
    }
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NavigationBar Buttons

#pragma mark - Expire token OAuth
- (void)tappedExpireTokenOAuth {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"forceExpire"];
    
    [self.view showFeedbackAlertOfKind:ErrorAlert message:@"::::: T O K E N  EXPIRADO :::::"];
    
    LogInfo(@"\n");
    LogInfo(@"        --------------------------------------------------------------------");
    LogInfo(@"        [REFRESHTOKEN] Token EXPIRED");
    LogInfo(@"        --------------------------------------------------------------------");
    LogInfo(@"\n");
}


#pragma mark - Search
- (void)tappedSearch
{
    [self openSearchWithQuery:nil completionBlock:nil];
}

- (void)openSearchWithQuery:(NSString *)query completionBlock:(void (^)())completionBlock
{
    if (self.search && self.search.isViewLoaded && self.search.view.window && [self.search isEqual:[NSNull null]])
    {
        [self.search refreshWithQuery:query];
    }
    else
    {
        self.search = [[OFSearchViewController alloc] initWithQuery:query];
        LogInfo(@"Banner query: %@", query);
        WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:_search];
        
        UIViewController *controller = (self.presentedViewController) ?: self;
        
        UTMIModel *utmi = [WMUTMIManager UTMI];
        [utmi setSection:self.UTMIIdentifier cleanOtherFields:NO];
        [WMUTMIManager storeUTMI:utmi];
        
        [controller presentViewController:navigation animated:YES completion:completionBlock];
    }
}

- (void)tappedCart
{
    [self showCartWithCompletion:nil];
}

- (void)showCartWithCompletion:(void (^)())completion
{
    NewCartViewController *cart = [NewCartViewController new];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:cart];
    [self presentViewController:navigation animated:YES completion:completion];
}

- (void)tappedWishlist {
	[self openWishlist];
}

- (void)openWishlist {
    WALWishlistViewController *wishlistController = [WALWishlistViewController new];
    WMBaseNavigationController *wishlistContainer = [[WMBaseNavigationController alloc] initWithRootViewController:wishlistController];
    [self.navigationController presentViewController:wishlistContainer animated:YES completion:nil];
}

- (NSString *)UTMIIdentifier {
    LogInfo(@"- (NSString *)UTMIIdentifier should be overridden if you you're subclassing WMBaseViewController");
    return nil;
}

#pragma mark - Push Notification Handler
- (void)checkCustomOpens
{
    LogInfo(@"[WMBaseViewController] checkCustomOpens");
    PushHandler *handler = [PushHandler singleton];
    if (handler.notificationDictionary)
    {
        NSString *orderID = [handler orderIDFromPushNotification];
        if (orderID)
        {
            [PushHandler destroy];
            [[WALMenuViewController singleton] presentMyAccountWithOrderId:orderID];
        }
        
        NSString *productId = [handler productIdFromNotification];
        if (productId)
        {
            [PushHandler destroy];
            [[WALMenuViewController singleton] closeMenuAnimated:YES completion:^{
                WALProductDetailViewController *productDetail = [[WALProductDetailViewController alloc] initWithProductId:productId showcaseId:nil];
                WMBaseNavigationController *navigationController = [[WMBaseNavigationController alloc] initWithRootViewController:productDetail];
                [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            }];
        }
        
        NSString *productSKU = [handler productSKUFromNotification];
        if (productSKU)
        {
            [PushHandler destroy];
            [[WALMenuViewController singleton] closeMenuAnimated:YES completion:^{
                WALProductDetailViewController *productDetail = [[WALProductDetailViewController alloc] initWithSKU:productSKU showcaseId:nil];
                WMBaseNavigationController *navigationController = [[WMBaseNavigationController alloc] initWithRootViewController:productDetail];
                [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            }];
        }
        
        NSString *collection = [handler collectionFromPushNotification];
        if (collection)
        {
            [PushHandler destroy];
            [self openSearchWithQuery:collection completionBlock:nil];
        }
        
        BOOL isHomePush = [handler isHomePushNotification];
        if (isHomePush)
        {
            [PushHandler destroy];
            
            OFAppDelegate *delegate = (OFAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate dismissModalViews];
            [[WALMenuViewController singleton] closeMenuAnimated:NO completion:^{
                [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
            }];
        }
    }
}

@end
