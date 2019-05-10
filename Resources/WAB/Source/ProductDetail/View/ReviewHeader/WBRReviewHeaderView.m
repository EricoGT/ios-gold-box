//
//  WBRReviewHeaderView.m
//  Walmart
//
//  Created by Cássio Sousa on 05/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRReviewHeaderView.h"
#import "OFFormatter.h"
#import "WBRProductRatingView.h"

@interface WBRReviewHeaderView()
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *outScoreView;
@property (weak, nonatomic) IBOutlet UIView *innerViewScore;
@property (weak, nonatomic) IBOutlet UILabel *totalRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet WBRProductRatingView *ratingView;

@end

@implementation WBRReviewHeaderView

- (void)setRating:(NSNumber *)totalRating average:(NSNumber *)average {
    [self setupLayout:totalRating average:average];
}

- (void)setupLayout:(NSNumber *)totalRating average:(NSNumber *)average{
    
    self.outScoreView.layer.cornerRadius = self.outScoreView.frame.size.width / 2;
    self.outScoreView.layer.borderWidth = 2;
    self.outScoreView.layer.borderColor = RGB(122, 192, 248).CGColor;
    
    self.innerViewScore.layer.cornerRadius = self.innerViewScore.frame.size.width / 2;
    self.innerViewScore.layer.borderWidth = 2;
    self.innerViewScore.layer.borderColor = RGB(255, 255, 255).CGColor;
    //define shadow on score label
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setCurrencyCode:@""];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimum:0];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *averageString = [formatter stringFromNumber:average];
    
    //format average label shadow
    NSMutableAttributedString * mutableAttrStr = [[NSMutableAttributedString alloc] initWithString:averageString];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = RGBA(0, 0, 0,0.2f);
    shadow.shadowBlurRadius = 0;
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    NSDictionary *shadowDictionary = @{NSShadowAttributeName:shadow};
    [mutableAttrStr setAttributes:shadowDictionary range:NSMakeRange(0,averageString.length)];
    self.averageLabel.attributedText = mutableAttrStr;
   
    NSString *evalutionString = totalRating.intValue == 1 ? @"avaliação": @"avaliações";
    self.totalRatingLabel.text = [NSString stringWithFormat:@"%i %@", [totalRating  intValue], evalutionString];
    
    [self.ratingView setRating:average];
    
}

@end
