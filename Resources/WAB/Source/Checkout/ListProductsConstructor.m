//
//  ListProductsConstructor.m
//  Ofertas
//
//  Created by Marcelo Santos on 11/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "ListProductsConstructor.h"
#import "CardShipProduct.h"
#import "CardHeader.h"
#import <QuartzCore/QuartzCore.h>

@implementation ListProductsConstructor

- (void) getListProducts:(NSArray *) arrProds withHeightCell:(float) heightCell withWidthCell:(float) widthCell andHeaderText:(NSString *) textHeader {
    
    LogInfo(@"Array received to build list of products:\n%@", arrProds);
    
    //First add the header if necessary
    float sizeHeader = 0.0f;
    if (![textHeader isEqualToString:@""]) {
        LogInfo(@"Mounting header...");
        sizeHeader = 40.0f;
        CardHeader *ch = [[CardHeader alloc] initWithNibName:@"CardHeader" bundle:nil andHeaderTitle:textHeader];
        ch.view.frame = CGRectMake(0, 0, 320, sizeHeader);

        [self addChildViewController:ch];
        [ch didMoveToParentViewController:self];

        [self.view addSubview:ch.view];
        [ch.view setNeedsLayout];
    }
    
    float ttHeightView = ([arrProds count]*heightCell)+sizeHeader;
    self.viewListProducts = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthCell, ttHeightView)];
    
    for (int i=0;i<[arrProds count];i++) {
        
        NSDictionary *dictProd = [arrProds objectAtIndex:i];
        
        NSString *descProduct = [dictProd objectForKey:@"descProduct"];
        NSString *qtyProduct = [dictProd objectForKey:@"qtyProduct"];
        
        BOOL filletShow = YES;
        
        if (i==0) {
            filletShow = NO;
        }
        
        CardShipProduct *cp = [[CardShipProduct alloc] initWithNibName:@"CardShipProduct" bundle:nil andDescription:descProduct andQty:qtyProduct showFillet:filletShow];
        cp.view.frame = CGRectMake(0, (i*heightCell)+sizeHeader, widthCell, heightCell);

        [self addChildViewController:cp];
        [cp didMoveToParentViewController:self];

        [_viewListProducts addSubview:cp.view];
    }
    
    [self.view addSubview:_viewListProducts];
    [_delegate finishListProductsWithHeight:_viewListProducts.frame.size.height];
}

@end
