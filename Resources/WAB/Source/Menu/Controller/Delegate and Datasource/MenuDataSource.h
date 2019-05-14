//
//  MenuDataSource.h
//  Walmart
//
//  Created by Bruno on 8/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *departments;

- (id)initWithDepartments:(NSArray *)departmentsSection;

@end
