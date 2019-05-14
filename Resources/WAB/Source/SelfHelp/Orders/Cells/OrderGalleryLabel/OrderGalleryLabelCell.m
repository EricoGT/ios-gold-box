//
//  OrderGalleryLabel.m
//  Walmart
//
//  Created by Renan Cargnin on 2/11/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "OrderGalleryLabelCell.h"

@interface OrderGalleryLabelCell ()

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation OrderGalleryLabelCell

+ (NSString *)reuseIdentifier {
    return @"OrderGalleryLabelCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCount:(NSUInteger)count {
    _countLabel.text = [NSString stringWithFormat:@"+%lu", ((unsigned long) count)];
}

@end
