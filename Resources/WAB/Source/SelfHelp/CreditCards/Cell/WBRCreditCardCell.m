//
//  WBRCreditCardCell.h
//  Walmart
//
//  Created by Diego Dias on 10/27/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCreditCardCell.h"

#import "WMFloatLabelMaskedTextField.h"
#import "WBRCreditCardValidation.h"

@interface WBRCreditCardCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *defaultCardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bankFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *holderLabel;
@property (weak, nonatomic) IBOutlet UILabel *validityDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeCardButton;
@property (weak, nonatomic) IBOutlet UIButton *setDefaultButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditCardFlagWidthConstraint;

@property (nonatomic) NSIndexPath *indexPath;

#define kDisclaimerToRemoveCardColor  [UIColor colorWithRed:102.f/255.0f green:102.f/255.0f blue:102.f/255.0f alpha:1]
#define kDisclaimerToExpiredCardColor [UIColor colorWithRed:244/255.0f green:67/255.0f blue:54/255.0f alpha:1]
#define kDisclaimerToDefaulCardColor  [UIColor colorWithRed:76/255.0f green:175/255.0f blue:80/255.0f alpha:1]

#define kDisclaimerToRemoveFont     [UIFont fontWithName:@"Roboto-Regular" size:11]
#define kDisclaimerToCardStatusFont [UIFont fontWithName:@"Roboto-Medium" size:11]

@end

@implementation WBRCreditCardCell

CGFloat const CreditCardFlagWidthSingleWidthImage = 30.0f;
CGFloat const CreditCardFlagWidthDoubleWidthImage = 58.0f;

+ (NSString *)reuseIdentifier {
    return @"WBRCreditCardCellIdentifier";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cardView.layer.cornerRadius = 4.0f;
    self.cardView.layer.masksToBounds = YES;
    
    [self setBorderColorGray];
}

#pragma mark - Override

- (void)willMoveToWindow:(UIWindow *)newWindow {
    
    if (!newWindow) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Methods

- (void)setupCard:(WBRModelCreditCard *)card hasOnlyOneCard:(BOOL)hasOnlyOneCard indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    
    self.cardTitleLabel.text = [NSString stringWithFormat:@"%@ - Final %@", [card.brand capitalizedString], card.lastDigitsOfCard];
    [self shouldShowDefaultCard:card.flagDefault];
    self.holderLabel.text = card.completeName;
    self.validityDateLabel.text = [NSString stringWithFormat:@"Válido até %@", card.expirationDate];
    
    CreditCardValidationFlag cardFlag = [WBRCreditCardValidation creditCardFlagForBrand:card.brand];
    UIImage *cardImage = [WBRCreditCardValidation thankYouPageImageForFlag:cardFlag];
    self.bankFlagImageView.image = cardImage;
    
    //Hiper card flag has 2 times the width of others credit cards
    if (cardFlag == CreditCardValidationFlagHiper) {
        self.creditCardFlagWidthConstraint.constant = CreditCardFlagWidthDoubleWidthImage;
    } else {
        self.creditCardFlagWidthConstraint.constant = CreditCardFlagWidthSingleWidthImage;
    }
    
    [self configCardStateWithExpiratedStatus:card.expired isMainCard:card.flagDefault hasOnlyOneCard:hasOnlyOneCard];
}

#pragma mark Helpers
- (void)setBorderColorGray {
    self.cardView.layer.borderWidth = 1.0f;
    self.cardView.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
}

- (void)shouldShowDefaultCard:(BOOL)show {
    
    if (show) {
        self.defaultCardImageView.hidden = NO;
    }
    else {
        self.defaultCardImageView.hidden = YES;
    }
}

- (void)configCardStateWithExpiratedStatus:(BOOL)isExpired isMainCard:(BOOL)isMainCard hasOnlyOneCard:(BOOL)hasOnlyOneCard {
    
    if (isExpired) {
        self.disclaimerLabel.text      = @"Cartão vencido";
        self.disclaimerLabel.textColor = kDisclaimerToExpiredCardColor;
        self.disclaimerLabel.font      = kDisclaimerToCardStatusFont;
        self.disclaimerLabel.hidden    = NO;
        self.setDefaultButton.hidden   = YES;
        self.removeCardButton.hidden   = NO;
        
        if (isMainCard && !hasOnlyOneCard) {
            self.removeCardButton.hidden = YES;
        }
        
    } else {
        if (isMainCard) {
            if (hasOnlyOneCard) {
                self.disclaimerLabel.text      = @"Cartão principal";
                self.disclaimerLabel.hidden    = NO;
                self.disclaimerLabel.textColor = kDisclaimerToDefaulCardColor;
                self.disclaimerLabel.font      = kDisclaimerToCardStatusFont;
                
                self.removeCardButton.hidden   = NO;
                self.setDefaultButton.hidden   = YES;
            } else {
                self.disclaimerLabel.text      = @"*Para excluir este cartão, outro deve ser definido como principal.";
                self.disclaimerLabel.hidden    = NO;
                self.disclaimerLabel.textColor = kDisclaimerToRemoveCardColor;
                self.disclaimerLabel.font      = kDisclaimerToRemoveFont;
                
                self.removeCardButton.hidden   = YES;
                self.setDefaultButton.hidden   = YES;
                
            }
        } else {
            self.setDefaultButton.hidden = NO;
            self.removeCardButton.hidden = NO;
            self.disclaimerLabel.hidden = YES;
        }
    }
    
    [self layoutIfNeeded];
}

#pragma mark IBActions
- (IBAction)removeCardTouch:(id)sender {
    [self.delegate WBRCreditCardCellDidSelectRemoveCard:self.indexPath];
}

- (IBAction)setDefaultCardTouch:(id)sender {
    [self.delegate WBRCreditCardCellDidSelectSetDefaultCard:self.indexPath];
}

@end
