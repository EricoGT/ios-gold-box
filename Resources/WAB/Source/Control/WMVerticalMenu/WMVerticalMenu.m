//
//  WMVerticalMenu.m
//  Walmart
//
//  Created by Bruno on 7/3/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMVerticalMenu.h"
#import "CustomMenuButton.h"
#import "UIView+Autolayout.h"

@interface WMVerticalMenu () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomIndicatorView;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, assign) BOOL animationInProgress;

@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;

@end

@implementation WMVerticalMenu

- (instancetype)initWithFrame:(CGRect)frame buttons:(NSArray *)buttons
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.buttons = buttons;
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect]))
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if (!self.buttons)
    {
        self.buttons = [NSArray new];
    }
    self.distanceBetweenButtons = kDistanceBetweenButtons;
    self.animationInProgress = NO;
    
    self.scrollView = [UIScrollView new];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.scrollView];
    [self.scrollView matchView:self];
    
    UIView *bottomBorder = [UIView new];
    bottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
    bottomBorder.backgroundColor = RGBA(221, 221, 221, 1);
    [self addSubview:bottomBorder];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomBorder]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"bottomBorder": bottomBorder}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomBorder(==1)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"bottomBorder": bottomBorder}]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self drawButtons];
}

- (void)setLayout
{
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - Setting Buttons
- (void)addButtons:(NSArray *)buttons
{
    self.buttons = buttons;
    [self drawButtons];
}

- (void)addButton:(CustomMenuButton *)button
{
    NSMutableArray *mutableButtonsList = [[NSMutableArray alloc] initWithArray:self.buttons];
    [mutableButtonsList addObject:button];
    self.buttons = mutableButtonsList.copy;
    [self drawButtons];
}

- (void)drawButtons
{
    if (self.buttons.count == 0) return;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.bottomIndicatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomIndicatorView.backgroundColor = RGBA(26, 117, 207, 1);
    [self.scrollView addSubview:self.bottomIndicatorView];
    
    if (self.buttons.count == 1)
    {
        //Only one button, so we are going to center it
        CustomMenuButton *menuItem = self.buttons[0];
        if ([menuItem isKindOfClass:[CustomMenuButton class]])
        {
            CGRect menuItemFrame = menuItem.frame;
            menuItemFrame.origin.x = self.scrollView.center.x - (menuItemFrame.size.width/2);
            menuItemFrame.origin.y = self.frame.size.height - menuItemFrame.size.height;
            menuItem.frame = menuItemFrame;
            [menuItem hidesBottomBar];
            [self.scrollView addSubview:menuItem];
            
            __weak typeof(menuItem) weakMenuItem = menuItem;
            [menuItem setBlockForTouchUpInsideEvent:^{
                [self scrollToMenu:weakMenuItem];
            }];
            
            [self activateMenu:menuItem triggerDelegate:YES];
            self.scrollView.contentSize = self.scrollView.frame.size;
            self.bottomIndicatorView.frame = CGRectMake(menuItem.frame.origin.x, self.scrollView.frame.size.height - kBottomIndicatorViewHeight, menuItem.frame.size.width, kBottomIndicatorViewHeight);
        }
    }
    else
    {
        //Two or more buttons, setting buttons and space between then and also adjusting content size
        CustomMenuButton *menuItem = self.buttons[0];
        CGFloat position = (self.scrollView.frame.size.width/2) - (menuItem.frame.size.width/2);
        self.leftMargin = position;
        
        for (CustomMenuButton *menuItem in self.buttons)
        {
            if ([menuItem isKindOfClass:[CustomMenuButton class]])
            {
                CGRect menuItemFrame = menuItem.frame;
                menuItemFrame.origin.x = position;
                menuItemFrame.origin.y = self.frame.size.height - menuItemFrame.size.height;
                menuItem.frame = menuItemFrame;
                [self.scrollView addSubview:menuItem];
                position += menuItemFrame.size.width;
                [menuItem hidesBottomBar];
                
                __weak typeof(menuItem) weakMenuItem = menuItem;
                [menuItem setBlockForTouchUpInsideEvent:^{
                    [self scrollToMenu:weakMenuItem];
                }];
                
                if ([self.buttons indexOfObject:menuItem] != self.buttons.count - 1)
                {
                    position += self.distanceBetweenButtons;
                }
                else
                {
                    //Setting extra space to center last item
                    CGFloat lastItemSize = menuItem.frame.size.width;
                    self.rightMargin = (self.scrollView.frame.size.width/2) - (lastItemSize/2);
                    position += _rightMargin;
                }
            }
        }
        
        [self activateMenu:menuItem triggerDelegate:YES];
        self.scrollView.contentSize = CGSizeMake(position, self.scrollView.frame.size.height);
        self.bottomIndicatorView.frame = CGRectMake(menuItem.frame.origin.x, self.scrollView.frame.size.height - kBottomIndicatorViewHeight, menuItem.frame.size.width, kBottomIndicatorViewHeight);
    }
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat centerOffset = scrollView.contentOffset.x + self.scrollView.frame.size.width/2;
    
    int counter = 0;
    for (CustomMenuButton *menuItem in _buttons)
    {
        CGFloat start = (menuItem.frame.origin.x - _distanceBetweenButtons/2);
        CGFloat end = (start + _distanceBetweenButtons/2 + menuItem.frame.size.width + _distanceBetweenButtons/2);
        counter ++;
        if (centerOffset >= start && centerOffset <= end)
        {
            [self activateMenu:menuItem triggerDelegate:YES];
            CGFloat position = menuItem.frame.origin.x - (_scrollView.frame.size.width/2) + menuItem.frame.size.width/2;
            [self.scrollView scrollRectToVisible:CGRectMake(position, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
            break;
        }
    }
}

- (void)activateMenuAtIndex:(NSInteger)menuIndex
{
    if ((menuIndex >= 0) && (menuIndex < self.buttons.count))
    {
        CustomMenuButton *menuItem = [self.buttons objectAtIndex:menuIndex];
        if (menuItem) {
            [self activateMenu:menuItem triggerDelegate:NO];
        }
    }
}

- (void)activateMenu:(CustomMenuButton *)menuItem
{
    [self activateMenu:menuItem triggerDelegate:NO];
}

- (void)activateMenu:(CustomMenuButton *)menuItem triggerDelegate:(BOOL)trigger
{
    if (self.animationInProgress) return;
    self.animationInProgress = YES;
    
    CGFloat position = menuItem.frame.origin.x - (_scrollView.frame.size.width/2) + menuItem.frame.size.width/2;
    
    [UIView animateWithDuration:.25 animations:^{
        self.bottomIndicatorView.frame = CGRectMake(menuItem.frame.origin.x, self.scrollView.frame.size.height - kBottomIndicatorViewHeight, menuItem.frame.size.width, kBottomIndicatorViewHeight);
        [self.scrollView scrollRectToVisible:CGRectMake(position, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    } completion:^(BOOL finished) {
        for (CustomMenuButton *button in self.buttons) {
            [button setActive:NO];
        }
        [menuItem setActive:YES];
        
        if (trigger)
        {
            if ((self.delegate) && ([self.delegate respondsToSelector:@selector(WMVerticalMenu:didChangeToIndex:item:)]))
            {
                [self.delegate WMVerticalMenu:self didChangeToIndex:[self.buttons indexOfObject:menuItem] item:menuItem];
            }
        }
        self.animationInProgress = NO;
    }];
}

- (void)scrollToMenu:(CustomMenuButton *)menuItem
{
    CGFloat position = menuItem.frame.origin.x - (_scrollView.frame.size.width/2) + menuItem.frame.size.width/2;
    [self.scrollView scrollRectToVisible:CGRectMake(position, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    [self activateMenu:menuItem triggerDelegate:YES];
}

@end
