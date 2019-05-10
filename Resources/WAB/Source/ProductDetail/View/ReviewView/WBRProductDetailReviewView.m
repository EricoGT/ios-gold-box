//
//  WBRProductDetailReviewView.m
//  Walmart
//
//  Created by Cássio Sousa on 06/11/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRProductDetailReviewView.h"
#import "WBRProductDetailReviewHeaderView.h"
#import "WBRProductDetailReviewCell.h"

NSString *const reviewsTableCellIdentifier = @"WBRProductDetailReviewCell";

@interface WBRProductDetailReviewView () <UITableViewDelegate, UITableViewDataSource, WBRProductDetailReviewCellDelegate>
@property (weak, nonatomic) IBOutlet WBRProductDetailReviewHeaderView *productDetailReviewHeader;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITableView *tableReviews;
@property (strong, nonatomic) NSArray<WBRReviewModel *> *reviewModelArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (assign,nonatomic) NSInteger totalDisplayReview;
@property (weak, nonatomic) IBOutlet WMButtonRounded *showAllReviewsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;
@end

@implementation WBRProductDetailReviewView

#pragma mark - Setup Layout
-(void)setupReview:(WBRRatingModel*)ratingModel reviewModelArray:(NSArray<WBRReviewModel *> *)reviewModelArray{
    self.reviewModelArray = reviewModelArray;
    
    if(self.reviewModelArray.count <= 3 ){
        self.totalDisplayReview = reviewModelArray.count;
        self.showAllReviewsButton.hidden = YES;
        [self.showAllReviewsButton removeFromSuperview];
        self.showAllReviewsButton = nil;
        
        self.tableBottomConstraint.constant = 0;
        [self layoutIfNeeded];
    }else{
        self.totalDisplayReview = 3;
    }

    [self.productDetailReviewHeader setupReview:ratingModel.ratingValue total:ratingModel.totalOfRatings];
    
    [self.tableReviews registerNib:[UINib nibWithNibName:@"WBRProductDetailReviewCell" bundle:nil]  forCellReuseIdentifier:reviewsTableCellIdentifier];
    
    self.tableReviews.delegate = self;
    self.tableReviews.dataSource = self;
    self.tableReviews.estimatedRowHeight = 82;
    self.tableReviews.rowHeight = UITableViewAutomaticDimension;
    self.tableHeightConstraint.constant = self.tableReviews.estimatedRowHeight * self.totalDisplayReview;
    [self.tableReviews reloadData];
    [self.tableReviews layoutIfNeeded];
    self.tableHeightConstraint.constant = self.tableReviews.contentSize.height;
    [self layoutIfNeeded];
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.totalDisplayReview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WBRProductDetailReviewCell *reviewsTableCell = [tableView dequeueReusableCellWithIdentifier:reviewsTableCellIdentifier forIndexPath:indexPath];
    [reviewsTableCell setupCell:[self.reviewModelArray objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
    reviewsTableCell.delegate = self;
    
    BOOL shouldShowReviewEvaluationView = [[WALMenuViewController singleton].services.isUserLikeReviewEnabled boolValue];
    [reviewsTableCell showReviewEvaluationView:shouldShowReviewEvaluationView];
    
    if(self.reviewModelArray.count <= 3 && (self.reviewModelArray.count -1) == indexPath.row){
        [reviewsTableCell hideSeparator];
    }
    return reviewsTableCell;
}

- (IBAction)showAllReviews:(id)sender {
    if([self.delegate respondsToSelector:@selector(showMoreReviews)]){
        [self.delegate showMoreReviews];
    }

}

#pragma mark - WBRProductDetailReviewCellDelegate

- (void)productDetailReviewCellDidEvaluateReviewIndexPath:(NSIndexPath *)reviewIndexPath withEvaluation:(BOOL)evaluation {
    
    if ([self.delegate respondsToSelector:@selector(productDetailReviewCellDidEvaluateReviewIndexPath:withEvaluation:)]) {
        [self.delegate productDetailReviewCellDidEvaluateReviewIndexPath:reviewIndexPath withEvaluation:evaluation];
    }
}

- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableHeightConstraint.constant = 3000;
    
    [self.tableReviews beginUpdates];
    [self.tableReviews endUpdates];
    
    [self layoutIfNeeded];
    self.tableHeightConstraint.constant = self.tableReviews.contentSize.height;
}

@end
