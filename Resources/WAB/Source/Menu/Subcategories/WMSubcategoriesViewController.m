//
//  WMSubcategoriesViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 2/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMSubcategoriesViewController.h"
#import "WMParser.h"
#import "CategoryMenuItem.h"
#import "CategoryMenuItemCount.h"
#import "NSString+HTML.h"
#import "SubcategoryMenuCellTableViewCell.h"
#import "WMMenuErrorView.h"
#import "WMButton.h"
#import "OFCustomSizeNavigationBar.h"
#import "WMOmniture.h"
#import "WALMenuViewController.h"
#import "WMRetargetingConnection.h"
#import "DepartmentMenuItem.h"
#import "WBRMenuManager.h"

static NSString *kCellReuseIdentifier = @"MenuCategoriesReuseIdentifier";

@interface WMSubcategoriesViewController ()

@property (nonatomic, strong) CategoryMenuItem *category;

@property (nonatomic, strong) WMMenuErrorView *errorView;
@property (nonatomic, strong) WMButton *retryButton;
@property (nonatomic, strong) UIActivityIndicatorView *loader;
@property (strong, nonatomic) WMRetargetingConnection *retargetingConnection;

@property (strong, nonatomic) IBOutlet UITableView *tbView;

@end

@implementation WMSubcategoriesViewController

- (WMSubcategoriesViewController *)initWithDepartment:(DepartmentMenuItem *)department {
    self = [super initWithNibName:@"WMSubcategoriesViewController" bundle:nil];
    if (self) {
        _department = department;
    }
    return self;
}

- (WMSubcategoriesViewController *)initWithCategory:(CategoryMenuItem *)category department:(DepartmentMenuItem *)deparment {
    self = [super initWithNibName:@"WMSubcategoriesViewController" bundle:nil];
    if (self) {
        _category = category;
        _department = deparment;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.retargetingConnection = [WMRetargetingConnection new];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 40, 21)];
    UIImage *backImage = [UIImage imageNamed:@"img_back"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    NSIndexPath *indexPath = self.tbView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tbView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - SetUp
- (void)setUp {
//    self.tbView.clearsSelectionOnViewWillAppear = YES;
    
    

    [self.tbView registerNib:[SubcategoryMenuCellTableViewCell nib] forCellReuseIdentifier:kCellReuseIdentifier];

    self.tbView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tbView.frame.size.width, 16)];
    self.tbView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tbView.frame.size.width, 16)];
    self.tbView.backgroundColor = RGBA(33, 150, 243, 1);
}

- (void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    [self setUp];
    
    if (!self.categories) {
        [self loadMenu];
    }
    else {
        //Removing items with zero results
        [self removeEmptyResults];
        
        //Inserting "Tudo em..." item
        NSMutableArray *mutableItems = [[NSMutableArray alloc] initWithArray:self.categories];
        [mutableItems insertObject:self.seeAllItem atIndex:0];
        self.categories = mutableItems.copy;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    OFCustomSizeNavigationBar *customNavigationBar = (OFCustomSizeNavigationBar *)self.navigationController.navigationBar;
    customNavigationBar.customTitle = _category.name.length > 0 ? _category.name : _department.name.length > 0 ? _department.name : @"";
}

#pragma Connection
- (void)loadMenu {
    [self showLoading];
    NSNumber *subMenuId = _department ? _department.departmentId : _category.categoryId;
    
    [WBRMenuManager getMenuCategoriesWithCategoryId:subMenuId successBlock:^(NSArray *items, NSArray *totals) {
        [self hideLoading];
        
        LogInfo(@"Request das categorias do menu com sucesso");
        if (self.seeAllItem) {
            self.categories = items;
            
            //Inserting "Tudo em..." item
            NSMutableArray *mutableItems = [[NSMutableArray alloc] initWithArray:self.categories];
            [mutableItems insertObject:self.seeAllItem atIndex:0];
            
            self.categories = mutableItems.copy;
            self.counts = totals;
        } else {
            self.categories = items;
            self.counts = totals;
        }
        
        //Removing items with zero results
        [self removeEmptyResults];
        [self removeError];
        [self.tbView reloadData];

    } failureBlock:^(NSError *error) {
        [self hideLoading];
        
        LogInfo(@"ERRO (%ld): %@", (long)error.code, error.localizedDescription);
        self.categories = @[];
        self.counts = @[];
        
        [self.tbView reloadData];
        [self setUpError];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryMenuItem *item = [self.categories objectAtIndex:indexPath.row];
    SubcategoryMenuCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    NSNumber *itemsCount = [self itemsCountForCategoryID:item.categoryId];
    [cell setupCellWithCategory:item count:itemsCount hideIcon:self.hideIcon];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryMenuItem *item = [self.categories objectAtIndex:indexPath.row];
    WALMenuViewController *menu = [WALMenuViewController singleton];
    
    if (item.isSeeAll.boolValue) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        //We aren't tracking subcategories level UTMI yet
        if (!_isThirdLevel) {
            UTMIModel *utmi = [WMUTMIManager UTMI];
            utmi.internalPosition = [@(indexPath.row + 1) stringValue];
            utmi.internalLabel = _category ? _category.name : _department.name;
            [WMUTMIManager storeUTMI:utmi];
        }
        
        [WMOmniture trackMenuAllInTap:item.name];
        
        if (item.useHub.boolValue) {
            LogInfo(@"SHOW HUB");
            [self logFlurryShoppingWithLastItem:item];
            
            NSString *hubTitle = _department.name;
            NSMutableArray *otherCategories = self.categories.mutableCopy;
            [otherCategories removeObject:item];
            
            if (_category) {
                [_retargetingConnection trackCategoryWithId:_category.categoryId.stringValue departmentId:_department.departmentId.stringValue];
            }
            else if (_department) {
                [_retargetingConnection trackDepartmentWithId:_department.departmentId.stringValue];
            }
            
            [menu presentHubWithID:item.categoryId.stringValue title:hubTitle otherCategories:otherCategories];
        }
        else {
            [_retargetingConnection trackCategoryWithId:_category.categoryId.stringValue departmentId:_department.departmentId.stringValue];
            [self logFlurryShoppingWithLastItem:item];
            [[WALMenuViewController singleton] loadQueryOnCurrentViewController:item.url];
        }
    }
    else {
        if (self.isThirdLevel) {
            [WMOmniture trackMenuSubCategoryTap:_department.name category:_department.name subcategory:item.name];
        }
        else {
            UTMIModel *utmi = [WMUTMIManager UTMI];
            utmi.internalPosition = [@(indexPath.row + 1) stringValue];
            utmi.internalLabel = item.name;
            [WMUTMIManager storeUTMI:utmi];
            
            [WMOmniture trackMenuCategoryTap:_department.name category:item.name];
        }
        
        if ((item.children) && (item.children.count > 0)) {
            WMSubcategoriesViewController *controller = [[WMSubcategoriesViewController alloc] initWithCategory:item department:_department];
            controller.categories = item.children;
            controller.counts = self.counts;
            controller.hideIcon = YES;
            controller.isThirdLevel = YES;
            
            //Creating the "Tudo em" menu item.
            CategoryMenuItem *seeAllItem = [CategoryMenuItem new];
            seeAllItem.categoryId = item.categoryId;
            seeAllItem.url = item.url;
            seeAllItem.name = item.name;
            seeAllItem.useHub = item.useHub;
            seeAllItem.isSeeAll = @YES;
            seeAllItem.name = [NSString stringWithFormat:@"Tudo em %@", item.name];
            
            controller.seeAllItem = seeAllItem;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            if (_isThirdLevel)
                [_retargetingConnection trackSubcategoryWithId:item.categoryId.stringValue categoryId:_category.categoryId.stringValue departmentId:_department.departmentId.stringValue];
            else
                [_retargetingConnection trackCategoryWithId:item.categoryId.stringValue departmentId:_department.departmentId.stringValue];
            
            [self logFlurryShoppingWithLastItem:item];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[WALMenuViewController singleton] loadQueryOnCurrentViewController:item.url];
        }
    }
}

#pragma mark - Error
- (void)setUpError {
    [self removeError];
    
    if (!self.errorView) {
        self.errorView = (WMMenuErrorView *)[WMMenuErrorView loadFromXib];
    }
    
    self.errorView.errorMessageLabel.text = REQUEST_ERROR;
    
    CGRect errorViewFrame = self.errorView.frame;
    errorViewFrame.origin.x = self.view.bounds.size.width / 2 - errorViewFrame.size.width / 2 - 30;
    errorViewFrame.origin.y = (self.view.frame.size.height/2) - (errorViewFrame.size.height/2) - 60;
    self.errorView.frame = errorViewFrame;
    
    if (!self.retryButton) {
        self.retryButton = [[WMButton alloc] initWithFrame:CGRectMake(self.errorView.center.x - 80, errorViewFrame.origin.y + errorViewFrame.size.height + 40, 160, 34) andButtonPressedBlock:^{
            [self loadMenu];
        }];
        
        self.retryButton.normalColor = RGBA(221, 221, 221, 1);
        [self.retryButton setTitleColor:RGBA(26, 117, 207, 1) forState:UIControlStateNormal];
        [self.retryButton setTitle:@"Tentar novamente" forState:UIControlStateNormal];
    }
    
    [self.view addSubview:self.errorView];
    [self.view addSubview:self.retryButton];
}

- (void)removeError {
    if (self.errorView) {
        [self.errorView removeFromSuperview];
    }
    
    if (self.retryButton) {
        [self.retryButton removeFromSuperview];
    }
}

#pragma mark - Loading
- (void)showLoading {
    [self removeError];
    if (!self.loader) {
        self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.loader.color = RGBA(255, 255, 255, 1);
        [self.loader setHidesWhenStopped:YES];
        [self.view addSubview:self.loader];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    self.loader.frame = CGRectMake(130, (screenHeight/2) - (self.loader.frame.size.height) - 30, self.loader.frame.size.width, self.loader.frame.size.height);
    self.loader.hidden = NO;
    [self.loader startAnimating];
}

- (void)hideLoading {
    [self.loader stopAnimating];
}

#pragma mark - Helper
- (NSNumber *)itemsCountForCategoryID:(NSNumber *)categoryID {
    NSNumber *count = nil;
    if (categoryID) {
        for (CategoryMenuItemCount *itemCount in self.counts) {
            if (itemCount.categoryId.integerValue == categoryID.integerValue) {
                count = itemCount.total;
                break;
            }
        }
    }
    
    return count;
}

- (void)removeEmptyResults {
    NSMutableArray *emptyItems = [NSMutableArray new];
    
    //Searching empty items
    for (CategoryMenuItemCount *itemCount in self.counts) {
        if (itemCount.total.integerValue == 0) {
            [emptyItems addObject:itemCount];
        }
    }
    
    //Removing empty items from the list
    NSMutableArray *mutableCategories = self.categories.mutableCopy;
    for (CategoryMenuItemCount *itemToBeRemoved in emptyItems) {
        for (CategoryMenuItem *item in self.categories) {
            if (item.categoryId.integerValue == itemToBeRemoved.categoryId.integerValue) {
                [mutableCategories removeObject:item];
                break;
            }
        }
    }
    
    self.categories = mutableCategories.copy;
}

#pragma mark - Flurry
- (void)logFlurryShoppingWithLastItem:(CategoryMenuItem *)item {
    NSMutableArray *categories = [NSMutableArray new];
    for (id viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[WMSubcategoriesViewController class]]) {
            WMSubcategoriesViewController *controller = (WMSubcategoriesViewController *)viewController;
            if (controller.department.name.length > 0) {
                [categories addObject:controller.department.name];
            }
        }
    }
    
    [categories addObject:item.name];
    if (categories.count > 0) {
        [FlurryWM logEvent_menu_shopping_result:categories];
    }
}

@end
