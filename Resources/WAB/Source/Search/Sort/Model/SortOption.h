//
//  SortOptions.h
//  Walmart
//
//  Created by Danilo on 9/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface SortOption : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *urlParameter;

- (SortOption *)initWithName:(NSString *)name urlParameter:(NSString *)urlParameter;

@end
