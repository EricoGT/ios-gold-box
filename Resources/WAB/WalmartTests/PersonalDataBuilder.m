//
//  PeronalDataBuilder.m
//  Walmart
//
//  Created by Renan on 6/8/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "PersonalDataBuilder.h"

//#import "UserPersonalData.h"

@implementation PersonalDataBuilder

//+ (UserPersonalData *)basePersonalData {
//    NSDictionary *personalDataDict = @{@"firstName" : @"Renan",
//                                   @"lastName" : @"Cargnin",
//                                   @"gender" : @"MALE",
//                                   @"document" : @"40440440440",
//                                   @"dateBirth" : @"1993-08-04",
//                                   @"phones" : @[@{@"areaCode" : @"11", @"number" : @"23523545", @"type" : @"RESIDENTIAL"},
//                                                 @{@"areaCode" : @"11", @"number" : @"24356678", @"type" : @"MOBILE"}],
//                                   @"email" : @"renan.cargnin@gingaone.com",
//                                   @"preferences" : @{@"email" : @YES, @"sms" : @NO, @"acceptedTerm" : @NO}};
//    
//    UserPersonalData *personalData = [[UserPersonalData alloc] initWithModelToJSONDictionary:personalDataDict error:NULL];
//    return personalData;
//}
//
//+ (UserPersonalData *)personalDataWithoutGender {
//    UserPersonalData *personalData = [PersonalDataBuilder basePersonalData];
//    personalData.gender = @"";
//    return personalData;
//}

@end
