//
//  WBRThankYouPageViewController.h
//  Walmart
//
//  Created by Rafael Valim on 19/09/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - Legacy Imports
#import "FeedbackBannerView.h"
#import "OFFeedback.h"
#import "WMBankSlipSuccessCard.h"
#import "WMWebViewController.h"
#import <MessageUI/MessageUI.h>

@interface WBRThankYouPageViewController : WMBaseViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *successDictionary;
@property BOOL isBankingTicket;
@property (nonatomic, strong) MFMailComposeViewController *comp;

@end
