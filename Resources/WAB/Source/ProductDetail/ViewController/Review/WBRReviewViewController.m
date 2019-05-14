//
//  WBRReviewViewController.m
//  Walmart
//
//  Created by Cássio Sousa on 05/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRReviewViewController.h"

#import "WBRReviewHeaderView.h"
#import "ProductDetailConnection.h"
#import "WBRReviewsModel.h"
#import "WBRReviewTableViewCell.h"
#import "WBRReviewTableLoading.h"
#import "WBRCreateReviewViewController.h"
#import "WALMenuViewController.h"
#import "WBRProduct.h"

NSString *const reviewTableCellIdentifier = @"ReviewTableCell";
NSInteger const linesDefaultShow = 5;

NSInteger const bottomViewShowingSize = 74;
NSInteger const bottomViewHideSize    = 0;

@interface WBRReviewViewController () <UITableViewDataSource, UITableViewDelegate,WBRReviewTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet WBRReviewHeaderView *reviewHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *reviewTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (strong, nonatomic) WBRReviewTableLoading *wbrReviewTableLoading;

@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSNumber* actualPage;
@property (strong, nonatomic) WBRRatingModel *ratingModel;
@property (strong, nonatomic) WBRReviewsModel *reviewsModel;
@property (assign, nonatomic) BOOL firstLoad;


@property (strong, nonatomic) ProductDetailConnection *productDetailConnection;
@property (strong,nonatomic) NSMutableArray<NSNumber *> *selectedReviewRows;
@property (strong,nonatomic) NSMutableArray<WBRReviewModel> *reviewsTableRows;

@end

@implementation WBRReviewViewController

-(WBRReviewViewController *)initWithProductId:(NSString *)productId
                                  ratingModel:(WBRRatingModel *)ratingModel {
    if (self = [super initWithTitle:@"Avaliações" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO]) {
        self.productId = productId;
        self.ratingModel = ratingModel;
        self.actualPage = @(0);
    }
    
    return self;
}

-(WBRReviewViewController *)initWithReviews:(WBRReviewsModel*)reviewsModel
                                ratingModel:(WBRRatingModel *)ratingModel
                                  productId:(NSString *)productId;{
    if (self = [super initWithTitle:@"Avaliações" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO]) {
        self.productId = productId;
        self.ratingModel = ratingModel;
        self.actualPage = @(1);
        self.reviewsModel = reviewsModel.copy;
        self.reviewsTableRows = reviewsModel.results.mutableCopy;
        self.reviewsModel.results = nil;
    }
    
    return self;
}

- (void)viewDidLayoutSubviews {
    [self applyShadowViewBottom];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showReviewButton:NO];

    [self.indicator startAnimating];
    self.selectedReviewRows = [NSMutableArray new];
    
    self.wbrReviewTableLoading = [[WBRReviewTableLoading alloc] initWithFrame:CGRectMake(0, 0, self.reviewTableView.frame.size.width, 80)];
    
    self.productDetailConnection = [ProductDetailConnection new];
    
    self.reviewTableView.dataSource = self;
    self.reviewTableView.delegate = self;
    
    [self setupLayout];

    if(self.reviewsTableRows.count == 0){
        self.reviewsTableRows = [NSMutableArray<WBRReviewModel> new];
        [self loadReviews];
    }else{
        self.indicator.hidden = YES;
        [self.indicator stopAnimating];
        self.reviewTableView.hidden = NO;
        self.reviewHeaderView.hidden = NO;
        self.reviewTableView.tableFooterView = nil;
        self.reviewsModel.results = nil;
        BOOL showReviewButton = [WALMenuViewController singleton].services.isUserWriteReviewEnabled.boolValue;
        [self showReviewButton:showReviewButton];
    }
    [self.reviewTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupLayout{
    self.wbrReviewTableLoading.hidden = YES;
    self.reviewTableView.hidden = YES;
    [self.reviewTableView registerNib:[UINib nibWithNibName:@"WBRReviewTableViewCell" bundle:nil]  forCellReuseIdentifier:reviewTableCellIdentifier];
    self.reviewTableView.rowHeight = UITableViewAutomaticDimension;
    self.reviewTableView.estimatedRowHeight = 175.0;
    [self.reviewHeaderView setRating:self.ratingModel.totalOfRatings average:self.ratingModel.ratingValue];
    self.reviewHeaderView.hidden = YES;
    
}

- (void)showReviewButton:(BOOL)show {
    if (show) {
        self.bottomView.hidden = NO;
        self.bottomViewHeight.constant = bottomViewShowingSize;
    } else {
        self.bottomView.hidden = YES;
        self.bottomViewHeight.constant = bottomViewHideSize;
    }
    
    [self.view layoutIfNeeded];
}

- (void)applyShadowViewBottom {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bottomView.bounds];
    self.bottomView.layer.masksToBounds = NO;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0.0f, -7.0f);
    self.bottomView.layer.shadowOpacity = 0.2f;
    self.bottomView.layer.shadowRadius = 4.0f;
    self.bottomView.layer.shadowPath = shadowPath.CGPath;
}

- (void)openCreationReview {
    WBRCreateReviewViewController *createReviewViewController = [[WBRCreateReviewViewController alloc] init];
    createReviewViewController.productId = self.productId;
    [self.navigationController pushViewController:createReviewViewController animated:YES];
}

-(void)loadReviews {
    self.actualPage = @(self.actualPage.integerValue+1);

    [self.productDetailConnection loadProductReviews:self.productId  pageNumber:self.actualPage success:^(WBRReviewsModel *reviewModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.reviewsModel = reviewModel;
           
            self.reviewTableView.hidden = NO;
            
            self.reviewHeaderView.hidden = NO;
            
            self.indicator.hidden = YES;
            [self.indicator stopAnimating];
            
            
            [self.reviewsTableRows addObjectsFromArray:self.reviewsModel.results.copy];
            self.reviewsModel.results = nil;
            
            [self.reviewTableView reloadData];
            
            self.reviewTableView.tableFooterView = nil;
            
            BOOL showReviewButton = [WALMenuViewController singleton].services.isUserWriteReviewEnabled.boolValue;
            [self showReviewButton:showReviewButton];
        });
    } failure:^(NSDictionary *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.actualPage = @(self.actualPage.integerValue-1);
            self.indicator.hidden = YES;
            self.reviewTableView.hidden = YES;
            self.reviewHeaderView.hidden = YES;
            [self.indicator stopAnimating];
            self.reviewTableView.tableFooterView = nil;
            [self loadReviewsFailure:error];
            [self showReviewButton:NO];
        });
    }];
}

- (void)loadReviewsFailure:(NSDictionary *)error {
    __weak typeof(self) weakSelf = self;
    [self.view showRetryViewWithMessage:@"Não foi possivel carregar as avaliações." retryBlock:^{
        
        weakSelf.indicator.hidden = NO;
        [weakSelf.indicator startAnimating];
        
        [weakSelf loadReviews];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBRReviewTableViewCell * reviewTableCell = [tableView dequeueReusableCellWithIdentifier:reviewTableCellIdentifier forIndexPath:indexPath];
    
    NSNumber *lines = [NSNumber numberWithInteger:linesDefaultShow] ;
    
    if ([self.selectedReviewRows containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        lines = [NSNumber numberWithInteger:0] ;
        [reviewTableCell showLessButton];
    }
    else {
        [reviewTableCell showMoreButton];
    }
    [reviewTableCell setupReview:[self.reviewsTableRows objectAtIndex:indexPath.row] linesShow:lines forIndexPath:indexPath];
    
    BOOL shouldShowReviewEvaluationView = [[WALMenuViewController singleton].services.isUserLikeReviewEnabled boolValue];
    [reviewTableCell showReviewEvaluationView:shouldShowReviewEvaluationView];
    
    reviewTableCell.tag = indexPath.row;
    reviewTableCell.delegate = self;
    return reviewTableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviewsTableRows.count;
}

- (void)updateReviewCell:(NSNumber *)index {
    [self.reviewTableView beginUpdates];
    NSIndexPath *indexCell = [NSIndexPath indexPathForRow:index.integerValue  inSection:0] ;
    
    if([self.selectedReviewRows containsObject:index]){
        [self.selectedReviewRows removeObjectIdenticalTo:index];
    }else{
        [self.selectedReviewRows addObject:index.copy];
    }
    NSArray *arrayCell = [NSArray arrayWithObject:indexCell];
    [self.reviewTableView reloadRowsAtIndexPaths:arrayCell withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.reviewTableView endUpdates];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1 && [self.actualPage compare:self.reviewsModel.countPage] <= 0 )
    {
        self.wbrReviewTableLoading.hidden = NO;
         self.reviewTableView.tableFooterView =self.wbrReviewTableLoading;
        [self loadReviews];
    }
}

- (void)submitReviewEvaluation:(BOOL)evaluation reviewIndexPath:(NSIndexPath *)indexPath {
    
    WBRReviewModel *selectedReview = (WBRReviewModel *)[self.reviewsTableRows objectAtIndex:indexPath.row];
    
    selectedReview.voteCount = [NSNumber numberWithInteger:[selectedReview.voteCount integerValue] + 1];
    
    if (evaluation) {
        selectedReview.voteRelevant = [NSNumber numberWithInteger:[selectedReview.voteRelevant integerValue] + 1];
        selectedReview.reviewEvaluated = kReviewEvaluatedPositiveEvaluation;
    } else {
        selectedReview.reviewEvaluated = kReviewEvaluatedNegativeEvaluation;
    }
    
    [self.reviewTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [[WBRProduct new] postReviewEvaluation:evaluation ofProduct:@([self.productId integerValue]) forReview:selectedReview.reviewId successBlock:^(NSDictionary *dataJson) {
        
        self.reviewsTableRows[indexPath.row] = selectedReview;

        LogInfo(@"reviewTableViewCellDidEvaluateReview:withEvaluation: %@", dataJson);
    } failure:^(NSDictionary *dictError) {
        
        LogInfo(@"reviewTableViewCellDidEvaluateReview:withEvaluation: %@", dictError);
        
        selectedReview.reviewEvaluated = kReviewEvaluatedNoEvaluation;
        
        selectedReview.voteCount = [NSNumber numberWithInteger:[selectedReview.voteCount integerValue] -1];
        if (evaluation) {
            selectedReview.voteRelevant = [NSNumber numberWithInteger:[selectedReview.voteRelevant integerValue] -1];
        }
        
        [self.reviewTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if ([dictError objectForKey:@"errorMessage"] != nil) {
            NSString *errorMessage = [dictError objectForKey:@"errorMessage"];
            [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:errorMessage];
        }
    }];
}

- (void)reviewTableViewCellDidEvaluateReview:(NSIndexPath *)indexPath withEvaluation:(BOOL)evaluation {
    
    if ([WALSession isAuthenticated]) {
        [self submitReviewEvaluation:evaluation reviewIndexPath:indexPath];
    }
    else {
        [self presentLoginWithLoginSuccessBlock:^{
            [self submitReviewEvaluation:evaluation reviewIndexPath:indexPath];
        } dismissBlock:^{
            WBRReviewTableViewCell *cell = [self.reviewTableView cellForRowAtIndexPath:indexPath];
            [cell resetEvaluationView];
        }];
    }
}

#pragma mark - IBAction

- (IBAction)openCreateReviewViewController {
    
    if (![WALSession isAuthenticated]) {
        [self presentLoginWithLoginSuccessBlock:^{
            [self openCreationReview];
        }];
    } else {
        [self openCreationReview];
    }
}

@end
