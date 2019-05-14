//
//  HubCategoriesFooter.m
//  Walmart
//
//  Created by Renan Cargnin on 7/3/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "HubCategoriesFooter.h"
#import "HubOtherCategoriesTableViewCell.h"
#import "CategoryMenuItem.h"

@implementation HubCategoriesFooter

static NSString * const reuseIdentifier = @"HubOtherCategoriesTableViewCell";

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIEdgeInsets tableViewContentInset = _tableView.contentInset;
    tableViewContentInset.bottom = 15.0f;
    [_tableView setContentInset:tableViewContentInset];
    [_tableView registerNib:[UINib nibWithNibName:@"HubOtherCategoriesTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupWithCategories:(NSArray *)categories {
    self.categories = categories;
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static HubOtherCategoriesTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    });
    [sizingCell setupWithCategory:self.categories[indexPath.row]];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HubOtherCategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setupWithCategory:self.categories[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryMenuItem *selectedCategory = _categories[indexPath.row];
    
    UTMIModel *utmi = [WMUTMIManager UTMI];
    [utmi setSection:@"departamento" cleanOtherFields:YES];
    utmi.module = @"menu-inferior";
    utmi.modulePosition = [@(indexPath.row + 1) stringValue];
    utmi.moduleLabel = selectedCategory.name;
    [WMUTMIManager storeUTMI:utmi];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedOtherCategory:)])
    {
        [self.delegate selectedOtherCategory:_categories[indexPath.row]];
    }
}

@end
