//
//  OFHubViewController.h
//  Walmart
//
//  Created by Renan on 2/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WALMenuItemViewController.h"

#import "RetryErrorView.h"
@class WMVerticalMenu;

@interface OFHubViewController : WALMenuItemViewController

@property (strong, nonatomic) NSString *hubId;
@property (nonatomic, strong) NSString *hubTitle;
@property (strong, nonatomic) NSArray *otherCategories;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet WMVerticalMenu *verticalMenu;

@property (weak) id delegate;

- (OFHubViewController *)initWithHubId:(NSString *)hubId hubTitle:(NSString *)hubTitle otherCategories:(NSArray *)otherCategories;

@end
