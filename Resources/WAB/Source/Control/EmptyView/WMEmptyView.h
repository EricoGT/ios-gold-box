//
//  WMEmptyView.h
//  Walmart
//
//  Created by Renan Cargnin on 2/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMPinnedView.h"

@interface WMEmptyView : WMPinnedView

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (WMEmptyView *)initWithMessage:(NSString *)message;

- (void)setMessage:(NSString *)message;
- (void)setAttributedMessage:(NSAttributedString *)attributedMessage;

@end
