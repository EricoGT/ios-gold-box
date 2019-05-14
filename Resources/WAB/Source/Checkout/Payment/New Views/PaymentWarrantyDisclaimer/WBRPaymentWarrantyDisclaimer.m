//
//  WBRPaymentWarrantyDisclaimer.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 9/27/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentWarrantyDisclaimer.h"

@interface WBRPaymentWarrantyDisclaimer ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWithLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWithTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWithBottomConstraint;
@end

@implementation WBRPaymentWarrantyDisclaimer

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    UINib *nib = [UINib nibWithNibName:@"WBRPaymentWarrantyDisclaimer" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    UIFont *textBoldFont = [UIFont fontWithName:@"Roboto-Medium" size:13];
    UIColor *color = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1.0f];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.warningLabel.text];
    [attributedString addAttribute:NSFontAttributeName value:textBoldFont range:NSMakeRange(0, 8)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, 8)];
    
    self.warningLabel.attributedText = attributedString;
}

#pragma mark - Custom getter

- (NSNumber *)suggestedHeight {
    return [NSNumber numberWithDouble:
            self.warningLabel.layer.frame.size.height +
            self.labelWithTopConstraint.constant +
            self.buttonWithLabelConstraint.constant +
            self.buttonHeightContainer.constant +
            self.buttonWithBottomConstraint.constant];
}

#pragma mark - IBAction

- (IBAction)singlePaymentAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(WBRPaymentWarrantySelectedSinglePayment:)]) {
        [self.delegate WBRPaymentWarrantySelectedSinglePayment:self];
    }
}

@end
