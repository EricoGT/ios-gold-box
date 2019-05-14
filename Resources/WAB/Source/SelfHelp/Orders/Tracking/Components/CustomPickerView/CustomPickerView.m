//
//  CustomPickerView.m
//  Tracking
//
//  Created by Bruno Delgado on 4/25/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "CustomPickerView.h"
#import "UIImage+Additions.h"

@interface CustomPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *divider;
@property (nonatomic, strong) NSArray *pickerOptions;
@property (nonatomic, assign) NSInteger indexSelected;
@property (nonatomic, assign) CGSize screenSize;

@end

@implementation CustomPickerView

+ (instancetype)sharedInstance
{
    static CustomPickerView *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [self new];
    });
    return _sharedManager;
}

+ (void)presentPickerViewWithOptions:(NSArray *)options
{
    [[self sharedInstance] showPickerWithOptions:options indexSelected:0];
}

- (UIView *)overlayView
{
    if (!_overlayView)
    {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = RGBA(0, 0, 0, .2);
        _backgroundView.alpha = 0;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundDidReceiveTouchEvent)];
        [_backgroundView addGestureRecognizer:singleTap];
    }
    return _backgroundView;
}

- (void)createPickerView
{
    if (!self.contentView)
    {
        self.toolbar = [UIToolbar new];
        [self.toolbar setFrame:CGRectMake(0, 0, 320, 44)];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filtrar" style:UIBarButtonItemStylePlain target:self action:@selector(filterPressed)];
        
        [self.toolbar setItems:[[NSArray alloc] initWithObjects:cancelButton,flexibleItem,filterButton, nil]];
        
        self.picker = [UIPickerView new];
        [self.picker setFrame:CGRectMake(0, self.toolbar.frame.size.height, self.picker.frame.size.width, self.picker.frame.size.height)];
        self.picker.showsSelectionIndicator = YES;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        
        self.divider = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolbar.frame.origin.y + self.toolbar.frame.size.height, self.screenSize.width, 0.5f)];
        self.divider.backgroundColor = RGBA(0, 0, 0, .3);
        
        [self.toolbar setTranslucent:NO];
        [self.picker setBackgroundColor:RGBA(255, 255, 255, 1)];
        
        NSDictionary *attributesCancelButton = @{NSForegroundColorAttributeName : RGBA(26, 117, 207, 1),
                                                 NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:17]};
        
        NSDictionary *attributesFilterButton = @{NSForegroundColorAttributeName : RGBA(26, 117, 207, 1),
                                                 NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Semibold" size:17]};
        
        [cancelButton setTitleTextAttributes:attributesCancelButton forState:UIControlStateNormal];
        [filterButton setTitleTextAttributes:attributesFilterButton forState:UIControlStateNormal];
        
        [self.toolbar setBackgroundImage:[UIImage imageWithColor:RGBA(255, 255, 255, 1)] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.divider setHidden:NO];
        
        CGSize contentViewSize = CGSizeMake(self.screenSize.width, self.toolbar.frame.size.height + self.picker.frame.size.height);
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.screenSize.height - contentViewSize.height, contentViewSize.width, contentViewSize.height)];
        self.contentView.backgroundColor = RGBA(255, 255, 255, 1);
        [self.contentView addSubview:self.toolbar];
        [self.contentView addSubview:self.picker];
        [self.contentView addSubview:self.divider];
        
        //Set frame above view to animate
        CGRect newFrame = self.contentView.frame;
        newFrame.origin.y = self.screenSize.height;
        self.contentView.frame = newFrame;
    }
}

#pragma mark - Show and Dismiss
- (void)showPickerWithOptions:(NSArray *)options indexSelected:(NSInteger)index
{
    self.indexSelected = index;
    self.pickerOptions = options;
    self.screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (!self.overlayView.superview)
    {
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal)
            {
                [window addSubview:self.overlayView];
                break;
            }
    }
    
    [self.overlayView addSubview:self.backgroundView];
    [self createPickerView];
    [self.overlayView addSubview:self.contentView];
    
    
    CGRect newFrame = self.contentView.frame;
    newFrame.origin.y = self.screenSize.height - self.contentView.frame.size.height;
    
    [UIView animateWithDuration:.4 animations:^{
        self.backgroundView.alpha = 1;
    }];
    
    [UIView animateWithDuration:.2 animations:^{
        self.contentView.frame = newFrame;
    }];
    
}

- (void)backgroundDidReceiveTouchEvent
{
    [self dismiss];
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(customPickerViewWillDismiss)]))
    {
        [self.delegate customPickerViewWillDismiss];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:CustomPickerViewWillDismissNotification object:nil];
    }
}

- (void)dismiss
{
    CGRect newFrame = self.contentView.frame;
    newFrame.origin.y = self.screenSize.height;
    [UIView animateWithDuration:.2 animations:^{
        self.contentView.frame = newFrame;
    }];
    
    [UIView animateWithDuration:.4 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self->_overlayView removeFromSuperview];
        self.overlayView = nil;
        
        self.backgroundView = nil;
        self.contentView = nil;
        self.picker = nil;
        self.toolbar = nil;
    }];

}

#pragma mark - Picker Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerOptions.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerOptions[row];
}

#pragma mark - Picker Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.indexSelected = row;
}

#pragma mark - Filter
- (void)filterPressed
{
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(customPickerViewDidSelectIndex:)]))
    {
        [self.delegate customPickerViewDidSelectIndex:@(self.indexSelected)];
    }
    else
    {
    [[NSNotificationCenter defaultCenter] postNotificationName:CustomPickerViewWillSelectNotification
                                                        object:nil
                                                      userInfo:@{CustomPickerViewSelectedIndexKey : @(self.indexSelected)}];
    }
    
    [self dismiss];
}

#pragma mark - Cancel
- (void)cancelPressed
{
    [self backgroundDidReceiveTouchEvent];
}


@end
