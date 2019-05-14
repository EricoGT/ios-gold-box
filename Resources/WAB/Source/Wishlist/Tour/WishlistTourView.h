//
//  WishlistTourView.h
//  Walmart
//
//  Created by Renan Cargnin on 12/3/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMPinnedView.h"

@protocol WishlistTourViewDelegate <NSObject>
@optional
- (void)wishlistTourViewPressedStartUsing;
@end

@interface WishlistTourView : WMPinnedView

@property (weak) id <WishlistTourViewDelegate> delegate;

- (WishlistTourView *)initWithDelegate:(id <WishlistTourViewDelegate>)delegate;

@end
