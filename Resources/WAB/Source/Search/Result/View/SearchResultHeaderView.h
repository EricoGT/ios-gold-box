//
//  SearchResultHeaderView.h
//  Walmart
//
//  Created by Renan Cargnin on 4/14/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@interface SearchResultHeaderView : WMView

- (void)setupWithCount:(NSUInteger)count term:(NSString *)term;

@end
