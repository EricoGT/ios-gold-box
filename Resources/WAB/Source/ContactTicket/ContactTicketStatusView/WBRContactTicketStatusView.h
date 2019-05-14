//
//  WBRContactTicketStatusView.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/18/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kTicketClosedStatus;
extern NSString *const kTicketCanceledStatus;
extern NSString *const kTicketOpenedStatus;

@interface WBRContactTicketStatusView : WMView

- (void)setupViewWithStatus:(NSString *)status;

@end
