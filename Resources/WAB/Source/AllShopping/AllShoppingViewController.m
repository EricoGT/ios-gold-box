//
//  AllShoppingViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 11/28/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "AllShoppingViewController.h"
#import "ShoppingMenuItem.h"
#import "DepartmentMenuItem.h"
#import "AllShoppingCell.h"
#import "NewCartViewController.h"
#import "AllShoppingConnection.h"

@interface AllShoppingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AllShoppingConnection *connection;

@end

@implementation AllShoppingViewController

- (AllShoppingViewController *)initWithCategories:(NSArray *)categories {
    self = [super initWithTitle:@"Todo o shopping" isModal:NO searchButton:YES cartButton:YES wishlistButton:NO];
    if (self)
    {
        _categories = categories;
        _connection = [AllShoppingConnection new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[AllShoppingCell nib] forCellReuseIdentifier:@"ShoppingCell"];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    for (UIView * button in self.view.subviews) {
        if([button isKindOfClass:[UIButton class]])
            [((UIButton *)button) setExclusiveTouch:YES];
    }
    
    if (_categories.count == 0) {
        [self loadAllShopping];
    }
    else {
        [WMOmniture trackAllShoppingEnter];
    }
}

#pragma mark - Connection
- (void)loadAllShopping {
    [self.view showLoading];
    [_connection loadAllShoppingWithCompletionBlock:^(NSArray *categories) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [WMOmniture trackAllShoppingEnter];
            
            [self.view hideLoading];
            self.categories = categories;
            [self->_tableView reloadData];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideLoading];
            [self.view showRetryViewWithMessage:REQUEST_ERROR retryBlock:^{
                [self loadAllShopping];
            }];
        });
    }];
}

#pragma mark - Menu
- (void)showHideMenu {
    if ([_delegate respondsToSelector:@selector(hideAllShoppingScreen)]) {
        [_delegate hideAllShoppingScreen];
    }
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ShoppingMenuItem *headerItem = _categories[section];
    return headerItem.departments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ShoppingMenuItem *headerItem = _categories[section];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *customHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, header.frame.size.width - 15, 24)];
    customHeaderTitle.backgroundColor = [UIColor clearColor];
    customHeaderTitle.font = [UIFont fontWithName:@"OpenSans" size:18];
    customHeaderTitle.textColor = [UIColor blackColor];
    customHeaderTitle.text = headerItem.header;
    customHeaderTitle.textAlignment = NSTextAlignmentLeft;
    
    if (headerItem.color.count == 4) {
        NSInteger redValue = [headerItem.color[0] integerValue];
        NSInteger greenValue = [headerItem.color[1] integerValue];
        NSInteger blueValue = [headerItem.color[2] integerValue];
        NSInteger alphaValue = [headerItem.color[3] integerValue];
        UIColor *headerColor = RGBA(redValue, greenValue, blueValue, alphaValue/255);
        customHeaderTitle.textColor = headerColor;
    }
    
    [header addSubview:customHeaderTitle];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ShoppingCell";
    AllShoppingCell *cell = (AllShoppingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[AllShoppingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    ShoppingMenuItem *headerItem = _categories[indexPath.section];
    DepartmentMenuItem *department = [headerItem.departments objectAtIndex:indexPath.row];
    [cell setupCellWithDepartmentMenuItem:department];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShoppingMenuItem *headerItem = [self.categories objectAtIndex:indexPath.section];
    DepartmentMenuItem *department = [headerItem.departments objectAtIndex:indexPath.row];
    
    //Counts the number of departments before the selected department
    NSInteger numberOfDepartmentsBefore = 0;
    for (ShoppingMenuItem *category in [_categories subarrayWithRange:NSMakeRange(0, indexPath.section)]) {
        numberOfDepartmentsBefore += category.departments.count;
    }
    
    UTMIModel *utmi = [WMUTMIManager UTMI];
    [utmi setSection:[self UTMIIdentifier] cleanOtherFields:YES];
    utmi.module = self.UTMIIdentifier;
    utmi.modulePosition = [@(numberOfDepartmentsBefore + indexPath.row + 1) stringValue];
    utmi.moduleLabel = department.name;
    [WMUTMIManager storeUTMI:utmi];
    
    [self departmentTouched:department];
}

#pragma mark - Query
- (void)departmentTouched:(DepartmentMenuItem *)item {
    if (item.useHub.boolValue) {
        LogInfo(@"SHOW HUB");
        [[WALMenuViewController singleton] presentHubWithID:item.departmentId.stringValue title:item.name otherCategories:nil];
    }
    else {
        [[WALMenuViewController singleton] loadQueryOnCurrentViewController:item.url];
        [FlurryWM logEvent_promo_touched];
        [FlurryWM logEvent_promo_entering];
    }
}

#pragma mark - UTMI
- (NSString *)UTMIIdentifier {
    return @"todo-shopping";
}

@end
