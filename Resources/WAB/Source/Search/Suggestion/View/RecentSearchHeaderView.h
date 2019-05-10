//
//  RecentSearchesHeaderView.h
//  Walmart
//
//  Created by Renan Cargnin on 02/03/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"

@protocol RecentSearchHeaderViewDelegate <NSObject>
@optional
- (void)recentSearchesHeaderViewPressedClearRecentSearches;
@end

@interface RecentSearchHeaderView : WMView

@property (weak) id <RecentSearchHeaderViewDelegate> delegate;

@end
