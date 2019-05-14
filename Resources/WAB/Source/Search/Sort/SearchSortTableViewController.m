//
//  OFOrderingViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 8/4/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "SearchSortTableViewController.h"
#import "UIImage+Additions.h"
#import "SortOption.h"
@interface SearchSortTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *applyButton;
@property (nonatomic, assign) NSInteger indexSelected;
@property (nonatomic, strong) NSArray *sortOptions;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortViewBottomConstraint;
@end

@implementation SearchSortTableViewController

- (SearchSortTableViewController *)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self)
    {
        SortOption *lowerPrice = [[SortOption alloc] initWithName:@"Menor preço" urlParameter:@"&O=OrderByPriceASC"];
        SortOption *higherPrice = [[SortOption alloc] initWithName:@"Maior preço" urlParameter:@"&O=OrderByPriceDESC"];
        SortOption *mostPopular = [[SortOption alloc] initWithName:@"Mais populares" urlParameter:@"&O=OrderByTopSaleDESC"];
        SortOption *desc = [[SortOption alloc] initWithName:@"A - Z" urlParameter:@"&O=OrderByNameASC"];
        SortOption *asc = [[SortOption alloc] initWithName:@"Z - A" urlParameter:@"&O=OrderByNameDESC"];
        
        _sortOptions = @[lowerPrice, higherPrice, mostPopular, asc, desc];
        
        _indexSelected = 999;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Ordenar";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    self.applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Aplicar" style:UIBarButtonItemStylePlain target:self action:@selector(applyPressed)];
    [_applyButton setEnabled:NO];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 16;
    
    NSDictionary *barButtonAttributes = @{NSForegroundColorAttributeName : RGBA(26, 117, 207, 1),
                                          NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:15]};
    
    [cancelButton setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
    [_applyButton setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
    
    [self.navigationItem setLeftBarButtonItems:@[spacer, cancelButton]];
    [self.navigationItem setRightBarButtonItems:@[spacer, _applyButton]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBA(247, 247, 247, 1)] forBarMetrics:UIBarMetricsDefault];
    
    //Exclusive for iPhone X
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPadding = window.safeAreaInsets.top;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;
        
        LogInfo(@"topPadding    : %f", topPadding);
        LogInfo(@"bottomPadding : %f", bottomPadding);
        
        if (bottomPadding == 0) {
            _sortViewBottomConstraint.constant = 0;
        }
    }
    else {
        _sortViewBottomConstraint.constant = 0;
    }
}

#pragma mark - Cancel
- (void)cancelPressed
{
    [self.baseViewController dismiss];
}

#pragma mark - Apply
- (void)applyPressed
{
    [FlurryWM logEvent_productSearchSortGo:[@(_indexSelected) stringValue]]; //value to be implemented
    [self.baseViewController selectOption:_indexSelected fromOptions:_sortOptions];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sortOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UIView *selectedBg = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBg.backgroundColor = RGBA(247, 247, 247, 1);
    cell.selectedBackgroundView = selectedBg;
    [cell.textLabel setHighlightedTextColor:[UIColor orangeColor]];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans" size:15.0]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1]];
    
    SortOption *option = [self.sortOptions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", option.name];
    
    if ([option.urlParameter isEqualToString: self.optionSelected.urlParameter]) {
        self.indexSelected = indexPath.row;
        self.optionSelected = [self.sortOptions objectAtIndex:indexPath.row];
    }
    
    if (indexPath.row == self.indexSelected)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:15.0]];
        [cell.textLabel setTextColor:RGBA(26, 117, 207, 1)];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans" size:15.0]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1]];
    }
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.applyButton setEnabled:YES];
    self.indexSelected = indexPath.row;
    self.optionSelected = [self.sortOptions objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

@end
