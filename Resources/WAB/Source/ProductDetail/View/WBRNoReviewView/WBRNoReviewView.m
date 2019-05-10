//
//  WBRNoReviewView.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/31/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRNoReviewView.h"

@implementation WBRNoReviewView

#pragma mark - IBAction

- (IBAction)didSelectEvaluateProduct:(id)sender {
    if (self.delegate) {
        [self.delegate WBRNoReviewViewDidSelectEvaluateProduct];
    }
}

@end
