//
//  UIImageView+UIActivityIndicatorView.h
//  AlbumShow
//
//  Created by Erico GT on 13/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBHud.h"

@interface UIImageView_UIActivityIndicatorView : UIImageView

- (void)activityIndicatorTintColor:(UIColor*)color;
- (void)startActivityIndicator;
- (void)stopActivityIndicator;

@end
