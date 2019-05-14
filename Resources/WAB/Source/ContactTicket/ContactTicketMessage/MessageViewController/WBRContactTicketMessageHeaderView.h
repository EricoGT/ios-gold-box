//
//  WBRMessageHeaderView.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/6/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBRContactTicketMessageHeaderView : UITableViewHeaderFooterView

+ (NSString *)identifier;
- (void)setInformation:(NSString *)information;

@end
