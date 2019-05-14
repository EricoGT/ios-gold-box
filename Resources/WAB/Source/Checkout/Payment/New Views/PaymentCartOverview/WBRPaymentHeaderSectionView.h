//
//  WBRPaymentHeaderSectionView.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 19/09/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBRPaymentHeaderSectionViewDelegate <NSObject>
@optional
- (void)changeButtonTouched;
@end

@interface WBRPaymentHeaderSectionView : UIView

@property (weak) id <WBRPaymentHeaderSectionViewDelegate> delegate;

@end
