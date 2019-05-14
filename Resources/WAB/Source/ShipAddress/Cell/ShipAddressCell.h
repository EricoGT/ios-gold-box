//
//  ShipAddressCell.h
//  Walmart
//
//  Created by Renan on 4/29/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShipAddressCell;

@protocol ShipAddressCellDelegate <NSObject>
@required
@optional
- (void)shipAddressCellPressedEdit:(ShipAddressCell *)cell;
- (void)shipAddressCellPressedDelete:(ShipAddressCell *)cell;
- (void)shipAddressCellSelected:(ShipAddressCell *)cell;
@end

@interface ShipAddressCell : UITableViewCell

@property (weak) id <ShipAddressCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

- (void)setupWithAddressDict:(NSDictionary *)addressDict;

@end
