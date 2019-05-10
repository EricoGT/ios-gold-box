//
//  WBRContactTicketTableViewCell.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/15/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketTableViewCell.h"
#import "WBRContactTicketProductCollectionViewCell.h"
#import "WBRContactTicketStatusView.h"

@interface WBRContactTicketTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *containerBorderView;
@property (weak, nonatomic) IBOutlet WBRContactTicketStatusView *ticketStatusView;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumber;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (weak, nonatomic) IBOutlet UILabel *ticketSubject;

@property (weak, nonatomic) IBOutlet UIView *productsContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productsCollectionViewHeightConstraint;

@property (weak, nonatomic) IBOutlet WBRContactTicketProductCollectionViewCell *product1;
@property (weak, nonatomic) IBOutlet WBRContactTicketProductCollectionViewCell *product2;
@property (weak, nonatomic) IBOutlet WBRContactTicketProductCollectionViewCell *product3;
@property (weak, nonatomic) IBOutlet WBRContactTicketProductCollectionViewCell *moreProductsView;

@property (weak, nonatomic) IBOutlet UIView *footerContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerContainerViewHeightContraint;

@property (weak, nonatomic) IBOutlet UIView *openTicketContainerView;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerOpenedTicketContainerConstraint;

@property (weak, nonatomic) IBOutlet UIButton *lookMessageClosedTicketBtn;
@property (weak, nonatomic) IBOutlet UIView *reopenTicketCloseContainerViewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reopenTicketCloseContainerViewButtonContainerConstraint;

@property (weak, nonatomic) IBOutlet UIView *closedTicketContainerView;
@property (weak, nonatomic) IBOutlet UIButton *reopenTicketBtn;
@property (weak, nonatomic) IBOutlet UIView *lookMessagesBtnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lookMessagesBtnViewContainerConstraint;

@property (weak, nonatomic) IBOutlet UIView *sellerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellerViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;

@property (strong, nonatomic) WBRModelTicket *ticket;

@end

CGFloat const sellerLabelHeightConstant = 13.0;
CGFloat const sellerLabelTopConstant = 5.0;
CGFloat const productsCollectionHeight = 72.0;

// Footer View Container
CGFloat const kFooterContainerTicketClosedHeight = 47.0;
CGFloat const kFooterContainerTicketOpenHeight   = 138.0;
CGFloat const kFooterContainerTicketOpenWithoutMessageButtonHeight = 85.0;

/// Footer: Open Ticket View Button
CGFloat const kLookMessagesBtnViewContainerHeight = 53.0;


/// Footer - Closed Ticket View Button
CGFloat const kReopenClosedTicketViewButtonWidth = 150.0;
CGFloat const kFooterClosedTicketViewContainerHeight = 42.0;


@implementation WBRContactTicketTableViewCell

+ (NSString *)reusableIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupLayoutBorderCell];
    [self resetProductsLayout];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.footerContainerView setHidden:NO];
    [self.reopenTicketBtn setHidden:NO];
    [self.openTicketContainerView setHidden:NO];
    self.footerContainerViewHeightContraint.constant = kFooterContainerTicketOpenHeight;
    
    self.sellerViewHeightConstraint.constant = sellerLabelHeightConstant;
    self.sellerViewTopConstraint.constant = sellerLabelTopConstant;

    [self resetProductsLayout];
    
    [self layoutIfNeeded];
}

- (void)setupLayoutBorderCell {
    [self.containerBorderView.layer setCornerRadius:4];
    [self.containerBorderView.layer setMasksToBounds:YES];
    [self.containerBorderView.layer setBorderWidth:1.f];
    [self.containerBorderView.layer setBorderColor:RGBA(204, 204, 204, 1).CGColor];
}

- (void)resetProductsLayout {
    [self.product1 resetLayout];
    [self.product2 resetLayout];
    [self.product3 resetLayout];
    [self.moreProductsView resetLayout];
    [self.productsContainer setHidden:NO];
    
    self.productsCollectionViewHeightConstraint.constant = productsCollectionHeight;
}

- (void)setDate:(NSString *)dateString inField:(UILabel *)dateLabel {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSDate *date = [formatter dateFromString:dateString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSString *stringDate = [NSString stringWithFormat:@"%li/%li/%li", (long)components.day, (long)components.month, (long)components.year];
    dateLabel.text = stringDate;
}

- (void)setProductsInView {
    if (self.ticket.orderImages) {
        if (self.ticket.orderImages.count > 0) {
            WBRModelOrderImages *item = self.ticket.orderImages[0];
            [self.product1 setupProductCellWithImage:item.imageUrl];
        }

        if (self.ticket.orderImages.count > 1) {
            WBRModelOrderImages *item = self.ticket.orderImages[1];
            [self.product2 setupProductCellWithImage:item.imageUrl];
        }

        if (self.ticket.orderImages.count > 2) {
            WBRModelOrderImages *item = self.ticket.orderImages[2];
            [self.product3 setupProductCellWithImage:item.imageUrl];
        }

        if (self.ticket.orderImages.count > 3) {
            NSNumber *numberOfMoreProducts = [NSNumber numberWithInteger:(self.ticket.orderImages.count-3)];
            [self.moreProductsView setupProdutCellWithNumberOfMoreProducts:numberOfMoreProducts];
        }
    } else {
        [self.productsContainer setHidden:YES];
        self.productsCollectionViewHeightConstraint.constant = 0.0f;
    }
}

#pragma mark IBActions
- (IBAction)reopenTicket:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reopenTicketTouched:)]) {
        [WMOmniture trackReopenTicket];
        [self.delegate reopenTicketTouched:self.ticket.ticketId.stringValue];
    }
}

- (IBAction)closeTicket:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeTicketTouched:)]) {
        [self.delegate closeTicketTouched:self.ticket.ticketId.stringValue];
    }
}

- (IBAction)openTicketMessages:(id)sender {
    if ([self.delegate respondsToSelector:@selector(openTicketMessagesTouched:)]) {
        [self.delegate openTicketMessagesTouched:self.ticket];
    }
}

#pragma mark - Public Methods
- (void)setupCellWithCollection:(WBRModelTicket *)ticket {
    
    self.ticket = ticket;
    self.ticketNumber.text = self.ticket.ticketId.stringValue;
    self.ticketSubject.text = self.ticket.ticketDescription;

    [self.ticketStatusView setupViewWithStatus:self.ticket.status];
    [self setDate:self.ticket.creationDate inField:self.creationDate];

    
    [self setProductsInView];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
        if (self.ticket.seller && self.ticket.seller.name && ![self.ticket.seller.name isEqualToString:@""]) {
            self.sellerView.hidden = NO;
            self.sellerLabel.hidden = NO;
            self.sellerNameLabel.text = self.ticket.seller.name;
            self.sellerViewHeightConstraint.constant = sellerLabelHeightConstant;
            self.sellerViewTopConstraint.constant = sellerLabelTopConstant;
        }
        else {
            self.sellerView.hidden = YES;
            self.sellerLabel.hidden = YES;
            self.sellerViewHeightConstraint.constant = 0;
            self.sellerViewTopConstraint.constant = 0;
        }
    }];
    
    [self setupFooterContainer:self.ticket.status canBeReopened:self.ticket.canBeReopened commentsVisible:[self.ticket.commentsVisible boolValue]];
}

- (void)setupFooterContainer:(NSString *)ticketStatus canBeReopened:(BOOL)canBeReopened commentsVisible:(BOOL)commentsVisible{

    if ([ticketStatus isEqualToString:kTicketOpenedStatus]) {
        [self showOpenedTicketContainerView:YES];
        [self.closedTicketContainerView setHidden:YES];
        [self setDate:self.ticket.dueDate inField:self.dueDateLabel];
        [self showBigMessagesButton:commentsVisible];

    } else  if ((!canBeReopened) && (!commentsVisible)) {
        [self showOpenedTicketContainerView:NO];
        [self showClosedTicketContainerView:NO];
        
        [self.footerContainerView setHidden:YES];
        self.footerContainerViewHeightContraint.constant = 0.0f;

    } else if (!canBeReopened) {
        [self showOpenedTicketContainerView:NO];
        [self showClosedTicketContainerView:YES];
        
        [self.reopenTicketCloseContainerViewButton setHidden:YES];
        self.reopenTicketCloseContainerViewButtonContainerConstraint.constant = 0;
        
        [self.lookMessageClosedTicketBtn setHidden:NO];
        
    } else if (!commentsVisible) {
        [self showOpenedTicketContainerView:NO];
        [self showClosedTicketContainerView:YES];
        
        [self.reopenTicketCloseContainerViewButton setHidden:NO];
        self.reopenTicketCloseContainerViewButtonContainerConstraint.constant = kReopenClosedTicketViewButtonWidth;
        
        [self.lookMessageClosedTicketBtn setHidden:YES];
    } else {
        [self showOpenedTicketContainerView:NO];
        [self showClosedTicketContainerView:YES];

        [self.lookMessageClosedTicketBtn setHidden:NO];

        [self.reopenTicketCloseContainerViewButton setHidden:NO];
        self.reopenTicketCloseContainerViewButtonContainerConstraint.constant = kReopenClosedTicketViewButtonWidth;
    }
    [self layoutIfNeeded];
    
}

#pragma mark Helpers - Containers Size
- (void)showClosedTicketContainerView:(BOOL)show {
    if (show) {
        [self.closedTicketContainerView setHidden:NO];
        self.footerOpenedTicketContainerConstraint.constant = kFooterContainerTicketClosedHeight;
        self.footerContainerViewHeightContraint.constant = kFooterContainerTicketClosedHeight;

    } else {
        [self.openTicketContainerView setHidden:YES];
        self.footerOpenedTicketContainerConstraint.constant = kFooterContainerTicketOpenHeight;
        self.footerContainerViewHeightContraint.constant = kFooterContainerTicketOpenHeight;
    }
    [self layoutIfNeeded];
}

- (void)showOpenedTicketContainerView:(BOOL)show {
    if (show) {
        [self.openTicketContainerView setHidden:NO];
        self.footerOpenedTicketContainerConstraint.constant = kFooterContainerTicketOpenHeight;
        self.footerContainerViewHeightContraint.constant = kFooterContainerTicketOpenHeight;
    } else {
        [self.openTicketContainerView setHidden:YES];
        self.footerOpenedTicketContainerConstraint.constant = kFooterContainerTicketClosedHeight;
        self.footerContainerViewHeightContraint.constant = kFooterContainerTicketClosedHeight;
    }
    [self layoutIfNeeded];
}

- (void)showBigMessagesButton:(BOOL)showButton {
    if (showButton) {
        [self.lookMessagesBtnView setHidden:NO];
        self.lookMessagesBtnViewContainerConstraint.constant = kLookMessagesBtnViewContainerHeight;
        self.footerContainerViewHeightContraint.constant = kFooterContainerTicketOpenHeight;
    } else {
        [self.lookMessagesBtnView setHidden:YES];
        self.lookMessagesBtnViewContainerConstraint.constant = 0;
        self.footerContainerViewHeightContraint.constant = kFooterContainerTicketOpenWithoutMessageButtonHeight;
    }
    [self layoutIfNeeded];
}

@end
