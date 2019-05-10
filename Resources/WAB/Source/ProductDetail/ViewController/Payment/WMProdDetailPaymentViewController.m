//
//  WMProdDetailPaymentViewController.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WMProdDetailPaymentViewController.h"
#import "WMPaymentFormsTableViewCell.h"
#import "WMPaymentCardsButton.h"
#import "PaymentConnection.h"
#import "OFFormatter.h"
#import "NewCartViewController.h"
#import "WMLoadingView.h"
#import "RetryErrorView.h"
#import "OFMessages.h"
#import "WBRProductConnection.h"

#define CREDIT_CARD_KEY @"CREDIT_CARD"
#define BANK_SLIP_KEY @"BANK_SLIP"
#define DEBIT_CARD_KEY @"DEBIT_CARD"

@interface WMProdDetailPaymentViewController () <retryErrorViewDelegate>

@property (nonatomic) PaymentForms *payment;
@property (weak, nonatomic) IBOutlet UIView *bankSlipView;
@property (weak, nonatomic) IBOutlet UILabel *bankSlipMessage;
@property (weak, nonatomic) IBOutlet UIView *fixedHeaderView;

@property (nonatomic) NSInteger selectedRow;

@property (nonatomic) BOOL isSearchPresented;
@property (nonatomic) int statusBarHeight;

@property (strong, nonatomic) RetryErrorView *retryErrorView;

@end

static NSString * const ReuseIdentifierRates = @"reuseIdentifierRates";
@implementation WMProdDetailPaymentViewController

- (WMProdDetailPaymentViewController *)initWithStandardSKU:(NSString *)standardSKU price:(NSString *)price sellerId:(NSString *) sellerId delegate:(id<prodDetailPaymentDelegate>)delegate
{
    if (self = [super initWithTitle:@"Formas de pagamento" isModal:NO searchButton:YES cartButton:YES wishlistButton:NO])
    {
        _standardSKU = standardSKU;
        _price = price;
        _sellerId = sellerId;
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [FlurryWM logEvent_productPaymentEntering];
    
    self.selectedRow = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.scrollView.delegate = self;
    [self loadPaymentData];
    [self.tableView registerNib:[WMPaymentFormsTableViewCell nib] forCellReuseIdentifier:ReuseIdentifierRates];
    
    self.bankSlipView.hidden = YES;
    self.bankSlipMessage.text = PRODUCT_PAYMENT_FORMS_BANK_SLIP_MESSAGE;
        
    for (UIView * button in self.view.subviews)
    {
        if([button isKindOfClass:[UIButton class]])
            [((UIButton *)button) setExclusiveTouch:YES];
    }
}

-(void)loadPaymentData
{
    [self.view showLoading];
    self.tableView.hidden = YES;
    self.fixedHeaderView.hidden = YES;
    
//    _standardSKU = standardSKU;
//    _price = price;
//    _sellerId = sellerId;
    
    NSDictionary *dictPaymentForms = @{@"sku" : _standardSKU,
                                       @"price" : _price,
                                       @"sellerId" : _sellerId
                                       };
    
    [[WBRProductConnection new] requestPaymentForms:dictPaymentForms successBlock:^(PaymentForms *payment) {

        [self.view hideLoading];
        self.tableView.hidden = NO;
        self.fixedHeaderView.hidden = NO;
        [self setPayment:payment];

    } failure:^(NSDictionary *dictError) {
        
        [self paymentOptionsFailure:dictError];
    }];
    
//    PaymentConnection *connection = [[PaymentConnection alloc] init];
//    [connection getPaymentFormsWithSku:self.standardSKU andPrice:self.price completionBlock:^(PaymentForms *payment) {
//        [self.view hideLoading];
//        self.tableView.hidden = NO;
//        self.fixedHeaderView.hidden = NO;
//        [self setPayment:payment];
//
//    } failureBlock:^(NSError *error) {
//        [self paymentOptionsFailure:error];
//    }];
}

-(void) setPayment:(PaymentForms *)payments {
    _payment = payments;
    [self setupCards];
    [self.tableView reloadData];
    [self setupCreditCardFooter];
}

-(void)setupCards {
    
    int topMargin = 20;
    int leftMargin = 15;
    int rightMargin = 15;
    int lastRightEdge = leftMargin;
    
    WMPaymentCardsButton *cardButton;
    NSArray *validPaymentTypes = @[BANK_SLIP_KEY, CREDIT_CARD_KEY, DEBIT_CARD_KEY];
    
    for (int i = 0; i < self.payment.payments.count; i++)
    {
        PaymentType *paymentType = [[self.payment.payments objectAtIndex:i] paymentType];
        if (paymentType.type.length > 0)
        {
            if ([validPaymentTypes containsObject:paymentType.type])
            {
                NSString *imageName = @"UIPaymentBankSlipIcon";
                
                if ([paymentType.type isEqualToString:DEBIT_CARD_KEY] || [paymentType.type isEqualToString:CREDIT_CARD_KEY]) {
                    
                    imageName = [self getCardImageNameFromId:paymentType._id] ?: @"UIPaymentBankSlipIcon";
                }
                
                UIImage *img = [UIImage imageNamed:imageName];
                cardButton = [[WMPaymentCardsButton alloc] initWithFrame:CGRectMake(lastRightEdge ,topMargin - 5, img.size.width+10, img.size.height+10) image:imageName paymentType:paymentType];
                
                cardButton.tag = i;
                [cardButton addTarget:self action:@selector(cardSelected:) forControlEvents:UIControlEventTouchUpInside];
                lastRightEdge += img.size.width+rightMargin;
                [self.scrollView addSubview:cardButton];
                
                if (i==0)
                {
                    cardButton.selected=YES;
                }
            }
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake(lastRightEdge + 10, self.scrollView.frame.size.height)];
}

-(void) cardSelected:(id)obj{
    
    [self deselectAllCards];
    
    WMPaymentCardsButton *btn = (WMPaymentCardsButton *)obj;
    PaymentType *paymentType = btn.paymentType;
    [btn setSelected:YES];
    
    BOOL isBankSlip = [paymentType.type isEqualToString:BANK_SLIP_KEY];
    if (isBankSlip)
    {
        self.tableView.hidden = YES;
        self.fixedHeaderView.hidden = YES;
        self.bankSlipView.hidden = NO;
    }
    else
    {
        self.tableView.hidden = NO;
        self.fixedHeaderView.hidden = NO;
        self.bankSlipView.hidden = YES;
        
        self.selectedRow = btn.tag;
        [self.tableView reloadData];
        [self setupCreditCardFooter];
    }
}

-(void) deselectAllCards{
    for (WMPaymentCardsButton *btn in self.scrollView.subviews) {
        [btn setSelected:NO];
    }
}

-(NSString *) getCardImageNameFromId:(NSNumber *)cardId {
    if ( [cardId isEqualToNumber:[NSNumber numberWithInt:0]] ) {
        return @"UIPaymentBankSlipIcon";
    }
    else if ( [cardId isEqualToNumber:[NSNumber numberWithInt:1]] ) {
        return @"UIProductDetailCardVisa.png";
    } else if ( [cardId isEqualToNumber:[NSNumber numberWithInt:3]] ) {
        return @"UIProductDetailCardMastercard.png";
    } else if ( [cardId isEqualToNumber:[NSNumber numberWithInt:2]] ) {
        return @"UIProductDetailCardAmex.png";
    } else if ( [cardId isEqualToNumber:[NSNumber numberWithInt:4]] ) {
        return @"UIProductDetailCardDiners.png";
    } else if ( [cardId isEqualToNumber:[NSNumber numberWithInt:33]] ) {
        return @"UIProductDetailCardElo.png";
    } else if ( [cardId isEqualToNumber:[NSNumber numberWithInt:22]] ) {
        return @"UIProductDetailCardHiper.png";
    }
    return @"";
}

- (void)setupCreditCardFooter
{
    CGSize bounds = self.view.bounds.size;       
    CGFloat margin = 15;
    PaymentItem *currentPaymentOption = [self.payment.payments objectAtIndex:self.selectedRow];
    NSNumber *paymentRate;
    
    for (Installment *installment in currentPaymentOption.installments)
    {
        if (installment.rate && installment.rate.floatValue > 0) {
            paymentRate = installment.rate;
            break;
        }
    }
    
    BOOL hasRate = (paymentRate && paymentRate.floatValue > 0);
    BOOL hasMaxCET = (currentPaymentOption.maxCET && currentPaymentOption.maxCET.floatValue > 0);
    
    if (hasRate && hasMaxCET)
    {
        CGFloat labelWidth = bounds.width - (margin * 2);
        
        UIView *footerView = [UIView new];
        footerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *footerLabel = [UILabel new];
        footerLabel.font = [UIFont fontWithName:@"OpenSans" size:10];
        footerLabel.numberOfLines = 0;
        footerLabel.textColor = RGBA(153, 153, 153, 1);
        footerLabel.backgroundColor = [UIColor whiteColor];
        
        NSString *rate = (paymentRate) ? [NSString stringWithFormat:@"%@%% a.m.", paymentRate.stringValue] : @"";
        NSString *maxCET = (currentPaymentOption.maxCET.length > 0) ? [NSString stringWithFormat:@"%@%% a.a.", currentPaymentOption.maxCET] : @"";
        NSString *rateMessage = [NSString stringWithFormat:[[OFMessages new] installmentsRateMessage], rate, maxCET];
        
        footerLabel.text = rateMessage;
        
        CGSize rateTextSize = [footerLabel.text sizeForTextWithFont:footerLabel.font constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        footerLabel.frame = CGRectMake(margin, margin, rateTextSize.width, rateTextSize.height);
        footerView.frame = CGRectMake(0, 0, bounds.width, margin + rateTextSize.height + margin);
        [footerView addSubview:footerLabel];
    
        self.tableView.tableFooterView = footerView;
    }
    else
    {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.width, margin)];
        footerView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = footerView;
    }
}

#pragma TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PaymentItem *currentPaymentOption = [self.payment.payments objectAtIndex:self.selectedRow];
    return currentPaymentOption.installments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WMPaymentFormsTableViewCell *cell = (WMPaymentFormsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifierRates forIndexPath:indexPath];
    cell.backgroundColor = (indexPath.row % 2) ? [UIColor whiteColor] : [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
    
    PaymentItem *currentPaymentOption = [self.payment.payments objectAtIndex:self.selectedRow];
    Installment *installment = [currentPaymentOption.installments objectAtIndex:indexPath.row];
    [cell setupWithInstallment:installment];
    
    return cell;
}

#pragma mark - Retry Error View
- (void)retry
{
    [self.retryErrorView removeFromSuperview];
    [self loadPaymentData];
}

- (void)paymentOptionsFailure:(NSDictionary *)error
{
    [self.view hideLoading];
    self.tableView.hidden = YES;
    self.fixedHeaderView.hidden = YES;
    
//    self.retryErrorView = [[RetryErrorView alloc] initWithMsg:error.localizedDescription];
    self.retryErrorView = [[RetryErrorView alloc] initWithMsg:error[@"error"]];
    self.retryErrorView.delegate = self;
    [self.view addSubview:self.retryErrorView];
}

- (IBAction) back
{
    [UIView animateWithDuration:.3 animations:^{
        self.view.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark - Cart
- (void)cart
{
    NewCartViewController *newCart = [NewCartViewController new];
    WMBaseNavigationController *navigation = [[WMBaseNavigationController alloc] initWithRootViewController:newCart];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)closeNewCartFromContinueBuyingIsModal:(BOOL)modal {
    [self dismissViewControllerAnimated:modal completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePaymentFromContinueShopping)]) {
        [self.delegate closePaymentFromContinueShopping];
    }
}

@end
