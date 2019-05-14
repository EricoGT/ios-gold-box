//
//  WMPDFViewerViewController.h
//  Walmart
//
//  Created by Renan on 6/1/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RetryErrorView;

@interface WMPDFViewerViewController : WMBaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *pdfURLStr;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (strong, nonatomic) NSString *customErrorMessage;

@property (strong, nonatomic) RetryErrorView *retryErrorView;
@property (assign, nonatomic) BOOL isFirstRequest;

- (WMPDFViewerViewController *)initWithPDFURLStr:(NSString *)pdfURLStr;
- (WMPDFViewerViewController *)initWithPDFURLStr:(NSString *)pdfURLStr title:(NSString *)title;

- (void)loadPDF;
- (void)loadPDFSuccessWithData:(NSData *)data;
- (void)loadPDFFailure;

@end
