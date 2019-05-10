//
//  WMKnowMoreViewController.h
//  Walmart
//
//  Created by Marcelo Santos on 2/5/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"

@interface WMKnowMoreViewController : WMBaseViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webKnowMore;

@end
