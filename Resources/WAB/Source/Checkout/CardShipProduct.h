//
//  CardShipProduct.h
//  Ofertas
//
//  Created by Marcelo Santos on 10/9/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardShipProduct : WMBaseViewController {
    
    NSString *desc;
    NSString *qty;
    IBOutlet UILabel *lblDescription;
    IBOutlet UILabel *lblQty;
    IBOutlet UIImageView *imgFillet;
    BOOL filletShow;
}

- (IBAction) testButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDescription:(NSString *) description andQty:(NSString *) qtyProd showFillet:(BOOL) fillet;

@end
