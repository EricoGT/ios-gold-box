//
//  WMBaseModel.m
//  Walmart
//
//  Created by Renan Cargnin on 3/14/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMBaseModel.h"

@implementation WMBaseModel

+ (id)jsonFromFileNamed:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

+ (id)mock {
    id json = [WMBaseModel jsonFromFileNamed:NSStringFromClass(self)];
    NSError *parserError;
    WMBaseModel *model = [[self alloc] initWithDictionary:json error:&parserError];
    return model;
}

+ (NSArray *)arrayOfMocks {
    id json = [WMBaseModel jsonFromFileNamed:[NSString stringWithFormat:@"%@s", NSStringFromClass(self)]];
    NSError *parserError;
    NSArray *arrayOfModels = [self arrayOfModelsFromDictionaries:json error:&parserError];
    return arrayOfModels;
}


@end
