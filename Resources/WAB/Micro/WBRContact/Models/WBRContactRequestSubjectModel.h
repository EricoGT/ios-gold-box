//
//  WBRContactRequestSubjectModel.h
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol WBRContactRequestSubjectModel
@end

@interface WBRContactRequestSubjectModel : JSONModel

@property (strong, nonatomic) NSString *subjectId;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString<Optional> *message;
@property (strong, nonatomic) NSString *type;
@property (nonatomic) BOOL disclaimer;

@end
