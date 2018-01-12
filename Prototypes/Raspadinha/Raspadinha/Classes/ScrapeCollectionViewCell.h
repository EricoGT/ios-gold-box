//
//  ScrapeCollectionViewCell.h
//  Raspadinha
//
//  Created by Erico GT on 11/01/18.
//  Copyright © 2018 lordesire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"

@interface ScrapeCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imvItem;

- (void)updateLayout;

@end
