//
//  WMPicker.h
//  Walmart
//
//  Created by Renan on 6/12/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMPickerDelegate <NSObject>
@required
- (void)pressedOk;
@end

@interface WMPicker : UIPickerView

@property (weak) id <WMPickerDelegate> wmPickerDelegate;
@property (strong, nonatomic) UIView *inputView;
@property (strong, nonatomic) UIFont *font;

@end
