//
//  WALShowcaseTrackerManager.h
//  Walmart
//
//  Created by Bruno Delgado on 8/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShowcaseTrackerModel;

@interface WALShowcaseTrackerManager : NSObject

#pragma mark - Add
+ (void)storeShowcaseTracking:(ShowcaseTrackerModel *)showcaseTracking;

#pragma mark - Retrieve
+ (ShowcaseTrackerModel *)retrieveShowcaseTracking;
+ (NSArray *)retrieveListOfShowcaseTrackings;

//This method returns the last valid showcase (if there's any)
//By valid we mean it's not on the list of showcases we should not sent
+ (ShowcaseTrackerModel *)retrieveLastValidShowcaseTracking;

#pragma mark - Clean
+ (void)clean;

@end
