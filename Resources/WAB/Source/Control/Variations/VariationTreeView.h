//
//  VariationTreeView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@class VariationNode;

@protocol VariationTreeViewDelegate <NSObject>
@optional
- (void)variationTreeDidChangeSelectedSKU:(NSNumber *)selectedSKU;
- (void)updateImagesFromVariations:(NSArray *) imageIds;
@end

@interface VariationTreeView : WMView

@property (weak) id <VariationTreeViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (VariationTreeView *)initWithVariationRootNode:(VariationNode *)variationRootNode baseImageURL:(NSString *)baseImageURL delegate:(id <VariationTreeViewDelegate>)delegate;

- (void)setupWithVariationRootNode:(VariationNode *)variationRootNode baseImageURL:(NSString *)baseImageURL;
- (NSNumber *)selectedSKU;
- (void)deselectLastSelectedNode;

- (void)disableScroll;

@end
