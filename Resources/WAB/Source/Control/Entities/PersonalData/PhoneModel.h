//
//  PhoneModel.h
//  Walmart
//
//  Created by Renan on 4/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol PhoneModel
@end

@interface PhoneModel : JSONModel

@property (nonatomic, strong) NSString *areaCode;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *type;

@end
