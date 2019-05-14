//
//  CardAddressView.h
//  Walmart
//
//  Created by Renan on 5/14/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel, AddressCardCell;

@protocol addressCardDelegate <NSObject>
@optional
- (void)editAddress:(AddressModel *)address;
- (void)addressCardCellPressedDeleteButton:(AddressCardCell *)cell;
- (void)addressCardCellSetAsDefaulAddress:(AddressModel *)address;
@end

@interface AddressCardCell : UITableViewCell

@property (weak) id <addressCardDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *receiverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *complementLabel;

- (AddressCardCell *)initForTestCase;
- (void)setupWithAddress:(AddressModel *)address;

- (IBAction)editPressed:(id)sender;
- (IBAction)deletePressed:(id)sender;
- (IBAction)setAsDefaultPressed:(id)sender;

@end
