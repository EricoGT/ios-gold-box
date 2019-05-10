//
//  ProductZoomCell.h
//  Walmart
//
//  Created by Renan Cargnin on 1/28/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductZoomCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)setImageURL:(NSURL *)imageURL;

@end
