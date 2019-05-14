//
//  WBRNavigationBarButtonItemFactory.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRNavigationBarButtonItemFactory.h"

@implementation WBRNavigationBarButtonItemFactory

+ (UIBarButtonItem *)createBarButtonItemWithImageString:(NSString *)imageStr andFrameRect:(CGRect)frame {
    
    UIImage *image = [UIImage imageNamed:imageStr];
    UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgButton setImage:image forState:UIControlStateNormal];
    [imgButton setFrame:frame];
    [imgButton setUserInteractionEnabled:NO];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:imgButton];
    
    return buttonItem;
}

@end
