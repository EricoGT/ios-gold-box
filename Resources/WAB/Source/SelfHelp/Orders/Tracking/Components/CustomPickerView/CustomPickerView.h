//
//  CustomPickerView.h
//  Tracking
//
//  Created by Bruno Delgado on 4/25/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *CustomPickerViewWillDismissNotification = @"CustomPickerViewWillDismissNotification";
static NSString *CustomPickerViewWillSelectNotification = @"CustomPickerViewSelectedNotification";
static NSString *CustomPickerViewSelectedIndexKey = @"SelectedIndex";

@protocol CustomPickerViewDelegate <NSObject>
@optional
- (void)customPickerViewWillDismiss;
- (void)customPickerViewDidSelectIndex:(NSNumber *)indexSelected;
@end

@interface CustomPickerView : UIView

@property (nonatomic, weak) id <CustomPickerViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame  __attribute__((unavailable("Use -presentPickerViewWithOptions:")));
- (id)initWithCoder:(NSCoder *)aDecoder  __attribute__((unavailable("Use -presentPickerViewWithOptions:")));
- (id)init  __attribute__((unavailable("Use -presentPickerViewWithOptions:")));
+ (void)presentPickerViewWithOptions:(NSArray *)options;

@end
