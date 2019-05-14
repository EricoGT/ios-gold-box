//
//  WBRContactOrdersViewController.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactOrdersViewController.h"
#import "WBRContactOrderFooterTableCell.h"
#import "WBRContactOrdersTableViewCell.h"
#import "WBRContactManager.h"

@interface WBRContactOrdersViewController () <UITableViewDelegate, UITableViewDataSource, WBRContactOrderFooterTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ordersTableView;
@property (strong, nonatomic) NSArray<WBRContactRequestOrderModel *> *currentOrders;
@property (copy, nonatomic) kOrderSelectionCompletionNotification selectionCompletionNotification;
@property (strong, nonatomic) NSString *searchedOrderId;
@property (weak, nonatomic) UITextField *activeField;
@end

@implementation WBRContactOrdersViewController

- (instancetype)initWithOrders:(NSArray<WBRContactRequestOrderModel *> *)orders withSelectionItemNotification:(kOrderSelectionCompletionNotification)selectionCompletionNotification {
    
    self = [super initWithTitle:@"Selecione um pedido" isModal:YES searchButton:NO cartButton:NO wishlistButton:NO];
    
    if (self) {
        self.currentOrders = orders;
        self.selectionCompletionNotification = selectionCompletionNotification;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterForKeyboardNotifications];
}

- (void)dealloc {
    [self deregisterForKeyboardNotifications];
}

#pragma mark - Keyboard Registers
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterForKeyboardNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+20, 0.0);
    self.ordersTableView.contentInset = contentInsets;
    self.ordersTableView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.ordersTableView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.ordersTableView.contentInset = contentInsets;
    self.ordersTableView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Network

- (void)loadOrderInfo {
    [self.navigationController.view showModalLoading];

    [WBRContactManager getOrderDetailsByOrderId:self.searchedOrderId success:^(BOOL canceled, BOOL hasWarranty) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.navigationController.view hideModalLoading];
            [self searchedOrderSelectedWithNumber:self.searchedOrderId isCanceled:canceled exists:YES hasWarranty:hasWarranty];
        }];

    } failure:^(NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.navigationController.view hideModalLoading];
        }];
        
        if (error.code == 404) {
            //Order not found
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self searchedOrderSelectedWithNumber:self.searchedOrderId isCanceled:NO exists:NO hasWarranty:NO];
            }];
            
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.navigationController.view showFeedbackAlertOfKind:ErrorAlert message:@"Problema na requisição"];
            }];
        }
    }];
}

#pragma mark - Orders Help
- (void)searchedOrderSelectedWithNumber:(NSString *)orderId isCanceled:(BOOL)canceled exists:(BOOL)exists hasWarranty:(BOOL)hasWarranty {
    WBRContactRequestOrderModel *selectedOrderModel = [[WBRContactRequestOrderModel alloc] init];
    
    selectedOrderModel.orderId = orderId;
    selectedOrderModel.canceled = [NSNumber numberWithBool:canceled];
    selectedOrderModel.hasWarranty = [NSNumber numberWithBool:hasWarranty];
    
    self.selectionCompletionNotification(selectedOrderModel, exists);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (void)setupTableView {
    
    self.ordersTableView.delegate = self;
    self.ordersTableView.dataSource = self;
    self.ordersTableView.estimatedRowHeight = 70.5;
    self.ordersTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.ordersTableView registerNib:[UINib nibWithNibName:[WBRContactOrderFooterTableCell reusableIdentifier] bundle:nil] forCellReuseIdentifier:[WBRContactOrderFooterTableCell reusableIdentifier]];
    
    [self.ordersTableView registerNib:[UINib nibWithNibName:[WBRContactOrdersTableViewCell reusableIdentifier] bundle:nil] forCellReuseIdentifier:[WBRContactOrdersTableViewCell reusableIdentifier]];
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.activeField resignFirstResponder];
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[WBRContactOrdersTableViewCell class]]) {
        WBRContactRequestOrderModel *selectedOrderModel = [self.currentOrders objectAtIndex:indexPath.row];
        if (self.selectionCompletionNotification) {
            self.selectionCompletionNotification(selectedOrderModel, YES);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentOrders.count >= 1) {
        return self.currentOrders.count+1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((self.currentOrders.count > 0) && (indexPath.row == self.currentOrders.count)) {
        WBRContactOrderFooterTableCell *cell = [self.ordersTableView dequeueReusableCellWithIdentifier:[WBRContactOrderFooterTableCell reusableIdentifier] forIndexPath:indexPath];
        cell.indexPathCell = indexPath;
        cell.delegate = self;
        return cell;
        
    } else {
        WBRContactRequestOrderModel *order = [self.currentOrders objectAtIndex:indexPath.row];

        WBRContactOrdersTableViewCell *cell = [self.ordersTableView dequeueReusableCellWithIdentifier:[WBRContactOrdersTableViewCell reusableIdentifier] forIndexPath:indexPath];
        cell.order = order;

        return cell;
    }
}

#pragma mark - TableCellFooter Delegate
-(void)didEndEditingTextField {
    self.activeField = nil;
}

- (void)didEnterOrderId:(NSString *)orderId {
    self.searchedOrderId = orderId;
    [self loadOrderInfo];
}

- (void)didBeginEditingTextField:(UITextField *)textField {
    self.activeField = textField;
}

@end
