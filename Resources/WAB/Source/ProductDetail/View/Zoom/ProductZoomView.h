//
//  ProductZoomView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/28/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@interface ProductZoomView : WMView

- (ProductZoomView *)initWithImagesIds:(NSArray *)imagesIds basePath:(NSString *)basePath dismissBlock:(void (^)())dismissBlock;

- (void)setImagesIds:(NSArray *)imagesIds basePath:(NSString *)basePath;

@end
