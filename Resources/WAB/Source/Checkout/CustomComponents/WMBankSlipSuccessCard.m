//
//  WMBankSlipSuccessCard.m
//  Walmart
//
//  Created by Marcelo Santos on 6/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBankSlipSuccessCard.h"
#import "OFSetupCustomCheckout.h"
#import "WMButton.h"

@interface WMBankSlipSuccessCard ()

@property (weak, nonatomic) IBOutlet UILabel *lblPaymentForms;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet WMButton *btSendToMail;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp;
@property BOOL blockBankButton;
@property BOOL blockSendMail;

@end

@implementation WMBankSlipSuccessCard

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lblPaymentForms.font = [UIFont fontWithName:fontSemiBold size:sizeFont15];
    _lblPaymentDesc.font = [UIFont fontWithName:fontSemiBold size:sizeFont14];
    _lblValue.font = [UIFont fontWithName:fontSemiBold size:sizeFont14];
    _lblHelp.font = [UIFont fontWithName:fontSemiBold size:sizeFont12];
    
    [_btSendToMail setup];
    [[self delegate] updateSuccessBankingValue];
}

- (void) fillValue:(float) valueLabel {
    
    valueLabel = valueLabel/100;
    
    NSString *strCurrency = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:valueLabel]];
    
    _lblValue.text = strCurrency;
}


//Currency
- (NSString *) currencyFormat:(float) value {
    
    NSNumber *amount = [[NSNumber alloc] initWithFloat:value];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"R$"];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *newFormat = [numberFormatter stringFromNumber:amount];
    
    LogInfo(@"Number: %@", newFormat);
    
    //Remove currency symbol
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"R$" withString:@""];
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    return newFormat;
}

- (void) getBankSlip:(id)sender {
    
    if (!_blockBankButton) {
        
        self.blockBankButton = YES;
        
        [[self delegate] getBankingSlip];
        
        [self performSelector:@selector(unblockButton) withObject:nil afterDelay:1.0];
    }
}

- (void) unblockButton {
    
    self.blockBankButton = NO;
    self.blockSendMail = NO;
}

- (void) sendMailToUser:(id)sender {
    
    if (!_blockSendMail) {
        
        self.blockSendMail = YES;
        
        [[self delegate] sendMailToUser];
        
        [self performSelector:@selector(unblockButton) withObject:nil afterDelay:3.0];
    }
}

@end
