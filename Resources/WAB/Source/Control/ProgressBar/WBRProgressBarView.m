//
//  WBRProgressBarView.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 1/2/19.
//  Copyright © 2019 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRProgressBarView.h"

@interface WBRProgressBarView ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;

@end

@implementation WBRProgressBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupConstraints];
        [self setupBorderView];
        [self setupProgressInfo];
    }
    
    return self;
}

- (void)setupBorderView {
    [self.layer setCornerRadius:4];
    [self.layer setMasksToBounds:YES];
}

- (void)setupProgressInfo {
    [self.progressText setText: @"0%"];
    [self.progressBar setProgress:0.0];
}

- (void)setupConstraints {
    if (IS_IPHONE_6) {
        self.trailingConstraint.constant = 30;
        self.leadingConstraint.constant = 30;
    } else if (IS_IPHONE_6P) {
        self.trailingConstraint.constant = 68;
        self.leadingConstraint.constant = 68;
    }
    
    [self layoutIfNeeded];
}


- (void)setProgressValue:(NSNumber *)progress {
    LogInfo(@"PROGRESS: %@", progress);
    
    self.progressText.text = [NSString stringWithFormat:@"%d%%", progress.intValue];
    [self.progressBar setProgress:progress.floatValue/100];
}

@end
