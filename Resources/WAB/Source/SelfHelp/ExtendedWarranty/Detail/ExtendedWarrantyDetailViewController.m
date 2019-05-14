//
//  ExtendedWarrantyDetailViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 5/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyDetailViewController.h"
#import "ExtendedWarrantyConnection.h"
#import "ExtendedWarrantyDetail.h"
#import "NSDate+DateTools.h"
#import "RetryErrorView.h"
#import "OFFormatter.h"
#import "UIImageView+WebCache.h"
#import "ExtendedWarrantyOptionsCell.h"
#import "NSString+Additions.h"
#import "ExtendedWarrantyCancelTicket.h"
#import "ExtendedWarrantyCancelManager.h"
#import "WMPDFViewerViewController.h"
#import "CancelWarrantyViewController.h"
#import "FeedbackAlertView.h"

@interface ExtendedWarrantyDetailViewController () <retryErrorViewDelegate, UITableViewDataSource, UITableViewDelegate, CancelWarrantyDelegate>

@property (strong, nonatomic) RetryErrorView *emptyView;
@property (strong, nonatomic) WMPDFViewerViewController *pdfViewer;
@property (assign, nonatomic) BOOL showAuthorizationTerm;

@end

@implementation ExtendedWarrantyDetailViewController

static NSString * const reuseIdentifier = @"ExtendedWarrantyOptionsCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    [self setupTableView];
    [self loadDetails];
}

#pragma mark - Setups
- (void)setup
{
    self.title = EXTENDED_WARRANTY_DETAILS_TITLE;
    
    self.warrantyCard.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.warrantyCard.layer.borderWidth = 1.0f;
}

- (void)setupTableView
{
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 44;
    [self.tableView registerNib:[UINib nibWithNibName:@"ExtendedWarrantyOptionsCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (void)setupFooter
{
    WarrantyState state = self.warranty.state.integerValue;
    if (state == WarrantyStateCancelling)
    {
        ExtendedWarrantyCancelTicket *ticket = [ExtendedWarrantyCancelManager ticketForWarrantyNumber:self.warranty.ticketNumber];
        NSString *protocolNumber = ticket.protocolNumber ? ticket.protocolNumber.stringValue : @"";
        
        UIFont *footerFont = [UIFont fontWithName:@"OpenSans" size:14];
        UIFont *footerBoldFont = [UIFont fontWithName:@"OpenSans-Bold" size:14];
        UIColor *normalColor = RGBA(165, 165, 165, 1);
        UIColor *highlightColor = RGBA(26, 117, 207, 1);
        
        NSString *protocolMessage = [NSString stringWithFormat:EXTENDED_WARRANTY_CANCEL_PROTOCOL_MESSAGE, protocolNumber];
        CGSize messageSize = [protocolMessage sizeForTextWithFont:footerFont constrainedToSize:CGSizeMake(self.tableView.frame.size.width, CGFLOAT_MAX)];
        
        NSRange protocolRange = [protocolMessage rangeOfString:protocolNumber];
        NSRange fullRange = NSMakeRange(0, protocolMessage.length);
        
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:protocolMessage];
        [message addAttribute:NSFontAttributeName value:footerFont range:fullRange];
        [message addAttribute:NSForegroundColorAttributeName value:normalColor range:fullRange];
        
        [message addAttribute:NSFontAttributeName value:footerBoldFont range:protocolRange];
        [message addAttribute:NSForegroundColorAttributeName value:highlightColor range:protocolRange];
        
        CGFloat footerTopMargin = 15;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageSize.width, footerTopMargin + messageSize.height)];
        contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, footerTopMargin, self.tableView.frame.size.width, messageSize.height)];
        messageLabel.numberOfLines = 0;
        messageLabel.attributedText = message;
        [contentView addSubview:messageLabel];
        
        self.tableView.tableFooterView = contentView;
    }
    else
    {
        self.tableView.tableFooterView = nil;
    }
}

- (void)loadDetails
{
    if (!self.ticketNumber)
    {
        [self stopLoading];
        [self showEmptyViewWithMessage:REQUEST_ERROR];
        return;
    }
    
    [self hideEmptyView];
    [self hideContent];
    [self startLoading];
    
    [[ExtendedWarrantyConnection alloc] getExtendedWarrantyDetailForTicketNumber:self.ticketNumber completionBlock:^(ExtendedWarrantyDetail *warranty) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.warranty = warranty;
            
            [self setWarrantyState];
            [self stopLoading];
            [self setupInterfaceForExtendedWarranty];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == 401) {
                [self presentLoginWithCompletionBlock:^{
                    [self stopLoading];
                } successBlock:^{
                    [self loadDetails];
                } dismissBlock:^{
                    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                }];
            }
            else {
                [self stopLoading];
                [self showEmptyViewWithMessage:error.localizedDescription];
            }
        });
    }];
}

- (void)setupInterfaceForExtendedWarranty
{
    WarrantyState state = self.warranty.state.integerValue;
    
    //We set empty spaces when there's no content in order to autolayout maintain the size one line
    //This is a story requirement
    self.ticketNumberLabel.text = self.warranty.ticketNumber ?: @" ";
    self.warrantyNameLabel.text = self.warranty.descriptionText ?: @" ";
    self.showAuthorizationTerm = self.warranty.enrollmentPdf.length > 0 ? YES : NO;
    
    self.productImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:self.warranty.urlImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.productImage.contentMode = UIViewContentModeScaleAspectFit;
        if (!image)
        {
            self.productImage.contentMode = UIViewContentModeCenter;
            self.productImage.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME];
        }
    }];
    
    self.enrollmentDateTitle.text = EXTENDED_WARRANTY_DETAIL_ENROLLMENT_TITLE;
    self.enrollmentDateLabel.text = self.warranty.enrollmentDate ? [self.warranty.enrollmentDate formattedDateWithFormat:@"dd/MM/YYYY"] : @" ";
    
    if (state == WarrantyStateCanceled)
    {
        self.startDateTitle.text = EXTENDED_WARRANTY_DETAIL_CANCEL_TITLE;
        self.startDateLabel.text = self.warranty.rescissionDate ? [self.warranty.rescissionDate formattedDateWithFormat:@"dd/MM/YYYY"] : @" ";
    }
    else
    {
        self.startDateTitle.text = EXTENDED_WARRANTY_DETAIL_START_DATE_TITLE;
        NSString *dateBegin = self.warranty.startDate ? [self.warranty.startDate formattedDateWithFormat:@"dd/MM/YYYY"] : @" ";
        NSString *dateEnd = self.warranty.expirationDate ? [self.warranty.expirationDate formattedDateWithFormat:@"dd/MM/YYYY"] : @" ";
        self.startDateLabel.text = [NSString stringWithFormat:@"%@ até %@", dateBegin, dateEnd];
    }
    
    self.addressTitle.text = EXTENDED_WARRANTY_DETAIL_ADDRESS_TITLE;
    self.addressLabel.text = self.warranty.address.fullAddress;
    
    NSNumberFormatter *formatter = [[OFFormatter sharedInstance] currencyFormatter];
    self.totalLabel.text = [NSString stringWithFormat:EXTENDED_WARRANTY_DETAIL_VALUE_TITLE, [formatter stringFromNumber:self.warranty.value]];

    [self.tableView reloadData];
    [self setupFooter];
    [self updateTableViewBottomConstraint];
    [self showContent];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WarrantyState state = self.warranty.state.integerValue;
    NSInteger rows = 0;
    if (state == WarrantyStateCancelling)
    {
        rows = (self.showAuthorizationTerm) ? 2 : 1;
    }
    else if (self.warranty.cancelable)
    {
        rows = (self.showAuthorizationTerm) ? 3 : 2;
    }
    else
    {
        rows = (self.showAuthorizationTerm) ? 2 : 1;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExtendedWarrantyOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    WarrantyState state = self.warranty.state.integerValue;
    
    switch (indexPath.row)
    {
        case 0:
            [cell setupWithOptionType:OptionTypeTicket];
            break;
            
        case 1:
            if (self.showAuthorizationTerm)
            {
                [cell setupWithOptionType:OptionTypeAuthorizationTerm];
            }
            else
            {
                if (state == WarrantyStateCanceled) [cell setupWithOptionType:OptionTypeCancelled];
                else if (state == WarrantyStateNormal) [cell setupWithOptionType:OptionTypeCancel];
            }
            break;
            
        case 2:
            if (state == WarrantyStateCanceled) [cell setupWithOptionType:OptionTypeCancelled];
            else if (state == WarrantyStateNormal) [cell setupWithOptionType:OptionTypeCancel];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WarrantyState state = self.warranty.state.integerValue;
    
    switch (indexPath.row)
    {
        case 0:
            self.pdfViewer = [[WMPDFViewerViewController alloc] initWithPDFURLStr:self.warranty.ticketPdf title:EXTENDED_WARRANTY_PDF_TICKET_TITLE];
            [self.navigationController pushViewController:self.pdfViewer animated:YES];
            break;
            
        case 1:
            if (self.showAuthorizationTerm)
            {
                self.pdfViewer = [[WMPDFViewerViewController alloc] initWithPDFURLStr:self.warranty.enrollmentPdf title:EXTENDED_WARRANTY_PDF_ENROLLMENT_TITLE];
                [self.navigationController pushViewController:self.pdfViewer animated:YES];
            }
            else
            {
                [self actionForState:state];
            }
            break;
            
        case 2:
            [self actionForState:state];
            break;
            
        default:
            break;
    }
}

- (void)actionForState:(WarrantyState)state
{
    if (state == WarrantyStateCanceled)
    {
        self.pdfViewer = [[WMPDFViewerViewController alloc] initWithPDFURLStr:self.warranty.rescissionPdf title:EXTENDED_WARRANTY_PDF_RESCISSION_TITLE];
        [self.navigationController pushViewController:self.pdfViewer animated:YES];
    }
    else if (state == WarrantyStateNormal)
    {
        [self cancelWarranty];
    }
}

#pragma mark - Cancel Warranty
- (void)cancelWarranty
{
    CancelWarrantyViewController *cancelController = [[CancelWarrantyViewController alloc] initWithNibName:@"CancelWarrantyViewController" bundle:nil];
    cancelController.warranty = self.warranty;
    cancelController.delegate = self;
    [self.navigationController pushViewController:cancelController animated:YES];
}

#pragma mark - Cancel Controller Delegate
- (void)cancelExtendedWarrantyWillPopBack
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setWarrantyState];
        [self setupInterfaceForExtendedWarranty];
    });
}

- (void)didCancelExtendedWarrantyWithSuccess:(ExtendedWarrantyCancelTicket *)cancelTicket
{
    [self.view showFeedbackAlertOfKind:SuccessAlert message:EXTENDED_WARRANTY_CANCEL_SUCCESS];
    
}

#pragma mark - Hide/Show content
- (void)hideContent
{
    self.ticketIconImageView.hidden = YES;
    self.ticketNumberLabel.hidden = YES;
    self.ticketNumberTitleLabel.hidden = YES;
    self.warrantyCard.hidden = YES;
    self.tableView.hidden = YES;
}

- (void)showContent
{
    self.ticketIconImageView.hidden = NO;
    self.ticketNumberLabel.hidden = NO;
    self.ticketNumberTitleLabel.hidden = NO;
    self.warrantyCard.hidden = NO;
    self.tableView.hidden = NO;
}

#pragma mark - Loading
- (void)startLoading
{
    self.scrollView.userInteractionEnabled = NO;
    [self hideContent];
    [self.view showLoading];
}

- (void)stopLoading
{
    self.scrollView.userInteractionEnabled = YES;
    [self.view hideLoading];
}

#pragma mark - EmptyView
- (void)showEmptyViewWithMessage:(NSString *)message
{
    self.scrollView.userInteractionEnabled = NO;
    if (!self.emptyView)
    {
        self.emptyView = [[RetryErrorView alloc] initWithMsg:message];
        self.emptyView.delegate = self;
        [self.view addSubview:self.emptyView];
    }
    
    [self hideContent];
    self.emptyView.hidden = NO;
}

- (void)hideEmptyView
{
    self.scrollView.userInteractionEnabled = YES;
    if (self.emptyView)
    {
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
}

- (void)retry
{
    [self loadDetails];
}

#pragma mark - State control
- (void)setWarrantyState
{
    BOOL cancelled = (self.warranty.cancelled) ? self.warranty.cancelled.boolValue : NO;
    if (cancelled)
    {
        self.warranty.state = @(WarrantyStateCanceled);
        
        //Should we remove a possible ticket as we notice the extended warranty is cancelled?
        [ExtendedWarrantyCancelManager removeTicketForWarrantyNumber:self.warranty.ticketNumber];
    }
    else
    {
        if ([self isWarrantyInProcessToCancel])
        {
            self.warranty.state = @(WarrantyStateCancelling);
        }
        else
        {
            self.warranty.state = @(WarrantyStateNormal);
        }
    }
}

- (BOOL)isWarrantyInProcessToCancel
{
    return [ExtendedWarrantyCancelManager isTicketOpenForWarrantyNumber:self.warranty.ticketNumber];
}

#pragma mark - Contraints
- (void)updateTableViewBottomConstraint
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    CGFloat rowSize = self.tableView.rowHeight;
    NSInteger size = rows * rowSize;
    
    WarrantyState state = self.warranty.state.integerValue;
    if (state == WarrantyStateCancelling)
    {
        size += self.tableView.tableFooterView.frame.size.height;
    }
    self.tableViewHeightConstraint.constant = size;
}

@end
