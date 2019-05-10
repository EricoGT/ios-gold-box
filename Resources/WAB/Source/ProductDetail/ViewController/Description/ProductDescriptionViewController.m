//
//  ProductDescriptionViewController.m
//  Walmart
//
//  Created by Renan Cargnin on 1/26/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductDescriptionViewController.h"

#import "ProductDetailConnection.h"
#import "WBRProductManager.h"

@interface ProductDescriptionViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *translateViewHeightConstraint;

@property (strong, nonatomic) NSString *productId;

@end

@implementation ProductDescriptionViewController

- (ProductDescriptionViewController *)initWithProductId:(NSString *)productId {
    if (self = [super initWithTitle:@"Descrição" isModal:NO searchButton:YES cartButton:YES wishlistButton:NO]) {
        _productId = productId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _translateViewHeightConstraint.constant = 0.0f;
    
    _webView.delegate = self;
    _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    _webView.scrollView.showsVerticalScrollIndicator = NO;

    [self loadDescription];
}

- (void)loadDescription {
    [self.view showLoading];
    
    [WBRProductManager getProductDescriptionWithProductId:self.productId successBlock:^(NSString *htmlString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideLoading];
            [self->_webView loadHTMLString:[self adjustHtmlDescription:htmlString] baseURL:nil];
        });

    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideLoading];
            [self.view showRetryViewWithMessage:error.localizedDescription retryBlock:^{
                [self loadDescription];
            }];
        });

    }];
}

- (NSString *) adjustHtmlDescription: (NSString *) descript
{
    NSString *specPage = descript;
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<hr>" withString:@"</p><hr>"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<div id=\"title\">" withString:@"<br><div><span class=\"title\">"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<div id=\"product-description\">" withString:@"<div><span class=\"conteudo\">"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"</style>" withString:@"\
                .title {font-family:'OpenSans-Bold';font-weight: bold;}\
                .conteudo {font-family:'Roboto';font-size: 12px;}</style>"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<br/><br/><br/>" withString:@"<br>"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<br/><br/><br/><br/>" withString:@"<br>"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<br/><br/><br/><br/><br />" withString:@"<br>"];
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<br/><br/> " withString:@"<br>"];
//    specPage = [specPage stringByReplacingOccurrencesOfString:@"<br/> " withString:@""];
    NSString *strSkipLine = @"<br>";
    specPage = [strSkipLine stringByAppendingString:specPage];
    return specPage;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    LogInfo(@"Finish html loading");
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
