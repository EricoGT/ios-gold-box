//
//  CardShipmentOptions.h
//  Ofertas
//
//  Created by Marcelo Santos on 13/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShipmentBoxViewController.h"

@protocol cardOptionsDelegate <NSObject>
@required
@optional
- (void) finishCardWithHeight:(float) height andIndex:(float) index;
- (void) openShipOptions;
@end

@interface CardShipmentOptions : WMBaseViewController {
    
    __weak id <cardOptionsDelegate> delegate;
    
   IBOutlet UIView *viewProducts;
   IBOutlet UIView *viewTypes;
    
    NSArray *arrProducts;
    NSArray *arrOptions;
    
    IBOutlet UIImageView *separator;
    
    NSString *qtyShipment; //Entrega 1 de n
    NSString *qtyTotalShip; //Entrega 1 de n
    
//    ShipmentBoxViewController *shipbox;
}

@property (weak) id delegate;
//@property (nonatomic, strong) ShipmentBoxViewController *shipBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProducts:(NSArray *) products andOptions:(NSArray *) options andShipIndex:(NSString *) shipIndex andTotalShip:(NSString *) shipTotal;

@end
