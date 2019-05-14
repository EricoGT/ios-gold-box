//
//  InfoInstantStatusTripaView.h
//  TripaView
//
//  Created by Bruno Delgado on 5/19/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoInstantStatusTripaView : UIView

/*
 Although this class doesn't have a designated initalizer,
 this method should be used to set the statuses.
 
 Setting the statuses, this view will reframe accordingly.
 
 The array should contain dictionaries with the following keys:
 "date" and "details".
 
 the "details" array should contain dictionaries with "time" and "description"
 */

- (void)setStatuses:(NSArray *)statuses;

@end
