//
//  UIView+Retry.h
//  Walmart
//
//  Created by Renan Cargnin on 2/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RetryView)

/**
 *  Shows retry view
 *
 *  @param kind NSString with the message to be displayed in the retry view
 *  @param kind void(^)() with the block that should be fired when the user presses the retry button
 */
- (void)showRetryViewWithMessage:(NSString *)message retryBlock:(void (^)())retryBlock;

/**
 *  Removes retry view
 */
- (void)removeRetryView;

@end
