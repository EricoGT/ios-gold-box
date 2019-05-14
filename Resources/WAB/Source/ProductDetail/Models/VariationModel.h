//
//  VariationModel.h
//  Walmart
//
//  Created by Renan Cargnin on 11/19/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface VariationModel : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString<Optional> *sku;
@property (strong, nonatomic) NSString<Optional> *imageId;
@property (strong, nonatomic) NSString<Optional> *optionsType;
@property (strong, nonatomic) NSArray<Optional> *options;

@end
