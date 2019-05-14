//
//  ProductZoomItemScrollView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/29/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductZoomItemScrollView : UIScrollView

- (ProductZoomItemScrollView *)initWithImageURL:(NSURL *)imageURL;

- (void)setImageURL:(NSURL *)imageURL;
- (void)resetZoom;

@end
