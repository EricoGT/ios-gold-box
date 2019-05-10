//
//  VariationTreeView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "VariationTreeView.h"

#import "VariationNode.h"
#import "VariationTypeCell.h"
#import "VariationPopup.h"
#import "VariationImageCell.h"

@interface VariationTreeView () <UITableViewDataSource, VariationTypeCellDelegate>

@property (strong, nonatomic) VariationNode *variationRootNode;

@property (strong, nonatomic) VariationNode *lastSelectedNode;

@end

@implementation VariationTreeView

- (VariationTreeView *)initWithVariationRootNode:(VariationNode *)variationRootNode baseImageURL:(NSString *)baseImageURL delegate:(id<VariationTreeViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        
        [self setup];
        [self setupWithVariationRootNode:variationRootNode baseImageURL:baseImageURL];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VariationTypeCell class]) bundle:nil] forCellReuseIdentifier:[VariationTypeCell reuseIdentifier]];
    UIEdgeInsets tableViewContentInset = _tableView.contentInset;
    tableViewContentInset.top = 16.0f;
    [_tableView setContentInset:tableViewContentInset];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 107;
}

- (void)setVariationRootNode:(VariationNode *)variationRootNode {
    _variationRootNode = variationRootNode;
    [_tableView reloadData];
}

- (void)setupWithVariationRootNode:(VariationNode *)variationRootNode baseImageURL:(NSString *)baseImageURL {
    self.variationRootNode = variationRootNode;
    [VariationImageCell setBaseImageURLString:baseImageURL];
}

- (void)disableScroll {
    [_tableView setScrollEnabled:NO];
    [_tableView removeConstraints:_tableView.constraints];
    [_tableView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0f
                                                            constant:_tableView.contentSize.height]];
}

- (NSNumber *)selectedSKU {
    return [_variationRootNode selectedSKU];
}

- (void)deselectLastSelectedNode {
    [_variationRootNode deselectNodesWithName:_lastSelectedNode.name depth:_variationRootNode.height - _lastSelectedNode.height - 1];
    
    for (NSInteger i = (_variationRootNode.height - _lastSelectedNode.height - 1); i < _variationRootNode.height; i++)
    {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _variationRootNode.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VariationTypeCell *cell = [_tableView dequeueReusableCellWithIdentifier:[VariationTypeCell reuseIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    
    VariationNode *selectedNode = [_variationRootNode selectedChildNodeWithDepth:indexPath.row - 1];
    NSArray *nodes = selectedNode ? selectedNode.options : [_variationRootNode childNodesWithDepth:indexPath.row];
    [cell setupWithVariationNodes:nodes];
    
    return cell;
}

#pragma mark - VariationTypeCellDelegate
- (void)selectedNode:(VariationNode *)selectedNode
{
    NSNumber *skuBeforeSelection = self.selectedSKU;
    
    LogInfo(@"Selected Name: %@", selectedNode.name);
    LogInfo(@"Selected height: %i", (int)selectedNode.height);
    LogInfo(@"Selected optionsType: %@", selectedNode.optionsType);
    LogInfo(@"Selected imageId 2: %@", selectedNode.imageIdFromLeaf);
    LogInfo(@"Selected isColorVariation: %i", selectedNode.isColorVariation);
    
    [_variationRootNode selectNodesWithName:selectedNode.name depth:_variationRootNode.height - selectedNode.height - 1];
    
    for (NSInteger i = (_variationRootNode.height - selectedNode.height); i < _variationRootNode.height; i++)
    {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    NSNumber *skuAfterSelection = self.selectedSKU;
    
    LogInfo(@"Selected Sku BEFORE: %@", skuBeforeSelection.stringValue);
    LogInfo(@"Selected Sku AFTER : %@", skuAfterSelection.stringValue);
    
    //Update image
//    if (selectedNode.isColorVariation) {
//        NSString *strImageId = selectedNode.imageIdFromLeaf;
//        [_delegate updateImagesFromVariations:@[strImageId]];
//    }
    
    
    
    self.lastSelectedNode = selectedNode;
    
    if (skuAfterSelection && ![skuBeforeSelection isEqual:skuAfterSelection]) {
        if (_delegate && [_delegate respondsToSelector:@selector(variationTreeDidChangeSelectedSKU:)]) {
            [_delegate variationTreeDidChangeSelectedSKU:skuAfterSelection];
        }
    }
}

- (void)deselectedNode:(VariationNode *)deselectedNode
{
    [_variationRootNode deselectNodesWithName:deselectedNode.name depth:_variationRootNode.height - deselectedNode.height - 1];
    
    for (NSInteger i = (_variationRootNode.height - deselectedNode.height); i < _variationRootNode.height; i++)
    {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
