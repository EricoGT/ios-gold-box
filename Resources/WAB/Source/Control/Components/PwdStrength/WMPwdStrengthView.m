//
//  WMPwdStrengthProgressView.m
//  Walmart
//
//  Created by Renan Cargnin on 3/30/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMPwdStrengthView.h"

#import "PwdStrengthInteractor.h"

@interface WMPwdStrengthView ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *strengthLabel;

@end

@implementation WMPwdStrengthView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [_progressView setTrackTintColor:RGBA(221, 221, 221, 1)];
    [self setPwdString:@""];
}

- (void)setTextField:(UITextField *)textField {
    [_textField removeTarget:self action:@selector(textFieldEditingChanged) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(textFieldEditingChanged) forControlEvents:UIControlEventEditingChanged];
    _textField = textField;
}

- (void)setPwdString:(NSString *)pwdString {
    PwdStrength pwdStrength = [[PwdStrengthInteractor singleton] strengthWithPwd:pwdString];
    
    [_progressView setProgress:[self progressForPwdStrength:pwdStrength] animated:YES];
    [_progressView setProgressTintColor:[self progressColorForPwdStrength:pwdStrength]];
    [_strengthLabel setTextColor:[self labelColorForPwdStrength:pwdStrength]];
    [_strengthLabel setText:[self textForPwdStrength:pwdStrength]];
}

- (CGFloat)progressForPwdStrength:(PwdStrength)pwdStrength {
    switch (pwdStrength) {
        case PwdStrengthNone:   return 0.0f;
        case PwdStrengthWeak:   return 0.33f;
        case PwdStrengthMedium: return 0.66f;
        case PwdStrengthStrong: return 1.0f;
    }
}

- (UIColor *)progressColorForPwdStrength:(PwdStrength)pwdStrength {
    switch (pwdStrength) {
        case PwdStrengthNone:   return RGBA(221, 221, 221, 1);
        case PwdStrengthWeak:   return RGBA(255, 0, 31, 1);
        case PwdStrengthMedium: return RGBA(255, 159, 0, 1);
        case PwdStrengthStrong: return RGBA(101, 211, 33, 1);
    }
}

- (UIColor *)labelColorForPwdStrength:(PwdStrength)pwdStrength {
    switch (pwdStrength) {
        case PwdStrengthNone:
            return RGBA(204, 204, 204, 1);
            
        case PwdStrengthWeak:
        case PwdStrengthMedium:
        case PwdStrengthStrong:
            return [self progressColorForPwdStrength:pwdStrength];
    }
}

- (NSString *)textForPwdStrength:(PwdStrength)pwdStrength {
    switch (pwdStrength) {
        case PwdStrengthNone:   return PWD_STRENGTH_NONE;
        case PwdStrengthWeak:   return PWD_STRENGTH_WEAK;
        case PwdStrengthMedium: return PWD_STRENGTH_MEDIUM;
        case PwdStrengthStrong: return PWD_STRENGTH_STRONG;
    }
}

#pragma mark - TextField
- (void)textFieldEditingChanged {
    [self setPwdString:_textField.text];
}

@end
