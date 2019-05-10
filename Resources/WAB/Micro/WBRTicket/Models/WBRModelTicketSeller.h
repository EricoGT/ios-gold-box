//
//  WBRModelTicketSeller.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 4/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRModelTicketSeller : JSONModel

@property(strong, nonatomic) NSString *sellerId;
@property(strong, nonatomic) NSString *name;

@end
