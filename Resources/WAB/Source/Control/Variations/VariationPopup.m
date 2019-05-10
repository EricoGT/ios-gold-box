//
//  VariationPopup.m
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "VariationPopup.h"

#import "VariationNode.h"
#import "VariationTreeView.h"
#import "VariationImageCell.h"

#import "ProductDetailConnection.h"

#define kAnimationTime 0.25f

@interface VariationPopup ()

@property (weak, nonatomic) IBOutlet UIView *variationsView;
@property (weak, nonatomic) IBOutlet VariationTreeView *variationTreeView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet WMButton *actionButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *variationTreeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomSpaceConstraint;

@property (copy, nonatomic) void (^selectedSKUBlock)(NSNumber *sku);

@property (strong, nonatomic) NSString *productId;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@end

@implementation VariationPopup

- (VariationPopup *)initWithSelectedSKUBlock:(void (^)(NSNumber *))selectedSKUBlock {
    self = [super init];
    if (self) {
        _selectedSKUBlock = selectedSKUBlock;
    }
    
    _buttonsView.layer.masksToBounds = NO;
    _buttonsView.layer.shadowColor = RGBA(0, 0, 0, 0.8).CGColor;
    _buttonsView.layer.shadowOpacity = 0.08;
    _buttonsView.layer.shadowOffset = CGSizeMake(0, -10);
    
    return self;
}

- (VariationPopup *)initWithProductId:(NSString *)productId selectedSKUBlock:(void (^)(NSNumber *selectedSKU))selectedSKUBlock {
    if (self = [self initWithSelectedSKUBlock:selectedSKUBlock]) {
        _productId = productId;
        [self loadProductVariations];
    }
    return self;
}

#pragma mark - Loading
- (void)showLoading {
    [_variationsView bringSubviewToFront:_loadingView];
    _loadingView.hidden = NO;
}

- (void)hideLoading {
    _loadingView.hidden = YES;
}

- (void)loadProductVariations {
    [self showLoading];
    [[ProductDetailConnection new] loadVariationsTreeWithProductId:_productId completionBlock:^(VariationNode *variationTree, NSString *baseImageURL) {
        [self hideLoading];
        [self showRetryView:NO];
        [self->_variationTreeView setupWithVariationRootNode:variationTree baseImageURL:baseImageURL];
        
        if (self->_variationTreeView.tableView.contentSize.height < self->_variationTreeView.bounds.size.height) {
            CGFloat height = self->_variationTreeView.tableView.contentSize.height + self->_variationTreeView.tableView.contentInset.top + self->_variationTreeView.tableView.contentInset.bottom;
            
            [self->_variationsView layoutIfNeeded];
            [UIView animateWithDuration:kAnimationTime animations:^{
                [self->_variationTreeView.tableView addConstraint:[NSLayoutConstraint constraintWithItem:self->_variationTreeView.tableView
                                                                                         attribute:NSLayoutAttributeHeight
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:nil
                                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                                        multiplier:1.0f
                                                                                          constant:height]];
                [self->_variationsView layoutIfNeeded];
            }];
            
        }
        
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showRetryView:YES];
    }];
    
    
}

- (void)dismissWithCompletion:(void (^)())completion
{
    [_variationsView layoutIfNeeded];
    [UIView animateWithDuration:kAnimationTime animations:^{
        self->_viewBottomSpaceConstraint.constant = - self->_variationsView.bounds.size.height;
        [self->_variationsView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) completion();
    }];
}

#pragma mark - IBAction
- (IBAction)pressedCancel:(id)sender
{
    [self dismissWithCompletion:nil];
}

- (IBAction)pressedAdd:(id)sender
{
    if ([_actionButton.titleLabel.text isEqualToString:[OFMessages variationPopUpRetryButton]]) {
        [self showRetryView:NO];
        [self loadProductVariations];
        return;
    }
    
    NSNumber *selectedSKU = [_variationTreeView selectedSKU];
	if (selectedSKU)
	{
        [self dismissWithCompletion:^{
            if (self->_selectedSKUBlock) self->_selectedSKUBlock(selectedSKU);
        }];
	}
    else
    {
        [self showAlertWithMessage:PRODUCT_FAVORITE_VARIATIONS_NO_CHOOSED];
    }
}

#pragma mark - Retry View
- (void)showRetryView:(BOOL)show
{
    if (show) {
        [self.variationTreeView showEmptyViewWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON];
        [self.actionButton setTitle:[OFMessages variationPopUpRetryButton] forState:UIControlStateNormal];
    } else {
        [self.variationTreeView hideEmptyView];
        [self.actionButton setTitle:[OFMessages variationPopUpConfirmButton] forState:UIControlStateNormal];
    }
}

@end
