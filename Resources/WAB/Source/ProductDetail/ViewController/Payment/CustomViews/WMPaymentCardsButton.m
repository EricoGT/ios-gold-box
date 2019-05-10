//
//  WMPaymentCardsButton.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/15/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WMPaymentCardsButton.h"

@interface WMPaymentCardsButton ()

@end

@implementation WMPaymentCardsButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndImage:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setBorderWidth:2];
        [self.layer setCornerRadius:3];
        [self.layer setBorderColor:[[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1] CGColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image:(NSString*)imageName paymentType:(PaymentType *)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.paymentType = type;
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setBorderWidth:2];
        [self.layer setCornerRadius:3];
        [self.layer setBorderColor:[[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1] CGColor]];
    }
    return self;
}

-(void)setSelected:(BOOL)selected {
    
    LogInfo(@"selected %i", selected);
    
    [super setSelected:selected];
    
    if (selected) {
        [self.layer setBorderColor:[[UIColor colorWithRed:26/255.0f green:117/255.0f blue:207/255.0f alpha:1] CGColor]];
    } else {
        [self.layer setBorderColor:[[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1] CGColor]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
