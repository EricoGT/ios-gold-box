//
//  MultipleDeliveriesBlock.m
//  Walmart
//
//  Created by Bruno Delgado on 5/4/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "MultipleDeliveriesBlock.h"

@interface MultipleDeliveriesBlock ()

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@end

@implementation MultipleDeliveriesBlock

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    self.contentView.layer.borderColor = RGBA(207, 233, 197, 1).CGColor;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.cornerRadius = 0;
}

- (void)setNumberOfDeliveries:(NSInteger)deliveries
{
    self.messageLabel.text = [NSString stringWithFormat:@"Separamos o seu pedido em %ld entregas. Assim os produtos que estão mais próximos do endereço de entrega chegarão primeiro ;)", (long)deliveries];
}

@end
