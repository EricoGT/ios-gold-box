//
//  WMBankingTicket.h
//  Walmart
//
//  Created by Marcelo Santos on 6/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMBankingTicketDelegate <NSObject>
- (void)finishOrderWithBankingTicket;
@end

@interface WMBankingTicket : WMBaseViewController

@property (nonatomic, weak) id<WMBankingTicketDelegate> delegate;

- (void)feedContentLabels:(NSDictionary *) dictContent;
- (CGFloat)containerHeight;

@end
