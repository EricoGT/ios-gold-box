//
//  InfoInstantStatusTripaParser.h
//  TripaView
//
//  Created by Bruno Delgado on 5/20/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoInstantStatusTripaParser : NSObject

+ (NSArray *)parseTimelineItems:(NSArray *)items;
+ (NSArray *)__mockTripaArray;

@end
