//
//  UTMIModel.h
//  Walmart
//
//  Created by Bruno Delgado on 10/15/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    UTMITypeNav,
    UTMITypeBan
} UTMIType;

@interface UTMIModel : NSObject

@property (nonatomic, strong, readonly) NSString *section;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *subcategory;
@property (nonatomic, strong) NSString *module;
@property (nonatomic, strong) NSString *modulePosition;
@property (nonatomic, strong) NSString *internalPosition;
@property (nonatomic, strong) NSString *moduleLabel;
@property (nonatomic, strong) NSString *internalLabel;
@property (nonatomic, assign) UTMIType type;

- (void)setSection:(NSString *)section cleanOtherFields:(BOOL)clean;
- (NSString *)typeFormatted;

@end
