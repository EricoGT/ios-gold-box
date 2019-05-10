//
//  SearchSuggestionCell.m
//  Walmart
//
//  Created by Renan Cargnin on 02/03/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "SearchSuggestionCell.h"

@implementation SearchSuggestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.textLabel.font = [UIFont fontWithName:@"OpenSans" size:15.0];
    self.textLabel.textColor = [UIColor colorWithRed:26.0f/255.0f green:117.0f/255.0f blue:207.0f/255.0f alpha:1];
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
    
    UIView *bg = [[UIView alloc] initWithFrame:self.frame];
    [bg setBackgroundColor:[UIColor colorWithRed:244.0f/255 green:123.0f/255 blue:32.0f/255 alpha:1]];
    self.selectedBackgroundView = bg;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.imageView.frame = CGRectMake(15, 10, 24, 24);
}

@end
