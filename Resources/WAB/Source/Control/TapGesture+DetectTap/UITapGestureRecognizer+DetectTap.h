//
//  UITapGestureRecognizer+DetectTap.h
//  Walmart
//
//  Created by Bruno on 1/21/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapGestureRecognizer (DetectTap)

- (BOOL)didTapAttributedTextInLabel:(UILabel *)label inRange:(NSRange)targetRange;

@end
