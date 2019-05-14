//
//  WMUTMIManager.m
//  Walmart
//
//  Created by Bruno Delgado on 10/15/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMUTMIManager.h"

@implementation WMUTMIManager

#pragma mark - Add
+ (void)storeUTMI:(UTMIModel *)model
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObjectToSave = [NSKeyedArchiver archivedDataWithRootObject:model];
    [defaults setObject:encodedObjectToSave forKey:kUTMIStored];
    [defaults synchronize];
    LogInfo(@"Storing UTMI (%@) = %@", model.typeFormatted, model.description);
}

#pragma mark - Retrieve
+ (UTMIModel *)UTMI
{
    UTMIModel *model = [UTMIModel new];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:kUTMIStored];
    if (encodedObject) {
        model = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }    
    return model;
}

#pragma mark - Clean
+ (void)clean
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUTMIStored];
}

@end
