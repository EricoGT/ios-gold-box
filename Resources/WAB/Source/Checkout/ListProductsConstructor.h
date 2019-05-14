//
//  ListProductsConstructor.h
//  Ofertas
//
//  Created by Marcelo Santos on 11/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol listProdsDelegate <NSObject>
@required
@optional
- (void) finishListProductsWithHeight:(float) height;
@end

@interface ListProductsConstructor : WMBaseViewController

@property (weak) id <listProdsDelegate> delegate;
@property (strong, nonatomic) UIView *viewListProducts;

- (void) getListProducts:(NSArray *) arrProds withHeightCell:(float) heightCell withWidthCell:(float) widthCell andHeaderText:(NSString *) textHeader;

@end
