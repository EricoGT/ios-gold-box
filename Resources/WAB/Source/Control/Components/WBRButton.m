//
//  WBRButton.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 01/02/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRButton.h"

@implementation WBRButton

#define BACKGROUND_COLOR RGB(33, 150, 243)
#define BACKGROUND_COLOR_HIGHLIGHTED RGB(20, 120, 200)

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    LogInfo(@"self.titleLabel.font: %@", self.titleLabel.font );
    if(self.titleLabel.font == nil){
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
    }
    self.exclusiveTouch = YES;
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    [self buttonTouchedColor:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self buttonTouchedColor:selected];
   
}

- (void)buttonTouchedColor:(BOOL)isTouched {
    
    if (self.selected || self.highlighted) {
        self.backgroundColor = BACKGROUND_COLOR_HIGHLIGHTED;
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        
    } else {
        self.backgroundColor = BACKGROUND_COLOR;
        [self.titleLabel setTextColor:[UIColor whiteColor]];
    }
}

@end
