//
//  Kit.h
//  Walmart
//
//  Created by Bruno Delgado on 5/7/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol Kit
@end

@interface Kit : JSONModel

@property (nonatomic, strong) NSString *kitID;
@property (nonatomic, strong) NSString *descriptionText;

@end
