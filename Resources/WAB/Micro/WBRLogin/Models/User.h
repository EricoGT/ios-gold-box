//
//  User.h
//  Walmart
//
//  Created by Bruno Delgado on 2/24/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

#import "PhoneModel.h"

@protocol User
@end

@interface User : JSONModel

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString<Optional> *dateBirth;
@property (strong, nonatomic) NSString<Optional> *gender;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *document;
@property (strong, nonatomic) NSString *guid;
@property (strong, nonatomic) NSArray<PhoneModel> *phones;
@property (strong, nonatomic) NSDictionary *preferences;
@property (strong, nonatomic) NSDictionary<Optional> *social;
@property (assign, nonatomic) BOOL hasDocument;
@property (assign, nonatomic) BOOL hasPhone;
@property (strong, nonatomic) NSString<Optional> *nickname;
@property (strong, nonatomic) NSString *pid;

+ (User *)sharedUser;
+ (void)setSharedUser:(User *)user;
+ (void)persist;
- (NSDictionary *)toDictionaryForUpdateServer;

@end
