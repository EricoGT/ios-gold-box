//
//  FeedbackBannerView.m
//  Walmart
//
//  Created by Renan on 8/25/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "FeedbackBannerView.h"

@interface FeedbackBannerView ()

@property (nonatomic, copy) void (^buttonPressedBlock)();

@end

@implementation FeedbackBannerView

- (FeedbackBannerView *)initWithWithButtonPressedBlock:(void (^)())buttonPressedBlock {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (self) {
        _buttonPressedBlock = buttonPressedBlock;
        
        CGRect frame = self.frame;
        frame.size.height = [self systemLayoutSizeFittingSize:self.bounds.size].height;
        self.frame = frame;
    }
    return self;
}

- (IBAction)pressedFeedbackButton:(id)sender {
    if (_buttonPressedBlock) _buttonPressedBlock();
}

@end
