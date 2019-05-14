//
//  HubCategoriesCollectionViewController.m
//  Walmart
//
//  Created by Renan Cargnin on 7/3/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "HubCategoriesCollectionViewController.h"

#import "HubCategory.h"
#import "HubCell.h"
#import "HubCategoriesFooter.h"
#import "HubConnection.h"
#import "CategoryMenuItem.h"

@interface HubCategoriesCollectionViewController () <HubCategoriesFooterDelegate>

@property (strong, nonatomic) HubCategoriesFooter *footer;

@end

@implementation HubCategoriesCollectionViewController

static NSString * const reuseIdentifier = @"HubCell";
static NSString * const hubCategoriesHeaderIdentifier = @"HubCategoriesHeader";
static NSString * const hubCategoriesFooterIdentifier = @"HubCategoriesFooter";

- (HubCategoriesCollectionViewController *)initWithHubId:(NSString *)hubId otherCategories:(NSArray *)otherCategories {
    self = [super initWithNibName:@"HubCategoriesCollectionViewController" bundle:nil];
    if (self) {
        self.hubId = hubId;
        self.connection = [HubConnection new];
        self.otherCategories = otherCategories;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // We take the color from hub view to handle loadings and retries properly
    self.view.backgroundColor = self.parentViewController.view.backgroundColor;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"HubCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HubCategoriesHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hubCategoriesHeaderIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HubCategoriesFooter" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:hubCategoriesFooterIdentifier];
    
    [self loadHubCategories];
}

- (void)loadHubCategories {
    [self.view showLoading];
    
    BOOL loadSubmenu = !self.otherCategories;
    [self.connection loadHubCategoriesWithHubId:self.hubId loadSubmenu:loadSubmenu completionBlock:^(NSArray *categories, NSArray *otherCategories) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadHubCategoriesSuccess:categories otherCategories:otherCategories];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadHubCategoriesFailure:error];
        });
    }];
}

- (void)loadHubCategoriesSuccess:(NSArray *)categories otherCategories:(NSArray *)otherCategories
{
    [WMOmniture trackHubEnter];
    
    [self.view hideLoading];
    
    self.categories = categories;
    if (otherCategories.count > 0)
    {
        self.otherCategories = otherCategories;
    }
    
    if (_categories.count == 0 && _otherCategories.count == 0)
    {
        [self.view showRetryViewWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON retryBlock:^{
            [self loadHubCategories];
        }];
    }
    else
    {
        [self removeRepeatedCategories];
        [_footer setupWithCategories:_otherCategories];
        
        [self.collectionView reloadData];
    }
}

- (void)loadHubCategoriesFailure:(NSError *)error {
    [self.view hideLoading];
    self.collectionView.hidden = YES;
    [self.view showRetryViewWithMessage:error.localizedDescription retryBlock:^{
        [self loadHubCategories];
        self.collectionView.hidden = NO;
    }];
}

- (void)removeRepeatedCategories {
    NSMutableArray *otherCategoriesMutable = self.otherCategories.mutableCopy;
    for (HubCategory *item in self.categories) {
        for (CategoryMenuItem *otherItem in self.otherCategories) {
            if ([item.searchParameter isEqualToString:otherItem.url]) {
                [otherCategoriesMutable removeObject:otherItem];
                break;
            }
        }
    }
    self.otherCategories = otherCategoriesMutable.copy;
}

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HubCategory *category = [self.categories objectAtIndex:indexPath.row];
    
    HubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setupWithHubCategory:category];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HubCategory *selectedCategory = _categories[indexPath.row];
    
    [FlurryWM logEvent_search_result_hubs:selectedCategory.text];
    
    UTMIModel *utmi = [WMUTMIManager UTMI];
    [utmi setSection:@"departamento" cleanOtherFields:YES];
    utmi.module = @"hub";
    utmi.modulePosition = [@(indexPath.row + 1) stringValue];
    utmi.moduleLabel = selectedCategory.text;
    [WMUTMIManager storeUTMI:utmi];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedHubCategory:)])
    {
        [self.delegate selectedHubCategory:selectedCategory];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (_footer)
    {
        return CGSizeMake(self.view.bounds.size.width, _footer.tableView.contentSize.height + _footer.tableView.contentInset.bottom + _footer.tableView.contentInset.top);
    }
    else
    {
        return CGSizeMake(self.collectionView.contentSize.width, 1);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.categories.count == 0) {
        return CGSizeZero;
    }
    else {
        return CGSizeMake(320, 60);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.height;
    return CGSizeMake((collectionView.bounds.size.width - 45.0f) / 2, itemHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:hubCategoriesHeaderIdentifier forIndexPath:indexPath];
        return header;
    }
    else {
        HubCategoriesFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:hubCategoriesFooterIdentifier forIndexPath:indexPath];
        if (!self.footer) {
            self.footer = footer;
            footer.delegate = self;
            [footer setupWithCategories:self.otherCategories];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionViewLayout invalidateLayout];
            });
        }
        return footer;
    }
}

#pragma mark - Other Categories Delegate
- (void)selectedOtherCategory:(CategoryMenuItem *)category {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedOtherCategory:)]) {
        [self.delegate selectedOtherCategory:category];
    }
}

- (void)handleTableViewInsets:(UIEdgeInsets)insets {
    [self.footer.tableView setContentInset:insets];
    [self.collectionView reloadData];
}

@end
