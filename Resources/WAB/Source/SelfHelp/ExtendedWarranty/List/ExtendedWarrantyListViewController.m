//
//  ExtendedWarrantyListViewController.m
//  Walmart
//
//  Created by Renan Cargnin on 5/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyListViewController.h"
#import "WMBExtendedWarrantyCardCell.h"
#import "ExtendedWarrantyConnection.h"

#import "RetryErrorView.h"

#import "WMMyAccountViewController.h"
#import "ExtendedWarrantyResumeModel.h"
#import "ExtendedWarrantyDetailViewController.h"
#import "WMButtonRounded.h"

#import "WALMenuViewController.h"

@interface ExtendedWarrantyListViewController () <retryErrorViewDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet WMButtonRounded *btStartBuy;
@end

static NSString * const reuseIdentifier = @"WMBExtendedWarrantyCardCell";

@implementation ExtendedWarrantyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = EXTENDED_WARRANTY_LIST_TITLE;
    self.headerTitleLabel.text = EXTENDED_WARRANTY_LIST_HEADER_TITLE;
    [self.tableView registerNib:[UINib nibWithNibName:@"WMBExtendedWarrantyCardCell" bundle:nil]  forCellReuseIdentifier:reuseIdentifier];
    
    [self loadExtendedWarranties];
    self.noWarrantiesLabel.text = EXTENDED_WARRANTY_LIST_NO_WARRANTIES;
}

#pragma mark - Loading

- (void)loadExtendedWarranties
{
    self.endOfWarrantiesReached = NO;
    self.lastPageNumber = 0;
    self.warranties = @[];
    [self.tableView reloadData];
    
    [self.loader startAnimating];
    
    ExtendedWarrantyConnection *connection = [ExtendedWarrantyConnection new];
    [connection loadExtendedWarrantiesWithPageNumber:1 completionBlock:^(NSArray *warranties) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadSuccessWithWarranties:warranties];
        });
    }
    failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ((error.code == 400) || (error.code == 401)) {
                LogErro(@"401 or 400!");
                [self presentLoginWithLoginSuccessBlock:^{
                    [self loadExtendedWarranties];
                } dismissBlock:^{
                    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                }];
            } else {
                
                [self loadFailureWithError:error.localizedDescription];
            }
        });
    }];
}

- (void)loadSuccessWithWarranties:(NSArray *)warranties
{
    [self.loader stopAnimating];
    
    if (warranties.count == 0)
    {
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = nil;
        self.emptyView.hidden = NO;
    }
    else
    {
        self.tableView.tableHeaderView = self.headerView;
        [self.headerView setNeedsLayout];
        [self.headerView layoutIfNeeded];
        CGFloat height = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

        CGRect headerFrame = self.headerView.frame;
        headerFrame.size.height = height;
        self.headerView.frame = headerFrame;
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
        self.lastPageNumber = 1;
        
        self.warranties = warranties;
        [self.tableView reloadData];
    }
}

- (void)loadFailureWithError:(NSString *)error
{
    [self.loader stopAnimating];
    [self showRetryErrorViewWithMsg:error];
}

- (IBAction)loadMore
{
    self.retryLoadMoreButton.hidden = YES;
    [self.loadMoreLoader startAnimating];
    
    ExtendedWarrantyConnection *connection = [ExtendedWarrantyConnection new];
    [connection loadExtendedWarrantiesWithPageNumber:self.lastPageNumber+1 completionBlock:^(NSArray *warranties) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadMoreSuccessWithWarranties:warranties];
        });
    }
    failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ((error.code == 400) || (error.code == 401)) {
                LogErro(@"401 or 400!");
                [self presentLoginWithLoginSuccessBlock:^{
                    [self loadMore];
                } dismissBlock:^{
                    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                }];
            } else {
                [self loadMoreFailure];
            }
        });
    }];
}

- (void)loadMoreSuccessWithWarranties:(NSArray *)warranties
{
    [self.loadMoreLoader stopAnimating];
    
    if (warranties.count == 0) {
        self.endOfWarrantiesReached = YES;
        self.tableView.tableFooterView = nil;
    }
    else {
        self.lastPageNumber++;
        NSMutableArray *warrantiesMutable = self.warranties.mutableCopy;
        [warrantiesMutable addObjectsFromArray:warranties];
        self.warranties = warrantiesMutable.copy;
        [self.tableView reloadData];
    }
}

- (void)loadMoreFailure
{
    [self.loadMoreLoader stopAnimating];
    self.retryLoadMoreButton.hidden = NO;
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.warranties.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static WMBExtendedWarrantyCardCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    });
    [sizingCell setupWithExtendedWarrantyResumeModel:[self.warranties objectAtIndex:indexPath.row]];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMBExtendedWarrantyCardCell *cell = (WMBExtendedWarrantyCardCell *)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setupWithExtendedWarrantyResumeModel:[self.warranties objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExtendedWarrantyDetailViewController *warrantyDetailViewController = [[ExtendedWarrantyDetailViewController alloc] initWithNibName:@"ExtendedWarrantyDetailViewController" bundle:nil];
    ExtendedWarrantyResumeModel *warranty = [self.warranties objectAtIndex:indexPath.row];
    warrantyDetailViewController.ticketNumber = warranty.ticketNumber;
    [self.navigationController pushViewController:warrantyDetailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.warranties.count - 1 && !self.endOfWarrantiesReached && self.retryLoadMoreButton.hidden && !self.loadMoreLoader.isAnimating)
    {
        [self loadMore];
    }
}

#pragma mark - RetryErrorView

- (void)showRetryErrorViewWithMsg:(NSString *)msg {
    self.retryView = [[RetryErrorView alloc] initWithMsg:msg];
    self.retryView.backgroundColor = RGBA(255, 255, 255, 0);
    self.retryView.delegate = self;
    [self.view addSubview:self.retryView];
}

- (void)retry {
    [self.retryView removeFromSuperview];
    [self loadExtendedWarranties];
}

#pragma mark - Go to shopping

- (IBAction)goToShopping:(id)sender
{
    [[WALMenuViewController singleton] presentHomeWithAnimation:YES reset:NO];
}

@end
