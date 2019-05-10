//
//  ContactRequestExchangeValueModel.h
//  Walmart
//
//  Created by Renan Cargnin on 6/18/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol ContactRequestExchangeValueModel
@end

@interface ContactRequestExchangeValueModel : JSONModel

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSNumber<Optional> *refund;

@end
