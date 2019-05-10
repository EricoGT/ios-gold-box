//
//  SHPOrdersTableViewCell.h
//  Tracking
//
//  Created by Bruno Delgado on 4/16/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "TrackingTableViewCell.h"

@class TrackingOrder, ConciergeDeliveryButton;

@interface SHPOrdersTableViewCell : TrackingTableViewCell

//Card
@property (nonatomic, weak) IBOutlet UIView *cardView;

//Top View
@property (nonatomic, weak) IBOutlet UILabel *orderNumberTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderDateTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderDateLabel;

//Order Status
@property (nonatomic, weak) IBOutlet UIImageView *orderStatusImageView;
@property (nonatomic, weak) IBOutlet UILabel *orderStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderPrevisionLabel;
@property (nonatomic, weak) IBOutlet ConciergeDeliveryButton *conciergeButton;

//Bottom View
@property (nonatomic, weak) IBOutlet UIView *bottomView;

- (void)configureWithOrder:(TrackingOrder *)order;

@end
