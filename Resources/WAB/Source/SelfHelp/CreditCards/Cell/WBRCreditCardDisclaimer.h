//
//  WMBCreditCardDisclaimer.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 02/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBRCreditCardDisclaimer : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIView  *disclaimerView;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerTitle;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerText;

+ (NSString *)reuseIdentifier;

@end
