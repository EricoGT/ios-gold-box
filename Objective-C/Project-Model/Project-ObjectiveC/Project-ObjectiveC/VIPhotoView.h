//
//  VIPhotoView.h
//  VIPhotoViewDemo
//
//  Created by Vito on 1/7/15.
//  Copyright (c) 2015 vito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"

@class VIPhotoView;

@protocol VIPhotoViewDelegate <NSObject>
@required
- (void)photoViewDidHide:(VIPhotoView*)photoView;
@end

@interface VIPhotoView : UIView

- (VIPhotoView*)initWithFrame:(CGRect)frame image:(UIImage *)image backgroundImage:(UIImage*)backgroundImage andDelegate:(NSObject<VIPhotoViewDelegate>*)controllerDelegate;

@end


