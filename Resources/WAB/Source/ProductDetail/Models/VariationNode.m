//
//  VariationNode.m
//  Walmart
//
//  Created by Renan Cargnin on 11/19/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "VariationNode.h"

@implementation VariationNode

- (VariationNode *)initWithOptionsType:(NSString *)optionsType options:(NSArray *)options
{
	if (self = [super init])
	{
		_optionsType = optionsType;
		_options = [self setupWithOptions:options];
	}
	return self;
}

- (NSArray *)setupWithOptions:(NSArray *)options
{
	if (options.count == 0) return @[];
	
	NSMutableArray *mutableOptions = [NSMutableArray new];
	
	NSDictionary *firstOptionDict = options[0];
	
	if (firstOptionDict[@"options"]) {
		//Node
		for (NSDictionary *optionDict in options)
        {
			VariationNode *node = [VariationNode new];
			node.parentNode = self;
			node.name = optionDict[@"name"];
			node.optionsType = optionDict[@"optionsType"];
			node.options = [node setupWithOptions:optionDict[@"options"]];
            
            if ([@[@"110v", @"220v"] containsObject:[node.name lowercaseString]])
            {
                self.optionsType = @"Voltagem";
            }
            
			[mutableOptions addObject:node];
		}
	}
	else {
		//Leaf
		for (NSDictionary *optionDict in options)
        {
			VariationNode *leaf = [VariationNode new];
			leaf.name = optionDict[@"name"];
			leaf.imageId = optionDict[@"imageId"];
			leaf.sku = optionDict[@"sku"];
			leaf.parentNode = self;
            
            if ([@[@"110v", @"220v"] containsObject:[leaf.name lowercaseString]])
            {
                self.optionsType = @"Voltagem";
            }
            
			[mutableOptions addObject:leaf];
		}
	}
    
    if (mutableOptions.count == 1) self.selectedChildNode = mutableOptions[0];
	
	return mutableOptions.copy;
}

- (BOOL)isColorVariation
{
    NSString *optionsTypeLower = [_parentNode.optionsType lowercaseString];
    return [@[@"cor", @"cores", @"color", @"colors"] containsObject:optionsTypeLower];
}

#pragma mark - Tree Methods
- (NSUInteger)height
{
	if (_options.count > 0)
	{
		//Every child has the same height (always)
		VariationNode *childNode = _options[0];
		return 1 + [childNode height];
	}
	else
	{
		return 0;
	}
}

- (BOOL)selected
{
    return _parentNode.selectedChildNode == self;
}

- (NSNumber *)selectedSKU
{
    return _sku ?: _selectedChildNode ? [_selectedChildNode selectedSKU] : nil;
}

- (NSString *)imageIdFromLeaf
{
    return _options.count == 0 ? _imageId : [_options[0] imageIdFromLeaf];
}

- (NSArray *)childNodesWithDepth:(NSUInteger)depth
{
	if (depth == 0)
	{
		return _options;
	}
	else
	{
		NSMutableArray *mutableArray = [NSMutableArray new];
		for (VariationNode *childNode in _options)
		{
			[mutableArray addObjectsFromArray:[childNode childNodesWithDepth:depth - 1]];
		}
		return mutableArray.copy;
	}
}

- (VariationNode *)selectedChildNodeWithDepth:(NSUInteger)depth
{
    if (depth == 0)
    {
        return _selectedChildNode;
    }
    return [_selectedChildNode selectedChildNodeWithDepth:depth - 1];
}

- (void)selectNodesWithName:(NSString *)name depth:(NSUInteger)depth
{
    NSArray *childNodes = [self childNodesWithDepth:depth];
	
    for (VariationNode *node in childNodes)
    {
        if ([node.name isEqualToString:name])
        {
            node.parentNode.selectedChildNode = node;
        }
		else if (![node.parentNode.selectedChildNode.name isEqualToString:name])
		{
			node.parentNode.selectedChildNode = nil;
		}
    }
}

- (void)deselectNodesWithName:(NSString *)name depth:(NSUInteger)depth
{
    NSArray *childNodes = [self childNodesWithDepth:depth];
    for (VariationNode *node in childNodes)
    {
        if ([node.name isEqualToString:name])
        {
            node.parentNode.selectedChildNode = nil;
        }
    }
}

@end
