//
//  ScheduleDeliveryDateViewController.m
//  Table Navigation
//
//  Created by Diego Dias on 24/08/17.
//

#import "ScheduleDeliveryDateViewController.h"
#import "ScheduleDeliveryCell.h"
#import "ScheduleDeliveryPeriodViewController.h"
#import "WBRNavigationBarButtonItemFactory.h"
#import "DeliveryType.h"

@interface ScheduleDeliveryDateViewController () <UITableViewDelegate, UITableViewDataSource, ScheduleDeliveryPeriodViewControllerDelegate>

@property (strong, nonatomic) DeliveryType *deliveryType;

@property (weak, nonatomic) IBOutlet UITableView *datesTableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet WMButtonRounded *continueButton;

@property NSInteger selectedDateIndexRow;

@end

//Constants
static CGFloat const DisabledElementAlphaValue = 0.5f;
static CGFloat const EnabledElementAlphaValue = 1.0f;

@implementation ScheduleDeliveryDateViewController

- (ScheduleDeliveryDateViewController *)initWithDeliveryType:(DeliveryType *)deliveryType delegate:(id <ScheduleDeliveryDateViewControllerDelegate>)delegate{
    self = [super init];
    if (self) {
        [self setDeliveryType:deliveryType];
        [self setDelegate:delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupTableView];
    [self setContinueButtonEnabled:NO];
    [self.datesTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = @"Entrega agendada";
    
    if ([OFSetup backgroundEnable]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didEnterInBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)setupView {
    UIButton *customBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customBackButton.accessibilityIdentifier = @"btnClose";
    UIImage *btnImg = [UIImage imageNamed:@"ic_ignore"];
    [customBackButton setImage:btnImg forState:UIControlStateNormal];
    customBackButton.frame = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
    [customBackButton addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBackButton];
    
    self.navigationItem.rightBarButtonItem = [WBRNavigationBarButtonItemFactory createBarButtonItemWithImageString:@"imgCartShipNavbar" andFrameRect:CGRectMake(0, 0, 104, 44)];

    [self applyShadowViewBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
     
- (void)dismissScreen {
    [self.delegate scheduledDeliveryView:nil selectedDate:nil periodDictionary:nil];

    [self.navigationController dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)didEnterInBackground {
    
    if (self.kDidEnterBackgroundNotification) {
        self.kDidEnterBackgroundNotification();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI Elements
- (void)applyShadowViewBottom {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bottomView.bounds];
    self.bottomView.layer.masksToBounds = NO;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0.0f, -7.0f);
    self.bottomView.layer.shadowOpacity = 0.2f;
    self.bottomView.layer.shadowRadius = 4.0f;
    self.bottomView.layer.shadowPath = shadowPath.CGPath;
}

#pragma mark - IBActions
- (IBAction)pressContinueButton:(id)sender {
    NSIndexPath *selectedIndexPath = [self.datesTableView indexPathForSelectedRow];
    NSArray *dates = self.deliveryType.deliveryWindowMap.allKeys;
    
    if (selectedIndexPath.row < dates.count) {
        NSString *dateString = dates[selectedIndexPath.row];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        NSArray *periodsArray = self.deliveryType.deliveryWindowMap[dates[selectedIndexPath.row]];
        ScheduleDeliveryPeriodViewController *schedulePeriodViewController = [[ScheduleDeliveryPeriodViewController alloc] initWithPeriodsArray:periodsArray selectedDate:date];
        
        __weak typeof(self) weakSelf = self;
        schedulePeriodViewController.kDidEnterBackgroundNotification = ^{
            [weakSelf didEnterInBackground];
        };
        
        schedulePeriodViewController.delegate = self;
        [self.navigationController pushViewController:schedulePeriodViewController animated:YES];
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

#pragma mark - ScheduleDeliveryPeriodViewController Delegate
- (void)periodSelected:(NSDictionary *)period {
    NSIndexPath *selectedIndexPath = [self.datesTableView indexPathForSelectedRow];
    
    NSString *dateString = _deliveryType.deliveryWindowMap.allKeys[selectedIndexPath.row];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];

    [self.delegate scheduledDeliveryView:nil selectedDate:date periodDictionary:period];
    [self dismissScreen];
    
    
}

#pragma mark - Table view data source
- (void)setupTableView {
    [self.datesTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ScheduleDeliveryCell class]) bundle:nil] forCellReuseIdentifier:[ScheduleDeliveryCell reuseIdentifier]];
    self.datesTableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    [self.datesTableView setDelegate:self];
    [self.datesTableView setDataSource:self];
    [self.datesTableView setTableHeaderView:self.headerView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deliveryType.deliveryWindowMap.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:[ScheduleDeliveryCell reuseIdentifier] forIndexPath:indexPath];
    
    [cell bindScheduleDate:self.deliveryType.deliveryWindowMap.allKeys[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogInfo(@"%@", self.deliveryType.deliveryWindowMap.allKeys[indexPath.row]);
    
    [self setContinueButtonEnabled:YES];
}

@end
