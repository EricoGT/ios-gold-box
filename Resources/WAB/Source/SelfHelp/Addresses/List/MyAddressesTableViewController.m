//
//  MyAddressesTableViewController.m
//  Walmart
//
//  Created by Renan on 5/15/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "MyAddressesTableViewController.h"

#import "WMButton.h"
#import "AddressModel.h"
#import "AddressCardCell.h"
#import "MyAddressesConnection.h"
#import "DeletePopupView.h"
#import "FeedbackAlertView.h"
#import "AddressViewController.h"
#import "WMMyAccountViewController.h"

@interface MyAddressesTableViewController () <addressCardDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) AddressCardCell *prototypeCell;
@property (weak, nonatomic) IBOutlet UIView *emptyStateView;

- (IBAction)addNewAddress:(id)sender;

@end

static NSString * const reuseIdentifier = @"AddressCardCell";

@implementation MyAddressesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WMOmniture trackAddressList];
    
    self.title = @"Endereços";
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:17.0f]}];
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.tableView.frame = CGRectMake(15.0f, self.tableView.frame.origin.y, self.tableView.frame.size.width - 30.0f, self.tableView.frame.size.height);
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableHeaderView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 237;
    
    [self.view addSubview:self.emptyStateView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressCardCell" bundle:nil]  forCellReuseIdentifier:reuseIdentifier];
    self.prototypeCell = (AddressCardCell *)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadMyAddresses];
}

#pragma mark - Private Methods
- (void)shouldDisplayEmptyStateView:(BOOL)shouldDisplayEmptyStateView {
    if (shouldDisplayEmptyStateView) {
        self.tableView.hidden = YES;
        self.emptyStateView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.emptyStateView.hidden = YES;
    }
}

- (void)loadMyAddresses {
    self.addresses = @[];
    [self.tableView reloadData];
    self.tableView.tableHeaderView.hidden = YES;
    self.emptyStateView.hidden = YES;
    
    [self.view showLoading];
    
    MyAddressesConnection *connection = [MyAddressesConnection new];
    [connection loadMyAddressesWithCompletionBlock:^(NSArray *addresses, NSTimeInterval requestTime) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            CGFloat minimumDelay = 0.5f;
            if (requestTime < minimumDelay) {
                [self performSelector:@selector(reloadWithAddresses:) withObject:addresses afterDelay:minimumDelay - requestTime];
            }
            else {
                if (addresses.count > 0) {
                    [self reloadWithAddresses:addresses];
                    [self shouldDisplayEmptyStateView:NO];
                }
                else {
                    [self shouldDisplayEmptyStateView:YES];
                }
            }
        }];
    } failure:^(NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.view hideLoading];
            
            LogInfo(@"Error: %@", error.userInfo);
            
            if ((error.code == 400) || (error.code == 401)) {
                LogErro(@"401 or 400");
                //We don't need the success block in this case because loadMyAddresses method will be called in viewWillAppear
                [self presentLoginWithLoginSuccessBlock:nil dismissBlock:^{
                    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                }];
            }
            else {
                [self.navigationController.view showPopupWithTitle:GREETING_OPS message:error.localizedDescription cancelButtonTitle:@"Cancelar" cancelBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } actionButtonTitle:TRY_BUTTON actionBlock:^{
                    [self loadMyAddresses];
                }];
            }
        }];
    }];
}

- (void)deleteAddress:(AddressModel *)address {
    [self.view showLoading];
    MyAddressesConnection *connection = [MyAddressesConnection new];
    [connection deleteAddressWithAddressId:address.addressId completionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [WMOmniture trackAddressDelete];
            [self.view hideLoading];
            [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:MY_ADDRESSES_DELETE_SUCCESS];
            [self loadMyAddresses];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideLoading];
            if (error.code == 401) {
                [self presentLoginWithLoginSuccessBlock:^{
                    [self deleteAddress:address];
                } dismissBlock:^{
                    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                }];
            }
            else {
                [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:MY_ADDRESSES_DELETE_ERROR];
            }
        });
    }];
}

- (void)setAddressAsDefault:(AddressModel *)address {
    [self.navigationController.view showModalLoading];
    MyAddressesConnection *connection = [MyAddressesConnection new];
    [connection setAddressAsDefaultWithAddressId:address completionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [WMOmniture trackAddressDelete];
            [self loadMyAddresses];
            [self.navigationController.view hideModalLoading];
            [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:ADDRESS_SUCCESS_SAVE_DEFAULT];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.navigationController.view hideModalLoading];
            if (error.code == 401) {
                [self presentLoginWithLoginSuccessBlock:^{
                    [self loadMyAddresses];
                } dismissBlock:^{
                    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                }];
            }
            else {
                [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:ADDRESS_ERROR_SAVE_DEFAULT];
            }
        });
    }];
}

- (void)reloadWithAddresses:(NSArray *)addresses {
    [self.view hideLoading];
    if (addresses.count > 0) {
        self.tableView.tableHeaderView.hidden = NO;
        self.addresses = [self reorderedAddresses:addresses];
        [self shouldDisplayEmptyStateView:NO];
        [self.tableView reloadData];
    }
    else {
        [self shouldDisplayEmptyStateView:YES];
    }
}

- (NSArray *)reorderedAddresses:(NSArray *)addresses {
    NSMutableArray *invertedAddresses = [[addresses reverseObjectEnumerator] allObjects].mutableCopy;
    AddressModel *mainAddress;
    for (AddressModel *address in invertedAddresses.copy) {
        if ([address.defaultAddress boolValue]) {
            mainAddress = address;
            [invertedAddresses removeObject:mainAddress];
            break;
        }
    }
    if (mainAddress) {
        [invertedAddresses insertObject:mainAddress atIndex:0];
    }
    return invertedAddresses.copy;
}

#pragma mark - UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCardCell *cell = (AddressCardCell *)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setupWithAddress:[self.addresses objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - Add New Address
- (IBAction)addNewAddress:(id)sender
{
    AddressViewController *address = [[AddressViewController alloc] initWithAddress:nil];
    address.editingAddress = NO;
    address.firstAddress = (self.addresses.count > 0) ? NO : YES;
    [self.navigationController pushViewController:address animated:YES];
}

#pragma mark - Address Card Delegate
- (void)editAddress:(AddressModel *)address
{
    AddressViewController *addressController = [[AddressViewController alloc] initWithAddress:address];
    addressController.editingAddress = YES;
    addressController.firstAddress = NO;
    [self.navigationController pushViewController:addressController animated:YES];
}

- (void)addressCardCellPressedDeleteButton:(AddressCardCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath.row >= _addresses.count) return;
    
    AddressModel *address = _addresses[indexPath.row];
    [self.navigationController.view showDeletePopupWithTitle:MSG_DELETE_ADDRESS message:address.fullAddress cancelBlock:nil deleteBlock:^{
        [self deleteAddress:address];
    }];
}

- (void)addressCardCellSetAsDefaulAddress:(AddressModel *)address {
    if (address) {
        [self setAddressAsDefault:address];
    }
}

- (void)animateFeedbackAlert:(FeedbackAlertView *)feedbackAlert {
    feedbackAlert.frame = CGRectMake(0, self.navigationController.view.frame.size.height, feedbackAlert.frame.size.width, feedbackAlert.frame.size.height);
    [self.navigationController.view addSubview:feedbackAlert];
    [feedbackAlert animateWithEaseInCompletionBlock:nil easeOutCompletionBlock:nil];
}

@end
