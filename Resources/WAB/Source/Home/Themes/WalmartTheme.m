//
//  WalmartTheme.m
//  Walmart
//
//  Created by Bruno on 10/26/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WalmartTheme.h"

@implementation WalmartTheme

- (UIColor *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = RGBA(242, 242, 242, 1);
    }
    return _backgroundColor;
}

- (UIColor *)headerColor {
    if (!_headerColor) {
        _headerColor = RGBA(26, 117, 207, 1);
    }
    return _headerColor;
}

- (UIColor *)pageControlColor {
    if (!_pageControlColor) {
        _pageControlColor = RGBA(216, 216, 216, 1);
    }
    return _pageControlColor;
}

- (UIColor *)pageControlHighlightColor {
    if (!_pageControlHighlightColor) {
        _pageControlHighlightColor = RGBA(35, 150, 243, 1);
    }
    return _pageControlHighlightColor;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_backgroundColor forKey:@"backgroundColor"];
    [encoder encodeObject:_headerColor forKey:@"headerColor"];
    [encoder encodeObject:_pageControlColor forKey:@"pageControlColor"];
    [encoder encodeObject:_pageControlHighlightColor forKey:@"pageControlHighlightColor"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.backgroundColor = [decoder decodeObjectForKey:@"backgroundColor"];
        self.headerColor = [decoder decodeObjectForKey:@"headerColor"];
        self.pageControlColor =[decoder decodeObjectForKey:@"pageControlColor"];
        self.pageControlHighlightColor =[decoder decodeObjectForKey:@"pageControlHighlightColor"];
    }
    return self;
}

@end
