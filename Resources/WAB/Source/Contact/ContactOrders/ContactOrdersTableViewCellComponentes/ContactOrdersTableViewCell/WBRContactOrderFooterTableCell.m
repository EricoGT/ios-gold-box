//
//  WBRContactOrderFooterTableCell.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 12/04/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactOrderFooterTableCell.h"
#import "WMFloatLabelMaskedTextField.h"

static NSInteger kMaxLenght = 15;
static CGFloat const DisabledElementAlphaValue = 0.5f;
static CGFloat const EnabledElementAlphaValue = 1.0f;

@interface WBRContactOrderFooterTableCell() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *orderNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation WBRContactOrderFooterTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self enableSearchButton:NO];
    self.orderNumberTextField.delegate = self;
}

+ (NSString *)reusableIdentifier {
    return NSStringFromClass([WBRContactOrderFooterTableCell class]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger realLenght = textField.text.length + string.length - range.length;

    if (self.orderNumberTextField.text.length + string.length > kMaxLenght) {
        return NO;
    }

    if (!([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)) {
        if (realLenght > 0) {
            [self enableSearchButton:YES];
        } else {
            [self enableSearchButton:NO];
        }
        return YES;
    }
    
    if (!string.length) {
        if (realLenght > 0) {
            [self enableSearchButton:YES];
        } else {
            [self enableSearchButton:NO];
        }
        return YES;
    }
    return NO;
}
- (void)enableSearchButton:(BOOL)enable {
    if (enable) {
        self.selectButton.userInteractionEnabled = YES;
        self.selectButton.alpha = EnabledElementAlphaValue;
    } else {
        self.selectButton.userInteractionEnabled = NO;
        self.selectButton.alpha = DisabledElementAlphaValue;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.orderNumberTextField.text.length != 0) {
        [self.delegate didEnterOrderId:self.orderNumberTextField.text];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self enableSearchButton:NO];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate didEndEditingTextField];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
     [self.delegate didBeginEditingTextField:textField];
}

- (IBAction)touchSelectOrderButton:(id)sender {
    if (self.orderNumberTextField.text.length != 0) {
        [self.delegate didEnterOrderId:self.orderNumberTextField.text];
    }
}
@end
