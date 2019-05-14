//
//  CardCreditResume.m
//  Walmart
//
//  Created by Marcelo Santos on 3/13/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "CardCreditResume.h"
#import "CardCreditCard.h"
#import "OFSetupCustomCheckout.h"

@interface CardCreditResume ()

@property (nonatomic, strong) CardCreditCard *ccard;
@property (weak) IBOutlet UILabel *lblPaymentDescription;
@property int initialPosition;

@end

@implementation CardCreditResume

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self formatView:self.view];
    
    _lblPaymentDescription.font = [UIFont fontWithName:fontSemiBold size:sizeFont15];
    
    self.initialPosition = 45;
}

- (void) configurePaymentInfoCells:(NSArray *) infoPayments {
    
    LogInfo(@"Info Payments: %@", infoPayments);
    
    int lastHeightCardProducts = 0;
    
    for (int i=0;i<(int) [infoPayments count];i++) {
        
        self.ccard = [[CardCreditCard alloc] initWithNibName:@"CardCreditCard" bundle:nil];
        _ccard.view.frame = CGRectMake(0, _initialPosition, _ccard.view.frame.size.width, _ccard.view.frame.size.height);
        [_ccard fillContentWithDictionary:[infoPayments objectAtIndex:i] andCard:i+1];
        [self.view addSubview:_ccard.view];
        
        lastHeightCardProducts = lastHeightCardProducts + _ccard.view.frame.size.height;
        self.initialPosition = _initialPosition + _ccard.view.frame.size.height;
    }
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, _initialPosition);
}

- (void) formatView:(UIView *) viewToRounded {
    
    viewToRounded.layer.masksToBounds = YES;
    viewToRounded.layer.borderWidth = 1.0f;
    viewToRounded.layer.cornerRadius = 3.0f;
    viewToRounded.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
}

@end