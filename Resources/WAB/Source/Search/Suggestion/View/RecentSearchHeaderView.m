//
//  RecentSearchesHeaderView.m
//  Walmart
//
//  Created by Renan Cargnin on 02/03/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "RecentSearchHeaderView.h"

@implementation RecentSearchHeaderView

- (IBAction)pressedClearRecentSearches:(id)sender {
    if ([_delegate respondsToSelector:@selector(recentSearchesHeaderViewPressedClearRecentSearches)]) {
        [_delegate recentSearchesHeaderViewPressedClearRecentSearches];
    }
}

@end
