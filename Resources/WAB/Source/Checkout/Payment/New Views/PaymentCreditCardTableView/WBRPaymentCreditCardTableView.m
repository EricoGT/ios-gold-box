//
//  WBRPaymentCreditCardTableView.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentCreditCardTableView.h"

#import "WBRPaymentCreditCardTableViewCell.h"
#import "WBRCardModel.h"
#import "CreditCardInteractor.h"
#import "WMOmniture.h"

@interface WBRPaymentCreditCardTableView () <UITableViewDelegate, UITableViewDataSource, WBRPaymentCreditCardTableViewCellProtocol>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) WBRPaymentCreditCardTableViewCell *selectedTableViewCell;

@end

@implementation WBRPaymentCreditCardTableView

#pragma mark - Init Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void)initSubviews {
    
    UINib *nib = [UINib nibWithNibName:@"WBRPaymentCreditCardTableView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    self.creditCardsTableView.delegate = self;
    self.creditCardsTableView.dataSource = self;
    self.creditCardsTableView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)customInit {
    [self initSubviews];
}

#pragma mark - Private Methods

- (NSNumber *)newContentHeight {
    
    NSNumber *newHeight;
    if (self.selectedIndexPath) {
        
        float expandedCellHeight;
        
        if (self.selectedTableViewCell.showingRateWarning) {
            expandedCellHeight = kCreditCardCellExpandedWithRateWarningHeight;
        }
        else {
            expandedCellHeight = kCreditCardCellExpandedHeight;
        }
        
        newHeight = @((self.contentArray.count - 1) * kCreditCardCellCollapsedHeight + expandedCellHeight);
    }
    else {
        newHeight = @(self.contentArray.count * kCreditCardCellCollapsedHeight);
    }
    
    return newHeight;
}

- (NSDictionary *)getDictErrorToPaymentWithMsg:(NSString *) msgError
{
    WBRPaymentCreditCardTableViewCell *selectedCell = [self.creditCardsTableView cellForRowAtIndexPath:self.selectedIndexPath];
    BOOL blockOperation = YES;
    NSDictionary *dictPaymentError = @{@"blockOperation"     :  [NSNumber numberWithBool:blockOperation],
                                       @"error"              :  msgError,
                                       @"paymentNumber"      :  self.paymentNumber,
                                       @"installmentsChoosed":  selectedCell.selectedInstallment ?: @"",
                                       @"cardSelected"       :  [NSNumber numberWithBool:YES]
                                       };
    return dictPaymentError;
}

- (void)selectFirstCell {
 
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.creditCardsTableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.creditCardsTableView didSelectRowAtIndexPath:firstIndexPath];
}

#pragma mark - Public Methods

- (void)setRateText:(NSString *)rateText {
    
    self.selectedTableViewCell = [self.creditCardsTableView cellForRowAtIndexPath:self.selectedIndexPath];
    [self.selectedTableViewCell setRateLabelText:rateText];
    
    [self.creditCardsTableView beginUpdates];
    [self.creditCardsTableView endUpdates];
    
    [self.delegate WBRPaymentCreditCardTableView:self didUpdateContentHeight:[self newContentHeight]];
}

- (void)setInstallmentText:(NSString *)installmentText {
    
    self.selectedTableViewCell = [self.creditCardsTableView cellForRowAtIndexPath:self.selectedIndexPath];
    [self.selectedTableViewCell setInstallmentText:installmentText];
    
    [self.creditCardsTableView beginUpdates];
    [self.creditCardsTableView endUpdates];
    
    [self.delegate WBRPaymentCreditCardTableView:self didUpdateContentHeight:[self newContentHeight]];
}

- (NSDictionary *)getContentPayment {
    
    WBRPaymentCreditCardTableViewCell *selectedCell = [self.creditCardsTableView cellForRowAtIndexPath:self.selectedIndexPath];
    WBRCardModel *selectedCard = self.selectedCard;
    
    if ([[selectedCell selectedInstallment] isEqualToString:@""] || [selectedCell selectedInstallment] == nil) {
        return [self getDictErrorToPaymentWithMsg:ERROR_INSTALLMENTS];
    }
    else if ([[selectedCell securityValue] isEqualToString:@""] || [selectedCell securityValue] == nil) {
        return [self getDictErrorToPaymentWithMsg:ERROR_SEC_CCARD];
    }
    
    //If success then inform other class
    BOOL hasInterest = NO;
//    self.cardAlreadySelected = YES;
    
    if ([self.paymentNumber isEqualToString:@"1"]) {
        hasInterest = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt1"];
    } else {
        hasInterest = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasInt2"];
    }
    
    NSString *selectedCardBrand = [selectedCard.brand lowercaseString];
    if ([selectedCardBrand containsString:@"hiper"]) {
        selectedCardBrand = @"hiper";
    }
    
    NSDictionary *dictPayment = @{@"blockOperation"     :   [NSNumber numberWithBool:NO],
                                  @"nameCard"           :   selectedCard.holder.name ?: @"",
                                  @"documentNumber"     :   selectedCard.holder.document ?: @"",
                                  @"cardNumber"         :   selectedCard.fakeCardNumber ?: @"",
                                  @"codCardNumber"      :   [selectedCell securityValue] ?: @"",
                                  @"monthCard"          :   [selectedCard.expirationDate substringToIndex:2] ?: @"",
                                  @"yearCard"           :   [selectedCard.expirationDate substringFromIndex:3] ?: @"",
                                  @"installmentsCard"   :   [selectedCell selectedInstallment] ?: @"",
                                  @"paymentNumber"      :   self.paymentNumber,
                                  @"cardId"             :   [self getCardNameWithName:selectedCardBrand] ?: @"",
                                  @"cardName"           :   selectedCard.brand ?: @"",
                                  @"installmentsChoosed":   [selectedCell selectedInstallment] ?: @"",
                                  @"cardSelected"       :   @1,//[NSNumber numberWithBool:self.cardAlreadySelected],
                                  @"hasInterest"        :   [NSNumber numberWithBool:hasInterest],
                                  @"creditCardToken"    :   selectedCard.cardId,
                                  @"maskedCCNumber"     :   selectedCard.mask,
                                  @"cardHolder"         :   selectedCard.holder.name
                                  };
    
    return dictPayment;
}

- (NSString *) getCardNameWithName:(NSString *) nameCard
{
    NSDictionary *dictAllCards = @{
                                   @"visa"       : @"1",
                                   @"amex"       : @"2",
                                   @"mastercard" : @"3",
                                   @"diners"     : @"4",
                                   @"hiper"      : @"22",
                                   @"elo"        : @"33"
                                   };
    NSString *idCard = [dictAllCards objectForKey:nameCard];
    return idCard;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedIndexPath &&
        self.selectedIndexPath.row == indexPath.row) {
        
        if (self.selectedTableViewCell.showingRateWarning) {
            return kCreditCardCellExpandedWithRateWarningHeight;
        }
        else {
            return kCreditCardCellExpandedHeight;
        }
    }
    else {
        return kCreditCardCellCollapsedHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedTableViewCell = [self.creditCardsTableView cellForRowAtIndexPath:self.selectedIndexPath];

    if (self.selectedIndexPath != indexPath) {
        
        WBRCardModel *selectedCard = [self.contentArray objectAtIndex:indexPath.row];
        if (!selectedCard.expired) {
            
            if (self.selectedIndexPath) {
                
                [self.selectedTableViewCell resetState];
            }
            
            [self.delegate WBRPaymentCreditCardTableView:self didSelectCard:selectedCard];
        }
    }
    
    self.selectedIndexPath = indexPath;
    [self.creditCardsTableView beginUpdates];
    [self.creditCardsTableView endUpdates];
    
    [self.delegate WBRPaymentCreditCardTableView:self didUpdateContentHeight:[self newContentHeight]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WBRPaymentCreditCardTableViewCell *cell = [self.creditCardsTableView dequeueReusableCellWithIdentifier:kCreditCardCellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WBRPaymentCreditCardTableViewCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    
    WBRCardModel *card = [self.contentArray objectAtIndex:indexPath.row];
    cell.paymentNumber = self.paymentNumber;
    cell.card = card;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - WBRPaymentCreditCardTableViewCell

- (void)WBRPaymentCreditCardTableViewCellDidSelectInstallmentOptions:(WBRPaymentCreditCardTableViewCell *)cell {
    
    if ([self.delegate respondsToSelector:@selector(WBRPaymentCreditCardTableViewDidSelectInstallmentsOption:)]) {
        [self.delegate WBRPaymentCreditCardTableViewDidSelectInstallmentsOption:self];
    }
}

#pragma mark - Custom Getter

- (NSNumber *)suggestedHeight {
    return [self newContentHeight];
}

- (WBRCardModel *)selectedCard {
    return [self.contentArray objectAtIndex:self.selectedIndexPath.row];
}

#pragma mark - Custom Setter 

- (void)setContentArray:(NSArray<WBRCardModel *> *)contentArray currentState:(kPaymentCreditCardState)currentState {
    
    _contentArray = contentArray;
    [self.creditCardsTableView reloadData];
    
    if (self.selectedIndexPath) {
        [self.creditCardsTableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.creditCardsTableView didSelectRowAtIndexPath:self.selectedIndexPath];
    }
    else {
        if (self.contentArray) {
            [WMOmniture trackCreditCardSaved:self.contentArray];
        }
        
        if (self.contentArray.count > 1) {
            
            WBRCardModel *firstCard = [self.contentArray firstObject];
            
            if (firstCard.defaultCard && !firstCard.expired && currentState != kPaymentCreditCardStateAddingNewCard) {
                [self selectFirstCell];
            }
        }
        else if (self.contentArray.count == 1) {
            
            WBRCardModel *firstCard = [self.contentArray firstObject];
            if (!firstCard.expired && currentState != kPaymentCreditCardStateAddingNewCard) {
                
                [self selectFirstCell];
            }
        }
    }
}

@end
