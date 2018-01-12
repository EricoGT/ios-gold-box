//
//  ScrapeCollectionViewCell.m
//  Raspadinha
//
//  Created by Erico GT on 11/01/18.
//  Copyright © 2018 lordesire. All rights reserved.
//

#import "ScrapeCollectionViewCell.h"

@implementation ScrapeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@synthesize imvItem;

- (void)updateLayout
{
    self.contentView.backgroundColor = nil;
    self.backgroundColor = [UIColor whiteColor];
    //
    imvItem.backgroundColor = nil;
    imvItem.image = nil;
    //
    [self.layer setCornerRadius:10.0]; 
}
@end
