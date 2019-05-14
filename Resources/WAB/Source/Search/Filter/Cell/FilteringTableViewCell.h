//
//  FilteringTableViewCell.h
//  Walmart
//
//  Created by Danilo on 9/10/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilteringTableViewCell : UITableViewCell

+ (UINib *)nib;
- (void)hideQuantityView:(BOOL)hide;
- (void)hideFilterCheckmark:(BOOL)hide;
- (void)setUp;

- (void)removeRoundness;
- (void)roundTop;
- (void)roundBottom;
- (void)roundTopAndBottom;

@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (weak, nonatomic) IBOutlet UIView *quantityContainer;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *filterCheckmark;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *customDivider;

@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, assign) BOOL isSelectable;
@property (nonatomic, assign) BOOL isParent;

@end
