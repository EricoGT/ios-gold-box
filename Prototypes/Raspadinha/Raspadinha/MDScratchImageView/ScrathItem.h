//
//  ScrathItem.h
//  Raspadinha
//
//  Created by Erico GT on 11/01/18.
//  Copyright © 2018 lordesire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDScratchImageView.h"

@interface ScrathItem : NSObject

@property (nonatomic, assign) bool isPremium;
@property (nonatomic, strong) MDScratchImageView *scrathView;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, strong) UIImage *itemImage;

+ (ScrathItem*) newItemWithRect:(CGRect)viewRect imageItem:(UIImage*)iImage imageTexture:(UIImage*)tImage lineThickness:(CGFloat)lineT premium:(bool)premium delegate:(id<MDScratchImageViewDelegate>)scratchImageViewDelegate order:(NSInteger)iOrder;

@end
