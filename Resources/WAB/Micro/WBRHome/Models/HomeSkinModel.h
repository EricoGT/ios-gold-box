//
//  HomeSkinModel.h
//  Walmart
//
//  Created by Bruno on 10/26/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

#import "JSONValueTransformer+UIColor.h"

@interface HomeSkinModel : JSONModel

@property (nonatomic, strong) UIColor<Optional> *bgColor;
@property (nonatomic, strong) UIColor<Optional> *headerColor;

@end
