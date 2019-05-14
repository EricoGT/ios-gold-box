//
//  WBRPaymentCreditCardContent.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentCreditCardContent.h"
#import "WBRPaymentCreditCardTableView.h"

#import "CreditCardInteractor.h"

static const int kMainCardExpiredViewHeightConstant = 65;
static const int kTopViewHeightConstantExpanded = 98;
static const int kTopViewHeightConstantCollapsed = 23;
static const int kTopViewTitleLabelHeightConstaint = 18;

static const int kMainCardExpiredTitleLabelHeightConstant = 13;
static const int kMainCardExpiredTitleLabelTopConstant = 10;
static const int kMainCardExpiredTitleLabelBottomConstant = 6;
static const int kMainCardExpiredMessageLabelHeightConstant = 26;
static const int kMainCardExpiredMessageLabelBottomConstant = 10;

@interface WBRPaymentCreditCardContent () <WBRPaymentCreditCardTableViewProtocol, WBRPaymentAddNewCardViewProtocol>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet WBRPaymentCreditCardTableView *creditCardTableView;
@property (weak, nonatomic) IBOutlet WBRPaymentAddNewCardView *addNewCardView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *mainCardExpiredView;
@property (weak, nonatomic) IBOutlet UILabel *mainCardExpiredMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainCardViewTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewCardViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainCardExpiredViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainCardExpiredTitleLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainCardExpiredTitleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainCardExpiredTitleLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainCardExpiredMessageLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainCardExpiredMessageLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTitleLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTitleLabelBottomConstraint;

@end

@implementation WBRPaymentCreditCardContent

#pragma mark - Init Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    
    UINib *nib = [UINib nibWithNibName:@"WBRPaymentCreditCardContent" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    self.creditCardTableView.delegate = self;
    self.creditCardTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.addNewCardView.delegate = self;
    self.addNewCardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (self.wallet.cards.count > 0) {
        self.creditCardTableView.contentArray = self.wallet.cards;
    }
}

#pragma mark - Custom Getter

- (NSNumber *)suggestedHeight {
    NSNumber *suggestedHeight = @([self.creditCardTableView.suggestedHeight floatValue] + [self.addNewCardView.suggestedHeight floatValue] + self.topViewHeightConstraint.constant);
    return suggestedHeight;
}

#pragma mark - Custom Setter

- (void)setWallet:(WBRWalletModel *)wallet {

    _wallet = wallet;
    
    [self reloadContent];
}

#pragma mark - WBRPaymentCreditCardTableViewProtocol

- (void)WBRPaymentCreditCardTableView:(WBRPaymentCreditCardTableView *)paymentCreditCardTableView didSelectCard:(WBRCardModel *)card {

    [self.delegate WBRPaymentCreditCardContent:self didSelectCard:card];
    self.currentState = kPaymentCreditCardStateSelectingAddedCard;
}

- (void)WBRPaymentCreditCardTableView:(WBRPaymentCreditCardTableView *)paymentCreditCardTableView didUpdateContentHeight:(NSNumber *)newHeight {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [self.delegate WBRPaymentCreditCardContent:self didUpdateHeight:[self suggestedHeight]];
        
        if (self.creditCardTableView.selectedIndexPath) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.addNewCardView showAddForm:NO];
            }];
        }
    }];
}

- (void)WBRPaymentCreditCardTableViewDidSelectInstallmentsOption:(WBRPaymentCreditCardTableView *)paymentCreditCardTableView {
    
    self.currentState = kPaymentCreditCardStateSelectingAddedCard;
    
    if ([self.delegate respondsToSelector:@selector(paymentCreditCardContentOpenPaymentOptions)]) {
        [self.delegate paymentCreditCardContentCallInstallments];
    }
}

#pragma mark - WBRPaymentAddNewCardViewProtocol

- (void)WBRPaymnetAddNewCardView:(WBRPaymentAddNewCardView *)paymentAddNewCardView didUpdateContentHeight:(NSNumber *)newHeight {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [UIView animateWithDuration:0.3f animations:^{
            self.addNewCardViewHeightConstraint.constant = [newHeight floatValue];
            [self layoutIfNeeded];
            
            if (self.addNewCardView.currentState == kAddNewCardStateShowingForm) {
                
                self.currentState = kPaymentCreditCardStateAddingNewCard;
                
                if (self.creditCardTableView.contentArray.count > 0) {
                    [self.creditCardTableView.creditCardsTableView deselectRowAtIndexPath:self.creditCardTableView.selectedIndexPath animated:YES];
                    self.creditCardTableView.selectedIndexPath = nil;
                    [self.creditCardTableView.creditCardsTableView.delegate tableView:self.creditCardTableView.creditCardsTableView didSelectRowAtIndexPath:self.creditCardTableView.selectedIndexPath];
                }
            }
        }];
        
        [self.delegate WBRPaymentCreditCardContent:self didUpdateHeight:[self suggestedHeight]];
    }];
}

- (void)paymentAddNewCardViewShowFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message {
    if ([self.delegate respondsToSelector:@selector(paymentCreditCardContentShowFeedbackAlertOfKind:message:)]) {
        [self.delegate paymentCreditCardContentShowFeedbackAlertOfKind:kind message:message];
    }
}

- (void)paymentAddNewCardViewOpenPaymentOptions {
    
    if ([self.delegate respondsToSelector:@selector(paymentCreditCardContentOpenPaymentOptions)]) {
        [self.delegate paymentCreditCardContentOpenPaymentOptions];
    }
}

- (void)paymentAddNewCardViewCallInstallments {
    
    if ([self.delegate respondsToSelector:@selector(paymentCreditCardContentCallInstallments)]) {
        [self.delegate paymentCreditCardContentCallInstallments];
    }
}

- (void)paymentAddNewCardViewPressedScanCardButton:(WBRPaymentAddNewCardView *)cardPaymentCell {
    if ([self.delegate respondsToSelector:@selector(paymentCreditCardContentPressedScanCardButton:)]) {
        [self.delegate paymentCreditCardContentPressedScanCardButton:cardPaymentCell];
    }
}

#pragma mark - Private Methods

- (void)shouldShowMainCardExpired:(BOOL)show hasAdditionalCards:(BOOL)hasAdditionalCards{
    
    if (show) {
        self.mainCardExpiredView.hidden = NO;
        [self expandMainCardExpiredView];
        self.topViewHeightConstraint.constant = kTopViewHeightConstantExpanded;
        
        if (hasAdditionalCards) {
            self.mainCardExpiredMessageLabel.text = @"Escolha outro cartão, adicione um novo ou selecione a opção boleto bancário para finalizar a compra :)";
            [self.addNewCardView showAddForm:NO];
        }
        else {
            [self.addNewCardView showAddForm:YES];
            self.mainCardExpiredMessageLabel.text = @"Adicione um novo ou selecione a opção boleto bancário para finalizar a compra :)";
        }
    }
    else {
        
        if (self.currentState == kPaymentCreditCardStateSelectingAddedCard) {
            [self.addNewCardView showAddForm:NO];
        }
        else {
            [self.addNewCardView showAddForm:YES];
        }
        [self collapseMainCardExpiredView];
        self.topViewTitleLabelBottomConstraint.constant = 5;
        self.topViewHeightConstraint.constant = kTopViewHeightConstantCollapsed;
    }
    
    [self layoutIfNeeded];
    
    [self.delegate WBRPaymentCreditCardContent:self didUpdateHeight:[self suggestedHeight]];
}

- (void)expandMainCardExpiredView {
    self.mainCardExpiredTitleLabelTopConstraint.constant = kMainCardExpiredTitleLabelTopConstant;
    self.mainCardExpiredTitleLabelHeightConstraint.constant = kMainCardExpiredTitleLabelHeightConstant;
    self.mainCardExpiredTitleLabelBottomConstraint.constant = kMainCardExpiredTitleLabelBottomConstant;
    self.mainCardExpiredMessageLabelHeightConstraint.constant = kMainCardExpiredMessageLabelHeightConstant;
    self.mainCardExpiredMessageLabelBottomConstraint.constant = kMainCardExpiredMessageLabelBottomConstant;
    self.mainCardExpiredViewHeightConstraint.constant = kMainCardExpiredViewHeightConstant;
    
    [self layoutIfNeeded];
}

- (void)expandTopView {
    
    self.topViewTitleLabelHeightConstraint.constant = kTopViewTitleLabelHeightConstaint;
    self.topViewTitleLabelBottomConstraint.constant = 5;
    self.topViewHeightConstraint.constant = kTopViewHeightConstantCollapsed;
    
    [self layoutIfNeeded];
}

- (void)collapseMainCardExpiredView {
    self.mainCardExpiredTitleLabelTopConstraint.constant = 0;
    self.mainCardExpiredTitleLabelHeightConstraint.constant = 0;
    self.mainCardExpiredTitleLabelBottomConstraint.constant = 0;
    self.mainCardExpiredMessageLabelHeightConstraint.constant = 0;
    self.mainCardExpiredMessageLabelBottomConstraint.constant = 0;
    self.mainCardExpiredViewHeightConstraint.constant = 0;
    
    [self layoutIfNeeded];
}

- (void)collapseTopView {
    
    [self collapseMainCardExpiredView];
    
    self.topViewTitleLabelHeightConstraint.constant = 0;
    self.topViewTitleLabelBottomConstraint.constant = 0;
    self.topViewHeightConstraint.constant = 0;
    
    [self layoutIfNeeded];
}

- (void)showTopViewIfNeeded:(BOOL)show {
    
    if (show) {
        [self expandTopView];
    }
    else {
        [self collapseTopView];
        self.topView.hidden = YES;
    }
}

- (void)reloadContent {
    
    kPaymentCreditCardState lastState = self.currentState;
    
    self.creditCardTableView.contentArray = self.wallet.cards;
    [self.creditCardTableView setContentArray:self.wallet.cards currentState:lastState];
    
    if (self.wallet && self.wallet.total >= self.wallet.maxCards) {
        self.addNewCardView.shouldHideSaveCard = YES;
    }
    
    __block WBRCardModel *mainCard;
    [self.wallet.cards enumerateObjectsUsingBlock:^(WBRCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.defaultCard == YES) {
            mainCard = obj;
            *stop = YES;
        }
    }];
    
    self.addNewCardView.shouldShowTitle = self.wallet.cards.count > 0;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (self.wallet.cards.count == 0 || lastState == kPaymentCreditCardStateAddingNewCard) {
            [self.addNewCardView showAddForm:YES];
            [self.addNewCardView textFieldDidEndEditing:self.addNewCardView.creditCardNumber];
            
            if (self.wallet.cards.count == 0) {
                [self showTopViewIfNeeded:NO];
            }
        }
        else {
            if (mainCard.expired) {
                [self shouldShowMainCardExpired:YES hasAdditionalCards:(self.wallet.cards.count > 1)];
            }
            else {
                
                [self shouldShowMainCardExpired:NO hasAdditionalCards:(self.wallet.cards.count > 1)];
            }
        }
    }];
}

#pragma mark - Public Methods

- (void)setCardContainerLabelText:(NSString *)titleText {
    [self.mainCardViewTitleLabel setText:titleText];
}

- (void)resetCardsState {
    if ([self.wallet.cards count] > 0) {
        self.currentState = kPaymentCreditCardStateSelectingAddedCard;
    }
    else {
        self.currentState = kPaymentCreditCardStateAddingNewCard;
    }
    self.creditCardTableView.selectedIndexPath = nil;
    [self reloadContent];
}

- (void)clearCreditCardInputtedContent {
    [self.addNewCardView resetContentValues];
    [self.creditCardTableView.creditCardsTableView reloadData];
}

- (void)collapseContent {
    [self.addNewCardView collapseContent];
    self.addNewCardViewHeightConstraint.constant = 0;
    [self collapseMainCardExpiredView];
    [self layoutIfNeeded];
}

- (void)clearSelectedInstallment {
    //TODO: CLEAR SELECTED INSTALLMENT OF SELECTED CREDIT CARD
    //    if (newCard) {
    self.addNewCardView.installmentSelectedTextField.text = @"";

    //    } else {
    //        selectedCard
    //    }
}

- (void)setPaymentNumber:(NSString *) paymentNumber {
    [self.addNewCardView setPaymentNumber:paymentNumber];
    [self.creditCardTableView setPaymentNumber:paymentNumber];
}

- (void)setCreditCardNumberInvalidLayout:(BOOL)invalid {
    
    WMFloatLabelMaskedTextField *cardNumberTextField;
    //TODO: Set layout to saved card
//    if (newCard) {
    cardNumberTextField = self.addNewCardView.creditCardNumber;
//    } else {
//        selectedCard
//    }
    
    if (invalid) {
        cardNumberTextField.layer.borderColor = [FeedbackAlertView colorForFeedbackAlertKind:WarningAlert].CGColor;
    } else {
        [cardNumberTextField defaultBorderColor];
    }
}

- (void)setInstallmentText:(NSString *)installmentText {
    
    if (self.currentState == kPaymentCreditCardStateAddingNewCard) {
        self.addNewCardView.installmentSelectedTextField.text = installmentText;
    }
    else {
        [self.creditCardTableView setInstallmentText:installmentText];
    }
}

- (void)setHasProduct:(BOOL)hasProduct {
    //TODO: Set hasProduct to saved card
    //    if (newCard) {
    self.addNewCardView.hasProduct = hasProduct;
    //    } else {
    //        selectedCard
    //    }
}

- (void)setHasExtendedWarranty:(BOOL)hasExtendedWarranty {
    //TODO: Set hasExtendedWarranty to saved card
    //    if (newCard) {
    self.addNewCardView.hasExtendedWarranty = hasExtendedWarranty;
    //    } else {
    //        selectedCard
    //    }
}

- (NSDictionary *)getContentPayment {
    
    if (self.currentState == kPaymentCreditCardStateAddingNewCard) {
        return [self.addNewCardView getContentPayment];
    }
    else {
        return [self.creditCardTableView getContentPayment];
    }
}

- (NSString *)getCreditCardNumber {
    if (self.currentState == kPaymentCreditCardStateAddingNewCard) {
        return self.addNewCardView.creditCardNumber.text;
    } else {
        return self.creditCardTableView.selectedCard.mask;
    }
}

- (NSString *)getSelectedInstallmentText {
    //TODO: Get selected installment from saved card
    //    if (newCard) {
    return self.addNewCardView.installmentSelectedTextField.text;
    //    } else {
    //        selectedCard
    //    }
}

- (CreditCardFlag)getCreditCardFlag {
    
    CreditCardFlag creditCardFlag;
    if (self.currentState == kPaymentCreditCardStateAddingNewCard) {
        creditCardFlag = self.addNewCardView.creditCardFlag;
    }
    else {
        creditCardFlag = [CreditCardInteractor creditCardFlagWithCardNumberString:[self.creditCardTableView.selectedCard.mask substringToIndex:6]];
    }
    
    return creditCardFlag;
}

- (void)resignFirstResponderCreditCardNumberField {
    //TODO: resignFirstResponder from saved card
    //    if (newCard) {
    [self.addNewCardView.creditCardNumber resignFirstResponder];
    //    } else {
    //        selectedCard
    //    }
}

- (NSString *)getNameCardWithNumber:(NSString *)cardNumber {
    //TODO: getNameCardWithNumber from saved card
    //    if (newCard) {
    return [self.addNewCardView getNameCardWithNumber:cardNumber];
    //    } else {
    //        selectedCard
    //    }
}

- (void)setRateLabel:(NSString *)rateText {
    if (self.currentState == kPaymentCreditCardStateAddingNewCard) {
        [self.addNewCardView setRateTextLabel:rateText];
    } else {
        [self.creditCardTableView setRateText:rateText];
    }
}

- (void)hideRateLabelAnimated:(BOOL)animated {
    //TODO: hide rate label to saved card
    //    if (newCard) {
    [self.addNewCardView hideRateLabelAnimated:animated];
    //    } else {
    //        selectedCard
    //    }
}

@end
