//
//  WMWebViewController.m
//  Walmart
//
//  Created by Renan on 6/23/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMWebViewController.h"

#import "RetryErrorView.h"

@interface WMWebViewController () <UIWebViewDelegate, retryErrorViewDelegate>

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *htmlString;
@property (assign, nonatomic) BOOL isLocalFile;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) RetryErrorView *retryErrorView;

@end

@implementation WMWebViewController

- (WMWebViewController *)initWithURL:(NSURL *)url title:(NSString *)title {
    self = [super initWithTitle:title isModal:YES searchButton:NO cartButton:NO wishlistButton:NO];
    if (self) {
        self.url = url;
    }
    return self;
}

- (WMWebViewController *)initWithURLStr:(NSString *)urlStr title:(NSString *)title {
    self = [self initWithURL:[NSURL URLWithString:urlStr] title:title];
    return self;
}

- (WMWebViewController *)initWithLocalHTMLFile:(NSString *)fileName title:(NSString *)title {
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@".html" withString:@""];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType: @"html"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    _isLocalFile = YES;
    
    self = [self initWithURL:fileURL title:title];
    return self;
}

- (WMWebViewController *)initWithHtmlString:(NSString *)htmlString title:(NSString *)title {
    self = [super initWithTitle:title isModal:YES searchButton:NO cartButton:NO wishlistButton:NO];
    if (self) {
        self.htmlString = htmlString;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (_isLocalFile)
    {
        _webView.scalesPageToFit = NO;
        _webView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.webView.delegate = self;
    [self loadContent];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadContent {
    LogURL(@"WebView URL: %@", _url.absoluteString);
    
    [self showLoading];
    if (self.htmlString) {
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

#pragma mark - WebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoading];
    
    self.retryErrorView = [[RetryErrorView alloc] initWithMsg:REQUEST_ERROR];
    self.retryErrorView.delegate = self;
    [self.view addSubview:self.retryErrorView];
}

#pragma mark - Loading 

- (void)showLoading {
    [self.view showLoading];
    _webView.hidden = YES;
}

- (void)hideLoading {
    [self.view hideLoading];
    _webView.hidden = NO;
}

#pragma mark - MsgCommon Delegate

- (void)retry {
    [_retryErrorView removeFromSuperview];
    [self loadContent];
}

#pragma mark - Open links in Safari

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}

@end
