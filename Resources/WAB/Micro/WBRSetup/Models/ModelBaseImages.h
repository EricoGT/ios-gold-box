//
//  BaseImagesModel.h
//  Walmart
//
//  Created by Marcelo Santos on 3/9/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface ModelBaseImages : JSONModel

@property (strong, nonatomic) NSString *products;
@property (strong, nonatomic) NSString *showcases;

@end
