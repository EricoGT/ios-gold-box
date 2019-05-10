//
//  WBRUTMModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 10/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBRUTMModel : NSObject

@property (strong, nonatomic) NSString *UTMValue;
@property (strong, nonatomic) NSDate *savedDate;
@property (assign, nonatomic, readonly) BOOL valid;

- (instancetype)initWithUTMValue:(NSString *)UTMValue;

@end
