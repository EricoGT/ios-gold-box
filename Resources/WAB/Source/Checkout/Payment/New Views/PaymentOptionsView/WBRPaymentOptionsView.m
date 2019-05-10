//
//  WBRPaymentOptionsView.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/25/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentOptionsView.h"

@interface WBRPaymentOptionsView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *optionsView;

@property (weak, nonatomic) IBOutlet UIView *optionsIndicatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsIndicatorViewHalfWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsIndicatorViewFullWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsIndicatorViewLeadingConstraint;

@property (weak, nonatomic) IBOutlet UIButton *creditCardButton;
@property (weak, nonatomic) IBOutlet UILabel *creditCardButtonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *creditCardButtonImagemView;

@property (weak, nonatomic) IBOutlet UIButton *bankSlipButton;
@property (weak, nonatomic) IBOutlet UILabel *bankSlipButtonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bankSlipButtonImageView;

@property (weak, nonatomic) IBOutlet UIView *onlyCreditCardOptionContainer;

@end

@implementation WBRPaymentOptionsView

#pragma mark - Init

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
    
    UINib *nib = [UINib nibWithNibName:@"WBRPaymentOptionsView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

#pragma mark - Private Methods

- (void)showOptionsIndicatorAtPosition:(NSInteger)position {
    
    CGFloat newXPosition = (self.optionsView.frame.size.width / 2) * position;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [UIView animateWithDuration:0.3f animations:^{
            self.optionsIndicatorViewLeadingConstraint.constant = newXPosition;
            [self layoutIfNeeded];
        }];
    }];
}


#pragma mark - Public Methods 

- (void)setOnlyCreditCardOption:(BOOL)visible {
    self.onlyCreditCardOptionContainer.hidden = !visible;
}

- (void)setSelectedFont {

    UIFont *robotoRegularFont = [UIFont fontWithName:@"Roboto-Regular" size:11];
    UIFont *robotoMediumFont = [UIFont fontWithName:@"Roboto-Medium" size:11];
    
    if (self.selectedPayment == kPaymentTypeCreditCard) {
        self.creditCardButtonLabel.font = robotoMediumFont;
        self.bankSlipButtonLabel.font = robotoRegularFont;
    }
    else {
        self.creditCardButtonLabel.font = robotoRegularFont;
        self.bankSlipButtonLabel.font = robotoMediumFont;
    }
}

#pragma mark - Custom Getter

- (NSNumber *)suggestedHeight {
    return @(78);
}

#pragma mark - IBAction

- (IBAction)creditCardAction:(id)sender {
    self.selectedPayment = kPaymentTypeCreditCard;
    [self showOptionsIndicatorAtPosition:0];
    [self.delegate WBRPaymentOptionsViewDidSelectCreditCard:self];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.bankSlipButtonLabel setAlpha:0.5f];
        [self.bankSlipButtonImageView setImage:[UIImage imageNamed:@"icBankingSlipOff"]];
        [self.creditCardButtonLabel setAlpha:1.0f];
        [self.creditCardButtonImagemView setImage:[UIImage imageNamed:@"icCreditCardOn"]];
        
        [self setSelectedFont];
    }];
}

- (IBAction)bankingSlipAction:(id)sender {
    self.selectedPayment = kPaymentTypeBankingSlip;
    [self showOptionsIndicatorAtPosition:1];
    [self.delegate WBRPaymentOptionsViewDidSelectBankingSlip:self];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.bankSlipButtonLabel setAlpha:1.0f];
        [self.bankSlipButtonImageView setImage:[UIImage imageNamed:@"icBankingSlipOn"]];
        [self.creditCardButtonLabel setAlpha:0.5f];
        [self.creditCardButtonImagemView setImage:[UIImage imageNamed:@"icCreditCardOff"]];
        [self setSelectedFont];
    }];
}

@end
