//
//  ShipAddressCell.m
//  Walmart
//
//  Created by Renan on 4/29/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ShipAddressCell.h"

#import "NSString+HTML.h"

#define RECEIVER_NAME_LABEL_TOP_CONSTRAINT 12
#define ADDRESS_LABEL_TRAILING_CONSTRAINT 5
#define MAIN_ADDRESS_IMAGE_HEIGHT_CONSTRAINT 15

@interface ShipAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *addressDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverNameLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressDescriptionLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainAddressImageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *receiverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *complementLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainAddressImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *mainAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIView *cardView;

@end

@implementation ShipAddressCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([ShipAddressCell class]);
}

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cardView.layer.cornerRadius = 4.0f;
    self.cardView.layer.masksToBounds = YES;
    
    [self setBorderColorGray];
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

#pragma mark - Private Methods

- (void)setupWithAddressDict:(NSDictionary *)addressDict enableEditControls:(BOOL)enableEdit {
    
    
    LogInfo(@"Receiver Name: %@", [addressDict objectForKey:@"receiverName"]);
    
    [self.editButton setHidden:!enableEdit];
    
    NSMutableDictionary *mutableAddressDictionary = [[NSMutableDictionary alloc] initWithDictionary:addressDict];
    
    addressDict = mutableAddressDictionary;

    self.addressDescriptionLabel.text = [addressDict objectForKey:@"description"];
    self.receiverNameLabel.text = [addressDict objectForKey:@"receiverName"];
    
    NSString *streetName = [addressDict objectForKey:@"street"];
    NSString *complement = [addressDict objectForKey:@"complement"];
    NSString *number = [addressDict objectForKey:@"number"];
    self.streetLabel.text = [self streetLabelContentWithName:streetName withNumber:number withComplement:complement];

    NSString *neighborhood = [addressDict objectForKey:@"neighborhood"];
    NSString *city = [addressDict objectForKey:@"city"];
    NSString *state = [addressDict objectForKey:@"state"];
    self.complementLabel.text = [self additionalInformationWithNeighborhood:neighborhood withCity:city withState:state];
    
    NSString *zipcode = [addressDict objectForKey:@"postalCode"];
    self.zipCodeLabel.text = [NSString stringWithFormat:@"CEP: %@", [self formatZipcodeString:zipcode]];
    
    [self showDefaultAddressViews:[[addressDict objectForKey:@"default"] boolValue]];
    
    [self updateDescriptionConstraintsIfNeeded:[[addressDict objectForKey:@"default"] boolValue]];
}

/**
 Update layout if cell's address is not the default one, so it's content must be adjusted to fit the layout
 */
- (void)updateDescriptionConstraintsIfNeeded:(BOOL)defaultAddress {
    
    if ([self.addressDescriptionLabel.text isEqualToString:@""] || self.addressDescriptionLabel.text == nil) {
        
        self.addressDescriptionLabelTrailingConstraint.constant = 0;
        
        if (defaultAddress) {
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
 Formats Zipcode

 @param zipcode to be formatted
 @return formatted zipcode
 */
- (NSString *)formatZipcodeString:(NSString *)zipcode {
    
    NSString *formatedZipcode = @"";
    if ([zipcode length] > 0) {
        NSMutableString *mutableZipcode = [NSMutableString stringWithString:zipcode];
        if ([zipcode length] > zipcodeDashIndex) {
            [mutableZipcode insertString:@"-" atIndex:zipcodeDashIndex];
        }
        
        formatedZipcode = mutableZipcode;
    }
    
    return formatedZipcode;
}

/**
 Method to get aditional information
 
 @param neighborhood
 @param city
 @param state
 @return concatened neighborhood, city and state
 */
- (NSString *)additionalInformationWithNeighborhood:(NSString *)neighborhood withCity:(NSString *)city withState:(NSString *)state {
    
    NSString *complementString = [NSString stringWithFormat:@"%@ - %@ - %@", neighborhood, city, state];
    return complementString;
}

/**
 Returns the formated string to street label

 @param streetName
 @param number
 @param complement
 @return formated string to be showed showed
 */
- (NSString *)streetLabelContentWithName:(NSString *)streetName withNumber:(NSString *)number  withComplement:(NSString *)complement {

    NSString *address = @"";
    
    LogInfo(@"Street i18n Old: %@", streetName);
    NSString *decodedStreetName = [streetName kv_decodeHTMLCharacterEntities];
    
    address = decodedStreetName;
    
    if (number && ![number isEqualToString:@""] && ![number isEqualToString:@"0"])
    {
        address = [NSString stringWithFormat:@"%@, %@", address, number];
    }
    else {
        address = [NSString stringWithFormat:@"%@, S/N", address];
    }
    
    if (![complement isEqualToString:@""]) {
        address = [NSString stringWithFormat:@"%@ - %@", address, complement];
    }
    
    return address;
}

/**
 Method to show/hidde the main address if it's the default one

 @param isDefaultAddress address enabled
 */
- (void)showDefaultAddressViews:(BOOL)isDefaultAddress {
    
    if (isDefaultAddress) {
        self.mainAddressImageView.hidden = NO;
        self.mainAddressLabel.hidden = NO;
        self.mainAddressButton.hidden = YES;
    }
    else {
        self.mainAddressImageView.hidden = YES;
        self.mainAddressLabel.hidden = YES;
        self.mainAddressButton.hidden = NO;
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

- (IBAction)pressedEdit {
    [FlurryWM logEvent_checkoutNewAddressAddEditBtn];
    [FlurryWM logEvent_checkout_shipping_edit_btn];
    
    if ([self.delegate respondsToSelector:@selector(shipAddressCellPressedEdit:)]) {
        [self.delegate shipAddressCellPressedEdit:self];
    }
}

- (IBAction)pressedDelete {
    [FlurryWM logEvent_checkout_shipping_delete_btn];
    if ([self.delegate respondsToSelector:@selector(shipAddressCellPressedDelete:)]) {
        [self.delegate shipAddressCellPressedDelete:self];
    }
}

@end
