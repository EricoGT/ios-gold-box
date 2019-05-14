//
//  VariationNode.h
//  Walmart
//
//  Created by Renan Cargnin on 11/19/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariationNode : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *optionsType;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) NSNumber *sku;
@property (strong, nonatomic) NSString *imageId;

@property (strong, nonatomic) VariationNode *parentNode;
@property (strong, nonatomic) VariationNode *selectedChildNode;

- (VariationNode *)initWithOptionsType:(NSString *)optionsType options:(NSArray *)options;
- (NSUInteger)height;
- (BOOL)selected;
- (NSNumber *)selectedSKU;
- (NSString *)imageIdFromLeaf;

- (NSArray *)childNodesWithDepth:(NSUInteger)depth;
- (VariationNode *)selectedChildNodeWithDepth:(NSUInteger)depth;
- (void)selectNodesWithName:(NSString *)name depth:(NSUInteger)depth;
- (void)deselectNodesWithName:(NSString *)name depth:(NSUInteger)depth;

- (BOOL)isColorVariation;

@end
