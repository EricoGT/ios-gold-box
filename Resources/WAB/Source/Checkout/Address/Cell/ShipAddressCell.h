//
//  ShipAddressCell.h
//  Walmart
//
//  Created by Renan on 4/29/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const zipcodeDashIndex = 5;

@class ShipAddressCell;

@protocol ShipAddressCellDelegate <NSObject>
@required
@optional
- (void)shipAddressCellPressedEdit:(ShipAddressCell *)cell;
- (void)shipAddressCellPressedDelete:(ShipAddressCell *)cell;
@end

@interface ShipAddressCell : UITableViewCell

@property (weak) id <ShipAddressCellDelegate> delegate;

+ (NSString *)reuseIdentifier;


/**
 Setup cell with the providen dictionary
 
 @param addressDict with address information
 It'll be used the following keys
 - receiverName
 - street
 - complement
 - number
 - neighborhood
 - city
 - state
 - postalCode
 - defaultAddress
 - description
 */
- (void)setupWithAddressDict:(NSDictionary *)addressDict enableEditControls:(BOOL)enableEdit;

@end
