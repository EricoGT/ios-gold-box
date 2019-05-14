//
//  WBRMessageHeaderView.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/6/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketMessageHeaderView.h"

static NSString *kWBRMessageHeaderViewIdentifier = @"WBRMessageHeaderViewIdentifier";

@interface WBRContactTicketMessageHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;


@end

@implementation WBRContactTicketMessageHeaderView

+ (NSString *)identifier {
    return kWBRMessageHeaderViewIdentifier;
}

- (void)setInformation:(NSString *)information {
    self.informationLabel.text = information;
}

@end
