//
//  WMPlaceholderTextView.m
//  Walmart
//
//  Created by Renan on 6/16/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMPlaceholderTextView.h"
#import "NSString+Additions.h"

@interface WMPlaceholderTextView () <UITextViewDelegate>

@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation WMPlaceholderTextView

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    UIEdgeInsets textContainerInset = self.textContainerInset;
    textContainerInset.left = 5.0f;
    self.textContainerInset = textContainerInset;
    
    self.placeholder = @"";
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(textContainerInset.left * 2, textContainerInset.top, 0, 0)];
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textColor = RGBA(204, 204, 204, 1);
    [self addSubview:self.placeholderLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewTextDidChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

#pragma mark - Placeholder

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    CGRect frame = self.placeholderLabel.frame;
    frame.size = [placeholder sizeForTextWithFont:self.placeholderLabel.font constrainedToSize:CGSizeMake(self.frame.size.width - self.placeholderLabel.frame.origin.x * 2, self.frame.size.height - self.placeholderLabel.frame.origin.y * 2)];
    
    self.placeholderLabel.frame = frame;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (!self.isFirstResponder) {
        self.placeholderLabel.hidden = text.length > 0;
    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _placeholderLabel.font = font;
    [self setPlaceholder:_placeholder];
}

- (void)textViewTextDidChange
{
    _placeholderLabel.hidden = (self.text.length == 0) ? NO : YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
