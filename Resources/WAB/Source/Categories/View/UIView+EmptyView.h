//
//  UIView+EmptyView.h
//  Walmart
//
//  Created by Renan Cargnin on 2/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EmptyView)

/**
 *  Shows empty view
 *
 *  @param kind NSString with the message to be displayed in the empty view
 */
- (void)showEmptyViewWithMessage:(NSString *)message;

/**
 *  Shows empty view
 *
 *  @param kind NSAttributedString with the attributed message to be displayed in the empty view
 */
- (void)showEmptyViewWithAttributedMessage:(NSAttributedString *)attributedMessage;

/**
 *  Hides the empty view
 */
- (void)hideEmptyView;

@end
