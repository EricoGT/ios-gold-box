//
//  WBRProductRatingView.m
//  Walmart
//
//  Created by Guilherme Ferreira on 29/06/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#include "WBRProductRatingView.h"

@interface WBRProductRatingView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingFillViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *firstStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthStarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fifthStarImageView;

@property (strong, nonatomic) NSArray *starsImageViewArray;

@end

@implementation WBRProductRatingView

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

- (void)setRating:(NSNumber *)rating {
    
    _rating = rating;
    
    [self updateRatingView];
}

#pragma mark - Private methods

- (void)initSubviews {
    
    UINib *nib = [UINib nibWithNibName:@"WBRProductRatingView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}


/**
 *  Adjusts the screen's constraints according to the value of the rating variable
 */
- (void)updateRatingView {
    
    if ([self.rating isEqual: @(5)]) {
        self.ratingFillViewWidthConstraint.constant = self.frame.size.width;
        return;
    }
    
    NSInteger integerRating = [self.rating intValue];
    self.starsImageViewArray = @[self.firstStarImageView, self.secondStarImageView, self.thirdStarImageView, self.fourthStarImageView, self.fifthStarImageView];
    UIView *star = [self.starsImageViewArray objectAtIndex:integerRating];
    float decimalValueRating = [self.rating floatValue] - integerRating;
    float ratingFillWidth = star.frame.origin.x + decimalValueRating * star.frame.size.width;
    
    self.ratingFillViewWidthConstraint.constant = ratingFillWidth;
}

@end
