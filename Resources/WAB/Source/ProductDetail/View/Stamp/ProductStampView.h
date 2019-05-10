//
//  ProductStampView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@protocol ProductStampViewDelegate <NSObject>
@optional
- (void)productStampDidTapWithStampURLPath:(NSString *)stampURLPath;
@end

@interface ProductStampView : WMView

@property (weak) id <ProductStampViewDelegate> delegate;

- (ProductStampView *)initWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description fullDescription:(NSString *)fullDescription delegate:(id <ProductStampViewDelegate>)delegate;

-(void)hideSeparator;
-(void)hideView;
-(void)showView;

@end
