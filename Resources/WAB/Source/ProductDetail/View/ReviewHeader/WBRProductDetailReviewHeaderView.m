//
//  WBRProductDetailReviewHeader.m
//  Walmart
//
//  Created by Cássio Sousa on 06/11/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRProductDetailReviewHeaderView.h"
#import "WBRProductRatingView.h"
#import "OFFormatter.h"

@interface WBRProductDetailReviewHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet WBRProductRatingView *ratingView;

@end

@implementation WBRProductDetailReviewHeaderView

-(void)setupReview:(NSNumber *)average total:(NSNumber *)total{
    
    if([total compare:@(1)] == 0){
        self.reviewLabel.text = @"Avaliação";
    }
    
    //define formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setCurrencyCode:@""];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimum:0];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.ratingView.rating = average;

    if (total.intValue == 0){
        self.ratingView.hidden = YES;
    }else{
        self.ratingView.hidden = NO;
    }
    
    self.averageLabel.text = [formatter stringFromNumber:average];
    self.totalLabel.text = total.stringValue;
}

@end
