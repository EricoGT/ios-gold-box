//
//  WBRContactDeliveryProductCollectionViewCell.h
//  Walmart
//
//  Created by Murilo Alves Alborghette on 3/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBRContactDeliveryProductCollectionViewCell : UICollectionViewCell

+ (NSString *)reusableIdentifier;

- (void)setUpCellWithImage:(NSString *)urlImage;

@end
