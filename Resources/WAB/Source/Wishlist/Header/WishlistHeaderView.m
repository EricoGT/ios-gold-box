//
//  WishlistHeaderView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/7/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WishlistHeaderView.h"
#import "WMPickerTextField.h"
#import "User.h"

@interface WishlistHeaderView () <WMPickerTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalItemsLabel;
@property (weak, nonatomic) IBOutlet WMPickerTextField *toViewPicker;
@property (weak, nonatomic) IBOutlet WMPickerTextField *sortPicker;

@end

@implementation WishlistHeaderView

- (WishlistHeaderView *)initWithTotalItems:(NSUInteger)totalItems delegate:(id)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        
        [self setupWithTotalItems:totalItems];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupWithTotalItems:0];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupWithTotalItems:0];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupWithTotalItems:0];
    }
    return self;
}

- (void)setupWithTotalItems:(NSUInteger)totalItems {
    [self setTotalItems:totalItems];
    [self setupUserNameLabel];
    
    UIFont *floatLabelFont = [UIFont fontWithName:@"OpenSans-Light" size:12.0f];
    _toViewPicker.floatLabel.font = floatLabelFont;
    _sortPicker.floatLabel.font = floatLabelFont;
    
    _toViewPicker.options = @[@"Não comprei", @"Já comprei"];
    _sortPicker.options = @[@"Mais recentes", @"Mais antigos", @"Menor preço", @"Maior preço"];
    
    [_toViewPicker selectFirstOption];
    [_sortPicker selectFirstOption];
    
    _toViewPicker.wmPickerTextFieldDelegate = self;
    _sortPicker.wmPickerTextFieldDelegate = self;
}

- (void)setupUserNameLabel
{
    User *user = [User sharedUser];
    _nameLabel.text = user.firstName.length > 0 ? user.firstName : @"";
}

- (void)setTotalItems:(NSUInteger)totalItems {
    _totalItemsLabel.text = [NSString stringWithFormat:WISHLIST_ITEM_COUNT_FORMAT, (long) totalItems, totalItems == 1 ? @"item" : @"itens"];
}

#pragma mark - WMPickerTextFieldDelegate
- (void)pickerTextField:(id)pickerTextField didFinishSelectingIndex:(NSInteger)index {
    if (pickerTextField == _toViewPicker) {
        if (_delegate && [_delegate respondsToSelector:@selector(wishlistHeaderViewDidSelectFilterOption:)]) {
            [_delegate wishlistHeaderViewDidSelectFilterOption:index];
        }
    }
    else if (pickerTextField == _sortPicker) {
        if (_delegate && [_delegate respondsToSelector:@selector(wishlistHeaderViewDidSelectSortOption:)]) {
            [_delegate wishlistHeaderViewDidSelectSortOption:index];
        }
    }
}

- (WishlistFilterOption)selectedFilter {
    return _toViewPicker.selectedOptionIndex;
}

- (WishlistSortOption)selectedSort {
    return _sortPicker.selectedOptionIndex;
}

- (NSString *)selectedFilterForOmniture {
    NSInteger selectedIndex = _toViewPicker.selectedOptionIndex;
    if (selectedIndex == WishlistFilterOptionDidNotBuy) {
        return @"nao-comprei";
    }
    else {
        return @"ja-comprei";
    }
}

@end
