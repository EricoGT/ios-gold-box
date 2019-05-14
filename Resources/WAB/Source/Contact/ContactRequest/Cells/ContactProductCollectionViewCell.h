//
//  ContactProductCollectionViewCell.h
//  Walmart
//
//  Created by Renan on 6/12/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactProductCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UIView *selectedAlphaView;

- (void)setupWithImageUrl:(NSString *)urlStr;

@end
