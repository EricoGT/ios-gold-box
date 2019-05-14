//
//  WBRContactTicketsViewController.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/15/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketViewController.h"
#import "WBRTicketManager.h"
#import "WBRContactTicketTableViewCell.h"
#import "WBRModelTicketCollection.h"
#import "WBRContactTicketDialogViewController.h"
#import "ContactRequestViewController.h"
#import "WBRContactTicketMessageViewController.h"

@interface WBRContactTicketViewController ()<UITableViewDataSource, UITableViewDelegate, WBRContactTicketTableViewCellDelegate, WBRContactTicketDialogViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contactTicketTableView;
@property (weak, nonatomic) IBOutlet UIView *emptyStateView;
@property (weak, nonatomic) IBOutlet UILabel *myTicketsLabel;

@property NSMutableArray<WBRModelTicket> *tickets;
@property NSNumber *requestPage;

@end

static NSInteger PaginationStartPage = 1;

@implementation WBRContactTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = CONTACT_TICKET_LIST_TITLE;
    self.tickets = [[NSMutableArray<WBRModelTicket> alloc] init];
    self.requestPage = [NSNumber numberWithInteger:PaginationStartPage];;
    [self.emptyStateView setHidden:YES];
    [self.myTicketsLabel setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupTableView];
    [self requestTickets];
}

#pragma mark - Class methods
- (void)setupTableView {
    [self.contactTicketTableView setDataSource:self];
    [self.contactTicketTableView setDelegate:self];
    self.contactTicketTableView.estimatedRowHeight = 270;
    self.contactTicketTableView.rowHeight = UITableViewAutomaticDimension;
    [self.contactTicketTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    [spinner setFrame:CGRectMake(0, 0, self.contactTicketTableView.frame.size.width, 44)];
    [self.contactTicketTableView setTableFooterView:spinner];
    
    [self.contactTicketTableView registerNib:[UINib nibWithNibName:[WBRContactTicketTableViewCell reusableIdentifier] bundle:nil] forCellReuseIdentifier:[WBRContactTicketTableViewCell reusableIdentifier]];
}


- (void)populateTicketArray:(NSArray *)tickets {
    
    [self.myTicketsLabel setHidden:NO];
    
    if (tickets && tickets.count > 0) {
        self.requestPage = @([self.requestPage integerValue] + 1);
        [self.tickets addObjectsFromArray:tickets];
        [self.contactTicketTableView reloadData];
        [WMOmniture trackOpenedTickets];
    } else {
        [self.contactTicketTableView setTableFooterView:[[UIView alloc] init]];
        [WMOmniture trackEmptyTickets];
    }
    
    [self showEmptyStateView:self.tickets.count == 0];
}

- (void)showEmptyStateView:(BOOL)showView {
    if (showView) {
        [self.emptyStateView setHidden:NO];
        self.view.backgroundColor = RGBA(33, 150, 243, 1);
    } else {
        [self.emptyStateView setHidden:YES];
        self.view.backgroundColor = RGBA(245, 245, 245, 1);
    }
}

- (void)showRetryRequestPopup:(NSError *)error {
    [self.myTicketsLabel setHidden:NO];
    
    [self.contactTicketTableView setTableFooterView:[[UIView alloc] init]];
    
    [self.navigationController.view showPopupWithTitle:GREETING_OPS message:error.localizedDescription cancelButtonTitle:@"Cancelar" cancelBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    } actionButtonTitle:TRY_BUTTON actionBlock:^{
        [self resetTicketList];
        [self requestTickets];
    }];
}

- (void)requestTickets {
    
    __weak WBRContactTicketViewController *weakSelf = self;
    [WBRTicketManager getUserTicketsForPageNumber:self.requestPage withSuccess:^(NSArray<WBRModelTicket *> *ticketCollection) {
        if (weakSelf) {
            [weakSelf populateTicketArray:ticketCollection];
        }
    } andFailure:^(NSError *error, NSData *data) {
        LogInfo(@"ERROR CONTACT TICKET REQUEST");
        if (weakSelf) {
            [weakSelf showRetryRequestPopup:error];
        }
    }];
}

- (void)resetTicketList {
    self.tickets = [[NSMutableArray<WBRModelTicket> alloc] init];
    self.requestPage = [NSNumber numberWithInteger:PaginationStartPage];
}

#pragma mark - IBActions

- (IBAction)gotoContactRequest {
    ContactRequestViewController *contactRequestViewController = [[ContactRequestViewController alloc] initFromMenu:NO andThankyouPageSuccessButtonTitle:@"Voltar"];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:contactRequestViewController];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WBRContactTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[WBRContactTicketTableViewCell reusableIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    [cell setupCellWithCollection:self.tickets[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.tickets.count-1) {
        [self requestTickets];
    }
}
    
#pragma mark - Reopen Contact Ticket
- (void)showTicketDialogViewController:(WBRContactTicketDialogViewController *)dialogTicketViewController {
    
    dialogTicketViewController.delegate = self;
    [self.navigationController.view showSmartLoadingWithBackgroundColor:RGBA(33, 150, 243, 1)];
    [self.navigationController presentViewController:dialogTicketViewController animated:YES completion:^{
    }];
}

#pragma mark - Reopen Contact Ticket Deleate
- (void)reopenTicketTouched:(NSString *)ticketId {
    WBRContactTicketDialogViewController* reopenTicketViewController = [[WBRContactTicketDialogViewController alloc] initReopenDialogWithTicketId:ticketId];
    [self showTicketDialogViewController:reopenTicketViewController];
}

- (void)closeTicketTouched:(NSString *)ticketId {
    WBRContactTicketDialogViewController* closeTicketViewController = [[WBRContactTicketDialogViewController alloc] initCloseDialogWithTicketId:ticketId];
    [self showTicketDialogViewController:closeTicketViewController];
}

- (void)openTicketMessagesTouched:(WBRModelTicket *)ticket {
    NSString *sellerName = ticket.seller.name;
    if (!sellerName) {
        sellerName = @"Walmart";
    }
    WBRContactTicketMessageViewController *messageViewController = [[WBRContactTicketMessageViewController alloc] initWithTicket:ticket];
    [self.navigationController pushViewController:messageViewController animated:YES];
}

#pragma mark - Reopen Contact Ticket Dialog Deleate
- (void)didDismissTicketDialogViewController{
    [self.navigationController.view hideSmartLoading];
}

- (void)didSuccessContactTicketReopened {
    [self.navigationController.view hideSmartLoading];
    [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:CONTACT_REQUEST_REOPEN_SEND_REQUEST_SUCCESS];
    
    [self resetTicketList];
    [self requestTickets];
}

- (void)didSuccessContactTicketClosed {
    [self.navigationController.view hideSmartLoading];
    [self.navigationController.view showFeedbackAlertOfKind:SuccessAlert message:CONTACT_REQUEST_CLOSE_SEND_REQUEST_SUCCESS];
    
    [self resetTicketList];
    [self requestTickets];
}

@end
