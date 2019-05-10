//
//  VariationTypeCellTableViewCell.h
//  Walmart
//
//  Created by Renan Cargnin on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VariationNode;

@protocol VariationTypeCellDelegate <NSObject>
@optional
- (void)selectedNode:(VariationNode *)selectedNode;
- (void)deselectedNode:(VariationNode *)deselectedNode;
@end

@interface VariationTypeCell : UITableViewCell

@property (weak) id <VariationTypeCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

- (void)setupWithVariationNodes:(NSArray *)variationNodes;

@end
