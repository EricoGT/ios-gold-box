//
//  LogError.h
//  Walmart
//
//  Created by Bruno on 6/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogError : NSObject

@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *absolutRequest;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *userMessage;
@property (nonatomic, strong) NSString *screen;
@property (nonatomic, strong) NSString *fragment;

@end
