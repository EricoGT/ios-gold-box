//
//  OrderGalleryItemCell.h
//  Walmart
//
//  Created by Renan Cargnin on 2/11/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderGalleryItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *extendedWarrantyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *globalStampImageView;

+ (NSString *)reuseIdentifier;

- (void)setProductImageURL:(NSString *)imageURL;

@end
