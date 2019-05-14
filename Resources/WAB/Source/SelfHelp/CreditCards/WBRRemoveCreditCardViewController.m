//
//  WBRRemoveCreditCardViewController.m
//  Walmart
//
//  Created by Rafael Valim on 10/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRRemoveCreditCardViewController.h"
#import "WBRCreditCardValidation.h"
#import "WBRCreditCard.h"

@interface WBRRemoveCreditCardViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleBottomConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *creditCardFlagImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creditCardFlagWidthConstraint;


@property (weak, nonatomic) IBOutlet UILabel *creditCardFlagName;
@property (weak, nonatomic) IBOutlet UILabel *creditCardMaskedNumber;

@property (weak, nonatomic) IBOutlet WMButtonRounded *cancelButton;
@property (weak, nonatomic) IBOutlet WMButtonRounded *confirmButton;

@property (strong, nonatomic) WBRModelCreditCard *creditCard;

@end

@implementation WBRRemoveCreditCardViewController

CGFloat const CreditCardFlagWidthSingleWidth = 30.0f;
CGFloat const CreditCardFlagWidthDoubleWidth = 58.0f;

CGFloat const SubtitleBottomConstraintCollapsed = 0.0f;
CGFloat const SubtitleBottomConstraintExpanded = 27.0f;

- (instancetype)initWithCreditCard:(WBRModelCreditCard *)creditCard {
    self = [super init];
    if (self) {
        self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _creditCard = creditCard;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScreen];
    [self setRoundedCorner];
}

#pragma mark - Private Methods

- (void)setRoundedCorner {
    self.containerView.layer.cornerRadius = 2.0f;
    self.containerView.layer.masksToBounds = YES;
}


#pragma mark - Screen Setup

- (void)setupScreen {
    
    if (self.creditCard) {
        
        //Title
        if (self.creditCard.flagDefault) {
            [self.subTitleLabel setText:@"Ao excluir este cartão, você não terá cartões cadastrados para efetuar compras rápidas :("];
            [self.subTitleLabel setHidden:NO];
            self.subTitleBottomConstraint.constant = SubtitleBottomConstraintExpanded;
        }
        else {
            [self.subTitleLabel setText:@""];
            [self.titleLabel setText:@"Excluir cartão de crédito"];
            [self.subTitleLabel setHidden:YES];
            self.subTitleBottomConstraint.constant = SubtitleBottomConstraintCollapsed;
        }
        
        //Credit card information
        CreditCardValidationFlag cardFlag = [WBRCreditCardValidation creditCardFlagForBrand:self.creditCard.brand];
        UIImage *cardImage = [WBRCreditCardValidation thankYouPageImageForFlag:cardFlag];
        [self.creditCardFlagImage setImage:cardImage];
        [self.creditCardFlagName setText:[[self.creditCard.brand lowercaseString] capitalizedString]];
        [self.creditCardMaskedNumber setText:[NSString stringWithFormat:@"**** **** **** %@", self.creditCard.lastDigitsOfCard]];
        
        //Hiper card flag has 2 times the width of others credit cards
        if (cardFlag == CreditCardValidationFlagHiper) {
            self.creditCardFlagWidthConstraint.constant = CreditCardFlagWidthDoubleWidth;
        } else {
            self.creditCardFlagWidthConstraint.constant = CreditCardFlagWidthSingleWidth;
        }
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(didFailToRemoveCreditCard)]) {
                [self.delegate didFailToRemoveCreditCard];
            }
        }];
    }
}

#pragma mark - Button Actions

- (IBAction)cancelButtonAction:(id)sender {
    
    [self.cancelButton setUserInteractionEnabled:NO];
    [self.confirmButton setUserInteractionEnabled:NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissRemoveCreditCardPopup)]) {
            [self.delegate didDismissRemoveCreditCardPopup];
        }
    }];
}

- (IBAction)confirmButtonAction:(id)sender {
    
    [self.cancelButton setUserInteractionEnabled:NO];
    [self.confirmButton setUserInteractionEnabled:NO];
    
    [[WBRCreditCard new] deleteUserCreditCard:self.creditCard withSuccess:^(NSData *data) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(didRemoveCreditCard)]) {
                [self.delegate didRemoveCreditCard];
            }
        }];
    } andFailure:^(NSError *error, NSData *dataError) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(didFailToRemoveCreditCard)]) {
                [self.delegate didFailToRemoveCreditCard];
            }
        }];
    }];
}

@end
