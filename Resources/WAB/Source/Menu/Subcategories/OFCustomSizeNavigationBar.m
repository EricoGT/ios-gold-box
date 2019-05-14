//
//  OFCustomSizeNavigationBar.m
//  Walmart
//
//  Created by Bruno Delgado on 2/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "OFCustomSizeNavigationBar.h"

@interface OFCustomSizeNavigationBar ()

@property (nonatomic, strong) UILabel *customTitleLabel;

@end

@implementation OFCustomSizeNavigationBar

const CGFloat NavigationBarHeightIncrease = 0;

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height += NavigationBarHeightIncrease;
    return amendedSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.customTitleLabel)
    {
        self.customTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 220, 44)];
        self.customTitleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
        self.customTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.customTitleLabel.backgroundColor = [UIColor clearColor];
        self.customTitleLabel.textColor = [UIColor whiteColor];
        self.customTitleLabel.text = @"";
        [self addSubview:self.customTitleLabel];
    }
    
    NSArray *classNamesToReposition = @[@"UINavigationButton", @"UIButton"];
    for (UIView *view in [self subviews])
    {
        NSString *className = NSStringFromClass([view class]);
        if ([classNamesToReposition containsObject:className])
        {
            CGRect frame = [view frame];
            frame.origin.x = 0;
            frame.origin.y = view.superview.frame.size.height/2 - (view.frame.size.height/2);
            [view setFrame:frame];
        }
    }
}

- (void)setCustomTitle:(NSString *)customTitle
{
    _customTitle = customTitle;
    [UIView animateWithDuration:.2 animations:^{
        self.customTitleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.customTitleLabel.text = customTitle;
        
        [UIView animateWithDuration:.2 animations:^{
            self.customTitleLabel.alpha = 1;
        }];
    }];
}

@end
