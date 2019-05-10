//
//  CardCreditCard.m
//  Walmart
//
//  Created by Marcelo Santos on 3/13/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "CardCreditCard.h"
#import "OFSetupCustomCheckout.h"

@interface CardCreditCard ()

@property (weak) IBOutlet UILabel *lblCard;
@property (weak) IBOutlet UILabel *lblCardInstallments;
@property (weak) IBOutlet UIImageView *imgCard;

@end

@implementation CardCreditCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) fillContentWithDictionary:(NSDictionary *) dictContent andCard:(int) cardNb {
    
    LogInfo(@"Content Payment: %@", dictContent);
    
    _lblCard.font = [UIFont fontWithName:fontDefault size:sizeFont13];
    _lblCardInstallments.font = [UIFont fontWithName:fontDefault size:sizeFont13];
    
    NSString *nameOwner = [dictContent objectForKey:@"cardHolder"];
    NSString *cardNumber = [dictContent objectForKey:@"creditCardNumber"];
    
    cardNumber = [cardNumber  stringByReplacingOccurrencesOfString:@"." withString:@""];
    cardNumber = [cardNumber  stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cardNumber = [cardNumber  stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *strLastFourDigitCard = [cardNumber substringFromIndex:[cardNumber length] - 4];
    NSString *strObsfucated = @"";
    
    for (int k=0; k<[cardNumber length]-4; k++)
    {
        strObsfucated = [strObsfucated stringByAppendingString:@"*"];
    }
    
    cardNumber = [NSString stringWithFormat:@"%@ %@", strObsfucated, strLastFourDigitCard];
    
    NSString *installmentsChoosed = [dictContent objectForKey:@"installmentsChoosed"];
    
    if ([[dictContent objectForKey:@"hasInterestToOrder"] boolValue]) {
        
        NSString *strTtProd = [[NSUserDefaults standardUserDefaults] stringForKey:@"priceWithRate1"];
  
       if (cardNb == 1) {
            
            strTtProd = [NSString stringWithFormat:@"Valor total de R$ %@", strTtProd];
            
            installmentsChoosed = [NSString stringWithFormat:@"%@\n%@*", installmentsChoosed, strTtProd];
        }
        else {
            
            strTtProd = [[NSUserDefaults standardUserDefaults] stringForKey:@"priceWithRate2"];
            
            strTtProd = [NSString stringWithFormat:@"Valor total de R$ %@", strTtProd];
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isUniqueInterest"]) {
                
                installmentsChoosed = [NSString stringWithFormat:@"%@\n%@*", installmentsChoosed, strTtProd];
                
            } else {
                
                installmentsChoosed = [NSString stringWithFormat:@"%@\n%@**", installmentsChoosed, strTtProd];
            }
        }
    }
    
    _lblCard.text = [NSString stringWithFormat:@"%@\n%@", nameOwner, cardNumber];
    _lblCardInstallments.text = installmentsChoosed;
    
    //Image
    NSString *flagCard = [[dictContent objectForKey:@"paymentTypeName"] capitalizedString];
    if ([flagCard isEqualToString:@"Master"]) {
        flagCard = @"Mastercard";
    }
    NSString *nameImgCardNormal = [NSString stringWithFormat:@"UIProductDetailCard%@.png", flagCard];
    
    UIImage *imgCardNormal = [UIImage imageNamed:nameImgCardNormal];
    _imgCard.image = imgCardNormal;
    
    if ([flagCard isEqualToString:@"Hiper"]) {
        _lblCard.frame = CGRectMake(_lblCard.frame.origin.x+45, _lblCard.frame.origin.y, _lblCard.frame.size.width-45, _lblCard.frame.size.height);
    }
    
    float heightLbl = [self heightFromLabel:_lblCard];
    float heightLbl2 = [self heightFromLabel:_lblCardInstallments];
    
    //Specially for Hipercard credit card
    if ([flagCard isEqualToString:@"Hiper"]) {
        _imgCard.frame = CGRectMake(15, _imgCard.frame.origin.y, 92, _imgCard.frame.size.height);
    } else {
        _imgCard.frame = CGRectMake(15, _imgCard.frame.origin.y, _imgCard.frame.size.width, _imgCard.frame.size.height);
    }
    
    _lblCard.frame = CGRectMake(_lblCard.frame.origin.x, _lblCard.frame.origin.y, _lblCard.frame.size.width, heightLbl);
    
     _lblCardInstallments.frame = CGRectMake(15, _lblCard.frame.origin.y+_lblCard.frame.size.height+5, self.view.frame.size.width-30, heightLbl2);
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, heightLbl+heightLbl2+20);
}

//Currency
- (NSString *) currencyFormat:(float) value
{
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

- (float)heightFromLabel:(UILabel *) label
{
    CGSize maxSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    CGSize labelSize = [label.text sizeForTextWithFont:label.font constrainedToSize:maxSize];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, labelSize.height);
    return label.frame.size.height;
}

@end