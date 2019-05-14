//
//  WBRSearchBar.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 1/15/19.
//  Copyright © 2019 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCustomSearchBar.h"

@implementation WBRCustomSearchBar


- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setBackgroundImage:[[UIImage alloc] init]];
    [self setPlaceholder:SEARCH_BAR_PLACEHOLDER];
    [self setSearchFieldBackgroundPositionAdjustment:UIOffsetMake(0, -10)];
    
    UITextField *searchTextField = [self valueForKey:@"searchField"];
    [searchTextField.layer setCornerRadius:searchTextField.layer.frame.size.height/2];
    [searchTextField.layer setMasksToBounds:YES];
    [searchTextField setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [searchTextField setTextColor:RGB(158, 158, 158)];
    [searchTextField setTintColor:RGB(11, 95, 255)];
}


-(void)layoutSubviews {
    [super layoutSubviews];
    UITextField *searchTextField = [self valueForKey:@"searchField"];
    CGRect currentFrame = searchTextField.layer.frame;
    [searchTextField.layer setFrame:CGRectMake(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, 50)];
}


@end
