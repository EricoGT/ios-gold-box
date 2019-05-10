//
//  LoadMoreCell.m
//  Tracking
//
//  Created by Bruno Delgado on 5/5/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.loader setHidesWhenStopped:YES];
    [self setLayout];
}

#pragma mark - Layout
- (void)setLayout
{
    self.loader.hidden = YES;
}

- (void)activate
{
    self.loader.hidden = NO;
    [self.loader startAnimating];
}

- (void)deactivate
{
    self.loader.hidden = YES;
    [self.loader stopAnimating];
}

@end
