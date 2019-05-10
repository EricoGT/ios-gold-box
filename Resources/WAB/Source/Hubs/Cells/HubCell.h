//
//  HubCell.h
//  Walmart
//
//  Created by Renan on 2/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HubCategory, WMImageView;

@interface HubCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet WMImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

- (void)setupWithHubCategory:(HubCategory *)hubCategory;

@end
