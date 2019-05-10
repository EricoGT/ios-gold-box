//
//  WBRCompleteRatingView.m
//  Walmart
//
//  Created by Guilherme Ferreira on 29/06/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCompleteRatingView.h"

#import "WBRProductRatingView.h"

@interface WBRCompleteRatingView() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet WBRProductRatingView *ratingView;

-(IBAction)navigateToReview:(UITapGestureRecognizer *)sender;
-(void)evaluationLabelDefaultColor;
-(void)evaluationLabelDefaultColorPressed;

@end

@implementation WBRCompleteRatingView

#pragma mark - View lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    
    UINib *nib = [UINib nibWithNibName:@"WBRCompleteRatingView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

#pragma mark - Private methods


/**
 *  Formats the string according to the number of items (1 or more than 1)
 *
 *  @param numberOfRatings Number of reviews for the product
 *  @return Formatted string according to the number of reviews
 */
- (NSString *)evaluationStringWithNumberOfRatings:(NSNumber *)numberOfRatings {
    
    if (_onlyRatingScore ==  YES){
        NSString *ratingTotalString = [NSString stringWithFormat:@"%ld", numberOfRatings.longValue];
        return ratingTotalString;
    }else{
        NSString *evaluation = numberOfRatings.integerValue == 1 ? @"avaliação" : @"avaliações";
        NSString *completeString = [NSString stringWithFormat:@"%ld %@", numberOfRatings.longValue, evaluation];
        return completeString;
    }
}

#pragma mark - Custom setter

/**
 *  Custom setter that hides the view if there is no displayable value
 *
 *  @param rating Rating variable
 */
- (void)setRating:(WBRRatingModel *)rating {
    
    _rating = rating;
    self.ratingView.rating = rating.ratingValue;
    if([self.rating.totalOfRatings isEqual:@(0)]){
        self.evaluationLabel.hidden = YES;
        self.ratingView.hidden = YES;
    }else{
        self.evaluationLabel.hidden = NO;
        self.ratingView.hidden = NO;
        self.evaluationLabel.text = [self evaluationStringWithNumberOfRatings:rating.totalOfRatings];
    }
    
    [self evaluationLabelDefaultColor];
}

/**
 * Show only total_of_ratin in label
 *
 * @param YES to show only total number
 */
- (void)setOnlyRatingScore:(BOOL)onlyRatingScore{
    _onlyRatingScore = onlyRatingScore;
}

-(void)navigateToReview:(UITapGestureRecognizer *)sender{
    if([self.delegate respondsToSelector: @selector(navigateToReview)] && self.isRatingActionEnabled){
        [self.delegate navigateToReview];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self evaluationLabelDefaultColorPressed];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self evaluationLabelDefaultColor];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self evaluationLabelDefaultColor];
}

-(void)evaluationLabelDefaultColorPressed{
    if(!self.evaluationLabel.hidden &&
       self.isRatingActionEnabled &&
       [self.rating.totalOfRatings compare:@(0)] > 0){
        
        self.evaluationLabel.textColor = RGB(25, 118, 210);
    }
}

/**
 * set default color evaluation label
 */
-(void)evaluationLabelDefaultColor{
    if(!self.evaluationLabel.hidden &&
       self.isRatingActionEnabled &&
       [self.rating.totalOfRatings compare:@(0)] > 0){
        
        self.evaluationLabel.textColor = RGB(33, 150, 243);
    }
}
@end
