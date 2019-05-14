//
//  WBRCardHolderModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 9/18/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol WBRCardHolderModelProtocol;

@interface WBRCardHolderModel : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *document;

@end
