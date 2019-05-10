//
//  WBRContactTicketStatusView.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/18/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketStatusView.h"
#import "WBRContactTicketUtils.h"

@interface WBRContactTicketStatusView()

@property (weak, nonatomic) IBOutlet UILabel *statusDescription;
@property (weak, nonatomic) IBOutlet UIView *statusContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthViewConstraint;

@property (strong, nonatomic) NSString *ticketStatus;

@end

CGFloat const openStatusWidth = 109.0;
CGFloat const closedStatusWith = 73.0;
CGFloat const canceledStatusWith = 100.0;

@implementation WBRContactTicketStatusView

- (void)setupViewWithStatus:(NSString *)status {
    self.ticketStatus = status;
    if ([self.ticketStatus isEqualToString:kTicketClosedStatus]) {
        [self setupClosedStatusLayout];
    }  else if ([self.ticketStatus isEqualToString:kTicketCanceledStatus]) {
        [self setupCanceledStatusLayout];
    }  else {
        [self setupOpenStatusLayout];
    }
    
    [self.statusContainer.layer setCornerRadius:3];
}

- (void)setupOpenStatusLayout {
    [self.statusContainer setBackgroundColor:RGB(255, 152, 0)];
    self.statusDescription.text = @"Em atendimento";
    [self.statusDescription setTextColor:[UIColor whiteColor]];
    self.widthViewConstraint.constant = openStatusWidth;
}

- (void)setupClosedStatusLayout {
    [self.statusContainer setBackgroundColor:RGBA(33, 150, 243, .1)];
    self.statusDescription.text = @"Concluído";
    [self.statusDescription setTextColor:RGB(155, 155, 155)];
    self.widthViewConstraint.constant = closedStatusWith;
}

- (void)setupCanceledStatusLayout {
    [self.statusContainer setBackgroundColor:RGBA(255, 235, 238, 1)];
    self.statusDescription.text = @"Cancelado";
    [self.statusDescription setTextColor:RGB(155, 155, 155)];
    self.widthViewConstraint.constant = canceledStatusWith;
}
    
@end
