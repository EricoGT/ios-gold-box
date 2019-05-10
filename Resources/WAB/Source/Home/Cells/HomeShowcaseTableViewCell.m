//
//  HomeShowcaseTableViewCell.m
//  Walmart
//
//  Created by Renan Cargnin on 7/23/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "HomeShowcaseTableViewCell.h"

#import "HomeProductCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShowcaseModel.h"
#import "ThemeManager.h"
#import "WalmartTheme.h"

@interface HomeShowcaseTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate, HomeProductCollectionViewCellDelegate>

@property (strong, nonatomic) ShowcaseModel *showcase;
@property (weak, nonatomic) IBOutlet UILabel *lblShowCase;
@property (strong, nonatomic) NSMutableDictionary *horizontalOffsets;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


-(void) calculatePageSelected;

@end

@implementation HomeShowcaseTableViewCell

static NSString * const reuseIdentifier = @"HomeProductCollectionViewCell";

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    [_collectionView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.exclusiveTouch = YES;
    CGFloat  cellScaling = 1;
    
    //calculate collection view cell flow size
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGFloat cellWidth = floor(screenSize.width * cellScaling);
    
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout* )_collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(cellWidth,layout.itemSize.height);
    self.horizontalOffsets = [NSMutableDictionary new];
}

- (void)setupWithShowcase:(ShowcaseModel *)showcase
{
    self.showcase = showcase;

    if (showcase.isRefreshing) {
        [_collectionView setHidden:YES];
        [_loader startAnimating];
    }
    else {
        [_loader stopAnimating];
        [_collectionView setHidden:NO];
        [_collectionView reloadData];
    }
    //load theme
    WalmartTheme *theme = [ThemeManager theme];
    
    NSString *nameLowerCase = [_showcase.name lowercaseString];
    NSString *nameShowCase = _showcase.name.copy;
    if(nameLowerCase.length > 1){
        nameShowCase = [NSString stringWithFormat:@"%@%@",[[nameLowerCase substringToIndex:1] uppercaseString],[ nameLowerCase substringFromIndex:1] ];
    }
    //get last word
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((\\w+)|(\\s(\\w+))\\s*)$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSRange highlightRange = [regex rangeOfFirstMatchInString:nameShowCase options:0 range:NSMakeRange(0, [nameShowCase length])];
    
    int fontSize = 24;
    //Roboto-Light
    UIFont *showcaseBoldFont = [UIFont fontWithName:@"Roboto-Bold" size:fontSize];
    UIFont *showcaseLightFont = [UIFont fontWithName:@"Roboto-Light" size:fontSize];
    
    NSRange fullRange = NSMakeRange(0, nameShowCase.length);
    
    NSMutableAttributedString *showCaseLabel = [[NSMutableAttributedString alloc] initWithString: nameShowCase];
    
    [showCaseLabel addAttribute:NSForegroundColorAttributeName value:theme.headerColor range:NSMakeRange(0, nameShowCase.length)];
    [showCaseLabel addAttribute:NSFontAttributeName value:showcaseLightFont range:fullRange];
    
    //compare if range of to highlight was found
    if (!NSEqualRanges(highlightRange, NSMakeRange(NSNotFound, 0))) {
        [showCaseLabel addAttribute:NSFontAttributeName value:showcaseBoldFont range:highlightRange];
    }
    
    _lblShowCase.attributedText = showCaseLabel;
    [self setupPageControl:theme];
}

- (void)refreshProductsWithSKU:(NSNumber *)sku {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (NSUInteger i = 0; i < _showcase.products.count; i++) {
        ShowcaseProductModel *product = _showcase.products[i];
        if ([product.skuId isEqual:sku]) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
    
    for (NSIndexPath *indexPath in indexPaths) {
        HomeProductCollectionViewCell *cell = (HomeProductCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        [cell updateHeartStatus];
    }
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _showcase.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeProductCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setupWithProduct:_showcase.products[indexPath.item] delegate:self];
    
    //This is necessary,because exists multiples page control for collectionView on the same view controller
    [self calculatePageSelected];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowcaseProductModel *product = _showcase.products[indexPath.item];
    
    UTMIModel *utmi = [WMUTMIManager UTMI];
    [utmi setSection:@"home" cleanOtherFields:YES];
    utmi.module = @"vitrine";
    utmi.internalPosition = [@(indexPath.item + 1) stringValue];
    utmi.moduleLabel = _showcase.name;
    utmi.internalLabel = product.productId.stringValue;
    [WMUTMIManager storeUTMI:utmi];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedProduct:showcase:)])
    {
        [_delegate selectedProduct:product.productId.stringValue showcase:_showcase];
    }
}

#pragma mark - HomeProductCollectionViewCellDelegate
- (void)homeProductCellTappedHeartButton:(id)homeProductCell {
    NSIndexPath *indexPath = [_collectionView indexPathForCell:homeProductCell];
    if (_delegate && [_delegate respondsToSelector:@selector(homeShowcaseCell:tappedHeartButtonForProductAtIndex:)]) {
        [_delegate homeShowcaseCell:self tappedHeartButtonForProductAtIndex:indexPath.item];
    }
}

#pragma mark - PageControl
-(void)setupPageControl:(WalmartTheme*) walmartTheme{
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    _pageControl.numberOfPages = _showcase.products.count;
    _pageControl.currentPageIndicatorTintColor = walmartTheme.pageControlHighlightColor;
    _pageControl.tintColor = walmartTheme.pageControlColor;
    _pageControl.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    
}

- (void)changePage:(id)sender{
    CGFloat pageWidthOfCollection = self.collectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake( pageWidthOfCollection * _pageControl.currentPage, 0);
    [self.collectionView setContentOffset:scrollTo animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self calculatePageSelected];
}

/*
 *This is necessary,because exists multiples page control on the same view controller
 */
-(void) calculatePageSelected{
    CGFloat pageWidthOfCollection = self.collectionView.frame.size.width;
    self.pageControl.currentPage = self.collectionView.contentOffset.x / (pageWidthOfCollection );
}

@end
