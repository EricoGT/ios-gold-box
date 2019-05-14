//
//  WBRContactRequestTypeModel.h
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WBRContactRequestSubjectModel.h"

@protocol WBRContactRequestTypeModel
@end

@interface WBRContactRequestTypeModel : JSONModel

@property (nonatomic, strong) NSNumber *authentication;
@property (nonatomic, strong) NSNumber *generic;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray<WBRContactRequestSubjectModel> *subjects;

@end
