//
//  PaymentSummaryItem.h
//  Walmart
//
//  Created by Bruno Delgado on 1/13/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentSummaryItem : UIView

@property (nonatomic, weak) IBOutlet UILabel *summaryTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *summaryValueLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *summaryLoader;
@property (nonatomic, weak) IBOutlet UIImageView *divider;

+ (UIView *)setup;
- (void)setLayout;

@end
