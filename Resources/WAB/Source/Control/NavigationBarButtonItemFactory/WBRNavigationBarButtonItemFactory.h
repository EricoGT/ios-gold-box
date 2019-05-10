//
//  WBRNavigationBarButtonItemFactory.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBRNavigationBarButtonItemFactory : NSObject

/**
 Create a custom UIBarButtonItem with a image and rect frame.
 
 @param imageStr Image name to be load in the button item.
 @param frame Button frame rect.
 @return A UIBarButtonItem reference created by image and frame rect params.
 */
+ (UIBarButtonItem *)createBarButtonItemWithImageString:(NSString *)imageStr andFrameRect:(CGRect)frame;

@end
