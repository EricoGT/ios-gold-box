//
//  ViewControllerCompleteRaspadinha.h
//  Raspadinha
//
//  Created by Erico GT on 12/01/18.
//  Copyright © 2018 lordesire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "ScrapeCollectionViewCell.h"
#import "ScrathItem.h"
#import "AppDelegate.h"
#import "SCLAlertViewStyleKit.h"

@interface ViewControllerRaspadinhaCompleta : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MDScratchImageViewDelegate>

@property(nonatomic, assign) float lineThickness;
@property(nonatomic, assign) bool forcePremium;

@end

//***************************************************************************************
//Neste modelo o usuário raspa uma view grande e esta repassa o toque para as internas (tem o processamento mais custoso)
//***************************************************************************************

