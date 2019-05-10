//
//  ExchangeFormPinnedView.m
//  Walmart
//
//  Created by Renan Cargnin on 6/18/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExchangeFormPinnedView.h"

#import "WMPickerTextField.h"
#import "WMFloatLabelMaskedTextField.h"

static const NSInteger fieldHeight = 44;

@implementation ExchangeFormPinnedView

- (ExchangeFormPinnedView *)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupLayout];
        [self setupBottomContainer];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *viewsDictionary = @{@"self" : self};
        
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[self]-0-|"
                                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                                               metrics:nil
                                                                                 views:viewsDictionary]];
        
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[self]-0-|"
                                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                                               metrics:nil
                                                                                 views:viewsDictionary]];
    }
}

- (void)setupLayout {
    self.backgroundColor = RGBA(238, 238, 238, 1);
}

- (void)setupBottomContainer {
    self.bottomContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width, 0)];
    self.bottomContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.bottomContainer];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomContainer
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomContainer
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomContainer
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1
                                                      constant:0]];
}

- (void)setupWithFields:(NSArray<ContactRequestExchangeFieldModel> *)fields {
    self.fields = fields;
    for (UIView *view in self.subviews) {
        if (view != self.bottomContainer) {
            [view removeFromSuperview];
        }
    }
    self.refundPickerTextField = nil;
    self.refundFieldModel = nil;
    
    NSMutableArray *textFieldsMutable = [NSMutableArray new];
    
    for (ContactRequestExchangeFieldModel *field in fields) {
        UITextField *textField;
        
        CGRect textFieldFrame = CGRectMake(0, 0, self.frame.size.width, fieldHeight);
        if (field.values.count > 0) {
            textField = [[WMPickerTextField alloc] initWithFrame:textFieldFrame placeholder:field.label];
            ((WMPickerTextField *)textField).options = [field.values valueForKey:@"label"];
            
            if ([[field.type uppercaseString] isEqualToString:@"REFUND"]) {
                self.refundFieldModel = field;
                self.refundPickerTextField = (WMPickerTextField *)textField;
            }
            
        }
        else {
            textField = [[WMFloatLabelMaskedTextField alloc] initWithFrame:textFieldFrame];
            textField.placeholder = field.label;
        }
        textField.textColor = RGBA(102, 102, 102, 1);
        textField.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
        [self addSubview:textField];
        
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *topView = textFieldsMutable.lastObject ? textFieldsMutable.lastObject : self;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:topView
                                                         attribute:topView == self ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:topView == self ? 0 : 15]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1
                                                          constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1
                                                          constant:0]];
        
        [textField addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:44]];
        
        if (field == fields.lastObject) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomContainer
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:textField
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:15]];
        }
        [textFieldsMutable addObject:textField];
    }
    self.textFields = textFieldsMutable.copy;
}

@end
