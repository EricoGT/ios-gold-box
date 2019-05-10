//
//  PaymentOptionsViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 9/29/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "PaymentOptionsViewController.h"
#import "WMPaymentFormsTableViewCell.h"

@interface PaymentOptionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *customTitle;

@property (nonatomic, strong) IBOutlet WMButtonRounded *cancelButton;
@property (nonatomic, strong) IBOutlet WMButtonRounded *confirmButton;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) NSArray *installments;

- (IBAction)back:(id)sender;
- (IBAction)confirm:(id)sender;

@end

static NSString * const ReuseIdentifierRates = @"reuseIdentifierRates";
@implementation PaymentOptionsViewController

- (instancetype)initWithInstallments:(NSArray *)installments selectedIndex:(NSUInteger)index
{
    self = [super initWithNibName:@"PaymentOptionsViewController" bundle:nil];
    if (self) {
        self.installments = installments;
        if (index) {
            self.selectedIndex = index;
        } else {
            self.selectedIndex = 0;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupActionButtons];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
}

- (void)setupTableView {
    [self.tableView registerNib:[WMPaymentFormsTableViewCell nib] forCellReuseIdentifier:ReuseIdentifierRates];
    
    self.tableView.tableHeaderView = ({UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1/UIScreen.mainScreen.scale)];
        line.backgroundColor = self.tableView.separatorColor;
        line;
    });
    
    self.tableView.tableFooterView = ({UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1/UIScreen.mainScreen.scale)];
        footerView.backgroundColor = self.tableView.separatorColor;
        footerView;
    });
    
    [self.tableView setSeparatorColor:RGBA(238, 238, 238, 1)];
}

- (void)setupActionButtons {
    [self.cancelButton setFont:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    [self.confirmButton setFont:[UIFont fontWithName:@"Roboto-Regular" size:13]];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.installments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WMPaymentFormsTableViewCell *cell = (WMPaymentFormsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifierRates forIndexPath:indexPath];

    UIView *bgColorView = [UIView new];
    bgColorView.backgroundColor = RGBA(238, 238, 238, 1);
    [cell setSelectedBackgroundView:bgColorView];
    
    Installment *installment = [_installments objectAtIndex:indexPath.row];
    [cell setupInCheckoutWithInstallment:installment];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    
    WMPaymentFormsTableViewCell *cell = (WMPaymentFormsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelectedWithInstallment:[self.installments objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    WMPaymentFormsTableViewCell *cell = (WMPaymentFormsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setDeselectedWithInstallment:[self.installments objectAtIndex:indexPath.row]];
}

- (void)back:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePaymentOptions)]) {
        [self.delegate closePaymentOptions];
    }
}

- (void)confirm:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(paymentOptionSelected:index:)]) {
        Installment *installmentSelected = _installments[_selectedIndex];
        [self.delegate paymentOptionSelected:installmentSelected index:_selectedIndex];
    }
}

@end
