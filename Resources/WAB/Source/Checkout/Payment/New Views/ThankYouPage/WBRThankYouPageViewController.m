//
//  WBRThankYouPageViewController.m
//  Walmart
//
//  Created by Rafael Valim on 19/09/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRThankYouPageViewController.h"
#import "ShippingDelivery.h"
#import "WBRThankYouPageProductTableViewCell.h"
#import "WBRThankYouPageProductHeaderView.h"
#import "CardCreditResume.h"
#import "OFShipmentTemp.h"
#import "OFCartTemp.h"
#import "CardProductsResume.h"
#import "CardShippingAddressViewController.h"
#import "OFSetupCustomCheckout.h"
#import "ExtendedWarrantySuccessView.h"
#import "WMButton.h"
#import "WMWebViewController.h"
#import "WMOmniture.h"
#import "WMBaseNavigationController.h"
#import "ShowcaseTrackerModel.h"
#import "WALShowcaseTrackerManager.h"
#import "WMRetargetingConnection.h"
#import "OFAppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CreditCardInteractor.h"
#import "WBROrderManager.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface WBRThankYouPageViewController () <UITableViewDelegate, UITableViewDataSource, WBRThankYouPageProductHeaderViewProtocol>

#pragma mark - Information Headers
@property (weak, nonatomic) IBOutlet UIView *paymentMethodCreditCardInformationView;
@property (weak, nonatomic) IBOutlet UIView *paymentMethodBankSlipInformationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentMethodContentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

#pragma mark - Bottom Button
@property (weak, nonatomic) IBOutlet UIView *bottomView;

#pragma mark - Order Number
@property (weak, nonatomic) IBOutlet UILabel *orderNumberTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberSummaryLabel;

#pragma mark - User Information
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdentificationDocumentLabel;

#pragma mark - Address Information
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressComplementLabel;

#pragma mark - Payment Information
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productInterestRateLabelTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productInterestRateLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *productInterestRateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warrantyTopSpaceToProductContainer;
@property (weak, nonatomic) IBOutlet UILabel *productPaymentTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productPaymentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *productPaymentView;
@property (weak, nonatomic) IBOutlet UIImageView *productPaymentViewCreditCardFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *productPaymentViewUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPaymentViewCreditCardDigitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPaymentViewInstallmentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warrantyPaymentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *warrantyPaymentView;
@property (weak, nonatomic) IBOutlet UIImageView *warrantyPaymentViewCreditCardFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *warrantyPaymentViewUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *warrantyPaymentViewCreditCardDigitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *warrantyPaymentViewInstallmentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankSlipPaymentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bankSlipPaymentView;
@property (weak, nonatomic) IBOutlet UILabel *bankSlipPaymentViewUserNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *bankSlipPaymentViewShowBankSlipButton;
@property (weak, nonatomic) IBOutlet UILabel *bankSlipPaymentViewInstallmentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftCardPaymentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *giftCardPaymentView;
@property (weak, nonatomic) IBOutlet UILabel *giftCardPaymentViewUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftCardPaymentViewGiftCardDescription;
@property (weak, nonatomic) IBOutlet UILabel *giftCardPaymentViewInstallmentLabel;

#pragma mark - Delivery Information
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *deliveryTableView;
@property (nonatomic, strong) NSArray *shippingDeliveries;

#pragma mark - Warranty Information
@property (weak, nonatomic) IBOutlet UIView *warrantyViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warrantyViewContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warrantyViewContainerTopSpaceConstraint;


@property (nonatomic, strong) NSDictionary *dictOrderSuccess;

@property (weak) IBOutlet UIView *viewFeedback;
@property (nonatomic, strong) NSString *strUrl;

@property int ttOrder;

@property BOOL showExtendedWaranty;
@property BOOL isFromMail;

//Unit Test
@property BOOL mustBeVerified;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, assign) UIUserNotificationType typeNotif;

@end

@implementation WBRThankYouPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mustBeVerified = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
    if (_mustBeVerified) {
        _typeNotif = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    }
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    [((WMBaseNavigationController *)self.navigationController).navigationBar setBackgroundImage:[OFColors imageWithColor:RGBA(75, 176, 80, 1) size:CGSizeMake(self.view.bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    [((WMBaseNavigationController *)self.navigationController).navigationBar setShadowImage:[OFColors imageWithColor:RGBA(75, 176, 80, 1) size:CGSizeMake(self.view.bounds.size.width, 1)]];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.title = @"Pedido realizado";
    
    [self assignValuesToSuccess];
    [self adjustContentViewsVisibility];
    [self populateUserInformation];
    [self populateAddressInformation];
    [self populateDeliveryInformation];
    [self populateWarrantyInformation];
    [self makeViewFeedback];
    
    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self applyShadowViewBottom];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.shippingDeliveries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ShippingDelivery *shippingDelivery = (ShippingDelivery *)[self.shippingDeliveries objectAtIndex:section];
    
    return [shippingDelivery.cartItems count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ShippingDelivery *shippingDelivery = (ShippingDelivery *)[self.shippingDeliveries objectAtIndex:section];
    NSDictionary *deliveryStrings = [self.successDictionary objectForKey:@"scheduledDeliveryInformation"];
    
    WBRThankYouPageProductHeaderView *headerView = [self.deliveryTableView dequeueReusableHeaderFooterViewWithIdentifier:[WBRThankYouPageProductHeaderView reuseIdentifier]];
    [headerView setShippingDelivery:shippingDelivery onSection:section ofTotal:self.shippingDeliveries.count withDeliveryInfo:deliveryStrings];
    headerView.delegate = self;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShippingDelivery *shippingDelivery = (ShippingDelivery *)[self.shippingDeliveries objectAtIndex:indexPath.section];
    CartItem *cartItem = [shippingDelivery.cartItems objectAtIndex:indexPath.row];
    
    WBRThankYouPageProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[WBRThankYouPageProductTableViewCell reuseIdentifier]];
        [cell.productQuantityLabel setText:[NSString stringWithFormat:@"%@x", cartItem.quantity]];
        [cell.productDescriptionLabel setText:cartItem.productDescription];
    
    return cell;
}


#pragma mark - Private Methods

- (void)hideInterestRateMessage {
    [self.productInterestRateLabel setHidden:YES];
    self.productInterestRateLabelHeightConstraint.constant = 0.0f;
    self.productInterestRateLabelTopSpaceConstraint.constant = 0.0f;
}

- (void)applyShadowViewBottom {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bottomView.bounds];
    self.bottomView.layer.masksToBounds = NO;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0.0f, -7.0f);
    self.bottomView.layer.shadowOpacity = 0.2f;
    self.bottomView.layer.shadowRadius = 4.0f;
    self.bottomView.layer.shadowPath = shadowPath.CGPath;
}


- (CGFloat)suggestedPaymentMethodContentViewCreditCardHeight {
    return 66.0f;
}

- (CGFloat)suggestedPaymentMethodContentViewBankSlipHeight {
    return 124.0f;
}

#pragma mark - Screen Elements Logic
- (void)adjustContentViewsVisibility {
    
    if (self.isBankingTicket) {
        
        [self.productPaymentView setHidden:YES];
        self.productPaymentViewHeightConstraint.constant = 0.0f;
        [self.warrantyPaymentView setHidden:YES];
        self.warrantyPaymentViewHeightConstraint.constant = 0.0f;
        [self.giftCardPaymentView setHidden:YES];
        self.giftCardPaymentViewHeightConstraint.constant = 0.0f;
        [self.bankSlipPaymentView setHidden:NO];
        
        self.warrantyTopSpaceToProductContainer.constant = 0.0f;
        
        self.paymentMethodContentViewHeightConstraint.constant = [self suggestedPaymentMethodContentViewBankSlipHeight];
        [self.paymentMethodCreditCardInformationView setHidden:YES];
        [self.paymentMethodBankSlipInformationView setHidden:NO];
    }
    else {
        
        [self.productPaymentView setHidden:NO];
        
        NSArray *paymentArray = [self.successDictionary objectForKey:@"payment"];
        //The user paid the extended warranty separately
        if ([paymentArray count] == 1) {
            [self.warrantyPaymentView setHidden:YES];
            self.warrantyPaymentViewHeightConstraint.constant = 0.0f;
            self.warrantyTopSpaceToProductContainer.constant = 0.0f;
        }
        else {
            [self.warrantyPaymentView setHidden:NO];
        }
        
        [self.giftCardPaymentView setHidden:YES];
        self.giftCardPaymentViewHeightConstraint.constant = 0.0f;
        [self.bankSlipPaymentView setHidden:YES];
        self.bankSlipPaymentViewHeightConstraint.constant = 0.0f;
        self.paymentMethodContentViewHeightConstraint.constant = [self suggestedPaymentMethodContentViewCreditCardHeight];
        [self.paymentMethodCreditCardInformationView setHidden:NO];
        [self.paymentMethodBankSlipInformationView setHidden:YES];
    }
}

#pragma mark - User Information Logic

- (void)populateUserInformation {
    
    NSDictionary *userInfoDictionary = [self.successDictionary objectForKey:@"userInfo"];
    NSDictionary *userProfile = [userInfoDictionary objectForKey:@"profile"];
    
    NSString *userName = [userProfile objectForKey:@"fullName"];
    [self.userNameLabel setText:userName];
    
    NSString *email = [userProfile objectForKey:@"email"];
    [self.userEmailLabel setText:email];
    
    NSArray *phoneNumbers = [userProfile objectForKey:@"phones"];
    if ([phoneNumbers count] > 0) {
        NSDictionary *mainPhoneNumber = [phoneNumbers firstObject];
        
        NSString *phoneNumberAreaCode = [mainPhoneNumber objectForKey:@"areaCode"];
        NSString *phoneNumber = [mainPhoneNumber objectForKey:@"number"];
        
        if ([phoneNumberAreaCode length] > 0 && [phoneNumber length] > 0) {
            
            NSString *formattedPhoneNumber = phoneNumber;
            if (phoneNumber.length == 8) {
                formattedPhoneNumber = [NSString stringWithFormat:@"%@-%@",
                                        [phoneNumber substringWithRange:NSMakeRange(0, 4)],
                                        [phoneNumber substringWithRange:NSMakeRange(4, phoneNumber.length-4)]];
            } else if (phoneNumber.length >= 9) {
                formattedPhoneNumber = [NSString stringWithFormat:@"%@-%@",
                                        [phoneNumber substringWithRange:NSMakeRange(0, 5)],
                                        [phoneNumber substringWithRange:NSMakeRange(5, phoneNumber.length-5)]];
            }
            
            NSString *fullNumber = [NSString stringWithFormat:@"(%@) %@", phoneNumberAreaCode, formattedPhoneNumber];
            [self.userPhoneNumberLabel setText:fullNumber];
        }
    }
    
    NSString *userDocument = [userProfile objectForKey:@"document"];
    NSString *formattedUserDocument;
    
    if ([userDocument length] > 11) {
        //CNPJ
        formattedUserDocument = [NSString stringWithFormat:@"CNPJ: %@.%@.%@/%@-%@",
                                 [userDocument substringWithRange:NSMakeRange(0, 2)],
                                 [userDocument substringWithRange:NSMakeRange(2, 3)],
                                 [userDocument substringWithRange:NSMakeRange(5, 3)],
                                 [userDocument substringWithRange:NSMakeRange(8, 4)],
                                 [userDocument substringWithRange:NSMakeRange(12, 2)]];
    }
    else {
        //CPF
        formattedUserDocument = [NSString stringWithFormat:@"CPF: %@.%@.%@-%@",
                                 [userDocument substringWithRange:NSMakeRange(0, 3)],
                                 [userDocument substringWithRange:NSMakeRange(3, 3)],
                                 [userDocument substringWithRange:NSMakeRange(6, 3)],
                                 [userDocument substringWithRange:NSMakeRange(9, 2)]];
    }
    [self.userIdentificationDocumentLabel setText:formattedUserDocument];
}

#pragma mark - Address Logic

- (void)populateAddressInformation {
    
    NSDictionary *userInfoDictionary = [self.successDictionary objectForKey:@"userInfo"];
    
    NSString *streetName = [userInfoDictionary objectForKey:@"street"];
    NSString *number = [userInfoDictionary objectForKey:@"number"];
    NSString *complement = [userInfoDictionary objectForKey:@"complement"];
    NSString *neighborhood = [userInfoDictionary objectForKey:@"neighborhood"];
    
    NSMutableString *addressMutableString = [[NSMutableString alloc] init];
    if ([streetName length] > 0) {
        [addressMutableString appendString:streetName];
    }
    
    if ([number length] > 0) {
        if ([number isEqualToString:@"0"]) {
            number = @"S/N";
        }
        if ([addressMutableString length] > 0) {
            [addressMutableString appendString:[NSString stringWithFormat:@", %@", number]];
        }
        else {
            [addressMutableString appendString:[NSString stringWithFormat:@"%@", number]];
        }
    }
    
    if ([complement length] > 0) {
        if ([addressMutableString length] > 0) {
            [addressMutableString appendString:[NSString stringWithFormat:@" %@", complement]];
        }
        else {
            [addressMutableString appendString:[NSString stringWithFormat:@"%@", complement]];
        }
    }
    if ([neighborhood length] > 0) {
        if ([addressMutableString length] > 0) {
            [addressMutableString appendString:[NSString stringWithFormat:@" - %@", neighborhood]];
        }
        else {
            [addressMutableString appendString:[NSString stringWithFormat:@"%@", neighborhood]];
        }
    }
    [self.addressLabel setText:addressMutableString];
    
    
    NSString *zipCode = [userInfoDictionary objectForKey:@"postalCode"];
    NSString *city = [userInfoDictionary objectForKey:@"city"];
    NSString *state = [userInfoDictionary objectForKey:@"state"];
    
    NSMutableString *addressComplementMutableString = [[NSMutableString alloc] init];
    if ([zipCode length] > 0) {
        [addressComplementMutableString appendString:[NSString stringWithFormat:@"CEP: %@", zipCode]];
    }
    
    if ([city length] > 0) {
        if ([addressComplementMutableString length] > 0) {
            [addressComplementMutableString appendString:[NSString stringWithFormat:@" - %@", city]];
        }
        else {
            [addressComplementMutableString appendString:[NSString stringWithFormat:@"%@", city]];
        }
    }
    
    if ([state length] > 0) {
        if ([addressComplementMutableString length] > 0) {
            [addressComplementMutableString appendString:[NSString stringWithFormat:@" - %@", state]];
        }
        else {
            [addressComplementMutableString appendString:[NSString stringWithFormat:@"%@", state]];
        }
    }
    [self.addressComplementLabel setText:addressComplementMutableString];
}

#pragma mark - Delivery Logic

- (void)populateDeliveryInformation {
    
    self.shippingDeliveries = [self.successDictionary objectForKey:@"deliveries"];
    
    [self.deliveryTableView registerClass:[WBRThankYouPageProductHeaderView class] forHeaderFooterViewReuseIdentifier:[WBRThankYouPageProductHeaderView reuseIdentifier]];
    [self.deliveryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WBRThankYouPageProductTableViewCell class]) bundle:nil] forCellReuseIdentifier:[WBRThankYouPageProductTableViewCell reuseIdentifier]];
    self.deliveryTableView.rowHeight = UITableViewAutomaticDimension;
    self.deliveryTableView.estimatedRowHeight = 100.0f;
    self.deliveryTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.deliveryTableView.estimatedSectionHeaderHeight = 60.0f;
    
    self.deliveryTableViewHeightConstraint.constant = 3000.0f;
    [self.deliveryTableView reloadData];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.deliveryTableView layoutIfNeeded];
        self.deliveryTableViewHeightConstraint.constant = [self.deliveryTableView contentSize].height;
    }];
}

#pragma mark - Credit Card Logic

- (void)populateCreditCardInformation {
    
    [self.bankSlipPaymentView setHidden:YES];
    
    NSArray *paymentArray = [self.successDictionary objectForKey:@"payment"];
    
    NSDictionary *productPayment = [paymentArray firstObject];
    [self.productPaymentViewUserNameLabel setText:[productPayment objectForKey:@"nameCard"]];
    
    CreditCardFlag cardFlag = CreditCardFlagUnrecognized;
    
    NSString *cardNumber = [productPayment objectForKey:@"maskedCCNumber"];
    if (cardNumber == nil || [cardNumber isEqualToString:@""]) {
        cardNumber = [productPayment objectForKey:@"cardNumber"];
        cardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:cardNumber];
    } else {
        cardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:[cardNumber substringToIndex:6]];
    }
    
    NSString *lastFourCardDigits = [cardNumber substringFromIndex:cardNumber.length-4];
    UIImage *cardImage = [CreditCardInteractor thankYouPageImageForFlag:cardFlag];
    [self.productPaymentViewCreditCardFlagImageView setImage:cardImage];
    [self.productPaymentViewCreditCardDigitsLabel setText:[NSString stringWithFormat:@"Final - %@", lastFourCardDigits]];
    [self.productPaymentViewInstallmentLabel setText:[productPayment objectForKey:@"installmentsChoosed"]];
    
    //The user paid the extended warranty separately
    if ([paymentArray count] > 1) {
        
        [self.productPaymentTitleLabel setText:@"Primeiro cartão de crédito"];
        
        NSDictionary *warrantyPayment = [paymentArray objectAtIndex:1];
        [self.warrantyPaymentViewUserNameLabel setText:[warrantyPayment objectForKey:@"nameCard"]];
        
        NSString *cardNumber = [warrantyPayment objectForKey:@"maskedCCNumber"];
        if (cardNumber == nil || [cardNumber isEqualToString:@""]) {
            cardNumber = [warrantyPayment objectForKey:@"cardNumber"];
        }
        CreditCardFlag cardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:[cardNumber substringToIndex:6]];
        UIImage *cardImage = [CreditCardInteractor thankYouPageImageForFlag:cardFlag];
        [self.warrantyPaymentViewCreditCardFlagImageView setImage:cardImage];
        NSString *lastFourWarrantyCardDigits = [cardNumber substringFromIndex:cardNumber.length-4];
        [self.warrantyPaymentViewCreditCardDigitsLabel setText:[NSString stringWithFormat:@"Final - %@", lastFourWarrantyCardDigits]];
        [self.self.warrantyPaymentViewInstallmentLabel setText:[warrantyPayment objectForKey:@"installmentsChoosed"]];
    }
    
    //Add Label Interest
    if ([[productPayment objectForKey:@"hasInterest"] boolValue]) {
        
        NSString *strMonthInterest = [[NSUserDefaults standardUserDefaults] stringForKey:@"monthInterest1"];
        NSString *strYearInterest = [[NSUserDefaults standardUserDefaults] stringForKey:@"firstCreditCET"];
        NSString *strText = [NSString stringWithFormat:@"*Importante: Para financiamento com juros de %@%% a.m. CET máximo de %@%% a.a. (cobrado pela operadora do cartão de crédito).", strMonthInterest, strYearInterest];
        
        [self.productInterestRateLabel setText:strText];
    }
    else {
        [self hideInterestRateMessage];
    }
}


#pragma mark - Bank Slip Logic

- (void)populateBankSlipInfoWithValue:(float)orderTotalAmount {
    
    [self hideInterestRateMessage];
    
    orderTotalAmount = orderTotalAmount/100;
    NSString *strCurrency = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:orderTotalAmount]];
    [self.bankSlipPaymentViewInstallmentLabel setText:[NSString stringWithFormat:@"Pagamento à vista %@", strCurrency]];
    
    NSDictionary *userInfoDictionary = [self.successDictionary objectForKey:@"userInfo"];
    NSDictionary *userProfile = [userInfoDictionary objectForKey:@"profile"];
    
    NSString *userName = [userProfile objectForKey:@"fullName"];
    [self.bankSlipPaymentViewUserNameLabel setText:userName];
}


#pragma mark - Warranty Logic

- (void)populateWarrantyInformation {
    
    self.warrantyViewContainer.layer.cornerRadius = 4.0f;
    self.warrantyViewContainer.layer.masksToBounds = YES;
    self.warrantyViewContainer.layer.borderWidth = 1.0f;
    self.warrantyViewContainer.layer.borderColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f].CGColor;
    
    if (!self.showExtendedWaranty) {
        self.warrantyViewContainer.hidden = YES;
        self.warrantyViewContainerHeightConstraint.constant = 0.0f;
        self.warrantyViewContainerTopSpaceConstraint.constant = 0.0f;
        [self.view setNeedsLayout];
    }
}

#pragma mark - Feedback Logic

- (void) makeViewFeedback {
    
    self.viewFeedback.layer.cornerRadius = 4.0f;
    self.viewFeedback.layer.masksToBounds = YES;
    self.viewFeedback.layer.borderWidth = 1.0f;
    self.viewFeedback.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f].CGColor;
}

#pragma mark - Button Actions

- (IBAction)backToShoppingButtonAction:(id)sender {
    [self backToHome];
}

- (IBAction)sendBankSlipEmailButtonAction:(id)sender {
    [self sendMailToUser];
}

- (IBAction)openBankSlipButtonAction:(id)sender {
    [self getBankingSlip];
}

- (IBAction)feedbackButtonAction:(id)sender {
    [FlurryWM logEvent_feedbackFromOrderSuccess];
    
    OFFeedback *feedbackViewController = [[OFFeedback alloc] initWithIsModal:YES];
    feedbackViewController.delegate = self;
    WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:feedbackViewController];
    [self presentViewController:container animated:YES completion:nil];
    
    [[MDSSqlite new] cleanCart];
}

#pragma mark - Seller Detail Methods

- (void)showSellerDescriptionWithSellerId:(NSString *)sellerId {
    WMWebViewController *sellerDescription = [[WMWebViewController alloc] initWithURLStr:[[OFUrls new] getURLSellerDescriptionWithSellerId:sellerId] title:@"Detalhes"];
    WMBaseNavigationController *container = [[WMBaseNavigationController alloc] initWithRootViewController:sellerDescription];
    [self presentViewController:container animated:YES completion:nil];
}


#pragma mark - Legacy Methods

- (void) getValuesToFlurry
{
    NSString *paymentMethod = @"cartão";
    if (_isBankingTicket)
    {
        paymentMethod = @"boleto";
    }
    
    NSDictionary *dictFlurrySuccess = @{@"total"    :   [NSString stringWithFormat:@"%i", _ttOrder], @"order_id" :   self.orderNumberTopLabel.text, @"paymentMethod" : paymentMethod};
    LogInfo(@"Dict Flurry: %@", dictFlurrySuccess);
    [FlurryWM logEvent_checkout_success:dictFlurrySuccess];
}

- (void)handleEnteredBackgroundSuccess:(NSNotification *)notification
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MDSSqlite *sq = [MDSSqlite new];
        [sq deleteAllTokenCheckout];
        [sq deleteAllCartId];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnteredBackgroundSuccess:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)assignValuesToSuccess {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"tkBankSlip"];
    
    LogInfo(@"dictOrder: %@", self.successDictionary);
    
    self.dictOrderSuccess = self.successDictionary;
    
    self.showExtendedWaranty = [[self.successDictionary objectForKey:@"extendedWarranty"] boolValue] ?: NO;
    self.ttOrder = [[self.successDictionary objectForKey:@"totalOrder"] intValue];
    
    NSDictionary *dictOrderData = [_dictOrderSuccess objectForKey:@"orderResume"];
    NSString *strOrderNumber = [NSString stringWithFormat:@"%@", [dictOrderData objectForKey:@"orderNumber"]];
    
    [self.orderNumberTopLabel setText:[NSString stringWithFormat:@"Nº %@", strOrderNumber]];
    [self.orderNumberSummaryLabel setText:strOrderNumber];
    
    [self trackFacebookAnalytics];
    
    if (!_isBankingTicket) {
        [self populateCreditCardInformation];
    }
    else {
        NSArray *paymentsArray = [self.successDictionary objectForKey:@"payment"];
        float valueBankingSlip = [[[paymentsArray firstObject] objectForKey:@"value"] floatValue];
        [self populateBankSlipInfoWithValue:valueBankingSlip];
    }
    
    [self getValuesToFlurry];
    NSNumber *orderId = [dictOrderData objectForKey:@"orderNumber"];
    [[WMRetargetingConnection new] trackSuccessOrder:self.successDictionary orderId:orderId];
    
    [WMOmniture trackPurchaseComplete:self.successDictionary];
    
    MDSSqlite *sq = [MDSSqlite new];
    NSString *strTkBankSlip = [sq getTokenCheck]; //This token is saved here for banking slip only, before delete token checkout and cart id from sqlite.
    [[NSUserDefaults standardUserDefaults] setObject:strTkBankSlip forKey:@"tkBankSlip"];
    [sq deleteAllTokenCheckout];
    [sq deleteAllCartId];
}

#pragma mark - Facebook Analytics

- (void)trackFacebookAnalytics {
    
    NSArray *arrCart = [_dictOrderSuccess objectForKey:@"cart"] ?: 0;
    
    NSMutableString *strMutIds = [NSMutableString new];
    [strMutIds appendString:@"["];
    
    int ttItems = 0;
    
    for (int i=0;i<arrCart.count;i++) {
        
        //        LogInfo(@"[FACE] Sku %i: %@", i, [[arrCart objectAtIndex:i] objectForKey:@"sku"]);
        NSString *strId = [[arrCart objectAtIndex:i] objectForKey:@"sku"];
        
        BOOL isExtendedWarranty = [[[arrCart objectAtIndex:i] objectForKey:@"service"] boolValue];
        
        if (!isExtendedWarranty) {
            
            ttItems++;
            
            //        [strMutIds appendString:[NSString stringWithFormat:@"\"%@\",", strId]]; //com aspas
            [strMutIds appendString:[NSString stringWithFormat:@"%@,", strId]]; //sem aspas
        }
    }
    
    [strMutIds appendString:@"]"];
    NSString *arrStrIds = strMutIds;
    arrStrIds = [arrStrIds stringByReplacingOccurrencesOfString:@",]" withString:@"]"];
    
    LogInfo(@"Total order: %i", self.ttOrder);
    
    NSDictionary *dictOrderData = [_dictOrderSuccess objectForKey:@"orderResume"];
    NSString *strOrderNumber = [NSString stringWithFormat:@"%@", [dictOrderData objectForKey:@"orderNumber"]];
    
    float orderTt = (float)self.ttOrder/100;
    LogInfo(@"[FACE] logPurchase - Ids: %@ | Value: %.2f | Items: %@", arrStrIds, orderTt, [NSNumber numberWithInt:(int) ttItems]);
    
    [FBSDKAppEvents logPurchase:(double) orderTt
                       currency:@"BRL"
                     parameters:@{
                                  FBSDKAppEventParameterNameContentID   : arrStrIds,
                                  FBSDKAppEventParameterNameContentType : @"product",
                                  FBSDKAppEventParameterNameNumItems    : [NSNumber numberWithInt:(int) ttItems],
                                  @"fb_order_id" : strOrderNumber
                                  }
     ];
}


- (void) getBankingSlip {
    
    LogInfo(@"Show boleto!");
    [self performSelector:@selector(continueLoadingBankSlip) withObject:nil afterDelay:0.1];
}

- (void) continueLoadingBankSlip {
    
    NSDictionary *dictOrderData = [_dictOrderSuccess objectForKey:@"orderResume"];
    NSString *strOrderNumber = [NSString stringWithFormat:@"%@", [dictOrderData objectForKey:@"orderNumber"]];
    LogInfo(@"Order #: %@", strOrderNumber);
    
    [WBROrderManager getBankSlipWithOrder:strOrderNumber successBlock:^(NSDictionary *bankSlipContent) {
        [self requestJsonBankSlip:bankSlipContent];
    } failureBlock:^(NSError *error) {
        [self errorConnection:error.localizedDescription op:@""];
    }];
}

- (void) requestJsonBankSlip:(NSDictionary *)strJsonBankSlip {
    
    NSDictionary *dictTemp = [NSDictionary dictionaryWithDictionary:strJsonBankSlip];
    LogInfo(@"dictTemp: %@", dictTemp);
    
    NSString *strFromDict = [dictTemp objectForKey:@"bankSlip"];
    LogInfo(@"dictTemp2: %@", strFromDict);
    
    NSError *error = nil;
    NSData *jsonData = [strFromDict dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    self.strUrl = [jsonObjects valueForKey:@"url"];
    
    if (_isFromMail) {
        [self sendMailAfterRequest];
        
    } else {
        [self goBankingSlip:_strUrl];
    }
}

- (void) goBankingSlip:(NSString *) strUrlSlip {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrlSlip]];
    });
}

- (void)errorConnection:(NSString *)msgError op:(NSString *)operation {
    
    LogInfo(@"Error bankslip: %@", msgError);
    
    self.isFromMail = NO;
    
    [self.view hideModalLoading];
    
    [self.view showAlertWithMessage:ERROR_BANKING_SLIP_CONNECTION];
}

- (void) executeCancelFromAlert {
    LogInfo(@"Cancel from Msg");
    
    self.isFromMail = NO;
    
    [self.navigationController.view hideModalLoading];
}

- (void) executeActionFromAlert {
    LogInfo(@"Action from Msg");
    
    self.isFromMail = NO;
    
    [self.navigationController.view hideModalLoading];
}

- (void) sendMailToUser {
    [self.view showModalLoading];
    
    self.isFromMail = YES;
    
    [self continueLoadingBankSlip];
}

- (void) sendMailAfterRequest {
    
    LogInfo(@"Send mail: %@", _strUrl);
    
    if (_strUrl) {
        
        NSDictionary *dictOrderData = [_dictOrderSuccess objectForKey:@"orderResume"];
        NSString *strOrderNumber = [NSString stringWithFormat:@"%@", [dictOrderData objectForKey:@"orderNumber"]];
        
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:[NSString stringWithFormat:@"Boleto Bancário pedido %@", strOrderNumber]];
            [mail setMessageBody:[NSString stringWithFormat:@"Caro cliente, segue abaixo o link para o boleto bancário do pedido <b>%@</b>:<br>%@", strOrderNumber, _strUrl] isHTML:YES];
            //        [mail setToRecipients:@[@"testingEmail@example.com"]];
            
            [self presentViewController:mail animated:YES completion:NULL];
            
            [self.view hideModalLoading];
        }
        else
        {
            LogErro(@"This device cannot send email");
            
            [self.view hideModalLoading];
            
            [self.view showAlertWithMessage:ERROR_BANKING_SLIP_NO_MAIL];
            
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_SENDBANKSLIP_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:@"" andUserMessage:ERROR_BANKING_SLIP_NO_MAIL andScreen:@"WMSuccessViewController" andFragment:@"sendMailToUser"];
        }
    }
    else {
        
        LogErro(@"This url is null");
        
        [self.view hideModalLoading];
        
        [self.view showAlertWithMessage:ERROR_BANKING_SLIP_CONNECTION];
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_SENDBANKSLIP_ERR" andRequestUrl:@"" andRequestData:@"" andResponseCode:@"" andResponseData:@"" andUserMessage:ERROR_BANKING_SLIP_CONNECTION andScreen:@"WMSuccessViewController" andFragment:@"sendMailToUser"];
    }
    
    self.isFromMail = NO;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            LogInfo(@"You sent the email.");
            break;
            
        case MFMailComposeResultSaved:
            LogInfo(@"You saved a draft of this email");
            break;
            
        case MFMailComposeResultCancelled:
            LogInfo(@"You cancelled sending this email.");
            break;
            
        default:
            LogInfo(@"An error occurred when trying to compose this email");
            [self.view hideModalLoading];
            
            [self.view showAlertWithMessage:ERROR_BANKING_SLIP_COMPOSER];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Rating suggestion after order
- (void)backToHome
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSuccess" object:nil];
    
    [FlurryWM logEvent_pushContinueButton];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(verifyPush) withObject:nil afterDelay:1];
    });
}

#pragma mark - Recover Push off
- (void) verifyPush {
    
    if (_mustBeVerified && _typeNotif == UIUserNotificationTypeNone) {
        
        [FlurryWM logEvent_pushShowAlert];
        
        [self showAlertRecoverPushForce];
    }
    else {
        
        [self resetSessionAndFinalize];
    }
}


- (void) showAlertRecoverPushForce {
    
    _alertController = [UIAlertController alertControllerWithTitle:RECOVER_PUSH_ALERT_TITLE message: RECOVER_PUSH_ALERT_MSG preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* denyAction = [UIAlertAction
                                 actionWithTitle:@"Agora não"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self->_alertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                     [FlurryWM logEvent_pushNoButton];
                                     
                                     [self resetSessionAndFinalize];
                                     
                                 }];
    
    UIAlertAction* allowAction = [UIAlertAction
                                  actionWithTitle:@"Ajustes"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [self->_alertController dismissViewControllerAnimated:NO completion:nil];
                                      
                                      [FlurryWM logEvent_pushYesButton];
                                      
                                      [self resetSessionAndFinalize];
                                      [self requestPushPermissions];
                                      
                                  }];
    
    [_alertController addAction: denyAction];
    [_alertController addAction: allowAction];
    
    [self presentViewController:_alertController animated:YES completion:nil];
}

-(void)requestPushPermissions {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void) resetSessionAndFinalize {
    
    [(OFAppDelegate *)[[UIApplication sharedApplication] delegate] dismissModalViews];
    
    MDSSqlite *sq = [MDSSqlite new];
    [sq deleteAllTokenCheckout];
    [sq deleteAllCartId];
}

- (NSString *)currencyFormat:(float)value {
    
    NSNumber *amount = [[NSNumber alloc] initWithFloat:value];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"R$"];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *newFormat = [numberFormatter stringFromNumber:amount];
    
    LogInfo(@"Number: %@", newFormat);
    
    //Remove currency symbol
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"R$" withString:@""];
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    return newFormat;
}

#pragma mark - WBRThankYouPageProductHeaderViewProtocol

- (void)WBRThankYouPageProductHeaderView:(WBRThankYouPageProductHeaderView *)thankYouPageProductHeader didChooseSeller:(ShippingDelivery *)shippingDelivery {
    
    [self showSellerDescriptionWithSellerId:shippingDelivery.sellerId];
}

@end
