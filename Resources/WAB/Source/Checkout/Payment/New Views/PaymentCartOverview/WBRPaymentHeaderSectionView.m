//
//  WBRPaymentHeaderSectionView.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 19/09/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentHeaderSectionView.h"

@implementation WBRPaymentHeaderSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void) setupView {
    UIView *view = [self viewFromNibForClass];
    view.frame = self.bounds;
    
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:view];
}

- (UIView *)viewFromNibForClass{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WBRPaymentHeaderSectionView" owner:self options:nil] firstObject];
}

- (IBAction)changeButtonPressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(changeButtonTouched)])
    [self.delegate changeButtonTouched];
}

@end
