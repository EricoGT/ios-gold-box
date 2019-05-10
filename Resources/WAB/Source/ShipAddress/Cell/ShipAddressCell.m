//
//  ShipAddressCell.m
//  Walmart
//
//  Created by Renan on 4/29/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ShipAddressCell.h"

#import "NSString+HTML.h"

@interface ShipAddressCell ()

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *receiverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *neighborhoodLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation ShipAddressCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([ShipAddressCell class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _cardView.layer.cornerRadius = 4.0f;
    _cardView.layer.masksToBounds = YES;
    _cardView.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
    _cardView.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithAddressDict:(NSDictionary *)addressDict {
    LogInfo(@"Receiver Name: %@", [addressDict objectForKey:@"receiverName"]);
    
    _receiverNameLabel.text = [addressDict objectForKey:@"receiverName"];
    
    NSString *complement = [addressDict objectForKey:@"complement"];
    
    NSString *address = @"";
    
    NSString *strStreet = [addressDict objectForKey:@"street"];
    LogInfo(@"Street i18n Old: %@", strStreet);
    strStreet = [strStreet kv_decodeHTMLCharacterEntities];
    if (![complement isEqualToString:@""]) {
        address = [NSString stringWithFormat:@"%@, %@, %@", strStreet, [addressDict objectForKey:@"number"], complement];
    } else {
        address = [NSString stringWithFormat:@"%@, %@", strStreet, [addressDict objectForKey:@"number"]];
    }
    _streetLabel.text = address;
    
    NSString *address2 = [NSString stringWithFormat:@"%@ - %@, %@", [addressDict objectForKey:@"neighborhood"], [addressDict objectForKey:@"city"], [addressDict objectForKey:@"state"]];
    _neighborhoodLabel.text = address2;
    _zipCodeLabel.text = [NSString stringWithFormat:@"CEP %@", [addressDict objectForKey:@"postalCode"]];
    _cityLabel.text = [NSString stringWithFormat:@"%@", [addressDict objectForKey:@"referencePoint"]];
}

#pragma mark - IBAction
- (IBAction)pressedEdit {
    [FlurryWM logEvent_checkoutNewAddressAddEditBtn];
    [FlurryWM logEvent_checkout_shipping_edit_btn];
    
    if ([_delegate respondsToSelector:@selector(shipAddressCellPressedEdit:)]) {
        [_delegate shipAddressCellPressedEdit:self];
    }
}

- (IBAction)pressedDelete {
    [FlurryWM logEvent_checkout_shipping_delete_btn];
    if ([_delegate respondsToSelector:@selector(shipAddressCellPressedDelete:)]) {
        [_delegate shipAddressCellPressedDelete:self];
    }
}

- (IBAction)pressedSelect {
    if ([_delegate respondsToSelector:@selector(shipAddressCellSelected:)]) {
        [_delegate shipAddressCellSelected:self];
    }
}

@end
