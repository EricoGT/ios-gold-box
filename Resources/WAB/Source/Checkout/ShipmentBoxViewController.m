//
//  ShipmentBoxViewController.m
//  Ofertas
//
//  Created by Marcelo Santos on 17/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "ShipmentBoxViewController.h"
#import "OFShipmentTemp.h"
#import <QuartzCore/QuartzCore.h>
#import "OFShippingsTemp.h"
#import "DateTools.h"
#import "DeliveryItemView.h"
#import "OFFormatter.h"
#import "WMButton.h"

@interface ShipmentBoxViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewBox;
@property (weak, nonatomic) IBOutlet WMButton *btCancel;
@property (weak, nonatomic) IBOutlet WMButton *btContinue;

@property (weak, nonatomic) IBOutlet UILabel *lblShipment;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectDate;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectPeriod;

@property (weak, nonatomic) IBOutlet UIScrollView *scrButtons;

@property (strong, nonatomic) NSMutableArray *arrayOptions;

@property (weak, nonatomic) IBOutlet UILabel *lblManha;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeManha;
@property (weak, nonatomic) IBOutlet UILabel *lblTarde;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeTarde;
@property (weak, nonatomic) IBOutlet UILabel *lblNoite;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeNoite;
@property (weak, nonatomic) IBOutlet UIButton *btManha;
@property (weak, nonatomic) IBOutlet UIButton *btTarde;
@property (weak, nonatomic) IBOutlet UIButton *btNoite;

@property (assign, nonatomic) id lastBtIndex;

@property (strong, nonatomic) NSDictionary *dictSkin;

@property (assign, nonatomic) BOOL isMorning;
@property (assign, nonatomic) BOOL isAfternoon;
@property (assign, nonatomic) BOOL isNight;

@property (strong, nonatomic) NSString *dateChoosed;
@property (strong, nonatomic) NSString *periodChoosed;

@property (strong, nonatomic) NSArray *arrTempUTC;
@property (strong, nonatomic) NSString *idShipping;

@property (nonatomic, retain) DeliveryItemView *deliveryItemView;
@property (nonatomic, retain) NSDictionary *windowsDeliveryOptionsDictionary;

@end

@implementation ShipmentBoxViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void) roundButton:(UIButton *) bt withRadius:(float) radiusAngle
{
    bt.layer.cornerRadius = radiusAngle;
    bt.layer.masksToBounds = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_btContinue setup];
    [_btCancel setup];
    _btCancel.normalColor = RGBA(221, 221, 221, 255);
    
    _viewBox.hidden = YES;
    [self resizeBoxOptions:250.0f];
    
    [self performSelector:@selector(updateScreen) withObject:nil afterDelay:0.1];
    
    if ([OFSetup backgroundEnable]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    }
}

- (void)handleEnteredBackground:(NSNotification *)notification
{
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}


- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image;
    
    if (context != NULL)
    {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        image = nil;
    }
    
    return image;
}

- (void) updateScreen {
    
    _btManha.hidden = YES;
    _btTarde.hidden = YES;
    _btNoite.hidden = YES;
    _lblManha.hidden = YES;
    _lblTarde.hidden = YES;
    _lblNoite.hidden = YES;
    _lblTimeManha.hidden = YES;
    _lblTimeTarde.hidden = YES;
    _lblTimeNoite.hidden = YES;
    
    _lblSelectPeriod.hidden = YES;
    
    _viewBox.layer.cornerRadius = 4.0f;
    _viewBox.layer.masksToBounds = YES;
    
    //Fonts custom
    float sizeFont = 16.0f;
    UIFont *fontCustom = [UIFont fontWithName:@"OpenSans" size:sizeFont];
    _lblShipment.font = fontCustom;

    fontCustom = [UIFont fontWithName:@"OpenSans" size:13];
    _lblSelectDate.font = fontCustom;
    _lblSelectPeriod.font = fontCustom;
    
    self.arrayOptions = [[NSMutableArray alloc] init];
    
    self.deliveryItemView = [OFShippingsTemp deliveryItemView];
    NSDictionary *windowMap = self.deliveryItemView.currentDeliveryType.deliveryWindowMap;
    
    self.windowsDeliveryOptionsDictionary = windowMap;
    NSMutableArray *arrTp = [[NSMutableArray alloc] initWithArray:windowMap.allKeys];
    self.arrayOptions = arrTp.copy;
    
    _viewBox.hidden = NO;
    
    //Build buttons
    int lastIndex = 0;
    int position = 0;
    float posY = 0;
    int lineIndex = 0;
    int ttlines = 1;
    
    for (int g=0;g<[arrTp count];g++)
    {
        lastIndex++;
        NSString *dateInString = [arrTp objectAtIndex:g];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:dateInString];
        NSString *strDate = [date formattedDateWithFormat:@"dd/MM"];
        LogInfo(@"Date: %@", strDate);
        
        float posX = position*70;
        
        position++;
        
        
        if (lastIndex == 4) {
            LogInfo(@"************************************************");
            
            ttlines++;
            
            UIButton *btDate = [[UIButton alloc] init];
            btDate.frame = CGRectMake(posX, posY, 55, 37);
            [btDate setBackgroundImage:[UIImage imageNamed:@"bt_data_normal"] forState:UIControlStateNormal];
            [btDate setBackgroundImage:[UIImage imageNamed:@"bt_data_pressed"] forState:UIControlStateHighlighted];
            
            OFColors *colorConvertClass = [[OFColors alloc] init];
            UIColor *colorBt = [colorConvertClass convertToArrayColorsFromString:@"114,114,114,255"];
            
            fontCustom = [UIFont fontWithName:@"OpenSans-Semibold" size:12];
            
            [btDate setTitle:strDate forState:UIControlStateNormal];
            [btDate setTitleColor:colorBt forState:UIControlStateNormal];

            btDate.titleLabel.font = fontCustom;
            btDate.tag = g;
            [btDate addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchDown];
            
            [_scrButtons addSubview:btDate];
            
            lineIndex++;
            posY = 47.0f*lineIndex;
            lastIndex = 0;
            position = 0;
        
        } else {
            
            UIButton *btDate = [[UIButton alloc] init];
            btDate.frame = CGRectMake(posX, posY, 55, 37);
            [btDate setBackgroundImage:[UIImage imageNamed:@"bt_data_normal"] forState:UIControlStateNormal];
            [btDate setBackgroundImage:[UIImage imageNamed:@"bt_data_pressed"] forState:UIControlStateHighlighted];
            
            OFColors *colorConvertClass = [[OFColors alloc] init];
            UIColor *colorBt = [colorConvertClass convertToArrayColorsFromString:@"114,114,114,255"];
            
            fontCustom = [UIFont fontWithName:@"OpenSans-Semibold" size:12];
            
            [btDate setTitle:strDate forState:UIControlStateNormal];
            [btDate setTitleColor:colorBt forState:UIControlStateNormal];
            btDate.titleLabel.font = fontCustom;
            btDate.tag = g;
            [btDate addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchDown];
            
            [_scrButtons addSubview:btDate];
        }
    }
    
    LogInfo(@"TTlines: %i", ttlines);
    _scrButtons.contentSize = CGSizeMake(265, ttlines*47);
}

- (void) resetControls:(NSArray *) arrButtons andPeriod:(NSArray *) arrTxtPeriod andTime:(NSArray *) arrTxtTime
{
    _btManha.hidden = YES;
    _btTarde.hidden = YES;
    _btNoite.hidden = YES;
    _lblManha.hidden = YES;
    _lblTarde.hidden = YES;
    _lblNoite.hidden = YES;
    _lblTimeManha.hidden = YES;
    _lblTimeTarde.hidden = YES;
    _lblTimeNoite.hidden = YES;
    _lblSelectPeriod.hidden = YES;
}

- (void) unselectDate
{
    UIButton *button = (UIButton *) _lastBtIndex;
    [button setBackgroundImage:[UIImage imageNamed:@"bt_data_normal.png"] forState:UIControlStateNormal];
}

- (void) resetButtonsPeriod
{
    [_btManha setSelected:NO];
    [_btTarde setSelected:NO];
    [_btNoite setSelected:NO];
    
    self.isMorning = NO;
    self.isAfternoon = NO;
    self.isNight = NO;
}

- (void) chooseMorning {
    
    [self resetButtonsPeriod];
    
    if (!_isMorning)
    {
        [_btManha setSelected:YES];
        self.isMorning = YES;
        self.periodChoosed = @"Manhã";
        [[OFShipmentTemp new] assignSelectedShipmentDetails:[_arrTempUTC objectAtIndex:0]];
    }
    else
    {
        [_btManha setSelected:NO];
        self.isMorning = NO;
    }
}

- (void) chooseAfternoon {
    
    [self resetButtonsPeriod];
    
    if (!_isAfternoon)
    {
        [_btTarde setSelected:YES];
        self.isAfternoon = YES;
        self.periodChoosed = @"Tarde";
        [[OFShipmentTemp new] assignSelectedShipmentDetails:[_arrTempUTC objectAtIndex:1]];
    }
    else
    {
        [_btTarde setSelected:NO];
        self.isAfternoon = NO;
    }
}

- (void) chooseNight {
    
    [self resetButtonsPeriod];
    
    if (!_isNight)
    {
        [_btNoite setSelected:YES];
        self.isNight = YES;
        self.periodChoosed = @"Noite";
        [[OFShipmentTemp new] assignSelectedShipmentDetails:[_arrTempUTC objectAtIndex:2]];
    }
    else
    {
        [_btNoite setSelected:NO];
        self.isNight = NO;
    }
}

- (void) resizeBoxOptions:(float) sizeBox {
    
    WMDeviceType *wm = [[WMDeviceType alloc] init];
    float height = [wm heightScreen];
    height = height - 20;
    
    float heightBox = sizeBox;
    _viewBox.frame = CGRectMake(18, (height - heightBox)/2, 285, heightBox);
}

- (void) selectDate:(id)sender
{
    self.periodChoosed = nil;
    [self resizeBoxOptions:332.0f];
    [self unselectDate];
    [self resetButtonsPeriod];
    
    NSArray *arrButtons = [NSArray arrayWithObjects:_btManha, _btTarde, _btNoite, nil];
    NSArray *arrTxtPeriod = [NSArray arrayWithObjects:_lblManha, _lblTarde, _lblNoite, nil];
    NSArray *arrTxtTime = [NSArray arrayWithObjects:_lblTimeManha, _lblTimeTarde, _lblTimeNoite, nil];
    
    [self resetControls:arrButtons andPeriod:arrTxtPeriod andTime:arrTxtTime];
    
    UIButton *button = (UIButton*) sender;
    LogInfo(@"Button #: %i", (int)button.tag);
    
    self.lastBtIndex = sender;
    
    [button setBackgroundImage:[UIImage imageNamed:@"bt_data_pressed.png"] forState:UIControlStateNormal];
    
    _lblSelectPeriod.hidden = NO;
    
    NSString *dateInString = [_arrayOptions objectAtIndex:button.tag];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateInString];
    NSString *strDateExtended = [date formattedDateWithFormat:@"dd/MM/yyyy"];
    
    _lblSelectPeriod.text = [NSString stringWithFormat:@"Selecione um período do dia %@", strDateExtended];
    
    //dateChoosed = [self convertToExtendedDate:strDateExtended];
    self.dateChoosed = strDateExtended;
    
    //Combinations test
    int testIndex = (int)button.tag;
    NSArray *arrDat = [self.windowsDeliveryOptionsDictionary objectForKey:[_arrayOptions objectAtIndex:testIndex]];
    self.arrTempUTC = arrDat;
    
    LogInfo(@"Arr UTC: %@", arrDat);
    LogInfo(@"# periods: %i", (int)[arrDat count]);
    
    for (int i=0;i<[arrDat count];i++)
    {
        //Determine manhã, tarde e noite
        NSDictionary *periodDictionary = [arrDat objectAtIndex:i];
        NSString *period = [periodDictionary objectForKey:@"period"];
        NSString *periodFormatted = @"";
        if ([period isEqualToString:@"MORNING"])
        {
            periodFormatted = @"Manhã";
        }
        else if([period isEqualToString:@"AFTERNOON"])
        {
            periodFormatted = @"Tarde";
        }
        else if ([period isEqualToString:@"EVENING"])
        {
            periodFormatted = @"Noite";
        }
        
        NSNumber *startUTCTime = [periodDictionary objectForKey:@"startDateUtc"];
        NSNumber *endUTCTime = [periodDictionary objectForKey:@"endDateUtc"];
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(startUTCTime.doubleValue)/1000];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(endUTCTime.doubleValue)/1000];
        
        NSString *time = [NSString stringWithFormat:@"%@ às %@",
                                                [startDate formattedDateWithFormat:@"HH:mm"],
                                                [endDate formattedDateWithFormat:@"HH:mm"]];
        
        UIButton *bt = [arrButtons objectAtIndex:i];
        bt.hidden = NO;
        
        UILabel *lbl = [arrTxtPeriod objectAtIndex:i];
        lbl.hidden = NO;
        lbl.text = periodFormatted;
        
        UILabel *lbl2 = [arrTxtTime objectAtIndex:i];
        lbl2.hidden = NO;
        lbl2.text = time;
    }

}


- (void) printGroups:(NSArray *) arrTimes {
    
    LogInfo(@"Print: %@", arrTimes);
    [_arrayOptions addObject:arrTimes];
}

- (NSString *) convertToExtendedDate:(NSString *) utcDate {
    LogInfo(@"UTC: %@", utcDate);
    NSArray *arrPeriodStart = [utcDate componentsSeparatedByString:@"T"];
    NSString *dateShipStart = [arrPeriodStart objectAtIndex:0];
    NSArray *arrDate = [dateShipStart componentsSeparatedByString:@"-"];
    NSString *strDay = [arrDate objectAtIndex:2];
    NSString *strMonth = [arrDate objectAtIndex:1];
    NSString *strYear = [arrDate objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@/%@/%@", strDay, strMonth, strYear];
}

- (NSString *) convertHoursStart:(NSString *) startHour andHourEnd:(NSString *) endHour {
    
    NSArray *arrPeriodStart = [startHour componentsSeparatedByString:@"T"];
    NSString *timeShipStart = [arrPeriodStart objectAtIndex:1];
    NSArray *arrHour = [timeShipStart componentsSeparatedByString:@":"];
    NSString *strHourStart = [arrHour objectAtIndex:0];
    NSString *strMinuteStart = [arrHour objectAtIndex:1];
    
    NSArray *arrPeriodEnd = [endHour componentsSeparatedByString:@"T"];
    NSString *timeShipEnd = [arrPeriodEnd objectAtIndex:1];
    NSArray *arrHourEnd = [timeShipEnd componentsSeparatedByString:@":"];
    NSString *strHourEnd = [arrHourEnd objectAtIndex:0];
    NSString *strMinuteEnd = [arrHourEnd objectAtIndex:1];
    
    return [NSString stringWithFormat:@"%@:%@ às %@:%@", strHourStart, strMinuteStart, strHourEnd, strMinuteEnd];
}

- (NSString *) convertTimeToDate:(NSString *) timeData {
    
    NSArray *arrDt = [timeData componentsSeparatedByString:@"-"];
    NSString *strDay = [arrDt objectAtIndex:2];
    NSString *strMonth = [arrDt objectAtIndex:1];
    
    return [NSString stringWithFormat:@"%@/%@", strDay, strMonth];
}

- (void) cancel {
    [self.view removeFromSuperview];
}


- (void) continueToPayment {
    LogInfo(@"strPeriod: %@ - %@", _dateChoosed, _periodChoosed);
    
    OFMessages *mes = [[OFMessages alloc] init];
    if (_periodChoosed != NULL && _dateChoosed != NULL)
    {
        [self.deliveryItemView updateScheduledDeliverSelectedDate:_dateChoosed period:_periodChoosed];
        [self.deliveryItemView selectItem];
        [self.view removeFromSuperview];
    }
    else
    {
        if (_dateChoosed == NULL || [_dateChoosed isEqualToString:@""])
        {
            [self.view showAlertWithMessage:[mes shipmentDate]];
        }
        else
        {
            [self.view showAlertWithMessage:[mes shipmentPeriod]];
        }
    }
}

- (NSString *)formattedScheduledDate {
    if (_dateChoosed.length > 0 && _periodChoosed.length > 0) {
        return [NSString stringWithFormat:@"%@ - Período: %@",_dateChoosed,_periodChoosed];
    } else {
        return nil;
    }
    
}

@end
