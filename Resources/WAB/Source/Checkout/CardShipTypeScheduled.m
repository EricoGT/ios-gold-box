//
//  CardShipTypeScheduled.m
//  Ofertas
//
//  Created by Marcelo Santos on 10/9/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "CardShipTypeScheduled.h"
#import <QuartzCore/QuartzCore.h>
#import "OFShipmentTemp.h"

@interface CardShipTypeScheduled ()

@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UIButton *btCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblPeriod;
@property (weak, nonatomic) IBOutlet UIButton *btChoose;

@property (strong, nonatomic) UIView *viewTemp;

@property (strong, nonatomic) NSString *strType;
@property (strong, nonatomic) NSString *strTime;
@property (strong, nonatomic) NSString *strValue;
@property (strong, nonatomic) NSString *indiceCard;

@property (assign, nonatomic) BOOL isSelected;

@end

@implementation CardShipTypeScheduled

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andType:(NSString *) refType andTime:(NSString *) refTime andValue:(NSString *) refValue andIndex:(NSString *) indexCard
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *refValueConverted = [refValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
        float ftVal = [refValueConverted floatValue];
        refValueConverted = [NSString stringWithFormat:@"%.2f", ftVal];
        
        _strType = refType;
        _strTime = refTime;
        _strValue = refValueConverted;
        _indiceCard = indexCard;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _btChoose.layer.cornerRadius = 4.0f;
    _btChoose.layer.masksToBounds = YES;
    
    //Fonts custom
    float sizeFont = 13.0f;
    UIFont *fontCustom = [UIFont fontWithName:@"OpenSans-Semibold" size:sizeFont];
    _lblType.font = fontCustom;
    _lblType.text = _strType;
    
    sizeFont = 12.0f;
    fontCustom = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    _lblTime.font = fontCustom;
    
    if (_strTime.length > 0) {
        NSString *timeDelivery;
        if ([_strTime isEqualToString:@"0d"]) {
            timeDelivery = DELIVERY_SAME_DAY;
        }
        else if ([_strTime isEqualToString:@"1d"]) {
            timeDelivery = @"1 dia útil";
        }
        else {
            timeDelivery = [_strTime stringByReplacingOccurrencesOfString:@"d" withString:@" dias úteis"];
        }
        _lblTime.text = timeDelivery;
    }
    
    sizeFont = 10.0f;
    fontCustom = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    _lblValue.font = fontCustom;
    
    float valueStr = [_strValue floatValue];
    LogInfo(@"Value str: %f", valueStr);
    if (valueStr > 0) {
        _lblValue.text = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:valueStr]];
    } else {
        _lblValue.text = SHIPMENT_VALUE_FREE;
    }
    
    sizeFont = 10.0f;
    fontCustom = [UIFont fontWithName:@"OpenSans-Bold" size:sizeFont];
    _lblPeriod.font = fontCustom;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uncheckOption) name:@"uncheckShipOptions" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDate) name:@"updateShip" object:nil];
}

- (void) uncheckOption {
    
    [_btCheck setImage:[UIImage imageNamed:@"checkOff.png"] forState:UIControlStateNormal];
    self.isSelected = NO;
    _lblPeriod.text = @"Escolha uma data";
}


- (void) choosePeriod {
    
    LogInfo(@"Choose period...");

    [[NSNotificationCenter defaultCenter] postNotificationName:@"uncheckShipOptions" object:nil];
    [_btCheck setImage:[UIImage imageNamed:@"checkOn.png"] forState:UIControlStateNormal];
    self.isSelected = YES;
    
    NSDictionary *dictShip = [[NSDictionary alloc] initWithObjectsAndKeys:_lblType.text, @"shipType", _strValue, @"shipValue", _lblTime.text, @"shipTime", @"NO", @"shipContinue", @"YES", @"scheduled", @"", @"utc1", @"", @"utc2", @"", @"idShip", nil];
    
    OFShipmentTemp *ot = [[OFShipmentTemp alloc] init];
    [ot assignShipmentDictionary:dictShip];
    
    //Open ShipmentBox
    [[self delegate] chooseDate];
}

- (void) select {
    LogInfo(@"Select agendada: %@ [card: %@]", _strType, _indiceCard);
    
    if (!_isSelected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uncheckShipOptions" object:nil];
        [_btCheck setImage:[UIImage imageNamed:@"checkOn.png"] forState:UIControlStateNormal];
        self.isSelected = YES;
    }
    else {
        [_btCheck setImage:[UIImage imageNamed:@"checkOff.png"] forState:UIControlStateNormal];
        self.isSelected = NO;
    }
}

//Currency
- (NSString *) currencyFormat:(float) value {
    
    NSNumber *amount = [[NSNumber alloc] initWithFloat:value];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"R$"];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *newFormat = [numberFormatter stringFromNumber:amount];
    
    LogInfo(@"Number: %@", newFormat);
    
    //Remove currency symbol
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"R$" withString:@""];
    newFormat = [newFormat stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    return newFormat;
}


- (void)updateDate
{
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"periodShipment"];
    LogInfo(@"Updating data shipment: %@", str);
    
    _lblPeriod.text = str;
    
    OFShipmentTemp *ot = [[OFShipmentTemp alloc] init];
    NSMutableDictionary *dictTp = [[NSMutableDictionary alloc] initWithDictionary:[ot getShipmentDictionary]];
    dictTp[@"shipContinue"] = @"YES";
    
    [ot assignShipmentDictionary:dictTp];
}

- (void) updateDateScheduled:(NSString *)text {
    
    LogInfo(@"Schedule: %@", text);
}

@end
