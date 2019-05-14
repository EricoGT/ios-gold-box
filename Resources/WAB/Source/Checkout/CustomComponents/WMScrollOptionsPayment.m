//
//  WMScrollOptionsPayment.m
//  Walmart
//
//  Created by Marcelo Santos on 6/18/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMScrollOptionsPayment.h"

@interface WMScrollOptionsPayment ()

@property (weak, nonatomic) IBOutlet UILabel *lblCreditCard;
@property (weak, nonatomic) IBOutlet UILabel *lblBankingTicket;
@property (weak, nonatomic) IBOutlet UIView *barCards;
@property (weak, nonatomic) IBOutlet UIView *barBankingTicket;
@property (weak, nonatomic) IBOutlet UIButton *btCredit;
@property (weak, nonatomic) IBOutlet UIButton *btTicket;

- (IBAction)moveToCreditCards:(id)sender;
- (IBAction)moveToBankingTicket:(id)sender;

@end

@implementation WMScrollOptionsPayment

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _barBankingTicket.hidden = YES;
    
    if (![OFSetup showBankingTicket]) {
        [self disableBankingOption];
    }
}

- (void) disableBankingOption {
    
    _lblBankingTicket.hidden = YES;
    _barBankingTicket.hidden = YES;
    _btTicket.hidden = YES;
    _btCredit.hidden = YES;
    
    float posXLabel = (self.view.frame.size.width - _lblCreditCard.frame.size.width) / 2;
    
    _lblCreditCard.frame = CGRectMake(posXLabel-5, _lblCreditCard.frame.origin.y, _lblCreditCard.frame.size.width, _lblCreditCard.frame.size.height);
    
    float posXBar = (self.view.frame.size.width - _barCards.frame.size.width) / 2;
    
    _barCards.frame = CGRectMake(posXBar-12, _barCards.frame.origin.y, _barCards.frame.size.width, _barCards.frame.size.height);
}

- (void) disableBankingOptionInDouble {
    
    _lblBankingTicket.hidden = YES;
    _barBankingTicket.hidden = YES;
    _btTicket.hidden = YES;
    _btCredit.hidden = YES;
    
    float posXLabel = (self.view.frame.size.width - _lblCreditCard.frame.size.width) / 2;
    
    _lblCreditCard.frame = CGRectMake(posXLabel-5, _lblCreditCard.frame.origin.y, _lblCreditCard.frame.size.width, _lblCreditCard.frame.size.height);
    
    float posXBar = (self.view.frame.size.width - _barCards.frame.size.width) / 2;
    
    _barCards.frame = CGRectMake(posXBar-5, _barCards.frame.origin.y, _barCards.frame.size.width, _barCards.frame.size.height);
}

- (void)moveToCreditCards:(id)sender {
    
    self.isAlreadyTicket = NO;
    
    if (!_isAlreadyCards) {
        [self moveBarToCards];
        self.isAlreadyCards = YES;
    }
}

- (void)moveToBankingTicket:(id)sender {
    
    self.isAlreadyCards = NO;
    
    if (!_isAlreadyTicket) {
        
        [self moveBarToBankingSlip];
        self.isAlreadyTicket = YES;
    }
}

- (void) moveBarToCardsWhenError {
    
    self.isAlreadyCards = YES;
    self.isAlreadyTicket = NO;
    
    _barCards.frame = CGRectMake(15, 40, 125, 5);
    [self changeColorCards];
}


- (void) moveBarToCards {
    
    _barCards.frame = CGRectMake(165, 40, 110, 5);
    
    [UIView animateWithDuration:.3 animations:^{
        self->_barCards.frame = CGRectMake(15, 40, 125, 5);
        [[self delegate] goCreditCards];
        [self changeColorCards];
    } completion:nil];
}


- (void) moveBarToBankingSlip {
    
    _barCards.frame = CGRectMake(15, 40, 125, 5);
    
    [UIView animateWithDuration:.3 animations:^{
        self->_barCards.frame = CGRectMake(165, 40, 110, 5);
        [[self delegate] goBankingTicket];
        [self changeColorBankingTicket];
    } completion:nil];

}

- (void) changeColorBankingTicket
{
    _lblBankingTicket.textColor = RGBA(26, 117, 207, 1);
    _lblCreditCard.textColor = RGBA(145, 150, 152, 1);
    _barCards.backgroundColor = RGBA(26, 117, 207, 1);
}

- (void) changeColorCards
{
    _lblBankingTicket.textColor = RGBA(145, 150, 152, 1);
    _lblCreditCard.textColor = RGBA(26, 117, 207, 1);
    _barCards.backgroundColor = RGBA(26, 117, 207, 1);
}

@end
