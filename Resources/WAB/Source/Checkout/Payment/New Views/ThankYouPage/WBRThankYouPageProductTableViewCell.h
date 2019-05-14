//
//  WBRThankYouPageProductTableViewCell.h
//  Walmart
//
//  Created by Rafael Valim on 22/09/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBRThankYouPageProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *productQuantityLabel;

+ (NSString *)reuseIdentifier;

@end
