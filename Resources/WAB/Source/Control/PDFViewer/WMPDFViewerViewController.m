//
//  WMPDFViewerViewController.m
//  Walmart
//
//  Created by Renan on 6/1/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMPDFViewerViewController.h"
#import "OFUrls.h"
#import "RetryErrorView.h"
#import "WBRConnection.h"

@interface WMPDFViewerViewController () <UIWebViewDelegate, retryErrorViewDelegate>

@end

@implementation WMPDFViewerViewController

- (WMPDFViewerViewController *)initWithPDFURLStr:(NSString *)pdfURLStr {
    self = [super initWithNibName:@"WMPDFViewerViewController" bundle:nil];
    if (self) {
        self.pdfURLStr = pdfURLStr;
    }
    return self;
}

- (WMPDFViewerViewController *)initWithPDFURLStr:(NSString *)pdfURLStr title:(NSString *)title {
    self = [self initWithPDFURLStr:pdfURLStr];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstRequest = YES;
    
    [self setupWebView];
    [self loadPDF];
}

- (void)setupWebView {
    self.webView.delegate = self;
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    for (UIView *subView in [self.webView.scrollView subviews])
    {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView setHidden:YES];
        }
    }
}

#pragma mark - Load PDF

- (void)loadPDF
{
    [self.loader startAnimating];
    [[WMTokens new] getTokenOAuth:^(NSString *token) {
        
        if (token) {
            NSString *url = self.pdfURLStr;

            self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
            if (![NSURLConnection canHandleRequest:self.request]) {
                
                NSURL *urlWithBaseAppVersion = [NSURL URLWithString:[[OFUrls new] getBaseURLWithAppVersion]];
                urlWithBaseAppVersion = [urlWithBaseAppVersion URLByAppendingPathComponent:self.pdfURLStr];
                
                url = urlWithBaseAppVersion.absoluteString;
            }

            [self.loader startAnimating];
            
            NSDictionary *dictInfo = [OFSetup infoAppToServer];
            NSDictionary *headersDictionary = @{
                                                @"system": [dictInfo objectForKey:@"system"],
                                                @"version": [dictInfo objectForKey:@"version"]
                                                };
            
            [[WBRConnection sharedInstance] GET:url headers:headersDictionary authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
                
                if (data.length > 1024) {
                    UInt8 pdfBytes[4] = {0x25, 0x50, 0x44, 0x46};
                    NSData *pdfHeaderData = [NSData dataWithBytes:pdfBytes length:4];
                    NSRange range = [data rangeOfData:pdfHeaderData options:NSDataSearchAnchored range:NSMakeRange(0, 1024)];
                    if (range.location != NSNotFound) {
                        [self loadPDFSuccessWithData:data];
                    }
                    else {
                        [self loadPDFFailure];
                    }
                }
                else {
                    [self loadPDFFailure];
                }
            } failureBlock:^(NSError *error, NSData *failureData) {
                
                if (error.code == 401 || error.code == 1012) {
                    [self presentLoginWithCompletionBlock:^{
                        [self.loader stopAnimating];
                    } successBlock:^{
                        [self loadPDF];
                    } dismissBlock:^{
                        [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                    }];
                }
                else {
                    [self loadPDFRequestFailure];
                }
            }];
        }
    }];
}

- (void)loadPDFSuccessWithData:(NSData *)data {
    [self.loader stopAnimating];
    [self.webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:[NSURL new]];
}

- (void)loadPDFFailure
{
    [self.loader stopAnimating];
    [self showErrorViewWithMsg:self.customErrorMessage ?: REQUEST_ERROR];
}

- (void)loadPDFRequestFailure
{
    [self.loader stopAnimating];
    [self showErrorViewWithMsg:REQUEST_ERROR];
}

#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (self.isFirstRequest) {
        self.isFirstRequest = NO;
        return YES;
    }
    return NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showErrorViewWithMsg:REQUEST_ERROR];
}

#pragma mark - Retry Error View

- (void)showErrorViewWithMsg:(NSString *)msg {
    self.retryErrorView = [[RetryErrorView alloc] initWithMsg:msg];
    self.retryErrorView.delegate = self;
    [self.view addSubview:self.retryErrorView];
}

- (void)retry {
    [self.retryErrorView removeFromSuperview];
    [self loadPDF];
}

@end
