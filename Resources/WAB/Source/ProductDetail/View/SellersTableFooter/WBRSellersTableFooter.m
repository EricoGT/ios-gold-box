//
//  WBRSellersTableFooter.m
//  Walmart
//
//  Created by Cássio Sousa on 25/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRSellersTableFooter.h"

@interface WBRSellersTableFooter ()
@property (weak, nonatomic) IBOutlet WMButtonRounded *moreSellersButton;

@end

@implementation WBRSellersTableFooter

- (WBRSellersTableFooter *)initWithNumber:(NSNumber *) number{
    if (self = [super init]) {
        [self setupLayout:number];
    }
    return self;
}

-(void)setupLayout:(NSNumber *) number{
    [self.moreSellersButton setTitle: [NSString stringWithFormat: @"Outras lojas no Walmart (%ld)",number.longValue] forState: UIControlStateNormal];
}

- (IBAction)displayMore:(id)sender {
    if([self.delegate respondsToSelector:@selector(showMoreSellers)]){
        [self.delegate showMoreSellers];
    }
}
@end
