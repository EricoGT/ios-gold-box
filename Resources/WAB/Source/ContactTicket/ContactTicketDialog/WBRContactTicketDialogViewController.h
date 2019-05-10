//
//  WBRContactReopenTicketDialogViewController.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 16/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBRContactTicketDialogViewControllerDelegate <NSObject>
@required
- (void)didDismissTicketDialogViewController;
@optional
- (void)didSuccessContactTicketReopened;
- (void)didSuccessContactTicketClosed;
@end

@interface WBRContactTicketDialogViewController : UIViewController
@property (weak) id <WBRContactTicketDialogViewControllerDelegate> delegate;

- (instancetype)initReopenDialogWithTicketId:(NSString *)ticketId;
- (instancetype)initCloseDialogWithTicketId:(NSString *)ticketId;


@end
