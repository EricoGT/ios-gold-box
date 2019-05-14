//
//  CancelWarrantyViewController.m
//  Walmart
//
//  Created by Bruno on 6/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "CancelWarrantyViewController.h"
#import "WMFloatLabelMaskedTextField.h"
#import "WMButtonRounded.h"
#import "WMPickerTextField.h"
#import "UIImage+Additions.h"
#import "OFMessages.h"
#import "Bank.h"
#import "ExtendedWarrantyCancelData.h"
#import "CancelOption.h"
#import "UIImageView+WebCache.h"
#import "NSDate+DateTools.h"
#import "ExtendedWarrantyConnection.h"
#import "FeedbackColor.h"

@interface CancelWarrantyViewController () <UITextFieldDelegate, WMPickerTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *warrantyCard;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *documentTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonBottomContraint;

@property (strong, nonatomic) NSArray *reasonsArray;
@property (strong, nonatomic) NSArray *optionsArray;
@property (strong, nonatomic) NSArray *bankAccountArray;
@property (strong, nonatomic) NSArray *banksArray;

@property (nonatomic, strong) NSString *alertMsg;
@property (nonatomic, strong) Bank *currentBank;

- (IBAction)sendPressed;

@end

@implementation CancelWarrantyViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    @try {
        [self removeObserver:self forKeyPath:@"state" context:nil];
    }
    @catch(id anException) {
        return;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUp];
    [self fillExtendedWarrantyCard];
    
    self.state = FormStateInitial;
    [self loadCancelData];
}

#pragma mark - Setup
- (void)setUp
{
    self.title = EXTENDED_WARRANTY_CANCEL_TITLE;
    
    //Custom gestures
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizedInScrollView)];
    tapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGesture];

    self.warrantyCard.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.warrantyCard.layer.borderWidth = 1.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)fillExtendedWarrantyCard
{
    //We set empty spaces when there's no content in order to autolayout maintain the size one line
    self.ticketNumberLabel.text = self.warranty.ticketNumber ?: @" ";
    self.warrantyNameLabel.text = self.warranty.descriptionText ?: @" ";
    
    self.productImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:self.warranty.urlImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.productImage.contentMode = UIViewContentModeScaleAspectFit;
        if (!image) {
            self.productImage.contentMode = UIViewContentModeCenter;
            self.productImage.image = [UIImage imageNamed:IMAGE_UNAVAILABLE_NAME];
        }
    }];
    
    self.enrollmentDateTitle.text = EXTENDED_WARRANTY_DETAIL_ENROLLMENT_TITLE;
    self.enrollmentDateLabel.text = self.warranty.enrollmentDate ? [self.warranty.enrollmentDate formattedDateWithFormat:@"dd/MM/YYYY"] : @" ";
    
    self.startDateTitle.text = EXTENDED_WARRANTY_DETAIL_START_DATE_TITLE;
    NSString *dateBegin = self.warranty.startDate ? [self.warranty.startDate formattedDateWithFormat:@"dd/MM/YYYY"] : @" ";
    NSString *dateEnd = self.warranty.expirationDate ? [self.warranty.expirationDate formattedDateWithFormat:@"dd/MM/YYYY"] : @" ";
    self.startDateLabel.text = [NSString stringWithFormat:@"%@ até %@", dateBegin, dateEnd];
}

#pragma mark - Services
- (void)loadCancelData
{
    [self showLoading];
    [[ExtendedWarrantyConnection new] getExtendedWarrantiesCancelOptionsForOrderNumber:self.warranty.orderNumber completionBlock:^(ExtendedWarrantyCancelData *cancelData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reasonsArray = cancelData.reason;
            self.optionsArray = cancelData.option;
            self.bankAccountArray = @[EXTENDED_WARRANTY_BANK_ACCOUNT_YES, EXTENDED_WARRANTY_BANK_ACCOUNT_NO];
            self.banksArray = cancelData.banks;
            [self setUpPickers];
            self.state = FormStateInitial;
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == 401) {
                [self presentLoginWithCompletionBlock:^{
                    [self hideLoading];
                } successBlock:^{
                    [self loadCancelData];
                } dismissBlock:^{
                    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                }];
            }
            else {
                [self showRequestError:error.localizedDescription];
            }
        });
    }];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    FormState newValue = [[change valueForKey:@"new"] integerValue];
    switch (newValue)
    {
        case FormStateInitial:
            [self setStateInitial];
            break;
        case FormStateChoosingRefundPossibilities:
            [self setStateChoosingRefundPossibilities];
            break;
        case FormStateBankRefund:
            [self setStateBankRefund];
            break;
        case FormStateDocumentRefund:
            [self setStateDocumentRefund];
            break;
            
        default:
            [self setStateInitial];
            break;
    }
}

#pragma Mark - Form states
//There's no need to call the state methods directly. KVO on 'state' variable will take care of everything
- (void)setStateInitial
{
    self.loader.hidden = YES;
    
    self.reasonTextField.hidden = NO;
    self.optionTextField.hidden = NO;
    self.bankAccountTextField.hidden = YES;
    self.bankNameTextField.hidden = YES;
    self.agencyTextField.hidden = YES;
    self.accountTextField.hidden = YES;
    self.documentTextField.hidden = YES;
    self.footerLabel.hidden = YES;
    self.sendButton.hidden = NO;
    
    [self updateContentSizeForLastElement:self.optionTextField];
}

- (void)setStateChoosingRefundPossibilities
{
    self.loader.hidden = YES;
    
    self.reasonTextField.hidden = NO;
    self.optionTextField.hidden = NO;
    self.bankAccountTextField.hidden = NO;
    self.bankNameTextField.hidden = YES;
    self.agencyTextField.hidden = YES;
    self.accountTextField.hidden = YES;
    self.documentTextField.hidden = YES;
    self.footerLabel.hidden = YES;
    self.sendButton.hidden = NO;
    
    [self updateContentSizeForLastElement:self.bankAccountTextField];
}

- (void)setStateDocumentRefund
{
    self.loader.hidden = YES;
    
    self.reasonTextField.hidden = NO;
    self.optionTextField.hidden = NO;
    self.bankAccountTextField.hidden = NO;
    self.bankNameTextField.hidden = YES;
    self.agencyTextField.hidden = YES;
    self.accountTextField.hidden = YES;
    self.documentTextField.hidden = NO;
    self.footerLabel.hidden = NO;
    self.footerLabel.text = EXTENDED_WARRANTY_REFUND_DOCS_MESSAGE;
    self.sendButton.hidden = NO;
    
    [self updateContentSizeForLastElement:self.footerLabel];
}

- (void)setStateBankRefund
{
    self.loader.hidden = YES;
    
    self.reasonTextField.hidden = NO;
    self.optionTextField.hidden = NO;
    self.bankAccountTextField.hidden = NO;
    self.bankNameTextField.hidden = NO;
    self.agencyTextField.hidden = NO;
    self.accountTextField.hidden = NO;
    self.documentTextField.hidden = YES;
    self.footerLabel.hidden = NO;
    self.footerLabel.text = EXTENDED_WARRANTY_REFUND_BANK_MESSAGE;
    self.sendButton.hidden = NO;
    
    [self updateContentSizeForLastElement:self.footerLabel];
}

#pragma mark - Loading
- (void)showLoading
{
    self.loader.hidden = NO;
    [self.loader startAnimating];
    
    self.reasonTextField.hidden = YES;
    self.optionTextField.hidden = YES;
    self.bankAccountTextField.hidden = YES;
    self.bankNameTextField.hidden = YES;
    self.agencyTextField.hidden = YES;
    self.accountTextField.hidden = YES;
    self.documentTextField.hidden = YES;
    self.footerLabel.hidden = YES;
    self.sendButton.hidden = YES;
    
    [self updateContentSizeForLastElement:self.warrantyCard];
}

- (void)hideLoading
{
    self.loader.hidden = NO;
}

#pragma mark - Text Fields delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return ((textField == self.accountTextField) || (textField == self.agencyTextField) || (textField == self.documentTextField)) ? YES : NO;
}

- (NSArray *)validateAndGetInvalidFields
{
    self.alertMsg = nil;
    NSMutableArray *invalidFields = [NSMutableArray new];
    
    if (self.reasonTextField.text.length == 0 && self.reasonTextField.hidden == NO)
    {
        if (!self.alertMsg) self.alertMsg = EXTENDED_WARRANTY_WARNING_REASON;
        [invalidFields addObject:self.reasonTextField];
    }
    
    if (self.optionTextField.text.length == 0 && self.optionTextField.hidden == NO)
    {
        if (!self.alertMsg) self.alertMsg = EXTENDED_WARRANTY_WARNING_OPTION;
        [invalidFields addObject:self.optionTextField];
    }
    
    if (self.bankAccountTextField.text.length == 0 && self.bankAccountTextField.hidden == NO)
    {
        if (!self.alertMsg) self.alertMsg = EXTENDED_WARRANTY_WARNING_ACCOUNT_OPTION;
        [invalidFields addObject:self.bankAccountTextField];
    }
    
    if (self.bankNameTextField.text.length == 0 && self.bankNameTextField.hidden == NO)
    {
        if (!self.alertMsg) self.alertMsg = EXTENDED_WARRANTY_WARNING_BANK;
        [invalidFields addObject:self.bankNameTextField];
    }
    
    if (self.agencyTextField.text.length == 0 && self.agencyTextField.hidden == NO)
    {
        if (!self.alertMsg) self.alertMsg = EXTENDED_WARRANTY_WARNING_AGENCY;
        [invalidFields addObject:self.agencyTextField];
    }
    
    if (self.accountTextField.text.length == 0 && self.accountTextField.hidden == NO)
    {
        if (!self.alertMsg) self.alertMsg = EXTENDED_WARRANTY_WARNING_ACCOUNT;
        [invalidFields addObject:self.accountTextField];
    }
    
    if (self.documentTextField.text.length == 0 && self.documentTextField.hidden == NO)
    {
        if (!self.alertMsg) self.alertMsg = EXTENDED_WARRANTY_WARNING_DOCUMENT;
        [invalidFields addObject:self.documentTextField];
    }
    
    return invalidFields.copy;
}

- (void)unvalidateFields
{
    for (id view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[WMFloatLabelMaskedTextField class]])
        {
            WMFloatLabelMaskedTextField *textField = (WMFloatLabelMaskedTextField *)view;
            textField.layer.borderColor = [textField defaultBorderColor];
        }
    }
}

#pragma mark - Pickers
- (void)setUpPickers
{
    self.reasonTextField.options = self.reasonsArray;
    self.reasonTextField.wmPickerTextFieldDelegate = self;
    
    self.optionTextField.options = [self.optionsArray valueForKey:@"label"];
    self.optionTextField.wmPickerTextFieldDelegate = self;
    
    self.bankAccountTextField.options = self.bankAccountArray;
    self.bankAccountTextField.wmPickerTextFieldDelegate = self;
    
    NSMutableArray *banksList = [NSMutableArray new];
    for (Bank *eachBank in self.banksArray)
    {
        NSString *bankInformation = [NSString stringWithFormat:@"%@ - %@", eachBank.code, eachBank.name];
        [banksList addObject:bankInformation];
    }
    
    self.bankNameTextField.options = banksList.copy;
    self.bankNameTextField.wmPickerTextFieldDelegate = self;
}

#pragma mark - Picker Delegate
- (void)pickerTextField:(id)pickerTextField didFinishSelectingOption:(NSString *)option;
{
    [(WMPickerTextField *)pickerTextField setText:option];
    
    if (pickerTextField == self.optionTextField)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.label == %@", option];
        NSArray *selectedOptions = [self.optionsArray filteredArrayUsingPredicate:predicate];
        if (selectedOptions.count > 0)
        {
            [self.bankAccountTextField resetPicker];
            [self.bankNameTextField resetPicker];
            self.agencyTextField.text = @"";
            self.accountTextField.text = @"";
            
            CancelOption *option = (CancelOption *)selectedOptions.firstObject;
            BOOL refund = (option.refund) ? option.refund.boolValue : NO;
            self.state = (refund) ? FormStateChoosingRefundPossibilities : FormStateInitial;
        }
    }
    else if (pickerTextField == self.bankAccountTextField)
    {
        if ([option isEqualToString:EXTENDED_WARRANTY_BANK_ACCOUNT_YES])
        {
            self.documentTextField.text = @"";
            
            [self pinFooterToItem:self.agencyTextField];
            self.state = FormStateBankRefund;
        }
        else
        {
            [self.bankNameTextField resetPicker];
            self.agencyTextField.text = @"";
            self.accountTextField.text = @"";
            
            [self pinFooterToItem:self.documentTextField];
            [self pinDocumentToItem:self.bankAccountTextField];
            self.state = FormStateDocumentRefund;
        }
    }
}

- (void)pickerTextField:(id)pickerTextField didFinishSelectingIndex:(NSInteger)index
{
    if (pickerTextField == self.optionTextField)
    {
        CancelOption *option = self.optionsArray[index];
        BOOL refund = (option.refund) ? option.refund.boolValue : NO;
        self.state = (refund) ? FormStateChoosingRefundPossibilities : FormStateInitial;
    }
    else if (pickerTextField == self.bankNameTextField)
    {
        self.currentBank = self.banksArray[index];
    }
}

#pragma mark - Send
- (void)sendPressed
{
    [self.scrollView endEditing:YES];
    [self unvalidateFields];
    
    NSArray *invalidFields = [self validateAndGetInvalidFields];
    if (invalidFields.count == 0)
    {
        NSDictionary *infos;
        if ((self.state == FormStateInitial) || (self.state == FormStateChoosingRefundPossibilities))
        {
            infos = @{@"orderId" : self.warranty.orderNumber ?: @"",
                      @"ticketNumber" : self.warranty.ticketNumber ?: @"",
                      @"reason" : self.reasonTextField.text ?: @"",
                      @"option" : self.optionTextField.text ?: @""};
        }
        else if (self.state == FormStateBankRefund)
        {
            NSDictionary *bankDictionary = self.currentBank.toDictionary;
            infos = @{@"orderId" : self.warranty.orderNumber ?: @"",
                      @"ticketNumber" : self.warranty.ticketNumber ?: @"",
                      @"reason" : self.reasonTextField.text ?: @"",
                      @"option" : self.optionTextField.text ?: @"",
                      @"bank" : bankDictionary ?: @"",
                      @"agency" : self.agencyTextField.text ?: @"",
                      @"account" : self.accountTextField.text ?: @"",
                      @"agency" : self.agencyTextField.text ?: @"",
                      @"account" : self.accountTextField.text ?: @""};
        }
        else if (self.state == FormStateDocumentRefund)
        {
            infos = @{@"orderId" : self.warranty.orderNumber ?: @"",
                      @"ticketNumber" : self.warranty.ticketNumber ?: @"",
                      @"reason" : self.reasonTextField.text ?: @"",
                      @"option" : self.optionTextField.text ?: @"",
                      @"rg" : self.documentTextField.text ?: @""};
        }
        
        [self.navigationController.view showModalLoading];
        [[ExtendedWarrantyConnection new] cancelExtendedWarranty:infos completionBlock:^(NSNumber *protocol) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController.view hideModalLoading];
                
                ExtendedWarrantyCancelTicket *ticket = [ExtendedWarrantyCancelTicket new];
                ticket.warrantyNumber = self.warranty.ticketNumber;
                ticket.protocolNumber = protocol;
                [ExtendedWarrantyCancelManager addTicket:ticket];
                
                if ((self.delegate) && ([self.delegate respondsToSelector:@selector(cancelExtendedWarrantyWillPopBack)]))
                {
                    [self.delegate cancelExtendedWarrantyWillPopBack];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                if ((self.delegate) && ([self.delegate respondsToSelector:@selector(didCancelExtendedWarrantyWithSuccess:)]))
                {
                    [self.delegate didCancelExtendedWarrantyWithSuccess:ticket];
                }
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.code == 401) {
                    [self presentLoginWithCompletionBlock:^{
                        [self.navigationController.view hideModalLoading];
                    } successBlock:^{
                        [self sendPressed];
                    } dismissBlock:^{
                        [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
                    }];
                }
                else {
                    [self.navigationController.view hideModalLoading];
                    [self.view showFeedbackAlertOfKind:ErrorAlert message:EXTENDED_WARRANTY_CANCEL_ERROR];
                }
            });
        }];
    }
    else
    {
        [self.view showFeedbackAlertOfKind:WarningAlert message:_alertMsg];
        for (UIView *view in invalidFields)
        {
            view.layer.borderColor = [FeedbackColor warningColor].CGColor;
        }
    }
}

#pragma mark - Error
- (void)showRequestError:(NSString *)error
{
    [self.navigationController.view showPopupWithTitle:GREETING_OPS message:error cancelButtonTitle:@"Cancelar" cancelBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    } actionButtonTitle:TRY_BUTTON actionBlock:^{
        [self loadCancelData];
    }];
}

#pragma mark - Autolayout Helper Methods
- (void)updateContentSizeForLastElement:(id)item
{
    [self.contentView removeConstraint:self.sendButtonTopConstraint];
    self.sendButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.sendButton
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:item
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:15];
    [self.contentView addConstraint:self.sendButtonTopConstraint];
}

- (void)pinDocumentToItem:(id)newItem
{
    [self.contentView removeConstraint:self.documentTopConstraint];
    self.documentTopConstraint = [NSLayoutConstraint constraintWithItem:self.documentTextField
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:newItem
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:15];
    [self.contentView addConstraint:self.documentTopConstraint];
}

- (void)pinFooterToItem:(id)newItem
{
    [self.contentView removeConstraint:self.footerTopConstraint];
    self.footerTopConstraint = [NSLayoutConstraint constraintWithItem:self.footerLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:newItem
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:15];
    [self.contentView addConstraint:self.footerTopConstraint];
}

#pragma mark - Keyboard/Picker
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    self.sendButtonBottomContraint.constant = keyboardRect.size.height + 15;
    
    [UIView animateWithDuration:.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.sendButtonBottomContraint.constant = 15;
    [UIView animateWithDuration:.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)tapGestureRecognizedInScrollView
{
    [self.scrollView endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
