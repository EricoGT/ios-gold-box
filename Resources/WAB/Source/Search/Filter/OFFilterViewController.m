//
//  OFFilterViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 11/11/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFFilterViewController.h"
#import "UIImage+Additions.h"
#import "NSString+HTML.h"

#import "FilteringTableViewCell.h"
#import "FilterConnection.h"
#import "FilterNavigationController.h"
#import "Filter.h"
#import "SearchCategoryResult.h"

#import "RetryErrorView.h"

#import "FilterCategory.h"

@interface OFFilterViewController () <retryErrorViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@property (nonatomic, strong) Filter *filtersData;

@property (nonatomic, strong) NSArray *filterOptions;

//These properties will be used until we have "selected" key working in API.
@property (assign, nonatomic) NSUInteger totalDepartments;
@property (assign, nonatomic) NSUInteger totalCategories;

@end

@implementation OFFilterViewController

- (OFFilterViewController *)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self)
    {
        _totalDepartments = 0;
        _totalCategories = 0;
    }
    return self;
}

- (OFFilterViewController *)initWithFiltersData:(Filter *)filtersData query:(NSString *)query
{
    self = [self init];
    if (self)
    {
        [self setFiltersData:filtersData];
        _query = query;
        self.title = @"Filtro";
    }
    return self;
}

- (OFFilterViewController *)initWithQuery:(NSString *)query title:(NSString *)title
{
    self = [self init];
    if (self)
    {
        _query = query;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *barButtonsAttributes = @{NSForegroundColorAttributeName : RGBA(255, 255, 255, 1),
                                           NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:15]};
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    [cancelButton setTitleTextAttributes:barButtonsAttributes forState:UIControlStateNormal];
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Limpar" style:UIBarButtonItemStylePlain target:self action:@selector(clearPressed)];
    [clearButton setTitleTextAttributes:barButtonsAttributes forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:clearButton];
    
    if (self == self.navigationController.viewControllers.firstObject)
    {
        [self.navigationItem setLeftBarButtonItem:cancelButton];
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [_tableView registerNib:[FilteringTableViewCell nib] forCellReuseIdentifier:@"filteringCell"];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 15, 0)];
    
    if (!_filtersData)
    {
        [self filterWithQuery:_query];
    }
    
    LogMicro(@"[FILTER] Query: %@", _query);
}

#pragma mark - UINavigationBar Buttons
- (void)clearPressed
{
    FilterNavigationController *filterNavigation = (FilterNavigationController *) self.navigationController;
    OFFilterViewController *firstFilterController = (OFFilterViewController *) filterNavigation.viewControllers.firstObject;
 
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if (![firstFilterController.query isEqualToString:filterNavigation.originalQuery])
    {
        [firstFilterController filterWithQuery:filterNavigation.originalQuery];
    }
}

- (void)cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Datasource
- (void)setFiltersData:(Filter *)filtersData
{
    _filtersData = filtersData;
    
    LogMicro(@"filters: %@", _filtersData.departments);
    
    for (int i=0;i<_filtersData.departments.count;i++) {
        
        FilterDepartment *fpd = _filtersData.departments[i];
        LogMicro(@"Categories: %@", fpd.categories);
        
        NSArray *fct = fpd.categories;
        
        for (int j=0;j<fct.count;j++) {
            FilterCategory *fca = [fct objectAtIndex:j];
            LogMicro(@"Categories: %@", fca.subCategories);
            LogMicro(@"SubCateg: %i", (int)fca.subCategories.count);
        }
        
    }
    
    self.totalDepartments = _filtersData.departments.count;
    
    LogMicro(@"totalDepartments: %i", (int)self.totalDepartments);
    
    NSMutableArray *mutableFilterOptions = [NSMutableArray new];
    
    if (_filtersData.departments.count == 1)
    {
        FilterDepartment *department = _filtersData.departments[0];
        self.totalCategories += department.categories.count;

        if (department.categories.count == 1)
        {
            
//            if (department.subCategories.count > 0) {
//                
//                NSMutableArray *filterItems = @[department].mutableCopy;
//                [filterItems addObjectsFromArray:department.subCategories];
//                [mutableFilterOptions addObject:filterItems.copy];
//
//            }
            FilterCategory *category = department.categories[0];
            if (category.subCategories.count > 0)
            {
                NSMutableArray *filterItems = @[category].mutableCopy;
                [filterItems addObjectsFromArray:category.subCategories];
                [mutableFilterOptions addObject:filterItems.copy];
            }
        }
        else if (department.categories.count > 0)
        {
            for (FilterCategory *category in department.categories)
            {
                NSMutableArray *filterItems = @[category].mutableCopy;
                [filterItems addObjectsFromArray:category.subCategories];
                [mutableFilterOptions addObject:filterItems.copy];
            }
        }
    }
    else if (_filtersData.departments.count > 0)
    {
        for (FilterDepartment *department in _filtersData.departments)
        {
            self.totalCategories += department.categories.count;
            
            NSMutableArray *filterItems = @[department].mutableCopy;
            [filterItems addObjectsFromArray:department.categories];
            [mutableFilterOptions addObject:filterItems.copy];
        }
    }
    
    if (filtersData.brands.count > 0 || filtersData.specs.count > 0 || filtersData.pricesRange.count > 0)
    {
        //Brands
        if (filtersData.brands.count > 0)
        {
            NSMutableArray *mutableBrands = [NSMutableArray new];
            
            FilterSpecValue *brandsSpec = [FilterSpecValue new];
            brandsSpec.name = @"Marca";
            brandsSpec.isParent = @YES;
            
            [mutableBrands addObject:brandsSpec];
            [mutableBrands addObjectsFromArray:filtersData.brands];
            [mutableFilterOptions addObject:mutableBrands.copy];
        }
        
        //Specs
        for (FilterSpec *spec in filtersData.specs)
        {
            FilterSpecValue *categoriesSpec = [FilterSpecValue new];
            categoriesSpec.name = spec.name;
            categoriesSpec.isParent = @YES;
            
            NSMutableArray *mutableSpecs = [NSMutableArray new];
            [mutableSpecs addObject:categoriesSpec];
            [mutableSpecs addObjectsFromArray:spec.values];
            [mutableFilterOptions addObject:mutableSpecs.copy];
        }
        
        //Price Range
        if (filtersData.pricesRange.count > 0)
        {
            NSMutableArray *mutablePrices = [NSMutableArray new];
            
            FilterSpecValue *priceSpec = [FilterSpecValue new];
            priceSpec.name = @"Faixa de preço";
            priceSpec.isParent = @YES;
            
            [mutablePrices addObject:priceSpec];
            [mutablePrices addObjectsFromArray:filtersData.pricesRange];
            [mutableFilterOptions addObject:mutablePrices.copy];
        }
    }
    
    self.filterOptions = mutableFilterOptions.copy;
}

#pragma mark - Connection
- (void)filterWithQuery:(NSString *)query
{
    _tableView.hidden = YES;
    [_loader startAnimating];
    
    self.query = query;
    
    [[FilterConnection new] filterWithQuery:query completionBlock:^(SearchCategoryResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.result = result;
            self.filtersData = result.filters;
            
            if (self->_tableView.numberOfSections > 0 && [self->_tableView numberOfRowsInSection:0] > 0)
            {
                [self->_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
            [self->_tableView reloadData];
            [self->_tableView setHidden:NO];
            [self->_loader stopAnimating];
        });
    } failureBlock:^(NSError *error) {
        LogInfo(@"FALHA NO FILTRO! -> %@", error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_tableView setHidden:NO];
            [self->_loader stopAnimating];
            
            [self showErrorViewWithMessage:[[OFMessages new] errorFilterConnection]];
        });
    }];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _filterOptions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *filterValues = [self.filterOptions objectAtIndex:section];
    return filterValues.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    [header setBackgroundColor:[UIColor clearColor]];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilteringTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filteringCell" forIndexPath:indexPath];
    
    NSString *name;
    NSNumber *productsCount;
    
    if ([_filterOptions[indexPath.section][indexPath.row] isKindOfClass:[FilterSpecValue class]])
    {
        FilterSpecValue *specValue = _filterOptions[indexPath.section][indexPath.row];
        name = [specValue.name kv_decodeHTMLCharacterEntities];
        productsCount = specValue.count;
        [cell hideFilterCheckmark:!specValue.selected];
        cell.isSelectable = specValue.url.length > 0;
        cell.isParent = specValue.isParent.boolValue;
    }
    else if ([_filterOptions[indexPath.section][indexPath.row] isKindOfClass:[FilterDepartment class]])
    {
        FilterDepartment *item = _filterOptions[indexPath.section][indexPath.row];
        name = [item.name kv_decodeHTMLCharacterEntities];
        productsCount = item.count;
        [cell hideFilterCheckmark:YES];
        cell.isSelectable = item.url.length > 0 && _totalDepartments > 1;
        cell.isParent = YES;
    }
    else if ([_filterOptions[indexPath.section][indexPath.row] isKindOfClass:[FilterCategory class]])
    {
        FilterCategory *item = _filterOptions[indexPath.section][indexPath.row];
        name = [item.name kv_decodeHTMLCharacterEntities];
        productsCount = item.count;
        [cell hideFilterCheckmark:YES];
        cell.isSelectable = item.url.length > 0 && _totalCategories > 1;
        cell.isParent = _filtersData.departments.count == 1;
    }
    else if ([_filterOptions[indexPath.section][indexPath.row] isKindOfClass:[FilterSubcategory class]])
    {
        FilterSubcategory *item = _filterOptions[indexPath.section][indexPath.row];
        name = [item.name kv_decodeHTMLCharacterEntities];
        productsCount = item.count;
        [cell hideFilterCheckmark:YES];
        cell.isSelectable = item.url.length > 0;
        cell.isParent = NO;
    }
    
    LogMicro(@"[FILTER] Name: %@", name);
    NSArray *arrCategory = _filterOptions;
    LogMicro(@"[FILTER] arrCategory: %@", arrCategory);
    
    cell.filterName = name;
    cell.quantityLabel.text = @"";
    
    if (productsCount && cell.isSelectable)
    {
        [cell hideQuantityView:NO];
        cell.quantityLabel.text = [productsCount stringValue];
    }
    else
    {
        [cell hideQuantityView:YES];
        cell.quantityLabel.text = @"";
    }
    
    [cell setUp];
    [cell layoutIfNeeded];
    
    NSInteger rows = [_tableView numberOfRowsInSection:indexPath.section];
    if (rows == 1)
    {
        [cell roundTopAndBottom];
        cell.customDivider.hidden = YES;
    }
    else
    {
        if (indexPath.row == 0)
        {
            [cell roundTop];
            cell.customDivider.hidden = NO;
        }
        else if (indexPath.row == rows - 1)
        {
            [cell roundBottom];
            cell.customDivider.hidden = YES;
        }
        else
        {
            [cell removeRoundness];
            cell.customDivider.hidden = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = cell.isSelectable;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *filterValue;
    NSString *nameValue;
    
    if ([_filterOptions[indexPath.section][indexPath.row] isKindOfClass:[FilterSpecValue class]])
    {
        FilterSpecValue *specValue = _filterOptions[indexPath.section][indexPath.row];
        BOOL isSelectable = specValue.url.length > 0;
        if (isSelectable)
        {
            filterValue = [self cleanFilterValue:specValue.url];
            [self filterWithQuery:filterValue];
        }
    }
    else if ([_filterOptions[indexPath.section][indexPath.row] isKindOfClass:[FilterDepartment class]])
    {
        FilterDepartment *item = _filterOptions[indexPath.section][indexPath.row];
        BOOL isSelectable = item.url.length > 0 && !item.selected;
        if (isSelectable)
        {
            nameValue = item.name;
            filterValue = [self cleanFilterValue:item.url];
            
            OFFilterViewController *filterController = [[OFFilterViewController alloc] initWithQuery:filterValue title:[nameValue kv_decodeHTMLCharacterEntities]];
            [self.navigationController pushViewController:filterController animated:YES];
        }
    }
    else if ([_filterOptions[indexPath.section][indexPath.row] isKindOfClass:[FilterCategory class]])
    {
        FilterCategory *item = _filterOptions[indexPath.section][indexPath.row];
        BOOL isSelectable = item.url.length > 0 && !item.selected;
        if (isSelectable)
        {
            nameValue = item.name;
            filterValue = [self cleanFilterValue:item.url];
            
            OFFilterViewController *filterController = [[OFFilterViewController alloc] initWithQuery:filterValue title:[nameValue kv_decodeHTMLCharacterEntities]];
            [self.navigationController pushViewController:filterController animated:YES];
        }
    }
    else if ([_filterOptions[indexPath.section][indexPath.row] isKindOfClass:[FilterSubcategory class]])
    {
        
        LogInfo(@"Filters Data: %@", _filtersData);
        
        if (_filtersData.brands.count > 0 || _filtersData.specs.count > 0 || _filtersData.pricesRange.count > 0) {
            
            FilterSubcategory *subcategory = _filterOptions[indexPath.section][indexPath.row];
            BOOL isSelectable = subcategory.url.length > 0;
            if (isSelectable)
            {
                nameValue = subcategory.name;
                filterValue = [self cleanFilterValue:subcategory.url];
                
                OFFilterViewController *filterController = [[OFFilterViewController alloc] initWithQuery:filterValue title:[nameValue kv_decodeHTMLCharacterEntities]];
                [self.navigationController pushViewController:filterController animated:YES];
            }
        }
        else {
            
            FilterNavigationController *filterNavigation = (FilterNavigationController *) self.navigationController;
            OFFilterViewController *firstFilterController = (OFFilterViewController *) filterNavigation.viewControllers.firstObject;
            
            FilterSubcategory *subcategory = _filterOptions[indexPath.section][indexPath.row];
            
            _query = subcategory.url;
            
            LogInfo(@"search query: %@", _query);
            
            [firstFilterController filterWithQuery:_query];
            
        }
    }
}

#pragma mark - Error
- (void)showErrorViewWithMessage:(NSString *)message
{
    self.tableView.hidden = YES;
    [self.view showRetryViewWithMessage:message retryBlock:^{
        self.tableView.hidden = NO;
        [self filterWithQuery:self->_query];
    }];
}

#pragma mark - Helpers
- (NSString *)cleanFilterValue:(NSString *)dirtyFilterValue
{
    NSString *filterValue = dirtyFilterValue;
    NSRange startRange = [dirtyFilterValue rangeOfString:@"?"];
    if (startRange.location != NSNotFound)
    {
        NSRange searchRange = NSMakeRange(startRange.location , dirtyFilterValue.length - startRange.location);
        filterValue = [dirtyFilterValue substringWithRange:searchRange];
    }
    return filterValue;
}

@end
