//
//  WBRContactTicketTableViewCell.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/15/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRModelTicket.h"

@protocol WBRContactTicketTableViewCellDelegate <NSObject>
@optional
- (void)reopenTicketTouched:(NSString *)ticketId;
- (void)openTicketMessagesTouched:(WBRModelTicket *)ticket;
- (void)closeTicketTouched:(NSString *)ticketId;
@end

@interface WBRContactTicketTableViewCell : UITableViewCell

+ (NSString *)reusableIdentifier;
@property (weak) id <WBRContactTicketTableViewCellDelegate> delegate;

- (void)setupCellWithCollection:(WBRModelTicket *)tickets;
- (void)setDate:(NSString *)dateString inField:(UILabel *)dateLabel;

@end
