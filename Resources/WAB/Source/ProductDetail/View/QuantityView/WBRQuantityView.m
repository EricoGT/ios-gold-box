//
//  WBRQuantityView.m
//  Walmart
//
//  Created by Cássio Sousa on 19/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRQuantityView.h"
#import "WBRStepper.h"

@interface WBRQuantityView()

@property (weak, nonatomic) IBOutlet WBRStepper *stepper;

@end

@implementation WBRQuantityView

- (NSUInteger)quantity {
    return self.stepper.stepValue;
}

@end
