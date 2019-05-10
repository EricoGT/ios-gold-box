//
//  FreightView.m
//  Walmart
//
//  Created by Accurate Rio Preto on 06/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRFreightView.h"

@interface WBRFreightView ()
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation WBRFreightView

- (WBRFreightView *)initWithDelegate:(id<WBRFreightViewDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.buttonView.layer.borderColor = RGBA(221, 221, 221, 1).CGColor;
    self.buttonView.layer.borderWidth = 1.0f;
    self.buttonView.layer.cornerRadius = 4.0f;
}

- (IBAction)pressedCalculateFreight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(productOptionsPressedCalculateFreight)]) {
        [self.delegate productOptionsPressedCalculateFreight];
    }
}

@end
