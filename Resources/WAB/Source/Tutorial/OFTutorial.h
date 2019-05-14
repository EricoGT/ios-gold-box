//
//  OFTutorial.h
//  Ofertas
//
//  Created by Marcelo Santos on 22/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFTutorial : WMBaseViewController <UIScrollViewDelegate>

- (IBAction)identifyButtonPressed;
- (IBAction)goToOffersButtonPressed;
- (IBAction)changePage:(id)sender;

@end
