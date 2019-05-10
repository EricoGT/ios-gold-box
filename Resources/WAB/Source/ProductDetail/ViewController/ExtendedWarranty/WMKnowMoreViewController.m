//
//  WMKnowMoreViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 2/5/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMKnowMoreViewController.h"
#import "WBRProductManager.h"

@interface WMKnowMoreViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

@end

@implementation WMKnowMoreViewController

- (WMKnowMoreViewController *)init
{
    self = [super initWithTitle:@"Saiba mais" isModal:YES searchButton:NO cartButton:NO wishlistButton:NO];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.webKnowMore.delegate = self;
    self.webKnowMore.scalesPageToFit = NO;
    self.webKnowMore.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    [self performSelector:@selector(loadHTML) withObject:nil afterDelay:0.1];
}

- (void) contentSpecification:(NSString *)specific {
    
    LogInfo(@"KnowMore url content: %@", specific);
    
    NSString *knowMorePage = [self adjustHtml:specific];
    
    [_webKnowMore loadHTMLString:knowMorePage baseURL:nil];
}


- (void) loadHTML
{
    [_actInd startAnimating];
    
    [WBRProductManager getExtendedWarrantyDescriptionWithSuccessBlock:^(NSString *html) {
        [self contentSpecification:html];
    } failureBlock:^(NSString *message) {
        [self errorConnectionProduct:message];
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //    return YES;
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
    
    [_actInd stopAnimating];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) back:(id)sender {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [self performSelector:@selector(removeWebview) withObject:nil afterDelay:1.0];
}

- (void) removeWebview {
    
    if (_webKnowMore) {
        NSArray *viewsToRemove = [_webKnowMore subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
    }
    
    [self.webKnowMore removeFromSuperview];
    self.webKnowMore = nil;
}

- (void) errorConnectionProduct:(NSString *) msgError {
    LogErro(@"Error Connection: %@", msgError);
    [_actInd stopAnimating];
    [self.view showRetryViewWithMessage:msgError retryBlock:^{
        [self loadHTML];
    }];
}

- (void) executeCancelFromAlert {
    LogInfo(@"Cancel from Msg");
}

- (void) executeActionFromAlert {
    [self back:self];
}

- (NSString *) adjustHtml: (NSString *) specif {
    
    //Adjust Layout Html
    NSString *specPage = [specif stringByReplacingOccurrencesOfString:@"width: 100%" withString:@"width: 300px;\npadding: 10px;"];
    
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<hr>" withString:@"</p><hr>"];
    
    specPage = [specPage stringByReplacingOccurrencesOfString:@"<div id=\"title\">" withString:@"<div><span class=\"title\">"];
    
    specPage = [specPage stringByReplacingOccurrencesOfString:@"</div>" withString:@"</span></div>\
                <div><span class=\"conteudo\"><p>"];
    
    //font: Euphemia UCAS
    specPage = [specPage stringByReplacingOccurrencesOfString:@"</style>" withString:@"\
                .title {font-family: OpenSans-Bold;font-weight: bold;}\
                .conteudo {font-family: OpenSans;font-size: 12px;}</style>"];
    
    LogInfo(@"SpecPage: %@", specPage);
    
    return specPage;
}

@end
