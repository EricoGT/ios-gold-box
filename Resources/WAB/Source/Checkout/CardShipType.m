//
//  CardShipType.m
//  Ofertas
//
//  Created by Marcelo Santos on 10/9/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "CardShipType.h"
#import "OFShipmentTemp.h"

@interface CardShipType ()

@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UIButton *btCheck;

@property (strong, nonatomic) NSString *strType;
@property (strong, nonatomic) NSString *strTime;
@property (strong, nonatomic) NSString *strValue;

@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) NSString *indiceCard;

@property (strong, nonatomic) NSDictionary *dictOptions;

@end

@implementation CardShipType

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andType:(NSString *) refType andTime:(NSString *) refTime andValue:(NSString *) refValue andIndex:(NSString *) indexCard andDictOption:(NSDictionary *) dictOpt;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        LogInfo(@"TimeCard: %@", refTime);
        LogInfo(@"TypeCard: %@", refType);
        LogInfo(@"ValueCard: %@", refValue);
        
        refValue = [refValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
        
        float ftVal = [refValue floatValue];
        
        refValue = [NSString stringWithFormat:@"%.2f", ftVal];
        
        _strType = refType;
        _strTime = refTime;
        _strValue = refValue;
        _indiceCard = indexCard;
        _dictOptions = dictOpt;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    LogInfo(@"lblType2: %@", _lblType.text);
    
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
    if (valueStr > 0) {
        _lblValue.text = [NSString stringWithFormat:@"R$ %@", [self currencyFormat:valueStr]];
    } else {
        _lblValue.text = SHIPMENT_VALUE_FREE;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uncheckOption) name:@"uncheckShipOptions" object:nil];
}

- (void) uncheckOption {
    
    [_btCheck setImage:[UIImage imageNamed:@"checkOff.png"] forState:UIControlStateNormal];
    self.isSelected = NO;
}

- (void) select {
    LogInfo(@"Select: %@ [card: %@]", _strType, _indiceCard);
    
    LogInfo(@"strValue: %@", _strValue);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uncheckShipOptions" object:nil];
    [_btCheck setImage:[UIImage imageNamed:@"checkOn.png"] forState:UIControlStateNormal];
    self.isSelected = YES;
    
    LogInfo(@"Dict Options CardShipType: %@", _dictOptions);
        
    NSDictionary *dictShip = [[NSDictionary alloc] initWithObjectsAndKeys:_lblType.text, @"shipType", _strValue, @"shipValue", _lblTime.text, @"shipTime", @"YES", @"shipContinue", @"NO", @"scheduled", [_dictOptions objectForKey:@"idShip"], @"idShip", @"", @"utc1", @"", @"utc2", nil];
    
    OFShipmentTemp *ot = [[OFShipmentTemp alloc] init];
    [ot assignShipmentDictionary:dictShip];
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

@end
