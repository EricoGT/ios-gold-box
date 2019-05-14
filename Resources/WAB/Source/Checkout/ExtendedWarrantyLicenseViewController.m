//
//  ExtendedWarrantyTermViewController.m
//  Walmart
//
//  Created by Renan on 2/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyLicenseViewController.h"
#import "WBRProductManager.h"

@interface ExtendedWarrantyLicenseViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

@end

@implementation ExtendedWarrantyLicenseViewController

- (ExtendedWarrantyLicenseViewController *)init
{
    self = [super initWithTitle:@"Termos de Autorização" isModal:YES searchButton:NO cartButton:NO wishlistButton:NO];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_actInd setHidesWhenStopped:YES];
    
    self.webView.scalesPageToFit = YES;
    
    [self loadHTML];
}

- (void)loadHTML {
    
    [WBRProductManager getExtendedWarrantyLicenseWithSuccessBlock:^(NSString *html) {
        [self.webView loadHTMLString:html baseURL:nil];
    } failureBlock:^(NSString *message) {
        [self.navigationController.view showRetryAlertWithMessage:message retryBlock:^{
            [self loadHTML];
        } cancelBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_actInd startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_actInd stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_actInd stopAnimating];
    [self.navigationController.view showRetryAlertWithMessage:EXTENDED_WARRANTY_LICENSE_ERROR retryBlock:^{
        [self loadHTML];
    } cancelBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
