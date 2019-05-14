//
//  WBRContactTicketProductCollectionViewCell.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/15/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBRContactTicketProductCollectionViewCell : WMView

+ (NSString *)reusableIdentifier;

- (void)setupProductCellWithImage:(NSString *)imageUrl ;
- (void)setupProdutCellWithNumberOfMoreProducts:(NSNumber *)numberProducts;
- (void)resetLayout;

@end
