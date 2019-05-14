//
//  ContactRequestViewController.m
//  Walmart
//
//  Created by Renan on 6/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ContactRequestViewController.h"

#import "WALSession.h"
#import "WMFloatLabelMaskedTextField.h"
#import "WMPickerTextField.h"
#import "WMPinnedView.h"
#import "WMPlaceholderTextView.h"
#import "ContactProductCollectionViewCell.h"
#import "ContactProductTableViewCell.h"
#import "WBRContactRequestFormModel.h"
#import "WBRContactRequestDeliveryModel.h"
#import "WMPicker.h"
#import "ContactRequestExchangeFieldModel.h"
#import "ExchangeFormPinnedView.h"
#import "FeedbackAlertView.h"
#import "FeedbackColor.h"
#import "WMBContactRequestThankYouPageViewController.h"
#import "WBRContactOrdersViewController.h"
#import "WBRContactDeliveryViewController.h"
#import "NSString+Validation.h"
#import "UITextField+MaskValidation.h"
#import "CreditCardInteractor.h"
#import "NSString+Additions.h"
#import "WBRUtils.h"
#import "OrderDetailConnection.h"
#import "WBRContactTicketViewController.h"
#import "WBRContactManager.h"

typedef enum {
    ContactRequestNormal = 0,
    ContactRequestOther = 1,
    ContactRequestBuy = 2,
    ContactRequestDelivery = 3,
    ContactRequestCancellation = 4,
    ContactRequestOrder = 5,
    ContactRequestPayments =  6,
    ContactRequestExchange = 7,
    ContactRequestWarranty = 8,
    ContactRequestRegister = 9,
    ContactRequestStore = 10,
    ContactRequestStatus = 11,
    ContactRequestOtherServices = 12
} ContactRequestType;

typedef enum {
    RefundTypeNone = 0,
    RefundTypeBank = 1,
    RefundTypeDocument = 2,
} RefundType;

typedef enum {
    RetryStateForm,
    RetryStateLoadOrders,
    RetryStateDeliveries,
    RetryStateExchangeFields,
    RetryStateLoadBanks,
    RetryStateLoadOrderInformation
} RetryState;

static CGFloat const DisabledElementAlphaValue = 0.5f;
static CGFloat const EnabledElementAlphaValue = 1.0f;
static NSString * const collectionViewReuseIdentifier = @"ContactProductCollectionViewCell";
static NSString * const tableViewReuseIdentifier = @"ContactProductTableViewCell";

static NSString *const REQUEST_TYPE_OTHER = @"OTHER";
static NSString *const REQUEST_TYPE_BUY = @"BUY";
static NSString *const REQUEST_TYPE_DELIVERY = @"DELIVERY";
static NSString *const REQUEST_TYPE_CANCELLATION = @"CANCELLATION";
static NSString *const REQUEST_TYPE_ORDER = @"ORDER";
static NSString *const REQUEST_TYPE_PAYMENTS = @"PAYMENTS";
static NSString *const REQUEST_TYPE_EXCHANGE = @"EXCHANGE";
static NSString *const REQUEST_TYPE_WARRANTY = @"WARRANTY";
static NSString *const REQUEST_TYPE_REGISTER = @"REGISTER";
static NSString *const REQUEST_TYPE_STORE = @"STORE";
static NSString *const REQUEST_TYPE_STATUS = @"STATUS";
static NSString *const REQUEST_TYPE_OTHER_SERVICES = @"SERVICE";

@interface ContactRequestViewController () <WMPickerTextFieldDelegate, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, WBRContactDeliveryViewControllerDelegate, WMBContactRequestThankYouPageViewControllerDelegate>

// Payment Information
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *paymentInformationContactRequestPinnedView;
@property (weak, nonatomic) IBOutlet UILabel *paymentInformationLabel;
@property (weak, nonatomic) IBOutlet UIButton *paymentInformationButton;
@property (weak, nonatomic) IBOutlet UIButton *paymentInformationRefundSwicthButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentInformationRefundSwicthButtonHeightConstraint;


//CPF
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *paymentCPFContactRequestPinnedView;
@property (weak, nonatomic) IBOutlet UILabel *paymentCPFLabel;

// Credit card
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *paymentCreditCardInformationContactRequestPinnedView;
@property (weak, nonatomic) IBOutlet UIView *paymentCreditCardInformationView;
@property (weak, nonatomic) IBOutlet UILabel *paymentCreditCardFinalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *paymentCreditCardBrandImageView;
@property (weak, nonatomic) IBOutlet UILabel *paymentCreditCardOwnerLabel;

// Credit Card2
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *paymentCreditCard2InformationContactRequestPinnedView;
@property (weak, nonatomic) IBOutlet UIView *paymentCreditCard2InformationView;
@property (weak, nonatomic) IBOutlet UILabel *paymentCreditCard2FinalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *paymentCreditCard2BrandImageView;
@property (weak, nonatomic) IBOutlet UILabel *paymentCreditCard2OwnerLabel;

// SecondBankingSlip
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *viewBankSlipContactRequestPinnedView;
@property (weak, nonatomic) IBOutlet UIButton *viewBankSlipButton;

// Back to marketplace
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *backToMarketplaceContactRequestPinnedView;
@property (weak, nonatomic) IBOutlet UIButton *backToMarketplaceButton;

//Form View
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet WMPickerTextField *requestTypeTextField;
@property (weak, nonatomic) IBOutlet UIView *requestTypeBottom;

@property (weak, nonatomic) IBOutlet UIView *loadingView;


//Order Number View
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *orderNumberView;
@property (weak, nonatomic) IBOutlet WMPickerTextField *orderNumberTextField;


//Delivery View
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *deliveryView;
@property (weak, nonatomic) IBOutlet WMPickerTextField *deliveryTextField;


//Products View
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *productsView;
@property (weak, nonatomic) IBOutlet UICollectionView *productsCollectionView;
@property (weak, nonatomic) IBOutlet UIView *selectedProductsView;
@property (weak, nonatomic) IBOutlet UITableView *selectedProductsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedProductsViewHeightConstraint;


//Has Account View
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *hasAccountView;
@property (weak, nonatomic) IBOutlet WMPickerTextField *hasAccountPickerTextField;


//Document View
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *documentView;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *documentTextField;
@property (weak, nonatomic) IBOutlet UILabel *documentLabel;


//Bank View
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *bankView;
@property (weak, nonatomic) IBOutlet WMPickerTextField *bankPickerTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *agencyTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *accountTextField;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UIView *loadingBanksView;


//Reimbursement
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *packagePickerView;
@property (weak, nonatomic) IBOutlet WMPickerTextField *packageTextField;
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *packageConditionPickerView;
@property (weak, nonatomic) IBOutlet WMPickerTextField *packageConditionTextField;
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *reimbursementTypePickerView;
@property (weak, nonatomic) IBOutlet WMPickerTextField *reimbursementTypeTextField;


//Subject View Picker
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *subjectViewSubjectPicker;
@property (weak, nonatomic) IBOutlet WMPickerTextField *subjectTextField;


//Subject View Description TextField
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *subjectViewDescriptionTextfield;
@property (weak, nonatomic) IBOutlet WMPlaceholderTextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailsTextViewCharCount;


//Subject View Submit Button
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *subjectViewSubmitButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *cpfTextfield;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *telephoneTextfield;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *emailTextfield;

//User Information View
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *userInformationView;


//Subject Order Error View
@property (strong, nonatomic) IBOutlet ContactRequestPinnedView *subjectOrderErrorView;
@property (weak, nonatomic) IBOutlet UIView *subjectErrorMessageContentView;
@property (weak, nonatomic) IBOutlet UILabel *subjectErrorMessageLabel;

@property (strong, nonatomic) NSDictionary *contactDict;

@property (strong, nonatomic) NSArray<Bank *> *banksArray;
@property (strong, nonatomic) NSArray *deliveries;
@property (strong, nonatomic) WBRContactRequestOrdersArrayModel *ordersArray;
@property (strong, nonatomic) NSArray *products;

@property (strong, nonatomic) NSMutableArray *formSections;
@property (strong, nonatomic) NSMutableArray *selectedProducts;

@property (strong, nonatomic) NSString *alertMsg;
@property (strong, nonatomic) NSString *bankSlipURL;
@property (strong, nonatomic) NSString *thankYouPageButtonTitle;

@property (strong, nonatomic) ExchangeFormPinnedView *exchangeFormView;

@property (strong, nonatomic) WBRContactRequestDeliveryModel *delivery;
@property (strong, nonatomic) WBRContactRequestExchangeModel *exchangeModel;
@property (strong, nonatomic) WBRContactRequestFormModel *form;
@property (strong, nonatomic) WBRContactRequestOrderModel *order;
@property (strong, nonatomic) WBRContactRequestSubjectModel *subject;

@property (strong, nonatomic) WBRContactRequestTypeModel *requestType;
@property (strong, nonatomic) WBRContactRequestTypeModel *requestTypeProtected;

@property (strong, nonatomic) WMLoginViewController *loginViewController;

@property (assign, nonatomic) ContactRequestType contactRequestType;
@property (assign, nonatomic) RefundType refundType;
@property (assign, nonatomic) RetryState retryState;
@property (assign, nonatomic) BOOL showedFromMenu;

@end

static NSInteger const kMaxLengthTextFieldDescription = 3000;
static NSInteger const kMaxLengthTextBankAgency = 20;

@implementation ContactRequestViewController

- (id)initFromMenu:(BOOL)fromMenu andThankyouPageSuccessButtonTitle:(NSString *)buttonTitle{
    self = [super init];
    if (self) {
        self.showedFromMenu = fromMenu;
        self.thankYouPageButtonTitle = buttonTitle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.exchangeFormView = [ExchangeFormPinnedView new];
    
    self.formSections = @[self.orderNumberView, self.deliveryView, self.productsView, self.subjectViewSubjectPicker, self.subjectViewDescriptionTextfield, self.subjectViewSubmitButton].mutableCopy;
    self.refundType = RefundTypeNone;
    
    [self setupNavigationBar];
    [self registerKeyboardNotifications];
    
    [self setupRequestTypePicker];
    [self setupOrderNumbersPicker];
    [self setupDeliveriesPicker];
    [self setupProductsCollectionView];
    [self setupSelectedProductsTableView];
    [self setupSubjectsPicker];
    [self setupDetailsTextView];
    [self setupMasks];
    [self setupCreditCardView];
    [self setupPackagePicker];
    [self setupPackageConditionPicker];
    [self setupReimbursementTypePickerTextField];
    
    self.bankLabel.text = EXTENDED_WARRANTY_REFUND_BANK_MESSAGE;
    self.documentLabel.text = EXTENDED_WARRANTY_REFUND_DOCS_MESSAGE;
    
    [self loadSubjects];
}

#pragma mark Subjects

- (void)loadSubjects {
    [self startLoading];
    
    BOOL authentication = [WALSession isAuthenticated];
    
    [WBRContactManager getContactSubjectsWithAuthentication:authentication success:^(WBRContactRequestFormModel *subjects) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadSubjectSuccess:subjects];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadSubjectFailure:error];
        });
    }];
}

- (void)loadSubjectSuccess:(WBRContactRequestFormModel *)form {
    [self stopLoading];
    
    self.form = form;
    self.requestTypeTextField.options = [self.form.requestTypes valueForKeyPath:@"label"];
    
    if (self.requestTypeTextField.selectedOptionIndex) {
        [self selectedRequestType];
    }
}

- (void)loadSubjectFailure:(NSError *)error {
    [self stopLoading];
    
    int logCode = [[NSString stringWithFormat:@"%li", (long)error.code] intValue];
    if (logCode == 401) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self showLoginScreen];
    }
    else {
        self.retryState = RetryStateForm;
        [self showPopUpAlertWithError:error];
    }
}

#pragma mark Orders

- (void)loadOrders {
    
    [self startLoading];
    
    BOOL notCancelledOrders = NO;
    if ([self.requestType.type caseInsensitiveCompare:REQUEST_TYPE_CANCELLATION] == NSOrderedSame ||
        [self.requestType.type caseInsensitiveCompare:REQUEST_TYPE_ORDER] == NSOrderedSame ||
        [self.requestType.type caseInsensitiveCompare:REQUEST_TYPE_OTHER_SERVICES] == NSOrderedSame) {
        
        notCancelledOrders = YES;
    }
    
    BOOL warrantyParameter = NO;
    if ([self.requestType.type caseInsensitiveCompare:REQUEST_TYPE_WARRANTY] == NSOrderedSame) {
        warrantyParameter = YES;
    }
    
    [WBRContactManager getOrdersWithExtendWarranty:warrantyParameter andFilterByNotCancelled:notCancelledOrders success:^(WBRContactRequestOrdersArrayModel *orders) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ordersArray = orders;
            [self updateToShowOrders];
        });

    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.retryState = RetryStateLoadOrders;
            [self showPopUpAlertWithError:error];
        });
    }];
}

- (void) showLoginScreen {
    [self presentLoginWithLoginSuccessBlock:^{
        [self loadSubjects];
    }];
}


- (void)loadOrderDeliveries {
    [self startLoading];
    
    [WBRContactManager getDeliveriesWithOrderId:self.order.orderId success:^(NSArray<WBRContactRequestDeliveryModel *> *deliveries) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadOrderDeliveriesSuccess:deliveries];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadOrderDeliveriesFailure:error];
        });
    }];
}

- (void)loadOrderDeliveriesSuccess:(NSArray *)deliveries {
    [self stopLoading];
    self.deliveries = deliveries;
    
    self.deliveryTextField.enabled = YES;
    
    if (self.deliveries.count == 1) {
        [self selectedDelivery:self.deliveries.firstObject];
    }
}

- (void)loadOrderDeliveriesFailure:(NSError *)error {
    [self stopLoading];
    
    self.deliveryTextField.enabled = NO;
    
    self.retryState = RetryStateDeliveries;
    [self showPopUpAlertWithError:error];
}

- (void)loadExchangeFieldsWithSuccesCompletionNotification:(void(^)(void))successCompletion {
    
    [self.loadingView setHidden:NO];
    
    [WBRContactManager getExchangeWithOrderId:self.order.orderId andSellerId:self.delivery.seller.sellerId success:^(WBRContactRequestExchangeModel *exchange) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView setHidden:YES];
            self.exchangeModel = exchange;
            if (successCompletion) {
                successCompletion();
            }
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView setHidden:YES];
            [self loadExchangeFieldsFailure:error];
        });
    }];
}

- (void)loadBanks {

    [self.loadingBanksView setHidden:NO];
    [WBRContactManager getBanksWithSuccess:^(NSArray<Bank *> *banks) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.banksArray = banks;
            [self.loadingBanksView setHidden:YES];
            [self setupBanksPicker];
        }];
    } failure:^(NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.retryState = RetryStateLoadBanks;
            [self showPopUpAlertWithError:error];
        }];
    }];
}

- (void)loadExchangeFieldsSuccess:(NSArray *)fields {
    [self stopLoading];
    
    //Ensure REFUND field is the last in exchange form
    NSMutableArray *fieldsMutable = fields.mutableCopy;
    for (ContactRequestExchangeFieldModel *field in fields) {
        if ([[field.type uppercaseString] isEqualToString:@"REFUND"]) {
            [fieldsMutable removeObject:field];
            [fieldsMutable addObject:field];
            break;
        }
    }
    
    [self.exchangeFormView setupWithFields:fieldsMutable.copy];
    if (self.exchangeFormView.refundPickerTextField) {
        self.exchangeFormView.refundPickerTextField.wmPickerTextFieldDelegate = self;
    }
}

- (void)loadExchangeFieldsFailure:(NSError *)error {
    [self stopLoading];
    
    self.retryState = RetryStateExchangeFields;
    [self showPopUpAlertWithError:error];
}

- (void)sendContactRequest {
    
    [self startLoading];
    
    NSMutableArray<NSString *> *selectedsProductsArray = [NSMutableArray array];
    for (WBRContactRequestProductModel *product in self.selectedProducts) {
        [selectedsProductsArray addObject:product.productId];
    }
    
    NSMutableDictionary *contactDict = [NSMutableDictionary new];
    if ([self.requestType.generic boolValue]) {
        if (![WALSession isAuthenticated]) {
            NSMutableDictionary *customerDict = [NSMutableDictionary new];
            [customerDict setObject:self.cpfTextfield.raw forKey:@"document"];
            [customerDict setObject:self.emailTextfield.text forKey:@"email"];
            [customerDict setObject:self.usernameTextfield.text forKey:@"name"];
            
            NSString *number = self.telephoneTextfield.raw;
            [customerDict setObject:@[@{@"type" : @"Residential", @"number" : number}] forKey:@"phones"];
            [contactDict setObject:customerDict forKey:@"customer"];
        }
    }
    else {
        if (self.contactRequestType != ContactRequestOther) {
            [contactDict setObject:self.delivery.deliveryId forKey:@"deliveryId"];
            [contactDict setObject:self.order.orderId forKey:@"walmartOrderId"];
            if (selectedsProductsArray.count >= 1) {
                [contactDict setObject:selectedsProductsArray forKey:@"items"];
            }
        }
    }
    
    [contactDict setObject:self.subject.subjectId forKey:@"reasonId"];
    
    //Gather additional information for reimbursement/exchange/return/etc
    NSMutableString *commentsStr = [NSMutableString new];
    
    if (self.contactRequestType == ContactRequestExchange ||
        self.contactRequestType == ContactRequestCancellation) {
        for (UITextField *field in [self activeFields]) {
            if (commentsStr.length != 0) {
                [commentsStr appendString:@" | "];
            }
            if ([field isKindOfClass:[WMFloatLabelMaskedTextField class]]) {
                [commentsStr appendFormat:@"%@: %@", [((WMFloatLabelMaskedTextField *)field).floatLabel.text stringByRemovingAccentuation], field.text];
            }
        }
    }
    
    if ([[self activeFields] containsObject:self.detailsTextView]) {
        
        if (commentsStr.length != 0) {
            [commentsStr appendString:@" | "];
        }
        [commentsStr appendFormat:@"Descricao: %@", self.detailsTextView.text];
    }
    
    //Added to remove TAB and ENTER of comment field.
    [commentsStr replaceOccurrencesOfString:@"\n" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, commentsStr.length)];
    [commentsStr replaceOccurrencesOfString:@"\t" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, commentsStr.length)];
    
    [contactDict setObject:commentsStr forKey:@"comment"];
    
    
    self.contactDict = contactDict.copy;
    
    [WBRContactManager openTicketWithDictionary:self.contactDict success:^(NSString *ticketNumber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopLoading];
            [WMOmniture trackOpenedTicketWithSuccess];
            WMBContactRequestThankYouPageViewController *thankYouPage = [[WMBContactRequestThankYouPageViewController alloc] initWithRequestId:ticketNumber andFromMenu:self.showedFromMenu andButtonTitleString:self.thankYouPageButtonTitle];
            thankYouPage.delegate = self;
            [self.navigationController presentViewController:thankYouPage animated:YES completion:^{
            }];
        });

    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopLoading];
            [self.view showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
        });
    }];
}

- (void)loadOrderInformation {
    
    [self setupBankSlipButtonView];
    [self.requestTypeBottom addSubview:self.viewBankSlipContactRequestPinnedView];
    
    if (self.exchangeModel.paymentMethods != nil  && self.exchangeModel.paymentMethods.count > 0) {
        
        self.bankSlipURL = ((WBRContactRequestPaymentModel *)[self.exchangeModel.paymentMethods firstObject]).paymentUrl;
    }
}

#pragma mark - Loading

- (void)startLoading {
    self.loadingView.hidden = NO;
}

- (void)stopLoading {
    self.loadingView.hidden = YES;
}

#pragma mark - Layout

- (void)setupNavigationBar
{
    self.title = @"Atendimento";
}

- (void)setupMasks {
    self.telephoneTextfield.mask = @"(##) ####-####";
    self.telephoneTextfield.delegate = self;
    self.cpfTextfield.delegate = self;
    
    self.agencyTextField.delegate = self;
    self.accountTextField.delegate = self;
}

- (void)setupRequestTypePicker {
    self.requestTypeTextField.delegate = self;
    self.requestTypeTextField.wmPickerTextFieldDelegate = self;
}

- (void)setupOrderNumbersPicker {
    self.orderNumberTextField.delegate = self;
    self.orderNumberTextField.wmPickerTextFieldDelegate = self;
}

- (void)setupDeliveriesPicker {
    self.deliveryTextField.delegate = self;
    self.deliveryTextField.wmPickerTextFieldDelegate = self;
}

- (void)setupSubjectsPicker {
    self.subjectTextField.delegate = self;
    self.subjectTextField.wmPickerTextFieldDelegate = self;
}

- (void)setupPackagePicker {
    self.packageTextField.delegate = self;
    self.packageTextField.wmPickerTextFieldDelegate = self;
}

- (void)setupPackageConditionPicker {
    self.packageConditionTextField.delegate = self;
    self.packageConditionTextField.wmPickerTextFieldDelegate = self;
}

- (void)setupReimbursementTypePickerTextField {
    self.reimbursementTypeTextField.delegate = self;
    self.reimbursementTypeTextField.wmPickerTextFieldDelegate = self;
}

- (void)setupDetailsTextView {
    self.detailsTextView.delegate = self;
    self.detailsTextView.placeholder = @"Digite aqui seu comentário...";
    self.detailsTextView.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.detailsTextView.layer.borderWidth = 1.0f;
}

- (void)setupBanksPicker {
    NSMutableArray *bankNames = [NSMutableArray new];
    for (Bank *bank in self.banksArray) {
        NSString *bankStr = [NSString stringWithFormat:@"%@ - %@", bank.code, bank.name];
        [bankNames addObject:bankStr];
    }
    self.bankPickerTextField.options = bankNames.copy;
}

- (void)hideFormSectionsFromFormSection:(id)formComponent {
    if ([self.formSections containsObject:formComponent]) {
        NSUInteger location = [self.formSections indexOfObject:formComponent];
        NSUInteger length = self.formSections.count - location;
        NSArray *formComponentsBelow = [self.formSections subarrayWithRange:NSMakeRange(location, length)];
        for (UIView *view in formComponentsBelow) {
            [view removeFromSuperview];
        }
    }
}

- (void)resetViewControllerState {
    [self.orderNumberView removeFromSuperview];
    [self.deliveryView removeFromSuperview];
    
    [self.productsView removeFromSuperview];
    [self.userInformationView removeFromSuperview];
    
    [self.subjectViewSubjectPicker removeFromSuperview];
    [self.subjectViewDescriptionTextfield removeFromSuperview];
    [self.subjectViewSubmitButton removeFromSuperview];
    
    [self.documentView removeFromSuperview];
    [self.bankView removeFromSuperview];
    
    [self.paymentInformationContactRequestPinnedView removeFromSuperview];
    [self.paymentCPFContactRequestPinnedView removeFromSuperview];
    [self.paymentCreditCardInformationContactRequestPinnedView removeFromSuperview];
    [self.paymentCreditCard2InformationContactRequestPinnedView removeFromSuperview];
    
    [self.viewBankSlipContactRequestPinnedView removeFromSuperview];
    [self.backToMarketplaceContactRequestPinnedView removeFromSuperview];

    [self.packagePickerView removeFromSuperview];
    [self.packageConditionPickerView removeFromSuperview];
    [self.reimbursementTypePickerView removeFromSuperview];
}

- (void)showGenericView {
    [self.requestTypeBottom addSubview:self.subjectViewSubjectPicker];
    
    if (![WALSession isAuthenticated]) {
        [self.requestTypeBottom addSubview:self.userInformationView];
    }
    
    [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
    [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
}

- (void)setupCreditCardView {
    self.paymentCreditCardInformationView.layer.borderWidth = 1;
    self.paymentCreditCardInformationView.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.paymentCreditCardInformationView.layer.masksToBounds = YES;
    self.paymentCreditCardInformationView.layer.cornerRadius = 4;
    
    self.paymentCreditCard2InformationView.layer.borderWidth = 1;
    self.paymentCreditCard2InformationView.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    self.paymentCreditCard2InformationView.layer.masksToBounds = YES;
    self.paymentCreditCard2InformationView.layer.cornerRadius = 4;
}

- (void)setupBankSlipButtonView {
    self.viewBankSlipButton.layer.borderColor = RGBA(33, 150, 243, 1).CGColor;
    self.viewBankSlipButton.layer.borderWidth = 1;
    self.viewBankSlipButton.layer.masksToBounds = YES;
    self.viewBankSlipButton.layer.cornerRadius = 22;
}

- (void)setupBackToMarketPlaceButton {
    self.backToMarketplaceButton.layer.borderColor = RGBA(33, 150, 243, 1).CGColor;
    self.backToMarketplaceButton.layer.borderWidth = 1;
    self.backToMarketplaceButton.layer.masksToBounds = YES;
    self.backToMarketplaceButton.layer.cornerRadius = 22;
}

- (void)showPackagePicker {
    WBRContactRequestExchangeTypeModel *exchangeTypeModel = [self getExchangeTypeModelValuesForExchangeType:@"PACKAGE"];
    self.packageTextField.options = [exchangeTypeModel.values  valueForKeyPath:@"exchangeTypeLabel"];
    self.packageTextField.delegate = self;
    [self.requestTypeBottom addSubview:self.packagePickerView];
}

- (void)showPackageConditionPicker {
    WBRContactRequestExchangeTypeModel *exchangeTypeModel = [self getExchangeTypeModelValuesForExchangeType:@"STATE"];
    self.packageConditionTextField.options = [exchangeTypeModel.values  valueForKeyPath:@"exchangeTypeLabel"];
    self.packageConditionTextField.delegate = self;
    [self.requestTypeBottom addSubview:self.packageConditionPickerView];
}

- (void)showReimbursementTypePicker {
    WBRContactRequestExchangeTypeModel *exchangeTypeModel = [self getExchangeTypeModelValuesForExchangeType:@"REFUND"];
    self.reimbursementTypeTextField.options = [exchangeTypeModel.values  valueForKeyPath:@"exchangeTypeLabel"];
    self.reimbursementTypeTextField.delegate = self;
    [self.requestTypeBottom addSubview:self.reimbursementTypePickerView];
}

- (void)resetPackagePickers:(WMPickerTextField *)pickerTextField {
    // Reset package and packageConditions pickers
    if (pickerTextField == self.packageTextField) {
        [self.packageConditionPickerView removeFromSuperview];
        self.packageConditionTextField.text = @"";
    }
    
    [self.reimbursementTypePickerView removeFromSuperview];
    self.reimbursementTypeTextField.text = @"";
    
    [self.paymentInformationContactRequestPinnedView removeFromSuperview];
    [self.paymentCPFContactRequestPinnedView removeFromSuperview];
    [self.bankView removeFromSuperview];
    [self.subjectViewDescriptionTextfield removeFromSuperview];
    [self.subjectViewSubmitButton removeFromSuperview];
    
    [self removeRefundView];

}
- (WBRContactRequestExchangeTypeModel *)getExchangeTypeModelValuesForExchangeType:(NSString *)exchangeType {
    WBRContactRequestExchangeTypeModel *exchangeTypeModel = nil;
    NSArray *arrayOfExchangeTypeModels = self.exchangeModel.fields;
    for (WBRContactRequestExchangeTypeModel *typeModel in arrayOfExchangeTypeModels) {
        if ([typeModel.exchangeType isEqualToString:exchangeType]) {
            exchangeTypeModel = typeModel;
            break;
        }
    }
    return exchangeTypeModel;
}

- (void)showExchangeView {
    //Remove refund views
    [self.requestTypeBottom addSubview:self.subjectViewSubjectPicker];
}

- (void)removeRefundView {
    
    //Clear the fields and remove the views
    self.bankPickerTextField.text = @"";
    self.agencyTextField.text = @"";
    self.accountTextField.text = @"";
    self.detailsTextView.text = @"";
    self.detailsTextViewCharCount.text = @"0/3000 caracteres";
    
    [self.paymentInformationContactRequestPinnedView removeFromSuperview];
    [self.paymentCreditCardInformationContactRequestPinnedView removeFromSuperview];
    [self.paymentCreditCard2InformationContactRequestPinnedView removeFromSuperview];
    [self.paymentCPFContactRequestPinnedView removeFromSuperview];
    [self.bankView removeFromSuperview];
    [self.subjectViewSubmitButton removeFromSuperview];
    [self.subjectViewDescriptionTextfield removeFromSuperview];
}

- (void)addRefundViewForExchangeFlow {
    //Remove last views before recreating the bottom part of the screen
    
    [self.requestTypeBottom addSubview:self.paymentInformationContactRequestPinnedView];
    
    WBRContactRequestPaymentModel *firstPaymentMethod = [self.exchangeModel.paymentMethods firstObject];
    if ([firstPaymentMethod paymentType] == kExchangePaymentTypeCreditCard) {
        [self showRefundMethodCreditCard];
    } else {
        [self showRefundMethodForPaymentWithBankingSlip];
    }
}

- (void)showRefundView {
    
    [self.requestTypeBottom addSubview:self.subjectViewSubjectPicker];
    [self.requestTypeBottom addSubview:self.paymentInformationContactRequestPinnedView];
    
    WBRContactRequestPaymentModel *firstPaymentMethod = [self.exchangeModel.paymentMethods firstObject];
    if ([firstPaymentMethod paymentType] == kExchangePaymentTypeCreditCard) {
        [self showRefundMethodCreditCard];
    }
    else {
        [self showRefundMethodForPaymentWithBankingSlip];
    }
    
    [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
}

- (void)showRefundMethodForPaymentWithBankingSlip {
    [self loadBanks];
    [self.paymentInformationRefundSwicthButton setHidden:NO];
    [self.paymentInformationRefundSwicthButtonHeightConstraint setConstant:20];
    [self.requestTypeBottom addSubview:self.paymentCPFContactRequestPinnedView];
    [self.paymentCPFLabel setText:[WBRUtils formatDocument:self.exchangeModel.customer.document]];
    self.refundType = RefundTypeNone;
    [self switchBankingSlipRefundMethod];
}

- (void)showRefundMethodCreditCard {
    
    self.refundType = RefundTypeNone;
    
    [self fillPaymentInformationWithCreditCard];

    WBRContactRequestPaymentModel *firstCreditCard = [self.exchangeModel.paymentMethods firstObject];
    self.paymentCreditCardFinalLabel.text = [NSString stringWithFormat:@"%@ - Final %@", [firstCreditCard.brand capitalizedString], firstCreditCard.lastDigitsOfCard];
    self.paymentCreditCardBrandImageView.image = [CreditCardInteractor minImageForFlag:[CreditCardInteractor creditCardFlagForCardName:firstCreditCard.brand]];
    self.paymentCreditCardOwnerLabel.text = firstCreditCard.completeName;
    
    [self.paymentInformationRefundSwicthButton setHidden:YES];
    [self.paymentInformationRefundSwicthButtonHeightConstraint setConstant:0];
    
    [self.requestTypeBottom addSubview:self.paymentCreditCardInformationContactRequestPinnedView];
    
    if (self.exchangeModel.paymentMethods.count == 2) {
        [self.requestTypeBottom addSubview:self.paymentCreditCard2InformationContactRequestPinnedView];
        
        WBRContactRequestPaymentModel *secondCreditCard = [self.exchangeModel.paymentMethods lastObject];
        self.paymentCreditCard2FinalLabel.text = [NSString stringWithFormat:@"%@ - Final %@", [secondCreditCard.brand capitalizedString], secondCreditCard.lastDigitsOfCard];
        self.paymentCreditCard2BrandImageView.image = [CreditCardInteractor minImageForFlag:[CreditCardInteractor creditCardFlagForCardName:secondCreditCard.brand]];
        self.paymentCreditCard2OwnerLabel.text = secondCreditCard.completeName;
    }
    
    [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
    [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
}

- (IBAction)switchBankingSlipRefundMethod {
    
    [self.subjectViewSubmitButton removeFromSuperview];
    [self.paymentCreditCardInformationContactRequestPinnedView removeFromSuperview];
    [self.paymentCreditCard2InformationContactRequestPinnedView removeFromSuperview];
    [self.bankView removeFromSuperview];
    
    if (self.refundType == RefundTypeNone || self.refundType == RefundTypeDocument) {
        self.refundType = RefundTypeBank;
        [self switchToRefundWithBankingAccount];
    }
    else {
        self.refundType = RefundTypeDocument;
        [self switchToRefundWithoutBankingAccount];
    }
    [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
    [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
}

- (void)switchToRefundWithBankingAccount {
    
    [self fillPaymentInformationWithAccount];
    [self.requestTypeBottom addSubview:self.bankView];
}

- (void)switchToRefundWithoutBankingAccount {
    [self.bankView removeFromSuperview];
    [self fillPaymentInformationWithoutBankingAccount];
}

- (void)fillPaymentInformationWithCreditCard {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:CONTACT_REQUEST_CREDIT_CARD_REFUND];
    
    //    Default Font
    UIFont *defaultFont = [UIFont fontWithName:@"Roboto-Regular" size:13];
    [mutableAttributedString addAttribute:NSFontAttributeName value:defaultFont range:NSMakeRange(0, mutableAttributedString.length)];
    
    //    Dark Color
    UIFont *grayFont = [UIFont fontWithName:@"Roboto-Medium" size:13];
    [mutableAttributedString addAttribute:NSFontAttributeName               value:grayFont                  range:[CONTACT_REQUEST_CREDIT_CARD_REFUND rangeOfString:CONTACT_REQUEST_CREDIT_CARD_PAYMENT_VIA_CREDIT_CARD]];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName    value:RGBA(155, 155, 155, 1.0)  range:[CONTACT_REQUEST_CREDIT_CARD_REFUND rangeOfString:CONTACT_REQUEST_CREDIT_CARD_PAYMENT_VIA_CREDIT_CARD]];
    
    self.paymentInformationLabel.attributedText = mutableAttributedString;
}

- (void)fillPaymentInformationWithAccount {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:CONTACT_REQUEST_BANKING_SLIP_WITH_ACCOUNT_REFUND];
    
    //Default Font
    UIFont *defaultFont = [UIFont fontWithName:@"Roboto-Regular" size:13];
    [mutableAttributedString addAttribute:NSFontAttributeName value:defaultFont range:NSMakeRange(0, mutableAttributedString.length)];
    
    //Dark Color
    UIFont *grayFont = [UIFont fontWithName:@"Roboto-Medium" size:13];
    [mutableAttributedString addAttribute:NSFontAttributeName               value:grayFont                  range:[CONTACT_REQUEST_BANKING_SLIP_WITH_ACCOUNT_REFUND rangeOfString:CONTACT_REQUEST_PAYMENT_VIA_BANKING_SLIP_REFUND]];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName    value:RGBA(155, 155, 155, 1.0)  range:[CONTACT_REQUEST_BANKING_SLIP_WITH_ACCOUNT_REFUND rangeOfString:CONTACT_REQUEST_PAYMENT_VIA_BANKING_SLIP_REFUND]];
    
    self.paymentInformationLabel.attributedText = mutableAttributedString;
    
    [self.paymentInformationButton setTitle:CONTACT_REQUEST_HAS_NO_BANK_ACCOUNT_REFUND forState:UIControlStateNormal];
}

- (void)fillPaymentInformationWithoutBankingAccount {
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:CONTACT_REQUEST_BANKING_SLIP_NO_ACCOUNT_REFUND];
    
    //    Default Font
    UIFont *defaultFont = [UIFont fontWithName:@"Roboto-Regular" size:13];
    [mutableAttributedString addAttribute:NSFontAttributeName value:defaultFont range:NSMakeRange(0, mutableAttributedString.length)];
    
    //    Dark Color
    UIFont *grayFont = [UIFont fontWithName:@"Roboto-Medium" size:13];
    [mutableAttributedString addAttribute:NSFontAttributeName               value:grayFont                  range:[CONTACT_REQUEST_BANKING_SLIP_WITH_ACCOUNT_REFUND rangeOfString:CONTACT_REQUEST_PAYMENT_VIA_BANKING_SLIP_REFUND]];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName    value:RGBA(155, 155, 155, 1.0)  range:[CONTACT_REQUEST_BANKING_SLIP_WITH_ACCOUNT_REFUND rangeOfString:CONTACT_REQUEST_PAYMENT_VIA_BANKING_SLIP_REFUND]];
    
    self.paymentInformationLabel.attributedText = mutableAttributedString;
    [self.paymentInformationButton setTitle:CONTACT_REQUEST_HAS_BANK_ACCOUNT_REFUND forState:UIControlStateNormal];
}

#pragma mark - Products Collection View

- (void)setupProductsCollectionView {
    self.productsCollectionView.delegate = self;
    self.productsCollectionView.dataSource = self;
    self.productsCollectionView.allowsMultipleSelection = YES;
    [self.productsCollectionView registerNib:[UINib nibWithNibName:@"ContactProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionViewReuseIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WBRContactRequestProductModel *product = self.products[indexPath.row];
    
    ContactProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewReuseIdentifier forIndexPath:indexPath];
    [cell setupWithImageUrl:product.urlImage];
    
    if ([self.selectedProducts containsObject:product]) {
        cell.selected = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.selectedProducts containsObject:self.products[indexPath.row]]) {
        [self.selectedProducts addObject:self.products[indexPath.row]];
        [self.selectedProductsTableView reloadData];
        [self updateSelectedProductsTableViewHeight];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.products.count != 1) {
        if ([self.selectedProducts containsObject:self.products[indexPath.row]]) {
            [self.selectedProducts removeObject:self.products[indexPath.row]];
            [self.selectedProductsTableView reloadData];
            [self updateSelectedProductsTableViewHeight];
        }
    }
}

#pragma mark - Selected Products Table View

- (void)setupSelectedProductsTableView {
    self.selectedProducts = [NSMutableArray new];
    
    [self.selectedProductsTableView registerNib:[UINib nibWithNibName:@"ContactProductTableViewCell" bundle:nil] forCellReuseIdentifier:tableViewReuseIdentifier];
    self.selectedProductsTableView.delegate = self;
    self.selectedProductsTableView.dataSource = self;
    self.selectedProductsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.selectedProductsTableView.estimatedRowHeight = 40;
    self.selectedProductsTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self updateSelectedProductsTableViewHeight];
}

- (void)updateSelectedProductsTableViewHeight
{
    self.selectedProductsViewHeightConstraint.constant = 3000;
    [self.selectedProductsTableView reloadData];
    [self.selectedProductsTableView layoutIfNeeded];

    CGFloat topSize = 33;
    if (self.selectedProductsTableView.contentSize.height == 0) {
        topSize = 0;
        self.selectedProductsView.hidden = YES;
    } else {
        topSize = 33;
        self.selectedProductsView.hidden = NO;
    }
    
    self.selectedProductsViewHeightConstraint.constant = self.selectedProductsTableView.contentSize.height + topSize;
    [self.view layoutIfNeeded];
    
    [self.selectedProductsView needsUpdateConstraints];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBRContactRequestProductModel *product = self.selectedProducts[indexPath.row];
    
    ContactProductTableViewCell *cell = (ContactProductTableViewCell *) [tableView dequeueReusableCellWithIdentifier:tableViewReuseIdentifier forIndexPath:indexPath];
    cell.productNameLabel.text = product.descriptionText;
    
    return cell;
}

#pragma mark - WMPickerTextField Delegate
- (BOOL)pickerTextFieldShouldOpenPicker:(id)pickerTextField {
    if (pickerTextField == self.orderNumberTextField || pickerTextField == self.deliveryTextField) {
        return NO;
    }
    return YES;
}

- (void)pickerTextFieldDidSelect:(id)pickerTextField {
    
    if (pickerTextField == self.orderNumberTextField) {
        [self openOrders];
    } else if (pickerTextField == self.deliveryTextField) {
        [self openDeliveries];
    }
}

- (void)pickerTextField:(id)pickerTextField didFinishSelectingOption:(NSString *)option {
    
    [self setContinueButtonEnabled:YES];
    
    [self.subjectOrderErrorView removeFromSuperview];
    
    if (pickerTextField == self.packageConditionTextField) {
        [self resetPackagePickers:self.packageConditionTextField];
        [self showReimbursementTypePicker];
    }
    if (pickerTextField == self.packageTextField) {
        [self resetPackagePickers:self.packageTextField];
        [self showPackageConditionPicker];
    }
    else if (pickerTextField == self.requestTypeTextField) {
        [self resetViewControllerState];
        [self selectedRequestType];
    }
    else if (pickerTextField == self.subjectTextField) {
        [self selectedSubject];
    }
    else if (pickerTextField == self.reimbursementTypeTextField) {
        
        [self removeRefundView];
        
        [self.subjectViewDescriptionTextfield removeFromSuperview];
        [self.subjectViewSubmitButton removeFromSuperview];
        
        if ([[[pickerTextField text] uppercaseString] isEqualToString:@"REEMBOLSO"]) {
            [self addRefundViewForExchangeFlow];
        } else {
            self.refundType = RefundTypeNone;
            [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
            [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.cpfTextfield) {
        return [textField maskCPFInRange:range forReplacementString:string];
    }
    else if (textField == self.telephoneTextfield) {

        //Workaround to make the MaskFormatter handle new masks on the fly
        NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSInteger lenght = [finalString length];
        if (lenght == 14) {
            NSString *temp = [self.telephoneTextfield.raw stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //Normalize the string to fit the new mask
            temp = [NSString stringWithFormat:@"(%@) %@-%@",
                    [temp substringWithRange:NSMakeRange(0, 2)],
                    [temp substringWithRange:NSMakeRange(2, 4)],
                    [temp substringFromIndex:6]];
            textField.text = temp;
            self.telephoneTextfield.mask = @"(##) ####-####";
        }  else if (lenght == 15) {
            NSString *temp = [self.telephoneTextfield.raw stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //Normalize the string to fit the new mask
            temp = [NSString stringWithFormat:@"(%@) %@-%@",
                    [temp substringWithRange:NSMakeRange(0, 2)],
                    [temp substringWithRange:NSMakeRange(2, 5)],
                    [temp substringFromIndex:7]];
            textField.text = temp;
            self.telephoneTextfield.mask = @"(##) #####-####";
        }
        
        return [(WMFloatLabelMaskedTextField *) textField shouldChangeCharactersInRange:range replacementString:string];
    } else if ((textField == self.agencyTextField) || (textField == self.accountTextField)){
        NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSInteger lenght = [finalString length];
        if (lenght > kMaxLengthTextBankAgency) {
            return NO;
        }

    } else if ([textField isKindOfClass:[WMFloatLabelMaskedTextField class]]) {
        return [(WMFloatLabelMaskedTextField *) textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

#pragma mark - Picker Selection

- (void)selectedRequestType {
    
    [self clearAndUnalertCommonFields];
    [self.orderNumberTextField resetPicker];
    
    self.requestType = self.form.requestTypes[self.requestTypeTextField.selectedOptionIndex];
    self.requestTypeProtected = [self.form.requestTypes[self.requestTypeTextField.selectedOptionIndex] copy];
    
    self.subjectTextField.options = [self.requestType.subjects valueForKeyPath:@"label"];
    if (self.requestType.subjects.count == 1) {
        [self.subjectTextField selectFirstOption];
        self.subject = self.requestType.subjects[self.subjectTextField.selectedOptionIndex];
    }
    
    if ([self.requestType.generic boolValue]) {
        [self showGenericView];
    }
    else {
        if (self.requestType.authentication.boolValue && ![WALSession isAuthenticated]) {
            [self presentLoginWithLoginSuccessBlock:^{
                [self loadOrders];
            } dismissBlock:^{
                self.requestType = nil;
                self.requestTypeProtected = nil;
                [self.requestTypeTextField resetPicker];
            }];
        } else {
            [self loadOrders];
        }
    }
}

- (void)updateToShowOrders {
    
    [self stopLoading];
    
    [self converSelectedTypeToContactRequestType];
    
    switch (self.contactRequestType) {
        case ContactRequestNormal:
        case ContactRequestDelivery:
        case ContactRequestCancellation:
        case ContactRequestOrder:
        case ContactRequestPayments:
        case ContactRequestWarranty:
        case ContactRequestStatus:
        case ContactRequestOtherServices: {
            [self.requestTypeBottom addSubview:self.orderNumberView];
            break;
        }
            
        case ContactRequestExchange: {
            
            NSMutableArray *ordersMutable = [NSMutableArray new];
            
            for (WBRContactRequestOrderModel *order in self.ordersArray.orders) {
                if (order.returnable.boolValue) {
                    [ordersMutable addObject:order];
                }
            }
            
            self.ordersArray.orders = ordersMutable.copy;
            
            [self.requestTypeBottom addSubview:self.orderNumberView];
            break;
        }
            
        case ContactRequestOther: {
            [self.requestTypeBottom addSubview:self.subjectViewSubjectPicker];
            [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
            [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
            break;
        }
            
        case ContactRequestRegister:
        case ContactRequestBuy:
        case ContactRequestStore: {
            [self.requestTypeBottom addSubview:self.subjectViewSubjectPicker];
            if (![WALSession isAuthenticated]) {
                [self.requestTypeBottom addSubview:self.userInformationView];
            }
            [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
            [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
            
            break;
        }
            
        default:
            break;
    }
    
    [self updateOrdersPicker];
    
    self.subjectTextField.options = [self.requestType.subjects valueForKeyPath:@"label"];
}

- (void)updateOrdersPicker {
    
    if (self.ordersArray.orders.count == 0) {
        self.orderNumberTextField.text = CONTACT_REQUEST_NO_ELIGIBLE_ORDERS;
        self.orderNumberTextField.enabled = NO;
    }
    else {
        self.orderNumberTextField.enabled = YES;
        
        if (self.ordersArray.orders.count == 1) {
            self.order = [self.ordersArray.orders firstObject];
            self.orderNumberTextField.text = self.order.orderId;
            [self selectedOrderNumber:YES];
        }
    }
}

- (void)selectedOrderNumber:(BOOL)orderFound {
    
    [self clearAndUnalertCommonFields];
    [self.deliveryTextField resetPicker];
    
    self.selectedProducts = nil;
    [self.selectedProductsTableView reloadData];
    [self updateSelectedProductsTableViewHeight];
    
    [self.productsView removeFromSuperview];
    
    [self.subjectViewSubjectPicker removeFromSuperview];
    [self.subjectViewDescriptionTextfield removeFromSuperview];
    [self.subjectViewSubmitButton removeFromSuperview];
    [self.deliveryView removeFromSuperview];
    [self.paymentCPFContactRequestPinnedView removeFromSuperview];
    [self.bankView removeFromSuperview];
    [self.bankPickerTextField resetPicker];
    self.agencyTextField.text = @"";
    self.accountTextField.text = @"";
    [self.paymentInformationContactRequestPinnedView removeFromSuperview];
    [self.paymentCreditCardInformationContactRequestPinnedView removeFromSuperview];
    [self.paymentCreditCard2InformationContactRequestPinnedView removeFromSuperview];
    [self.viewBankSlipContactRequestPinnedView removeFromSuperview];
    [self.subjectOrderErrorView removeFromSuperview];
    [self.backToMarketplaceContactRequestPinnedView removeFromSuperview];
    [self.packagePickerView removeFromSuperview];
    [self.packageTextField resetPicker];
    [self.packageConditionPickerView removeFromSuperview];
    [self.packageConditionTextField resetPicker];
    [self.reimbursementTypePickerView removeFromSuperview];
    [self.reimbursementTypeTextField resetPicker];
    
    if (orderFound) {
        if ((self.contactRequestType == ContactRequestWarranty) && (![self.order.hasWarranty boolValue]) && (self.order.hasWarranty != nil)) {
            [self.requestTypeBottom addSubview:self.subjectOrderErrorView];
            self.subjectErrorMessageLabel.text = CONTACT_REQUEST_ORDER_WARRANTY_NOT_FOUND;
        } else if (
                   (self.contactRequestType == ContactRequestCancellation || self.contactRequestType == ContactRequestOrder || self.contactRequestType == ContactRequestOtherServices)
                   && ([self.order.canceled boolValue])
                   && (self.order.canceled != nil)) {
            
            [self.requestTypeBottom addSubview:self.subjectOrderErrorView];
            self.subjectErrorMessageLabel.text = CONTACT_REQUEST_ORDER_CANCELED;
            
        } else {
            [self loadOrderDeliveries];
            [self.requestTypeBottom addSubview:self.deliveryView];
        }
        
    } else {
        [self.requestTypeBottom addSubview:self.subjectOrderErrorView];
        self.subjectErrorMessageLabel.text = CONTACT_REQUEST_ORDER_NOT_FOUND;
    }

}

- (void)selectedDelivery:(WBRContactRequestDeliveryModel *)delivery {
    self.delivery = delivery;
    self.subjectTextField.options = [self.requestType.subjects valueForKeyPath:@"label"];
    
    NSString *deliveryStr = [NSString stringWithFormat:@"%d - %@", (unsigned int)([self.deliveries indexOfObject:self.delivery] + 1), self.delivery.seller.sellerName];
    self.deliveryTextField.text = deliveryStr;
    
    [self clearAndUnalertCommonFields];
    
    self.products = self.delivery.products;
    [self.productsCollectionView reloadData];
    
    self.selectedProducts = [NSMutableArray new];
    if (self.products.count == 1) {
        self.selectedProducts = self.products.copy;
    }
    [self.selectedProductsTableView reloadData];
    
    [self.requestTypeBottom addSubview:self.productsView];
    
    switch (self.contactRequestType) {
        case ContactRequestNormal:
        case ContactRequestDelivery:
        case ContactRequestOrder:
        case ContactRequestWarranty:
        case ContactRequestStatus:
        case ContactRequestOtherServices: {
            [self filterSubjectsForOrdersWithExpiredDelivery:self.delivery.expiredDelivery];
            [self.formSections removeObject:self.exchangeFormView];
            [self.requestTypeBottom addSubview:self.subjectViewSubjectPicker];
            [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
            [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
            break;
        }
            
        case ContactRequestOther: {
            [self.formSections removeObject:self.exchangeFormView];
            break;
        }
        case ContactRequestCancellation: {
            [self loadExchangeFieldsWithSuccesCompletionNotification:^{
                [self.requestTypeBottom addSubview:self.subjectViewSubjectPicker];
            }];
            break;
        }
        case ContactRequestPayments: {
            [self loadExchangeFieldsWithSuccesCompletionNotification:^{
                [self filterSubjectsForPaymentsContactRequestWithExpiredBankSlip:[self.exchangeModel.expiredBankSlip boolValue] andApprovedPayment:[self.exchangeModel.approvedPayment boolValue]];
                
                [self.requestTypeBottom addSubview:self.subjectViewSubjectPicker];
                [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
                [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
            }];
            break;
        }
        default:
            break;
    }
    
    [self updateSelectedProductsTableViewHeight];

}

- (void)filterSubjectsForOrdersWithExpiredDelivery:(NSNumber *)expiredDelivery {
    NSMutableArray<WBRContactRequestSubjectModel *> *arraySubjectModel = [NSMutableArray arrayWithArray: self.requestType.subjects];
    NSMutableArray *subjectsItems = [[NSMutableArray alloc] initWithArray:self.subjectTextField.options];
    
    if ((!expiredDelivery) || ([expiredDelivery boolValue])) {
        self.requestType.subjects = self.requestTypeProtected.subjects;
        self.subjectTextField.options = [self.requestTypeProtected.subjects valueForKeyPath:@"label"];
    } else {
        NSString *optionString = @"Minha entrega está atrasada";
        NSString *predicateString = [NSString stringWithFormat:@"label == '%@'", optionString];
        [arraySubjectModel removeObjectsInArray:[arraySubjectModel filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString]]];
        [subjectsItems removeObject:optionString];
        
        NSArray<WBRContactRequestSubjectModel> *arrayRequestSubjetModel = [NSArray<WBRContactRequestSubjectModel> arrayWithArray:arraySubjectModel];
        self.requestType.subjects = arrayRequestSubjetModel;
        self.subjectTextField.options = subjectsItems;
    }
}

- (void)filterSubjectsForPaymentsContactRequestWithExpiredBankSlip:(BOOL)expiredBankSlip andApprovedPayment:(BOOL)approvedPayment {

    NSMutableArray<WBRContactRequestSubjectModel *> *arraySubjectModel = [NSMutableArray arrayWithArray: self.requestType.subjects];
    NSMutableArray *subjectsItems = [[NSMutableArray alloc] initWithArray:self.subjectTextField.options];
    
    if (approvedPayment) {
        NSString *optionString = @"Meu pagamento não foi confirmado";
        NSString *predicateString = [NSString stringWithFormat:@"label == '%@'", optionString];
        [arraySubjectModel removeObjectsInArray:[arraySubjectModel filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString]]];
        [subjectsItems removeObject:optionString];
    }
    
    if (expiredBankSlip || approvedPayment) {
        NSString *optionString = @"Preciso da 2ª via de boleto";
        NSString *predicateString = [NSString stringWithFormat:@"label == '%@'", optionString];
        [arraySubjectModel removeObjectsInArray:[arraySubjectModel filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString]]];
        [subjectsItems removeObject:optionString];
    }

    NSArray<WBRContactRequestSubjectModel> *arrayRequestSubjetModel = [NSArray<WBRContactRequestSubjectModel> arrayWithArray:arraySubjectModel];
    self.requestType.subjects = arrayRequestSubjetModel;
    self.subjectTextField.options = subjectsItems;
}

- (void)selectedSubject {
    
    self.subject = self.requestType.subjects[self.subjectTextField.selectedOptionIndex];
    
    if (self.contactRequestType == ContactRequestPayments) {
        [self handleSelectedSubjectForRequestPayment];
    }
    else if (self.contactRequestType == ContactRequestCancellation) {
        [self handleSelectedSubjectForRequestCancellation];
    }
    else if (self.contactRequestType != ContactRequestCancellation) {
        [self selectedSubjectWithDisclaimer:self.subject.disclaimer];
    }
}

- (void)handleSelectedSubjectForRequestPayment {
    
    [self.subjectViewDescriptionTextfield removeFromSuperview];
    [self.subjectViewSubmitButton removeFromSuperview];
    [self.viewBankSlipContactRequestPinnedView removeFromSuperview];
    [self.backToMarketplaceContactRequestPinnedView removeFromSuperview];
    [self setupBackToMarketPlaceButton];
    
    if ([self.subject.label isEqualToString:CONTACT_REQUEST_BANK_SLIP_COPY]) {
        
        WBRContactRequestPaymentModel *firstPayment = [self.exchangeModel.paymentMethods firstObject];
        if ([firstPayment paymentType] == kExchangePaymentTypeBankSlip) {
            if ([self.exchangeModel.expiredBankSlip boolValue]) {
                self.subjectErrorMessageLabel.text = CONTACT_REQUEST_BANK_SLIP_OUT_OF_DATE;
                [self.requestTypeBottom addSubview:self.subjectOrderErrorView];
                [self.requestTypeBottom addSubview:self.backToMarketplaceContactRequestPinnedView];
            }
            else {
                [self loadOrderInformation];
            }
        }
        else {
            self.subjectErrorMessageLabel.text = CONTACT_REQUEST_CREDIT_CARD_PAYMENT_REFUND_BANK_SLIP;
            [self.requestTypeBottom addSubview:self.subjectOrderErrorView];
            [self.requestTypeBottom addSubview:self.backToMarketplaceContactRequestPinnedView];
        }
    }
    else if ([self.subject.label isEqualToString:CONTACT_REQUEST_PAYMENT_NOT_CONFIRMED]) {
        
        WBRContactRequestPaymentModel *firstPayment = [self.exchangeModel.paymentMethods firstObject];
        if ([firstPayment paymentType] == kExchangePaymentTypeBankSlip) {
            
            if ([self.exchangeModel.allowCreateBankSlipTicket boolValue]) {
                [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
                [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
            }
            else {
                self.subjectErrorMessageLabel.text = CONTACT_REQUEST_PAYMENT_WITHIN_LIMIT;
                [self.requestTypeBottom addSubview:self.subjectOrderErrorView];
                [self.requestTypeBottom addSubview:self.backToMarketplaceContactRequestPinnedView];
            }
        }
        else {
            
            [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
            [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
        }
    }
    else {
        
        [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
        [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
    }
}

- (void)handleSelectedSubjectForRequestCancellation {
    
    [self removeExchangeFields];
    [self removeRefundView];
    [self showPackagePicker];
}

- (void)removeExchangeFields {
    
    [self.packagePickerView removeFromSuperview];
    self.packageTextField.text = @"";
    [self.packageConditionPickerView removeFromSuperview];
    self.packageConditionTextField.text = @"";
    [self.reimbursementTypePickerView removeFromSuperview];
    self.reimbursementTypeTextField.text = @"";
}

- (void)selectedSubjectWithDisclaimer:(BOOL)showDisclaimer {
    
    [self setContinueButtonEnabled:!showDisclaimer];
    
    [self.subjectViewSubmitButton removeFromSuperview];
    [self.subjectViewDescriptionTextfield removeFromSuperview];
    
    if (showDisclaimer) {
        self.subjectErrorMessageLabel.text = self.subject.message;
        
        [self.subjectViewSubmitButton removeFromSuperview];
        [self.subjectViewDescriptionTextfield removeFromSuperview];
        
        [self.requestTypeBottom addSubview:self.subjectOrderErrorView];
        [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
    }
    else {
        [self.requestTypeBottom addSubview:self.subjectViewDescriptionTextfield];
        [self.requestTypeBottom addSubview:self.subjectViewSubmitButton];
    }
}

- (void)setContinueButtonEnabled:(BOOL)enabled {
    
    //If we are disabling, even before the animation is finished, the button should already be disabled
    if (!enabled) {
        [self.sendButton setUserInteractionEnabled:NO];
    }
    else {
        [self.sendButton setUserInteractionEnabled:YES];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        if (enabled) {
            self.sendButton.alpha = EnabledElementAlphaValue;
        }
        else {
            self.sendButton.alpha = DisabledElementAlphaValue;
        }
    } completion:nil];
}
#pragma mark - Thankyou Page Delegate
- (void)thankyouPageTicketFinish {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)thankyouPageTicketListTouched {
    if (self.showedFromMenu) {
        [self.requestTypeTextField resetPicker];
        [self clearAndUnalertCommonFields];
        [self resetViewControllerState];
        WBRContactTicketViewController *ticketListViewController = [[WBRContactTicketViewController alloc] init];
        WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:ticketListViewController];
        [self presentViewController:navigation animated:YES completion:nil];

    } else {
        [self dismissViewControllerAnimated:YES completion:^{}];
        if ([self.delegate respondsToSelector:@selector(thankyouPageTicketListTouched)]) {
            [self.delegate thankyouPageTicketListTouched];
        }
    }

}

#pragma mark - General methods

- (void)converSelectedTypeToContactRequestType {
    if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_OTHER]){
        self.contactRequestType = ContactRequestOther; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_BUY]){
        self.contactRequestType = ContactRequestBuy; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_DELIVERY]){
        self.contactRequestType = ContactRequestDelivery; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_CANCELLATION]){
        self.contactRequestType = ContactRequestCancellation; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_ORDER]){
        self.contactRequestType = ContactRequestOrder; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_PAYMENTS]){
        self.contactRequestType = ContactRequestPayments; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_EXCHANGE]){
        self.contactRequestType = ContactRequestExchange; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_WARRANTY]){
        self.contactRequestType = ContactRequestWarranty; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_REGISTER]){
        self.contactRequestType = ContactRequestRegister; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_STORE]){
        self.contactRequestType = ContactRequestStore; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_STATUS]){
        self.contactRequestType = ContactRequestStatus; }
    else if ([[self.requestType.type uppercaseString] isEqualToString:REQUEST_TYPE_OTHER_SERVICES]) {
        self.contactRequestType = ContactRequestOtherServices;
    }
}

#pragma mark - Send Request

- (IBAction)sendRequestPressed:(id)sender {
    
    [self unalertFields:[self activeFields]];
    
    self.alertMsg = nil;
    
    //Check fields
    NSString *errorMsg;
    NSMutableArray *invalidFields = [self validateAndGetInvalidFields:&errorMsg];
    
    if (![self.requestType.generic boolValue] && self.selectedProducts.count == 0) {
        self.alertMsg = CONTACT_REQUEST_ALERT_SELECT_PRODUCTS;
        CGRect productsViewFrame = [self.productsView.superview convertRect:self.productsView.frame toView:self.scrollView];
        [self.scrollView scrollRectToVisible:productsViewFrame animated:YES];
    }
    
    if (invalidFields.count > 0) {
        if (![invalidFields containsObject:self.detailsTextView] &&
            (self.detailsTextView.text.length < 10 || self.detailsTextView.text.length > 3000)) {
            [invalidFields addObject:self.detailsTextView];
        }
        
        if (invalidFields.count > 1) {
            self.alertMsg = CONTACT_REQUEST_ALERT_INCOMPLETE_FORM;
        }
        else {
            self.alertMsg = errorMsg;
        }
        
        UIView *firstInvalidField = invalidFields.firstObject;
        CGRect firstInvalidFieldFrame = [firstInvalidField.superview convertRect:firstInvalidField.frame toView:self.scrollView];
        [self.scrollView scrollRectToVisible:firstInvalidFieldFrame animated:YES];
    } else {
        
        if ([[self activeFields] containsObject:self.detailsTextView]) {
            //Description field custom logic
            if (self.detailsTextView.text.length < 10 || self.detailsTextView.text.length > 3000) {
                invalidFields = [NSMutableArray new];
                [invalidFields addObject:self.detailsTextView];
                self.alertMsg = CONTACT_REQUEST_ALERT_DESCRIPTION_FORM;
            }
            
            UIView *firstInvalidField = invalidFields.firstObject;
            CGRect firstInvalidFieldFrame = [firstInvalidField.superview convertRect:firstInvalidField.frame toView:self.scrollView];
            [self.scrollView scrollRectToVisible:firstInvalidFieldFrame animated:YES];
            
        }
    }
    
    if (self.alertMsg.length > 0) {
        [self.view showFeedbackAlertOfKind:WarningAlert message:_alertMsg];
        if (invalidFields.count > 0) {
            [self alertFields:invalidFields color:[FeedbackColor warningColor].CGColor];
        }
    }
    else {
        [self sendContactRequest];
    }
}

- (NSArray *)activeFields {
    
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    if ([self.requestType.generic boolValue]) {
        
        [fields addObject:self.subjectTextField];
        [fields addObject:self.detailsTextView];
        
        if (![WALSession isAuthenticated]) {
            [fields addObject:self.usernameTextfield];
            [fields addObject:self.cpfTextfield];
            [fields addObject:self.emailTextfield];
            [fields addObject:self.telephoneTextfield];
        }
    }
    else {
        if (self.contactRequestType == ContactRequestNormal ||
            self.contactRequestType == ContactRequestDelivery ||
            self.contactRequestType == ContactRequestOrder ||
            self.contactRequestType == ContactRequestPayments ||
            self.contactRequestType == ContactRequestWarranty ||
            self.contactRequestType == ContactRequestStatus ||
            self.contactRequestType == ContactRequestOtherServices) {
            
            [fields addObject:self.subjectTextField];
            [fields addObject:self.detailsTextView];
        }
        else if (self.contactRequestType == ContactRequestCancellation) {
            
            if ([self.subject.type caseInsensitiveCompare:REQUEST_TYPE_CANCELLATION] == NSOrderedSame) {
                [fields addObject:self.subjectTextField];
                
                [fields addObject:self.packageTextField];
                [fields addObject:self.packageConditionTextField];
                [fields addObject:self.reimbursementTypeTextField];

                if (self.refundType == RefundTypeBank) {
                    [fields addObject:self.bankPickerTextField];
                    [fields addObject:self.agencyTextField];
                    [fields addObject:self.accountTextField];
                }
                [fields addObject:self.detailsTextView];

            }
            else if ([self.subject.type caseInsensitiveCompare:REQUEST_TYPE_EXCHANGE] == NSOrderedSame){
                [fields addObject:self.subjectTextField];
                [fields addObject:self.packageTextField];
                [fields addObject:self.packageConditionTextField];
                [fields addObject:self.reimbursementTypeTextField];
                
                if (self.refundType == RefundTypeBank) {
                    [fields addObject:self.bankPickerTextField];
                    [fields addObject:self.agencyTextField];
                    [fields addObject:self.accountTextField];
                }
                
                [fields addObject:self.detailsTextView];
            }
        }
    }
    
    return fields.copy;
}

- (void)unalertFields:(NSArray *)fields {
    for (UIView *view in fields) {
        view.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
    }
}

- (void)alertFields:(NSArray *)fields color:(CGColorRef)color {
    for (UIView *field in fields) {
        field.layer.borderColor = color;
    }
}

- (NSString *)errorMessageForField:(UITextField *)textField {
    
    NSString *errorMessage;
    
    if (textField == self.subjectTextField) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_SUBJECT;
    } else if (textField == (UITextField *)self.detailsTextView) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_DESCRIPTION;
    } else if (textField == self.usernameTextfield) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_USERNAME;
    } else if (textField == self.cpfTextfield) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_CPF;
    } else if (textField == self.emailTextfield) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_EMAIL;
    } else if (textField == self.telephoneTextfield) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_TELEPHONE;
    } else if (textField == self.bankPickerTextField) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_BANK_NAME;
    } else if (textField == self.agencyTextField) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_BANK_BRANCH;
    } else if (textField == self.accountTextField) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_ACCOUNT_NUMBER;
    } else if (textField == self.packageTextField) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_PACKAGE;
    } else if (textField == self.packageConditionTextField) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_PACKAGE_CONDITION;
    } else if (textField == self.reimbursementTypeTextField) {
        errorMessage = CONTACT_REQUEST_VALIDATION_ERROR_MESSAGE_REINBURSEMENT_TYPE;
    }
    return errorMessage;
}

- (NSMutableArray *)validateAndGetInvalidFields:(NSString **)errorMsg {
    
    NSMutableArray *invalidFields = [NSMutableArray new];
    NSArray *activeFields = [self activeFields];
    
    for (UITextField *field in activeFields) {
        if (field == self.cpfTextfield) {
            if (self.cpfTextfield.text.length == 0 || ![self.cpfTextfield.text isCPF]) {
                [invalidFields addObject:self.cpfTextfield];
                *errorMsg = [self errorMessageForField:field];
            }
        } else if (field == self.emailTextfield) {
            if (self.emailTextfield.text.length == 0 || ![self.emailTextfield.text isEmail]) {
                [invalidFields addObject:self.emailTextfield];
                *errorMsg = [self errorMessageForField:field];
            }
        } else if (field == self.telephoneTextfield) {
            if (self.telephoneTextfield.text.length == 0 || ![self.telephoneTextfield.raw isMobilePhone]) {
                [invalidFields addObject:self.telephoneTextfield];
                *errorMsg = [self errorMessageForField:field];
            }
        } else {
            if (field.text.length == 0) {
                [invalidFields addObject:field];
                *errorMsg = [self errorMessageForField:field];
            }
        }
    }
    
    return invalidFields;
}

- (void)clearAndUnalertCommonFields {
    NSMutableArray *fields = [NSMutableArray new];
    if (self.subjectTextField) {
        [fields addObject:self.subjectTextField];
    }
    if (self.detailsTextView) {
        [fields addObject:self.detailsTextView];
    }
    [self unalertFields:fields];
    [self.subjectTextField resetPicker];
    self.detailsTextView.text = @"";
    self.detailsTextViewCharCount.text = @"0/3000 caracteres";
    [self.subjectViewSubjectPicker removeFromSuperview];
    [self.subjectOrderErrorView removeFromSuperview];
    [self.backToMarketplaceContactRequestPinnedView removeFromSuperview];
    [self.subjectViewSubmitButton removeFromSuperview];
    [self.subjectViewDescriptionTextfield removeFromSuperview];
    [self removeRefundView];
    [self.reimbursementTypePickerView removeFromSuperview];
    self.reimbursementTypeTextField.text = @"";
    [self.packagePickerView removeFromSuperview];
    self.packageTextField.text = @"";
    [self.packageConditionPickerView removeFromSuperview];
    self.packageConditionTextField.text = @"";
    [self.reimbursementTypePickerView removeFromSuperview];
    self.reimbursementTypeTextField.text = @"";
}

#pragma mark - Scroll View

- (IBAction)tappedScrollView:(id)sender {
    [self.scrollView endEditing:YES];
}

#pragma mark - TextView Delegates

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger lenght = textView.text.length;
    self.detailsTextViewCharCount.text = [NSString stringWithFormat:@"%li/3000 caracteres", (long)lenght];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length + text.length > kMaxLengthTextFieldDescription) {
        return NO;
    }
    
    if([text length] == 0) {
        if([textView.text length] > 0) {
            return YES;
        }
    } else if([[textView text] length] >= kMaxLengthTextFieldDescription)    {
        return NO;
    }
    return YES;
}

#pragma mark - Keyboard

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    if (self.detailsTextView.isFirstResponder) {
        CGRect detailsParentFrame = [self.detailsTextView.superview convertRect:self.detailsTextView.frame toView:self.scrollView];
        [self.scrollView scrollRectToVisible:detailsParentFrame animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.scrollViewBottomSpaceConstraint.constant = 0;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - MsgCommon Delegate 

- (void)showPopUpAlertWithError:(NSError *)error {
    
    [self.navigationController.view showPopupWithTitle:GREETING_OPS message:error.localizedDescription cancelButtonTitle:@"Cancelar" cancelBlock:^{
        [[WALMenuViewController singleton] presentHomeWithAnimation:YES reset:NO];
        
    } actionButtonTitle:TRY_BUTTON actionBlock:^{
        switch (self.retryState) {
            case RetryStateForm:
                [self loadSubjects];
                break;
                
            case RetryStateDeliveries:
                [self loadOrderDeliveries];
                break;
                
            case RetryStateExchangeFields: {
                [self loadExchangeFieldsWithSuccesCompletionNotification:^{
                    [self.requestTypeBottom addSubview:self.subjectViewSubjectPicker];
                }];
                break;
            }
            case RetryStateLoadBanks: {
                [self loadBanks];
                break;
            }
            case RetryStateLoadOrderInformation: {
                [self loadOrderInformation];
                break;
            }
            case RetryStateLoadOrders: {
                [self loadOrders];
                break;
            }
        }
    }];
}

- (void)openOrders {
    
    WBRContactOrdersViewController *ordersViewController = [[WBRContactOrdersViewController alloc] initWithOrders:self.ordersArray.orders withSelectionItemNotification:^(WBRContactRequestOrderModel *selectedOrder, BOOL exists) {
        
        self.orderNumberTextField.text = selectedOrder.orderId;
        self.order = selectedOrder;
        
        [self selectedOrderNumber:exists];
    }];
    
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:ordersViewController];
    [self presentViewController:navigation animated:YES completion:nil];
}


#pragma mark - Deliveries Selection ViewController/Delegate

- (void)openDeliveries {
    WBRContactDeliveryViewController *deliveriesViewController = [[WBRContactDeliveryViewController alloc] initWithDeliveries:self.deliveries];
    [deliveriesViewController setDelegate:self];
    
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:deliveriesViewController];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)contactDeliveryDidSelect:(WBRContactRequestDeliveryModel *)delivery {
    [self selectedDelivery:delivery];
}

#pragma mark - IBAction

- (IBAction)viewBankSlipAction:(id)sender {
    
    if (![self.bankSlipURL isEqualToString:@""] && self.bankSlipURL) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.bankSlipURL]];
    }
    else {
        [self.navigationController.view showAlertWithImageName:nil title:@"Ops" attributedMessage:[[NSAttributedString alloc] initWithString:@"Tentar novamente"] dismissButtonTitle:@"OK" dismissBlock:nil];
    }
}

- (IBAction)backToMarketplace:(id)sender {
    [[WALMenuViewController singleton] unselectHeaderButtons];
    [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
    
    if (!self.showedFromMenu) {
        [[WALMenuViewController singleton] unselectHeaderButtons];
        [[WALMenuViewController singleton] presentOrdersViewController];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
