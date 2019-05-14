//
//  ModelErrata.h
//  Walmart
//
//  Created by Marcelo Santos on 4/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface ModelErrata : JSONModel

@property (strong, nonatomic) NSString <Optional> *imageUrl;
@property (strong, nonatomic) NSString <Optional> *title;
@property (strong, nonatomic) NSString <Optional> *message;
@property (strong, nonatomic) NSString <Optional> *url;

@end
