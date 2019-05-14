//
//  RetryView.h
//  Walmart
//
//  Created by Renan Cargnin on 2/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMPinnedView.h"

@interface WMRetryView : WMPinnedView

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (copy, nonatomic) void (^retryBlock)();

- (WMRetryView *)initWithMessage:(NSString *)message retryBlock:(void (^)())retryBlock;

- (void)setMessage:(NSString *)message;

@end
