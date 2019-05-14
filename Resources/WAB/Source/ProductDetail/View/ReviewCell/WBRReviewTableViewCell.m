//
//  WBRReviewTableViewCell.m
//  Walmart
//
//  Created by Cássio Sousa on 06/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRReviewTableViewCell.h"

#import "WBRProductRatingView.h"
#import "UIImageView+WebCache.h"

NSInteger kNameLabelBottomConstraintValue = 14;
NSInteger kSyndicationViewBottomConstraintValue = 20;

NSInteger kReviewEvaluationViewHeightConstraintValue = 59;
float kDisableEvaluationViewAlpha = 0.3;

@interface WBRReviewTableViewCell()

@property (strong, nonatomic) WBRReviewModel *reviewModel;
@property (weak, nonatomic) IBOutlet WBRProductRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *showTextButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *wrapContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *syndicationView;
@property (weak, nonatomic) IBOutlet UIImageView *syndicationImageView;
@property (weak, nonatomic) IBOutlet UILabel *syndicationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *syndicationViewBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showMoreBottomConstraint;

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

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation WBRReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Layout

- (void)resetCellState {
    self.showTextButton.hidden = YES;
    self.commentLabel.text = @"";
    self.titleLabel.text = @"";
    self.textLabel.text = @"";
    
    self.nameLabel.text = @"";
    self.nameLabelBottomConstraint.constant = 0;
}

- (void)showReviewEvaluationView:(BOOL)show {
    
    if (show) {
        self.reviewEvaluationViewHeightConstraint.constant = kReviewEvaluationViewHeightConstraintValue;
    }
    else {
        self.reviewEvaluationViewHeightConstraint.constant = 0;
    }
    
    [self layoutIfNeeded];
}

- (void)resetEvaluationView {
    [self disableFeedbackView:NO withPositiveEvaluation:NO];
}

- (void)disableFeedbackView:(BOOL)disable withPositiveEvaluation:(BOOL)evaluation {
    
    self.thumbDownImageView.image = [UIImage imageNamed:@"thumbDown"];
    self.thumbUpImageView.image = [UIImage imageNamed:@"thumbUp"];
    
    if (disable) {
        self.thumbUpButton.enabled = NO;
        self.thumbDownButton.enabled = NO;
        
        if (evaluation) {
            self.thumbDownView.alpha = kDisableEvaluationViewAlpha;
            self.thumbUpImageView.image = [UIImage imageNamed:@"thumbUpSelected"];
        }
        else {
            self.thumbUpView.alpha = kDisableEvaluationViewAlpha;
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

#pragma mark - Animations

- (void)showLessButton {
    
    [self.showTextButton setTitle:@"Mostrar menos" forState:UIControlStateNormal ];
    
    self.showTextButton.imageEdgeInsets = UIEdgeInsetsMake(0,9, 0, 0);
    
    [self.showTextButton setImage:[UIImage imageNamed:@"icUpArrow"] forState:UIControlStateNormal];
    [self.showTextButton setImage:[UIImage imageNamed:@"icUpArrowPressed"] forState:UIControlStateSelected];
    [self.showTextButton setImage:[UIImage imageNamed:@"icUpArrowPressed"] forState:UIControlStateHighlighted];
    
    [self.showTextButton setTitleColor:RGB(33, 150, 243) forState:UIControlStateNormal];
    [self.showTextButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateSelected];
    [self.showTextButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateHighlighted];
    [self.showTextButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateFocused];
}

- (void)showMoreButton {
    
    [self.showTextButton setTitle:@"Mostrar mais" forState:UIControlStateNormal ] ;
    
    self.showTextButton.imageEdgeInsets = UIEdgeInsetsMake(0,9, 0, 0);
    
    [self.showTextButton setImage:[UIImage imageNamed:@"icDownArrow"] forState:UIControlStateNormal];
    [self.showTextButton setImage:[UIImage imageNamed:@"icDownArrowPressed"] forState:UIControlStateSelected];
    [self.showTextButton setImage:[UIImage imageNamed:@"icDownArrowPressed"] forState:UIControlStateHighlighted];
    
    [self.showTextButton setTitleColor:RGB(33, 150, 243) forState:UIControlStateNormal];
    [self.showTextButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateSelected];
    [self.showTextButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateHighlighted];
    [self.showTextButton setTitleColor:RGB(25, 118, 210) forState:UIControlStateFocused];
}

#pragma mark - IBActions

- (IBAction)displayText:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(updateReviewCell:)]){
        [self.delegate updateReviewCell:[NSNumber numberWithInteger:self.tag]];
    }
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
    
    if ([self.delegate respondsToSelector:@selector(reviewTableViewCellDidEvaluateReview:withEvaluation:)]) {
        [self.delegate reviewTableViewCellDidEvaluateReview:self.currentIndexPath withEvaluation:evaluation];
    }
}

- (NSInteger) lineCount:(NSString *) text{
    CGSize rect = CGSizeMake(self.commentLabel.bounds.size.width, FLT_MAX);
    CGRect labelSize = [text boundingRectWithSize:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.commentLabel.font} context:nil ];
    return ceil(labelSize.size.height / self.commentLabel.font.lineHeight);
}

#pragma mark Setups

- (void)setupReview:(WBRReviewModel *)reviewModel linesShow:(NSNumber *)linesShow forIndexPath:(NSIndexPath *)currentIndexPath {
    
    self.currentIndexPath = currentIndexPath;
    
    self.reviewModel = reviewModel;
    
    [self resetCellState];
    
    [self setClientName:self.reviewModel.client];
    [self setReviewDate:self.reviewModel.reviewDate];
    
    [self setupCommentView:self.reviewModel.text withLinesToShow:linesShow];
    
    self.titleLabel.text = self.reviewModel.title;
    [self.ratingView setRating:self.reviewModel.rating];
    
    [self setupSyndicationViewWithName:self.reviewModel.syndicationName withImageURL:self.reviewModel.logoImageUrl];
    
    [self setReviewEvaluationsWithVoteCount:self.reviewModel.voteCount withVoteRelevant:self.reviewModel.voteRelevant];
    [self setupEvaluationViewWithEvaluation:self.reviewModel.reviewEvaluated];
    
    [self.wrapContentView layoutIfNeeded];
}

- (void)setupSyndicationViewWithName:(NSString *)syndicationName withImageURL:(NSString *)imageURL {
    
    self.syndicationLabel.text = @"";
    self.syndicationImageView.image = nil;
    self.syndicationViewBottomConstraint.constant = 0;
    
    if (syndicationName) {
        [self setupSyndicationName:syndicationName];
        [self.syndicationImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        self.syndicationViewBottomConstraint.constant = kSyndicationViewBottomConstraintValue;
    }
}

- (void)setupSyndicationName:(NSString *)syndicationName {
    
    NSString *visistString = @"Escrito por um cliente enquanto visitava";
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

- (void)setupCommentView:(NSString *)comment withLinesToShow:(NSNumber *)linesToShow {
    
    if(linesToShow){
        [self.commentLabel setNumberOfLines: linesToShow.integerValue];
    }
    self.commentLabel.text = comment;
    
    NSInteger totalLines = [self lineCount:comment];
    if(totalLines > linesToShow.integerValue ){
        self.showTextButton.hidden = NO;
        self.commentLabelBottomConstraint.constant = 40;
    }
    else{
        self.showTextButton.hidden = YES;
        self.commentLabelBottomConstraint.constant = 20;
    }
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

#pragma mark Setters

- (void)setReviewDate:(NSNumber *)reviewDate {
    
    if (reviewDate) {
        NSTimeInterval seconds = reviewDate.doubleValue / 1000;
        NSDate *reviewDate= [[NSDate alloc] initWithTimeIntervalSince1970: seconds];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        self.dateLabel.text = [dateFormat stringFromDate:reviewDate];
    }
}

- (void)setClientName:(WBRReviewClientModel *)client {
    
    if (client) {
        self.nameLabel.text = client.name;
        self.nameLabelBottomConstraint.constant = kNameLabelBottomConstraintValue;
    }
}

- (void)setReviewEvaluationsWithVoteCount:(NSNumber *)voteCount withVoteRelevant:(NSNumber *)voteRelevant {
    
    NSString *positiveEvaluationString = [voteRelevant stringValue];
    NSString *negativeEvaluationString = [[NSNumber numberWithFloat:([voteCount floatValue] - [voteRelevant floatValue])] stringValue];
    
    self.thumbUpNumberLabel.text = [NSString stringWithFormat:@"(%@)", positiveEvaluationString];
    self.thumbDownNumberLabel.text = [NSString stringWithFormat:@"(%@)", negativeEvaluationString];
}

@end

