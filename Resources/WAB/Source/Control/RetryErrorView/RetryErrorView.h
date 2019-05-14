//
//  HubErrorView.h
//  Walmart
//
//  Created by Renan on 2/13/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMButton.h"

@protocol retryErrorViewDelegate <NSObject>
@optional
- (void)retry;
@end

@interface RetryErrorView : UIView

@property (nonatomic, assign) id <retryErrorViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet WMButton *retryButton;

- (RetryErrorView *)initWithMsg:(NSString *)msg;

@end
