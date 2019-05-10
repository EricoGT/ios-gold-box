//
//  LoadMoreCell.h
//  Tracking
//
//  Created by Bruno Delgado on 5/5/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "TrackingTableViewCell.h"

@interface LoadMoreCell : TrackingTableViewCell

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loader;

- (void)activate;
- (void)deactivate;

@end
