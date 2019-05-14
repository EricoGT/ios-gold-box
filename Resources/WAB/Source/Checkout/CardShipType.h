//
//  CardShipType.h
//  Ofertas
//
//  Created by Marcelo Santos on 10/9/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardShipType : WMBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andType:(NSString *) refType andTime:(NSString *) refTime andValue:(NSString *) refValue andIndex:(NSString *) indexCard andDictOption:(NSDictionary *) dictOpt;

- (IBAction) select;

@end
