//
//  WMWebViewController.h
//  Walmart
//
//  Created by Renan on 6/23/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"

@interface WMWebViewController : WMBaseViewController

- (WMWebViewController *)initWithURL:(NSURL *)url title:(NSString *)title;
- (WMWebViewController *)initWithURLStr:(NSString *)urlStr title:(NSString *)title;
- (WMWebViewController *)initWithLocalHTMLFile:(NSString *)fileName title:(NSString *)title;
- (WMWebViewController *)initWithHtmlString:(NSString *)htmlString title:(NSString *)title;
@end
