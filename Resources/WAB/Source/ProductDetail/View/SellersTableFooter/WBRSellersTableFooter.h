//
//  WBRSellersTableFooter.h
//  Walmart
//
//  Created by Cássio Sousa on 25/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"
@protocol WBRSellersTableFooterDelegate <NSObject>

@required
- (void)showMoreSellers;

@end
@interface WBRSellersTableFooter : WMView
- (WBRSellersTableFooter *)initWithNumber:(NSNumber *) number;
@property (nonatomic, weak) id <WBRSellersTableFooterDelegate> delegate;
@end
