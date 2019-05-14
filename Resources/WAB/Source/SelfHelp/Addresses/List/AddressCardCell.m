//
//  CardAddressView.m
//  Walmart
//
//  Created by Renan on 5/14/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "AddressCardCell.h"
#import "AddressModel.h"

#define RECEIVER_NAME_LABEL_TOP_CONSTRAINT 12
#define ADDRESS_LABEL_TRAILING_CONSTRAINT 5
#define MAIN_ADDRESS_IMAGE_HEIGHT_CONSTRAINT 15

#define BUTTON_DEFAULT_BLUE_COLOR [UIColor colorWithRed:33.0/255.0 green:150.0/255.0 blue:243.0/255.0 alpha:1.0]
#define BUTTON_DEFAULT_GREEN_COLOR [UIColor colorWithRed:76.0/255.0 green:175.0/255.0 blue:80.0/255.0 alpha:1.0]

@interface AddressCardCell ()

@property (nonatomic, strong) AddressModel *address;

@property (weak, nonatomic) IBOutlet UILabel *addressDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverNameLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressDescriptionLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainAddressImageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *zipCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainAddressImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *mainAddressButton;

@property (weak, nonatomic) IBOutlet UIView *cardView;

@end

@implementation AddressCardCell

#pragma mark - Life Cycle

- (AddressCardCell *)initForTestCase
{
    Class class = [self class];
    NSString *nibName = NSStringFromClass(class);
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    self = [nibViews objectAtIndex:0];
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.cardView.layer.cornerRadius = 4.0f;
    self.cardView.layer.masksToBounds = YES;
}

#pragma mark - Overide

/**
 Method used to update border color due to selection state, if state == YES so the border color will be blue otherwise it'll be the default gray
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self setBorderColorBlue];
    }
    else {
        [self setBorderColorGray];
    }
}

#pragma mark - Public Methods

- (void)setupWithAddress:(AddressModel *)address {
    
    self.address = address;
    
    LogInfo(@"Receiver Name: %@", address.receiverName);
    
    if ([address.defaultAddress boolValue]) {
        [self.mainAddressButton setTitle:@"Endereço principal" forState:UIControlStateNormal];
        [self.mainAddressButton setTitleColor:BUTTON_DEFAULT_GREEN_COLOR forState:UIControlStateNormal];
        [self.mainAddressButton setUserInteractionEnabled:NO];
    } else {
        [self.mainAddressButton setTitle:@"Definir como principal" forState:UIControlStateNormal];
        [self.mainAddressButton setTitleColor:BUTTON_DEFAULT_BLUE_COLOR forState:UIControlStateNormal];
        [self.mainAddressButton setUserInteractionEnabled:TRUE];
    }
    
    self.addressDescriptionLabel.text = address.addressDescription;
    self.receiverNameLabel.text = address.receiverName;
    self.streetLabel.text = [address streetNameWithComplement];
    self.complementLabel.text = [address additionalInformation];
    
    self.zipCodeLabel.text = [NSString stringWithFormat:@"CEP: %@", address.zipcode];
    
    [self showDefaultAddressViews:[address.defaultAddress boolValue]];
    
    [self updateDescriptionConstraintsIfNeeded];
}

#pragma mark - Private Methods

/**
 Update layout if cell's address is not the default one, so it's content must be adjusted to fit the layout
 */
- (void)updateDescriptionConstraintsIfNeeded {
    
    if ([self.addressDescriptionLabel.text isEqualToString:@""] || self.addressDescriptionLabel.text == nil) {
        
        self.addressDescriptionLabelTrailingConstraint.constant = 0;
        
        if ([self.address.defaultAddress compare:@(1)] == NSOrderedSame) {
            self.receiverNameLabelTopConstraint.constant = RECEIVER_NAME_LABEL_TOP_CONSTRAINT;
            self.mainAddressImageViewHeightConstraint.constant = MAIN_ADDRESS_IMAGE_HEIGHT_CONSTRAINT;
        }
        else {
            self.receiverNameLabelTopConstraint.constant = 0;
            self.mainAddressImageViewHeightConstraint.constant = 0;
        }
    }
    else {
        self.receiverNameLabelTopConstraint.constant = RECEIVER_NAME_LABEL_TOP_CONSTRAINT;
        self.addressDescriptionLabelTrailingConstraint.constant = ADDRESS_LABEL_TRAILING_CONSTRAINT;
        self.mainAddressImageViewHeightConstraint.constant = MAIN_ADDRESS_IMAGE_HEIGHT_CONSTRAINT;
    }
    
}

/**
 Method to show/hidde the main address if it's the default one
 
 @param isDefaultAddress address enabled
 */
- (void)showDefaultAddressViews:(BOOL)isDefaultAddress {
    
    if (isDefaultAddress) {
        self.mainAddressImageView.hidden = NO;
        self.mainAddressLabel.hidden = NO;
    }
    else {
        self.mainAddressImageView.hidden = YES;
        self.mainAddressLabel.hidden = YES;
    }
}

- (void)setBorderColorBlue {
    self.cardView.layer.borderWidth = 2.0f;
    self.cardView.layer.borderColor = RGBA(33, 150, 243, 1).CGColor;
}

- (void)setBorderColorGray {
    self.cardView.layer.borderWidth = 1.0f;
    self.cardView.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
}

#pragma mark - IBAction

- (IBAction)editPressed:(id)sender {
    LogInfo(@"Edit address - ID: %@", self.address.addressId);
    if (self.delegate && [self.delegate respondsToSelector:@selector(editAddress:)]) {
        [self.delegate editAddress:self.address];
    }
}

- (IBAction)deletePressed:(id)sender {
    LogInfo(@"Delete address - ID: %@", self.address.addressId);
    if ([_delegate respondsToSelector:@selector(addressCardCellPressedDeleteButton:)]) {
        [_delegate addressCardCellPressedDeleteButton:self];
    }
}

- (IBAction)setAsDefaultPressed:(id)sender{
    LogInfo(@"Set address default - ID: %@", self.address.addressId);
    if ([_delegate respondsToSelector:@selector(addressCardCellSetAsDefaulAddress:)]) {
        [_delegate addressCardCellSetAsDefaulAddress:self.address];
    }
}

@end
