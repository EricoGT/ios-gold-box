//
//  WALShowcaseTrackerManager.m
//  Walmart
//
//  Created by Bruno Delgado on 8/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WALShowcaseTrackerManager.h"
#import "ShowcaseTrackerModel.h"

#define kShowcaseTrackingListStoreKey @"ShowcaseTrackingListStoreKey"

@implementation WALShowcaseTrackerManager

//Today we only need to store one ShowcaseTrackerModel. This class used a list
//so if one day we decided to store more itens, it will be easier to maintain

#pragma mark - Add
+ (void)storeShowcaseTracking:(ShowcaseTrackerModel *)showcaseTracking
{
    LogInfo(@"Storing \"%@\" for 30 days", showcaseTracking.showcaseId);
    NSMutableArray *list = [self listOfShowcaseTrackings];
    [list addObject:showcaseTracking];
    [self saveListOfShowcaseTrackings:list];
//    LogInfo(@"Show case stored: %@", list);
}

#pragma mark - Retrieve
+ (ShowcaseTrackerModel *)retrieveShowcaseTracking
{
    ShowcaseTrackerModel *showcase = nil;
    NSMutableArray *list = [self listOfShowcaseTrackings];
    
    if (list.count > 0)
    {
        //P.O defined that we should only send the last showcase the user saw
        showcase = (ShowcaseTrackerModel *)list.lastObject;
        if (showcase.isInValidTimeRange) {
            LogInfo(@"Last showcase stored: %@", showcase.showcaseId);
        } else {
            showcase = nil;
            [self clean];
        }
    }
    
    return showcase;
}

+ (ShowcaseTrackerModel *)retrieveLastValidShowcaseTracking
{
    //This method returns the last valid showcase (if there's any)
    //By valid we mean it's not on the list of showcases we should not sent
    NSMutableArray *list = [self listOfShowcaseTrackings];
    return [self validShowcaseInList:list];
}

+ (ShowcaseTrackerModel *)validShowcaseInList:(NSMutableArray *)list
{
    ShowcaseTrackerModel *showcase = nil;
    if (list.count > 0)
    {
        //P.O defined that we should only send the last showcase the user saw
        showcase = (ShowcaseTrackerModel *)list.lastObject;
        if ([self isShowcaseValid:showcase])
        {
            if (showcase.isInValidTimeRange) {
                LogInfo(@"Last valid showcase stored: %@", showcase.showcaseId);
            } else {
                showcase = nil;
                [self clean];
            }
        }
        else
        {
            [list removeLastObject];
            showcase = nil;
            return [self validShowcaseInList:list];
        }
    }
    
    return showcase;
}

+ (NSArray *)retrieveListOfShowcaseTrackings
{
    NSMutableArray *list = [self listOfShowcaseTrackings];
    return list.copy;
}

#pragma mark - Clean
+ (void)clean
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kShowcaseTrackingListStoreKey];
}

#pragma mark - Helpers
+ (NSMutableArray *)listOfShowcaseTrackings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:kShowcaseTrackingListStoreKey];
    NSMutableArray *mutableListOfShowcaseTrackings;
    
    if (encodedObject) {
        NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        mutableListOfShowcaseTrackings = [[NSMutableArray alloc] initWithArray:list];
    } else {
        mutableListOfShowcaseTrackings = [NSMutableArray new];
    }
    return mutableListOfShowcaseTrackings;
}

+ (void)saveListOfShowcaseTrackings:(NSMutableArray *)list
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObjectToSave = [NSKeyedArchiver archivedDataWithRootObject:list.copy];
    [defaults setObject:encodedObjectToSave forKey:kShowcaseTrackingListStoreKey];
    [defaults synchronize];
}

+ (BOOL)isShowcaseValid:(ShowcaseTrackerModel *)showcase
{
    //There's a list of showcases that we should not register
    NSArray *showcasesThatShouldntBeRegistered = @[@"mais ofertas"];
    
    if (showcase.showcaseName.length > 0) {
        for (NSString *showcaseName in showcasesThatShouldntBeRegistered) {
            if ([showcaseName.lowercaseString isEqualToString:showcase.showcaseName.lowercaseString]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end
