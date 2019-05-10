//
//  WMSeePwdSwitch.h
//  Walmart
//
//  Created by Renan Cargnin on 3/31/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface WMSeePwdButton : UIButton

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (assign, nonatomic) IBInspectable BOOL on;

- (CGFloat)widthFromConstraint;

@end
