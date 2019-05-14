//
//  FreightView.h
//  Walmart
//
//  Created by Accurate Rio Preto on 06/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"

@protocol WBRFreightViewDelegate <NSObject>
@required
- (void)productOptionsPressedCalculateFreight;
@end

@interface WBRFreightView : WMView
@property (weak) id <WBRFreightViewDelegate> delegate;
- (WBRFreightView *)initWithDelegate:(id <WBRFreightViewDelegate>)delegate;
@end
