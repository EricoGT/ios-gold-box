//
//  ContactRequestExchangeFieldModel.h
//  Walmart
//
//  Created by Renan Cargnin on 6/18/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

#import "ContactRequestExchangeValueModel.h"

@protocol ContactRequestExchangeFieldModel
@end

@interface ContactRequestExchangeFieldModel : JSONModel

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray<ContactRequestExchangeValueModel> *values;

@end
