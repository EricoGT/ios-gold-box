//
//  ProductSpecificationViewController.m
//  Walmart
//
//  Created by Renan Cargnin on 1/26/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductSpecificationViewController.h"

#import "ProductDetailConnection.h"
#import "WBRProductManager.h"

@interface ProductSpecificationViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString *productId;

@end

@implementation ProductSpecificationViewController

- (ProductSpecificationViewController *)initWithProductId:(NSString *)productId {
    if (self = [super initWithTitle:@"Características" isModal:NO searchButton:YES cartButton:YES wishlistButton:NO]) {
        _productId = productId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _webView.delegate = self;
    _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    
    [self loadSpecification];
}

- (void)loadSpecification {
    [self.view showLoading];
    
    [WBRProductManager getProductSpecificationWithProductId:self.productId successBlock:^(NSString *htmlString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideLoading];
            [self->_webView loadHTMLString:[self adjustHTML:htmlString] baseURL:nil];
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideLoading];
        });
    }];
}

- (NSString *)adjustHTML:(NSString *)specif {
    NSString *specPage = [specif stringByReplacingOccurrencesOfString:@"<hr>" withString:@"</p><hr>"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<div id=\"title\">" withString:@"<div><span class=\"title\">"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"</div>" withString:@"</span></div>\
                <div><span class=\"conteudo\"><p>"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"</style>" withString:@"\
                .title {font-family: OpenSans-Bold;font-weight: bold;}\
                .conteudo {font-family: Roboto;font-size: 12px;}</style>"];
    NSString *strSkipLine = @"<br>";
    specPage = [strSkipLine stringByAppendingString:specPage];
    return specPage;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    LogInfo(@"Finish html loading");
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

@end
