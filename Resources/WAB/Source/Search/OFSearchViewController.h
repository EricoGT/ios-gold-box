//
//  OFSearchViewController.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 7/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFSearchViewController : UIViewController

- (OFSearchViewController *)initWithQuery:(NSString *)query;
- (void)refreshWithQuery:(NSString *)query;

@end
