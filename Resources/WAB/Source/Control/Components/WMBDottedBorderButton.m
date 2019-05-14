//
//  WMBDottedBorderButton.m
//  Walmart
//
//  Created by Rafael Valim on 03/07/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBDottedBorderButton.h"

@interface WMBDottedBorderButton ()

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation WMBDottedBorderButton

#pragma mark - View Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.cornerRadius = self.cornerRadius;
    
    self.borderLayer.strokeColor = self.borderColor.CGColor;
    self.borderLayer.fillColor = nil;
    self.borderLayer.lineDashPattern = @[[NSNumber numberWithInteger:self.paintedSize],
                                         [NSNumber numberWithInteger:self.notPaintedSize]];
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius].CGPath;
    self.borderLayer.frame = self.bounds;
}

#pragma mark - Private Methods

- (void)baseInit {
    self.borderLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.borderLayer];
}


@end
