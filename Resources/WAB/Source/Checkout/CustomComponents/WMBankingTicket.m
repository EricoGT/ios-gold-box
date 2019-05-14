//
//  WMBankingTicket.m
//  Walmart
//
//  Created by Marcelo Santos on 6/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBankingTicket.h"
#import "OFSetupCustomCheckout.h"

@interface WMBankingTicket ()
@property (weak, nonatomic) IBOutlet UILabel *lblPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UIImageView *imgBankSlip;
@property (weak, nonatomic) IBOutlet UITextView *warningTextView;

@end

@implementation WMBankingTicket

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    _lblPayment.font = [UIFont fontWithName:fontDefault size:sizeFont14];
    _lblValue.font = [UIFont fontWithName:fontDefault size:sizeFont14];

    //_lblPayment.frame = CGRectMake(_imgBankSlip.frame.origin.x+_imgBankSlip.frame.size.width+25, _lblPayment.frame.origin.y, _lblPayment.frame.size.width, _lblPayment.frame.size.height);
    //_lblValue.frame = CGRectMake(_imgBankSlip.frame.origin.x+_imgBankSlip.frame.size.width+25, _lblValue.frame.origin.y, _lblValue.frame.size.width, _lblValue.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)feedContentLabels:(NSDictionary *) dictContent
{
    _lblPayment.text = [dictContent objectForKey:@"paymentDesc"];
    _lblValue.text = [dictContent objectForKey:@"valueDesc"];
}

- (IBAction)finishOrder
{
    if ([self.delegate respondsToSelector:@selector(finishOrderWithBankingTicket)])
    {
        [self.delegate finishOrderWithBankingTicket];
    }
}

- (CGFloat)containerHeight
{
    CGSize textViewSize = [self.warningTextView sizeThatFits:CGSizeMake(self.warningTextView.frame.size.width, CGFLOAT_MAX)];

    CGRect frame = _warningTextView.frame;
    frame.size.height = textViewSize.height;
    _warningTextView.frame = frame;

    return _warningTextView.frame.origin.y + _warningTextView.frame.size.height;
}

@end
