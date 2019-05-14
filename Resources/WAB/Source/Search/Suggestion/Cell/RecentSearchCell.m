//
//  RecentSearchCell.m
//  Walmart
//
//  Created by Renan Cargnin on 02/03/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "RecentSearchCell.h"

@implementation RecentSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.textLabel.font = [UIFont fontWithName:@"OpenSans" size:15.0f];
    self.imageView.highlightedImage = [UIImage imageNamed:@"UISearchQuote-Gray.png"];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.imageView.image = [UIImage imageNamed:@"UISearchQuote-Gray.png"];
    
    UIView *bg = [[UIView alloc] initWithFrame:self.frame];
    [bg setBackgroundColor:[UIColor lightGrayColor]];
    self.selectedBackgroundView = bg;
    
    self.textLabel.textColor = RGB(153.f, 153.f, 153.f);
    self.textLabel.highlightedTextColor = RGB(153.f, 153.f, 153.f);;
}

@end
