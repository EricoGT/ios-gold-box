//
//  ProductImagesView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/18/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@protocol ProductImagesViewDelegate <NSObject>
@required
- (void)productImagesResquestedZoom;
@end

@interface ProductImagesView : WMView

@property (weak) id <ProductImagesViewDelegate> delegate;

- (ProductImagesView *)initWithImagesIds:(NSArray *)imagesIds basePath:(NSString *)basePath delegate:(id <ProductImagesViewDelegate>)delegate;

- (void)setImagesIds:(NSArray *)imagesIds basePath:(NSString *)basePath;
- (UIImage *)firstImage;

- (void) moveToFirstImage;

@end
