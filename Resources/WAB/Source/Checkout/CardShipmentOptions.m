//
//  CardShipmentOptions.m
//  Ofertas
//
//  Created by Marcelo Santos on 13/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "CardShipmentOptions.h"
#import "CardHeader.h"
#import "CardShipProduct.h"
#import "CardShipType.h"
#import "CardShipTypeScheduled.h"

@interface CardShipmentOptions () <chooseDateDelegate>

@end

@implementation CardShipmentOptions

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProducts:(NSArray *) products andOptions:(NSArray *) options andShipIndex:(NSString *) shipIndex andTotalShip:(NSString *) shipTotal
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        arrProducts = products;
        arrOptions = options;
        qtyShipment = shipIndex;
        qtyTotalShip = shipTotal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    viewProducts.backgroundColor = [UIColor clearColor];
    viewTypes.backgroundColor = [UIColor clearColor];
    
    LogInfo(@"Products: %@", arrProducts);
    LogInfo(@"Options: %@", arrOptions);
    
//    int ind = [qtyShipment intValue];
//    NSString *indexShip = [NSString stringWithFormat:@"%i", ind];
    
    NSString *textHeader = @"Entrega";
//    NSString *textHeader = [NSString stringWithFormat:@"Entrega %@ de %@", indexShip, qtyTotalShip];
//    NSString *textHeader = @"Entrega 1 de 2";
    //First add the header if necessary
    float sizeHeader = 0.0f;
    if (![textHeader isEqualToString:@""]) {
        LogInfo(@"Mounting header...");
        sizeHeader = 40.0f;
        CardHeader *ch = [[CardHeader alloc] initWithNibName:@"CardHeader" bundle:nil andHeaderTitle:textHeader];
        ch.view.frame = CGRectMake(0, 0, 320, sizeHeader);
        
        [self addChildViewController:ch];
        [ch didMoveToParentViewController:self];
        
        [self.view addSubview:ch.view];
        [ch.view setNeedsLayout];
    }
    
    NSArray *arrProds = arrProducts;
    
    float heightCell = 50.0f;
    float widthCell = 285.0f;
    float ttHeightView = ([arrProds count]*heightCell)+sizeHeader;
    
    for (int i=0;i<[arrProds count];i++) {
        
        NSDictionary *dictProd = [arrProds objectAtIndex:i];
        
        NSString *descProduct = [dictProd objectForKey:@"descProduct"];
        NSString *qtyProduct = [dictProd objectForKey:@"qtyProduct"];
        LogInfo(@"Desc2: %@", descProduct);
        
        CardShipProduct *cp = [[CardShipProduct alloc] initWithNibName:@"CardShipProduct" bundle:nil andDescription:descProduct andQty:qtyProduct showFillet:YES];
        cp.view.frame = CGRectMake(0, (i*heightCell)+sizeHeader, widthCell, heightCell);
        
        [self addChildViewController:cp];
        [cp didMoveToParentViewController:self];
        
        [self.view addSubview:cp.view];
    }
    
    separator.frame = CGRectMake(0, ttHeightView, widthCell, 2);
    [self.view addSubview:separator];
    
    float lastPosY = ttHeightView+2;
    
    //Options shipment
    NSString *textHeaderOptions = @"Tipo de entrega";
    //First add the header if necessary
    float sizeHeaderOptions = 0.0f;
    if (![textHeaderOptions isEqualToString:@""]) {
        LogInfo(@"Mounting header Options...");
        sizeHeaderOptions = 40.0f;
        CardHeader *ch = [[CardHeader alloc] initWithNibName:@"CardHeader" bundle:nil andHeaderTitle:textHeaderOptions];
        ch.view.frame = CGRectMake(0, lastPosY, 320, sizeHeaderOptions);
        
        [self addChildViewController:ch];
        [ch didMoveToParentViewController:self];
        
        [self.view addSubview:ch.view];
        [ch.view setNeedsLayout];
    }
    
    lastPosY = lastPosY + sizeHeaderOptions;

    float heightCellOptions = 42.0f;
    BOOL agendada = NO;
    
    NSString *typeShipSched = @"";
    NSString *timeShipSched = @"";
    NSString *valueShipSched = @"";
    
    LogInfo(@"ArrOptions: %@", arrOptions);

    for (int k=0;k<[arrOptions count];k++)
    {
        NSDictionary *dictOptions = [arrOptions objectAtIndex:k];
        
        NSString *typeShip = [dictOptions objectForKey:@"shipType"];
        NSString *timeShip = [dictOptions objectForKey:@"shipTime"];
        NSString *valueShip = [dictOptions objectForKey:@"shipValue"];
        
        if (![typeShip isEqualToString:@"Agendada"])
        {
            CardShipType *cp = [[CardShipType alloc] initWithNibName:@"CardShipType" bundle:nil andType:typeShip andTime:timeShip andValue:valueShip andIndex:qtyShipment andDictOption:dictOptions];
            
            cp.view.frame = CGRectMake(0, (k*heightCellOptions)+lastPosY, widthCell, heightCellOptions);
            
            [self addChildViewController:cp];
            [cp didMoveToParentViewController:self];
            
            [self.view addSubview:cp.view];
        } else {
            agendada = YES;
            
            typeShipSched = typeShip;
            timeShipSched = timeShip;
            valueShipSched = valueShip;
        }
    }
    
    float posAgendada = lastPosY + (([arrOptions count]-1)*heightCellOptions);
    
    if (agendada) {
        
        LogInfo(@"We have a scheduled option for shipment");
        
        float heightScheduled = 82.0f;
        
        CardShipTypeScheduled *cship = [[CardShipTypeScheduled alloc] initWithNibName:@"CardShipTypeScheduled" bundle:nil andType:typeShipSched andTime:timeShipSched andValue:valueShipSched andIndex:qtyShipment];
        cship.delegate = self;
        cship.view.frame = CGRectMake(0, posAgendada, 285.0f, heightScheduled);
        
        [self addChildViewController:cship];
        [cship didMoveToParentViewController:self];
        
        [self.view addSubview:cship.view];
    }

    self.view.frame = CGRectMake(0, 0, 285, posAgendada+82);
    
    LogInfo(@"Size card: %f", posAgendada+82);
    
    [[self delegate] finishCardWithHeight:posAgendada+82 andIndex:[qtyShipment floatValue]];    
}

//- (void) updateDateScheduled:(NSString *) text {
//    
//    LogInfo(@"Update date scheduled Card: %@", text);
//}

- (void) chooseDate {
    
    LogInfo(@"Choosing date from cardshipment");
    
    [[self delegate] openShipOptions];
    
//    self.shipBox = [[ShipmentBoxViewController alloc] initWithNibName:@"ShipmentBoxViewController" bundle:nil];
//    shipBox.delegate = self;
//    shipBox.view.frame = CGRectMake(0, 0, 320, 568);
//    [self.view setFrame:CGRectMake(0, 0, 320, 568)];
//    [self.view addSubview:shipBox.view];

//    [self addChildViewController:shipBox];
//    [shipBox didMoveToParentViewController:self];
//    
//    [self.view addSubview:shipBox.view];
}

@end
