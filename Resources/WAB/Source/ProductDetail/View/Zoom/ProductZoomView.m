//
//  ProductZoomView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/28/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ProductZoomView.h"

#import "ProductZoomCell.h"
#import "ProductZoomItemScrollView.h"

@interface ProductZoomView () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *tutorialView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *imagesURLs;
@property (copy, nonatomic) void (^dismissBlock)();

@end

@implementation ProductZoomView

- (ProductZoomView *)initWithImagesIds:(NSArray *)imagesIds basePath:(NSString *)basePath dismissBlock:(void (^)())dismissBlock {
    if (self = [super init]) {
        _dismissBlock = dismissBlock;
        
        [self setup];
        [self setImagesIds:imagesIds basePath:basePath];
    }
    return self;
}

- (void)setup {
    [_scrollView setDelegate:self];
    
    UIEdgeInsets collectionViewContentInset = _collectionView.contentInset;
    collectionViewContentInset.left = 15.0f;
    collectionViewContentInset.right = 15.0f;
    [_collectionView setContentInset:collectionViewContentInset];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductZoomCell class]) bundle:nil] forCellWithReuseIdentifier:[ProductZoomCell reuseIdentifier]];
}

- (void)setImagesIds:(NSArray *)imagesIds basePath:(NSString *)basePath {
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *imagesURLsMutable = [NSMutableArray new];
    
    UIView *lastView = _scrollView;
    for (NSString *imageId in imagesIds) {
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", basePath, imageId]];
        [imagesURLsMutable addObject:imageURL];
        
        ProductZoomItemScrollView *zoomItemScrollView = [[ProductZoomItemScrollView alloc] initWithImageURL:imageURL];
        [_scrollView addSubview:zoomItemScrollView];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:zoomItemScrollView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:zoomItemScrollView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:zoomItemScrollView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:zoomItemScrollView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:zoomItemScrollView
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:lastView
                                                                attribute:lastView == _scrollView ? NSLayoutAttributeLeading : NSLayoutAttributeTrailing
                                                               multiplier:1.0f
                                                                 constant:0.0f]];
        
        if (imageId == imagesIds.lastObject) {
            [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:zoomItemScrollView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_scrollView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];
        }
        
        lastView = zoomItemScrollView;
    }
    self.imagesURLs = imagesURLsMutable.copy;
    
    [_collectionView reloadData];
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1
                                                                    constant:0]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1
                                                                    constant:0]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1
                                                                    constant:0]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1
                                                                    constant:0]];
        
        [UIView animateWithDuration:0.5f delay:1.5f options:0 animations:^{
            [self->_tutorialView setAlpha:0];
        } completion:^(BOOL finished) {
            [self->_tutorialView removeFromSuperview];
        }];
    }
}

- (void)dismissAnimated:(BOOL)animated {
    if (_dismissBlock) _dismissBlock();
    
    if (animated) {
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else {
        [self removeFromSuperview];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        NSUInteger page = roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
        [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
        for (ProductZoomItemScrollView *zoomItemScrollView in _scrollView.subviews) {
            [zoomItemScrollView resetZoom];
        }
    }
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imagesURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductZoomCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:[ProductZoomCell reuseIdentifier] forIndexPath:indexPath];
    [cell setImageURL:_imagesURLs[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewCellDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * indexPath.row, 0.0f) animated:YES];
}

#pragma mark - IBAction
- (IBAction)pressedClose {
    [self dismissAnimated:YES];
}

@end
