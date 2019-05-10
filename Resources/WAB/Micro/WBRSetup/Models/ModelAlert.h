//
//  AlertModel.h
//  Walmart
//
//  Created by Marcelo Santos on 3/9/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface ModelAlert : JSONModel

@property (strong, nonatomic) NSNumber *block;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *system;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *buttonOk;
@property (strong, nonatomic) NSString *buttonCancel;

@end
