//
//  OrderGalleryLabel.h
//  Walmart
//
//  Created by Renan Cargnin on 2/11/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderGalleryLabelCell : UICollectionViewCell

- (void)setCount:(NSUInteger)count;

+ (NSString *)reuseIdentifier;

@end
