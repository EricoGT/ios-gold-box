//
//  AddressViewController.h
//  Walmart
//
//  Created by Renan on 5/20/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"
#import "AddressModel.h"
#import "FeedbackAlertView.h"
#import "WMFloatLabelMaskedTextField.h"
#import "WMPickerTextField.h"
#import "WMButtonRounded.h"

@interface AddressViewController : WMBaseViewController

@property (nonatomic, assign, getter=isFirstAddress) BOOL firstAddress;
@property (nonatomic, assign, getter=isEditingAddress) BOOL editingAddress;

@property (nonatomic, strong) AddressModel *address;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *zipCodeTextField;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *receiverNameTextField;
@property (nonatomic, weak) IBOutlet WMPickerTextField *addressTypeTextField;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *streetTextField;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *neighborhoodTextField;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *numberTextField;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *complementTextField;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *cityTextField;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *stateTextField;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *referenceTextField;
@property (nonatomic, weak) IBOutlet WMFloatLabelMaskedTextField *addressNameTextField;
@property (nonatomic, weak) IBOutlet WMButtonRounded *actionButton;

@property (nonatomic, strong) NSString *alertMsg;

- (AddressViewController *)initWithAddress:(AddressModel *)address;

- (void)updateAddressWithModel:(AddressModel *)address;
- (NSArray *)validateAndGetInvalidFields;
- (void)setUp;

@end
