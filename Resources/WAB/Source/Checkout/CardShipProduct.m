//
//  CardShipProduct.m
//  Ofertas
//
//  Created by Marcelo Santos on 10/9/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "CardShipProduct.h"
#import "OFCartTemp.h"
#import "NSString+HTML.h"

@interface CardShipProduct ()

@end

@implementation CardShipProduct

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDescription:(NSString *) description andQty:(NSString *) qtyProd showFillet:(BOOL) fillet
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        desc = description;
        qty = qtyProd;
        filletShow = fillet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!filletShow) {
        imgFillet.hidden = YES;
    }
    
    //Fonts custom
    float sizeFont = 12.0f;
    UIFont *fontCustom = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    lblDescription.font = fontCustom;
//    lblDescription.text = desc;
//    lblDescription.text = [OFCartTemp convertToXMLEntities:desc];
    lblDescription.text = [desc kv_decodeHTMLCharacterEntities];
    
    sizeFont = 17.0f;
    fontCustom = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    lblQty.font = fontCustom;
    lblQty.text = qty;
}

- (void) testButton {
    
    LogInfo(@"Pressed: %@", desc);
}

@end
