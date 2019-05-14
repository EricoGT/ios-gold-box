//
//  ContactRequestViewController.h
//  Walmart
//
//  Created by Renan on 6/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WALMenuItemViewController.h"
#import "ContactRequestPinnedView.h"

@protocol ContactRequestDelegate <NSObject>
@optional
- (void)contactRequestSentWithTicketNumber:(NSString *)ticketNumber;
- (void)thankyouPageTicketFinish;
- (void)thankyouPageTicketListTouched;
@end

@class WMPickerTextField, WMPlaceholderTextView, WBRContactRequestFormModel, WBRContactRequestDeliveryModel, WBRContactRequestTypeModel, WBRContactRequestSubjectModel, WBRContactRequestOrderModel, ExchangeFormPinnedView, WBRContactRequestConnection, WMLoginViewController, WMFloatLabelMaskedTextField, FormAlertView;

@interface ContactRequestViewController : WALMenuItemViewController

- (id)initFromMenu:(BOOL)fromMenu andThankyouPageSuccessButtonTitle:(NSString *)buttonTitle;

@property (weak) id <ContactRequestDelegate> delegate;

@end
