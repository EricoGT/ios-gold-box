//
//  WBRProductDetailReviewCell.m
//  Walmart
//
//  Created by Cássio Sousa on 07/11/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRProductDetailReviewCell.h"
#import "WBRProductRatingView.h"

NSInteger kSyndicationBottomConstraintValue = 10;
NSInteger kSyndicationTopConstraintValue = 20;
NSInteger kReviewEvaluationViewHeightValue = 59;
float kDisabledEvaluationViewAlpha = 0.3;

@interface WBRProductDetailReviewCell ()

@property (strong, nonatomic) WBRReviewModel *reviewModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WBRProductRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;

@property (weak, nonatomic) IBOutlet UIView *syndicationView;
@property (weak, nonatomic) IBOutlet UIImageView *syndicationImageView;
@property (weak, nonatomic) IBOutlet UILabel *syndicationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *syndicationViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *syndicationViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *reviewEvaluationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewEvaluationViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *thumbUpView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbUpImageView;
@property (weak, nonatomic) IBOutlet UILabel *thumbUpNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbUpButton;

@property (weak, nonatomic) IBOutlet UIView *thumbDownView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbDownImageView;
@property (weak, nonatomic) IBOutlet UILabel *thumbDownNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbDownButton;

@property (weak, nonatomic) IBOutlet UIView *separator;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation WBRProductDetailReviewCell

#pragma mark - Setup

- (void)setupCell:(WBRReviewModel *)reviewModel forIndexPath:(NSIndexPath *)currentIndexPath {
    
    self.reviewModel = reviewModel;
    self.currentIndexPath = currentIndexPath;
    
    self.ratingView.rating = self.reviewModel.rating;
    self.titleLabel.text = self.reviewModel.title;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.commentLabel.text = self.reviewModel.text;
    }];
    
    [self setReviewDate:self.reviewModel.reviewDate];
    [self showShowMoreButtonDueToTextComment:self.reviewModel.text];
    [self setupSyndicationViewWithName:self.reviewModel.syndicationName withImageURL:self.reviewModel.logoImageUrl];
    [self setReviewEvaluationsWithVoteCount:self.reviewModel.voteCount withVoteRelevant:self.reviewModel.voteRelevant];
    [self setupEvaluationViewWithEvaluation:self.reviewModel.reviewEvaluated];
    
    [self layoutIfNeeded];
}

- (void)setupSyndicationViewWithName:(NSString *)syndicationName withImageURL:(NSString *)imageURL {
    
    self.syndicationLabel.text = @"";
    self.syndicationImageView.image = nil;
    self.syndicationViewBottomConstraint.constant = 0;
    
    if (syndicationName) {
        [self setupSyndicationName:syndicationName];
        [self.syndicationImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        self.syndicationViewBottomConstraint.constant = kSyndicationBottomConstraintValue;
    }
    
    [self layoutIfNeeded];
}

- (void)setReviewEvaluationsWithVoteCount:(NSNumber *)voteCount withVoteRelevant:(NSNumber *)voteRelevant {
    
    NSString *positiveEvaluationString = [voteRelevant stringValue];
    NSString *negativeEvaluationString = [[NSNumber numberWithFloat:([voteCount floatValue] - [voteRelevant floatValue])] stringValue];
    
    self.thumbUpNumberLabel.text = [NSString stringWithFormat:@"(%@)", positiveEvaluationString];
    self.thumbDownNumberLabel.text = [NSString stringWithFormat:@"(%@)", negativeEvaluationString];
}

- (void)setupEvaluationViewWithEvaluation:(kReviewEvaluated)evaluation {
    
    switch (evaluation) {
        case kReviewEvaluatedNoEvaluation:
            [self disableFeedbackView:NO withPositiveEvaluation:NO];
            break;
        case kReviewEvaluatedNegativeEvaluation:
            [self disableFeedbackView:YES withPositiveEvaluation:NO];
            break;
        case kReviewEvaluatedPositiveEvaluation:
            [self disableFeedbackView:YES withPositiveEvaluation:YES];
            break;
    }
}

#pragma mark - Layout methods

- (void)hideSeparator {
    self.separator.hidden = YES;
}

- (void)setupSyndicationName:(NSString *)syndicationName {
    
    NSString *visistString = @"Escrito por um cliente enquanto visitava ";
    NSString *syndicationString = [NSString stringWithFormat:@"%@ %@", visistString, syndicationName];
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:syndicationString];
    [mutableString addAttribute:NSForegroundColorAttributeName
                          value:RGB(153, 153, 153)
                          range:[syndicationString rangeOfString:visistString]];
    [mutableString addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"Roboto-Regular" size:12.0f]
                          range:[syndicationString rangeOfString:visistString]];
    [mutableString addAttribute:NSForegroundColorAttributeName
                          value:RGB(102, 102, 102)
                          range:[syndicationString rangeOfString:syndicationName]];
    self.syndicationLabel.attributedText = mutableString;
}

- (void)showReviewEvaluationView:(BOOL)show {
    
    if (show) {
        self.reviewEvaluationViewHeightConstraint.constant = kReviewEvaluationViewHeightValue;
    }
    else {
        self.reviewEvaluationViewHeightConstraint.constant = 0;
    }
    
    [self layoutIfNeeded];
}

- (void)disableFeedbackView:(BOOL)disable withPositiveEvaluation:(BOOL)evaluation {
    
    if (disable) {
        self.thumbUpButton.enabled = NO;
        self.thumbDownButton.enabled = NO;
        
        if (evaluation) {
            self.thumbDownView.alpha = kDisabledEvaluationViewAlpha;
            self.thumbUpImageView.image = [UIImage imageNamed:@"thumbUpSelected"];
        }
        else {
            self.thumbUpView.alpha = kDisabledEvaluationViewAlpha;
            self.thumbDownImageView.image = [UIImage imageNamed:@"thumbDownSelected"];
        }
    }
    else {
        self.thumbUpButton.enabled = YES;
        self.thumbUpImageView.image = [UIImage imageNamed:@"thumbUp"];
        self.thumbDownButton.enabled = YES;
        self.thumbDownImageView.image = [UIImage imageNamed:@"thumbDown"];
        
        self.thumbUpView.alpha = 1.0;
        self.thumbDownView.alpha = 1.0;
    }
}

#pragma mark - IBAction

- (IBAction)toggleShowMoreButton:(id)sender {
    
    if (self.commentLabel.numberOfLines == 0) {
        self.commentLabel.numberOfLines = 3;
        [self showMoreButtonAction];
    }
    else {
        self.commentLabel.numberOfLines = 0;
        [self showLessButton];
    }
    
    [self layoutIfNeeded];
    
    [self.delegate updateCellAtIndexPath:self.currentIndexPath];
}

- (IBAction)didEvaluateReviewLike:(id)sender {
    [self disableFeedbackView:YES withPositiveEvaluation:YES];
    [self reviewEvaluation:YES];
}

- (IBAction)didEvaluateReviewUnlike:(id)sender {
    [self disableFeedbackView:YES withPositiveEvaluation:NO];
    [self reviewEvaluation:NO];
}

#pragma mark - Privates

- (void)reviewEvaluation:(BOOL)evaluation {
    
    if ([self.delegate respondsToSelector:@selector(productDetailReviewCellDidEvaluateReviewIndexPath:withEvaluation:)]) {
        [self.delegate productDetailReviewCellDidEvaluateReviewIndexPath:self.currentIndexPath withEvaluation:evaluation];
    }
}


- (void)setReviewDate:(NSNumber *)reviewDate {
    
    if (reviewDate) {
        NSTimeInterval seconds = reviewDate.doubleValue / 1000;
        NSDate *reviewDate= [[NSDate alloc] initWithTimeIntervalSince1970: seconds];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        self.dateLabel.text = [dateFormat stringFromDate:reviewDate];
    }
}

- (void)showLessButton {
    
    [self.showMoreButton setTitle:@"Mostrar menos" forState:UIControlStateNormal ];
    
    self.showMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 0);
    
    [self.showMoreButton setImage:[UIImage imageNamed:@"icUpArrow"] forState:UIControlStateNormal];
    [self.showMoreButton setImage:[UIImage imageNamed:@"icUpArrowPressed"] forState:UIControlStateSelected];
    [self.showMoreButton setImage:[UIImage imageNamed:@"icUpArrowPressed"] forState:UIControlStateHighlighted];
    
    [self.showMoreButton setTitleColor:RGB(33, 150, 243) forState:UIControlStateNormal];
    [self.showMoreButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateSelected];
    [self.showMoreButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateHighlighted];
    [self.showMoreButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateFocused];
}

- (void)showMoreButtonAction {
    
    [self.showMoreButton setTitle:@"Mostrar mais" forState:UIControlStateNormal ] ;
    
    self.showMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 0);
    
    [self.showMoreButton setImage:[UIImage imageNamed:@"icDownArrow"] forState:UIControlStateNormal];
    [self.showMoreButton setImage:[UIImage imageNamed:@"icDownArrowPressed"] forState:UIControlStateSelected];
    [self.showMoreButton setImage:[UIImage imageNamed:@"icDownArrowPressed"] forState:UIControlStateHighlighted];
    
    [self.showMoreButton setTitleColor:RGB(33, 150, 243) forState:UIControlStateNormal];
    [self.showMoreButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateSelected];
    [self.showMoreButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateHighlighted];
    [self.showMoreButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateFocused];
}

- (void)showShowMoreButtonDueToTextComment:(NSString *)comment {
    
    NSInteger totalLines = [self lineCount:comment];
    if(totalLines > 3 ){
        self.showMoreButton.hidden = NO;
        self.syndicationViewTopConstraint.constant = kSyndicationTopConstraintValue;
    }
    else{
        self.showMoreButton.hidden = YES;
        self.syndicationViewTopConstraint.constant = 0;
    }
    
    [self layoutIfNeeded];
}

- (NSInteger) lineCount:(NSString *) text{
    CGSize rect = CGSizeMake(self.commentLabel.bounds.size.width, FLT_MAX);
    CGRect labelSize = [text boundingRectWithSize:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.commentLabel.font} context:nil ];
    return ceil(labelSize.size.height / self.commentLabel.font.lineHeight);
}

@end
