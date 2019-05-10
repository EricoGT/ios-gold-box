//
//  ScheduleDeliveryPeriodViewController.m
//  Table Navigation
//
//  Created by Diego Dias on 25/08/17.
//

#import "ScheduleDeliveryPeriodViewController.h"
#import "ScheduleDeliveryCell.h"
#import "WBRNavigationBarButtonItemFactory.h"
#import "WMButtonRounded.h"
#import "WBRScheduleDeliveryUtils.h"

@interface ScheduleDeliveryPeriodViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

//Generals
@property (weak, nonatomic) IBOutlet UITableView *periodsTableView;

@property (weak, nonatomic) IBOutlet UILabel *datePeriodDescriptionLabel;

//Header
@property (weak, nonatomic) IBOutlet UIView *headerView;

//Bottom
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet WMButtonRounded *continueButton;

@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSArray *periodsArray;

@end

//Constants
static CGFloat const DisabledElementAlphaValue = 0.5f;
static CGFloat const EnabledElementAlphaValue = 1.0f;

@implementation ScheduleDeliveryPeriodViewController


- (ScheduleDeliveryPeriodViewController *)initWithPeriodsArray:(NSArray *)periodsArray selectedDate:(NSDate *)selectedDate {
    self = [super init];
    if (self) {
        [self setSelectedDate:selectedDate];
        [self setPeriodsArray:periodsArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Entrega agendada";
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if ([OFSetup backgroundEnable]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

#pragma mark - Notifications

- (void)didEnterBackground {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.kDidEnterBackgroundNotification) {
        self.kDidEnterBackgroundNotification();
    }
}

#pragma mark - UI Elements
- (void)setupView {
    [self applyShadowViewBottom];
    self.navigationItem.rightBarButtonItem = [WBRNavigationBarButtonItemFactory createBarButtonItemWithImageString:@"imgCartShipNavbar" andFrameRect:CGRectMake(0, 0, 104, 44)];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self setupTableView];
    [self setContinueButtonEnabled:NO];
    [self.periodsTableView reloadData];
}

- (void)applyShadowViewBottom {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bottomView.bounds];
    self.bottomView.layer.masksToBounds = NO;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0.0f, -7.0f);
    self.bottomView.layer.shadowOpacity = 0.2f;
    self.bottomView.layer.shadowRadius = 4.0f;
    self.bottomView.layer.shadowPath = shadowPath.CGPath;
}

- (NSDictionary *)attributedBoldText {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithWhite:103.0f/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil];
    
    return dict;
}

- (NSDictionary *)attributedLightText {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithWhite:153.0f/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil];
    
    return dict;
}

#pragma mark Helpers

- (NSString *)convertUTCToPeriodToString:(NSNumber *)utcTime {
    
    NSDate *hour = [NSDate dateWithTimeIntervalSince1970:(utcTime.doubleValue) / 1000.0];
    NSDateFormatter *hourFormatter = [NSDateFormatter new];
    [hourFormatter setDateFormat:@"HH:mm"];
    
    return [hourFormatter stringFromDate: hour];
}

- (NSAttributedString *)descriptionTextByPeriod:(NSString *)selectedPeriod {
    
    NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc] init];
    
    NSDateFormatter *customFormatter = [NSDateFormatter new];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    [customFormatter setDateFormat:@"EEEE"];
    [customFormatter setLocale:locale];

    NSString *dayOfWeekString = [self sentenceCapitalizedString:[customFormatter stringFromDate:self.selectedDate]];
    NSMutableAttributedString *weekDay = [[NSMutableAttributedString alloc] initWithString:dayOfWeekString attributes:[self attributedBoldText]];
    [descriptionString appendAttributedString:weekDay];
    
    NSMutableAttributedString *textDay = [[NSMutableAttributedString alloc] initWithString:@", dia " attributes:[self attributedLightText]];
    [descriptionString appendAttributedString:textDay];
    
    [customFormatter setDateFormat:@"dd"];
    NSMutableAttributedString *dayNumber = [[NSMutableAttributedString alloc] initWithString:[customFormatter stringFromDate:self.selectedDate] attributes:[self attributedBoldText]];
    [descriptionString appendAttributedString:dayNumber];

    NSMutableAttributedString *textOf = [[NSMutableAttributedString alloc] initWithString:@" de " attributes:[self attributedLightText]];
    [descriptionString appendAttributedString:textOf];
    
    [customFormatter setDateFormat:@"MMMM"];
    NSString *monthText = [customFormatter stringFromDate:self.selectedDate];
    NSMutableAttributedString *month = [[NSMutableAttributedString alloc] initWithString:[monthText capitalizedString]  attributes:[self attributedBoldText]];
    [descriptionString appendAttributedString:month];
    
    [descriptionString appendAttributedString:textOf];
    
    [customFormatter setDateFormat:@"yyyy"];
    NSString *yearText = [customFormatter stringFromDate:self.selectedDate];
    NSMutableAttributedString *year = [[NSMutableAttributedString alloc] initWithString:yearText attributes:[self attributedBoldText]];
    [descriptionString appendAttributedString:year];

    NSMutableAttributedString *periodText = [[NSMutableAttributedString alloc] initWithString:@", no período da " attributes:[self attributedLightText]];
    [descriptionString appendAttributedString:periodText];
    
    NSMutableAttributedString *period = [[NSMutableAttributedString alloc] initWithString:[selectedPeriod lowercaseString]  attributes:[self attributedBoldText]];
    [descriptionString appendAttributedString:period];
    
    return descriptionString;
}

- (NSString *)sentenceCapitalizedString:(NSString *)stringWeekDay {
    
    NSString *uppercase = [[stringWeekDay substringToIndex:1] uppercaseString];
    NSString *lowercase = [[stringWeekDay substringFromIndex:1] lowercaseString];
    return [uppercase stringByAppendingString:lowercase];
}

#pragma mark - IBActions
- (IBAction)pressContinueButton:(id)sender {
    NSIndexPath *selectedIndexPath = [self.periodsTableView indexPathForSelectedRow];

    if (selectedIndexPath.row < self.periodsArray.count) {
        NSDictionary *period = _periodsArray[selectedIndexPath.row];
        [self.delegate periodSelected:period];
    }
}

- (void)setContinueButtonEnabled:(BOOL)enabled {
    
    //If we are disabling, even before the animation is finished, the button should already be disabled
    if (!enabled) {
        [self.continueButton setUserInteractionEnabled:NO];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        if (enabled) {
            self.continueButton.alpha = EnabledElementAlphaValue;
        }
        else {
            self.continueButton.alpha = DisabledElementAlphaValue;
        }
    } completion:^(BOOL finished) {
        //If we are enabling the button, it should only be enabled after the animation finishes
        if (enabled) {
            [self.continueButton setUserInteractionEnabled:YES];
        }
    }];
}

#pragma mark - Table view data source
- (void)setupTableView {
    [self.periodsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ScheduleDeliveryCell class]) bundle:nil] forCellReuseIdentifier:[ScheduleDeliveryCell reuseIdentifier]];
    [self.periodsTableView setDelegate:self];
    [self.periodsTableView setDataSource:self];
    [self.periodsTableView setTableHeaderView:self.headerView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.periodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:[ScheduleDeliveryCell reuseIdentifier] forIndexPath:indexPath];
    
    NSDictionary *periodDict = self.periodsArray[indexPath.row];
    NSString *periodString = [WBRScheduleDeliveryUtils convertePeriodText:periodDict[@"period"]];
    
    NSNumber *startHour = periodDict[@"startDateUtc"];
    NSNumber *endHour = periodDict[@"endDateUtc"];
    
    [cell bindSchedulePeriod:periodString startHour:[self convertUTCToPeriodToString:startHour] endHour:[self convertUTCToPeriodToString:endHour]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *periodDict = self.periodsArray[indexPath.row];
    NSString *periodString = [WBRScheduleDeliveryUtils convertePeriodText:periodDict[@"period"]];

    self.datePeriodDescriptionLabel.attributedText = [self descriptionTextByPeriod:periodString];
    [self setContinueButtonEnabled:YES];
}

@end
