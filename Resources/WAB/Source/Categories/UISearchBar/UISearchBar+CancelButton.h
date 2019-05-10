//
//  UISearchBar+CancelButton.h
//  Walmart
//
//  Created by Renan Cargnin on 2/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (CancelButton)

- (void)customCancelButtonWithTitle:(NSString *)title tintColor:(UIColor *)tintColor;
- (void)reenableCancelButton;

@end
