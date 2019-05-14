//
//  VariationTypeCellTableViewCell.m
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "VariationTypeCell.h"

#import "VariationImageCell.h"
#import "VariationLabelCell.h"

#import "VariationNode.h"

@interface VariationTypeCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, VariationCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedVariationLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *distinctVariations;

@property (assign, nonatomic) CGFloat largestOptionWidth;

@end

@implementation VariationTypeCell

+ (NSString *)reuseIdentifier
{
	return @"VariationTypeCell";
}

+ (NSDictionary *)typeImageNames
{
    static NSDictionary *typeImageNames;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        typeImageNames = @{@"cor" : @"UIProductVariationSelectorColorsIcon",
                           @"cores" : @"UIProductVariationSelectorColorsIcon",
                           @"color" : @"UIProductVariationSelectorColorsIcon",
                           @"colors" : @"UIProductVariationSelectorColorsIcon",
                           @"tamanho" : @"UIProductVariationSelectorSizeIcon",
                           @"size" : @"UIProductVariationSelectorSizeIcon",
                           @"peso" : @"UIProductVariationSelectorWeightIcon",
                           @"peso recomendado" : @"UIProductVariationSelectorWeightIcon",
                           @"weight" : @"UIProductVariationSelectorWeightIcon",
                           @"voltagem" : @"UIProductVariationSelectorVoltageIcon",
                           @"voltage" : @"UIProductVariationSelectorVoltageIcon"};
    });
    return typeImageNames;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    _selectedVariationLabel.text = @"";
    
	[_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VariationImageCell class]) bundle:nil] forCellWithReuseIdentifier:[VariationImageCell reuseIdentifier]];
	[_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VariationLabelCell class]) bundle:nil] forCellWithReuseIdentifier:[VariationLabelCell reuseIdentifier]];
}

- (void)setupWithVariationNodes:(NSArray *)variationNodes
{
	if (variationNodes.count == 0) return;
	
	//Removes duplicated variations (for display only)
	NSMutableArray *distinctVariationsMutable = [NSMutableArray new];
	for (VariationNode *variationNode in variationNodes)
	{
        NSArray *variationNames = [distinctVariationsMutable valueForKey:@"name"];
        if ([variationNames containsObject:variationNode.name]) continue;
        [distinctVariationsMutable addObject:variationNode];
	}
	self.distinctVariations = distinctVariationsMutable.copy;
	
    //Variation type
    VariationNode *parentNode = [variationNodes[0] parentNode];
	NSString *imageName = [VariationTypeCell typeImageNames][[parentNode.optionsType lowercaseString]] ?: @"UIProductVariationSelectorGenericIcon";
	_typeImageView.image = [UIImage imageNamed:imageName];
	_typeLabel.text = parentNode.optionsType;
	
	[_collectionView reloadData];
    
    //Calculate collection view cells width
    CGSize maximumLabelSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    NSDictionary *attributes = @{NSFontAttributeName : [VariationLabelCell labelFont]};
	self.largestOptionWidth = 0.0f;
    
    for (VariationNode *node in _distinctVariations)
    {
        if (node.selected)
        {
            [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:[_distinctVariations indexOfObject:node] inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
            _selectedVariationLabel.text = [node isColorVariation] ? node.name : @"";
        }
        
        if ([node isColorVariation]) continue;
        
        CGFloat expectedLabelWidth = [node.name boundingRectWithSize:maximumLabelSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:[NSStringDrawingContext new]].size.width;
        self.largestOptionWidth = MAX(MAX(expectedLabelWidth + 20.0f, _largestOptionWidth), 50.0f);
    }
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return _distinctVariations.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	VariationNode *node = _distinctVariations[indexPath.row];
	if ([node isColorVariation])
	{
		return CGSizeMake(64.0f, 54.0f);
	}
	else
	{
        return CGSizeMake(_largestOptionWidth <= 64.0f ? 64.0f : _largestOptionWidth, 54.0f);
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	VariationNode *node = _distinctVariations[indexPath.row];
	
	NSString *reuseIdentifier = [node isColorVariation] ? [VariationImageCell reuseIdentifier] : [VariationLabelCell reuseIdentifier];
	
	VariationCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	[cell setupWithVariationNode:node delegate:self];
	
	return cell;
}

#pragma mark - UIcollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	VariationNode *selectedVariationNode = _distinctVariations[indexPath.row];
    
    
    LogInfo(@"collectionView Selected Name: %@", selectedVariationNode.name);
    LogInfo(@"collectionView Selected height: %i", (int)selectedVariationNode.height);
    LogInfo(@"collectionView Selected optionsType: %@", selectedVariationNode.optionsType);
    LogInfo(@"collectionView Selected imageId: %@", selectedVariationNode.imageIdFromLeaf);
    LogInfo(@"collectionView Selected isColorVariation: %i", selectedVariationNode.isColorVariation);
    LogInfo(@"collectionView Selected Position: %i", (int)indexPath.row);
    
	
    _selectedVariationLabel.text = ([selectedVariationNode isColorVariation]) ? selectedVariationNode.name : @"";
	
	if (_delegate && [_delegate respondsToSelector:@selector(selectedNode:)])
	{
		[_delegate selectedNode:selectedVariationNode];
	}
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VariationNode *deselectedVariationNode = _distinctVariations[indexPath.row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(deselectedNode:)])
    {
        [_delegate deselectedNode:deselectedVariationNode];
    }
}

@end
