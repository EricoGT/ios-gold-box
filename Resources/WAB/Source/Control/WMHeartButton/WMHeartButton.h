//
//  WMHeartButton.h
//  Walmart
//
//  Created by Bruno on 11/24/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMHeartButton : UIButton

@property (nonatomic, assign) CGFloat animationDuration;

/**
 *  Favorites and animates the heart
 */
- (void)favoriteAnimated:(BOOL)animated;

/**
 *  Unfavorites
 */
- (void)unfavoriteAnimated:(BOOL)animated;

/**
 *  Checks if the button is favorited
 *
 *  @return BOOL value indicating if the button is favorited
 */
- (BOOL)favorite;

/**
 *  Starts to pulse the empty heart
 */
- (void)pulseEmptyHeart;

/**
 *  Starts to pulse the full heart
 */
- (void)pulseFullHeart;

/**
 *  Starts to pulse
 */
- (void)pulse;

/**
 *  Stops all pulsing animations
 */
- (void)stopPulsing;

@end