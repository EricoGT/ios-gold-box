//
//  OFNotificationsViewController.m
//  Walmart
//
//  Created by Bruno Delgado on 3/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "OFNotificationsViewController.h"
#import "NotificationItemTableViewCell.h"
#import "OFMessages.h"
#import "NSString+Additions.h"
#import "PushHandler.h"

static NSString *reuseIdentifier = @"NotificationCellReuseIdentifier";

@interface OFNotificationsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL notificationsEnabled;

@end

@implementation OFNotificationsViewController

@synthesize delegate;

- (OFNotificationsViewController *)init {
    self = [super initWithTitle:@"Notificações" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [FlurryWM logEvent_notificationsEntering];
    [self setUp];
    
    self.notificationsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"WantNotifications"];
}

#pragma mark - SetUp
- (void)setUp {
    [self.tableView registerNib:[NotificationItemTableViewCell nib] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.rowHeight = 80;
    self.tableView.tableHeaderView = [self customTableViewHeader];
    self.tableView.scrollEnabled = NO;
    
    BOOL notificationsOn = [self isNotificationsEnabled];
    [self showTableViewFooter:!notificationsOn];
    
    //Gestos
    UISwipeGestureRecognizer *swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    UISwipeGestureRecognizer *swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    
    swipeRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizerRight];
    
    swipeRecognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizerLeft];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.switchControl setOn:self.notificationsEnabled animated:NO];
    return cell;
}

#pragma mark - Header and Footer
- (UIView *)customTableViewHeader {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, self.tableView.frame.size.width - 20, 18)];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    headerTitle.textColor = RGBA(102, 102, 102, 1);
    headerTitle.text = NOTIFICATIONS_HEADER;
    
    UIView *headerDivider = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height - 1, self.tableView.frame.size.width, 1)];
    headerDivider.backgroundColor = RGBA(226, 226, 226, 1);
    
    [header addSubview:headerDivider];
    [header addSubview:headerTitle];
    [header bringSubviewToFront:headerDivider];
    return header;
}

- (UIView *)customTableViewFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGFloat position = 0;
    position += 13;
    
    CGFloat labelsMaxWidth = self.tableView.frame.size.width - 62 - 15;
    UIFont *footerTitleFont = [UIFont fontWithName:@"OpenSans-Semibold" size:13];
    CGSize footerTitleSize = [NOTIFICATIONS_WARNING_TITLE sizeForTextWithFont:footerTitleFont constrainedToSize:CGSizeMake(labelsMaxWidth, CGFLOAT_MAX)];
    
    UILabel *footerTitle = [[UILabel alloc] initWithFrame:CGRectMake(62, position, labelsMaxWidth, footerTitleSize.height)];
    footerTitle.numberOfLines = 0;
    footerTitle.backgroundColor = [UIColor clearColor];
    footerTitle.font = footerTitleFont;
    footerTitle.textColor = RGBA(244, 123, 32, 1);
    footerTitle.text = NOTIFICATIONS_WARNING_TITLE;
    position += footerTitleSize.height;
    [footer addSubview:footerTitle];
    
    UIFont *footerMessageFont = [UIFont fontWithName:@"OpenSans" size:13];
    CGSize footerMessageSize = [NOTIFICATIONS_WARNING_MESSAGE sizeForTextWithFont:footerMessageFont constrainedToSize:CGSizeMake(labelsMaxWidth, CGFLOAT_MAX)];
    
    UILabel *footerMessage = [[UILabel alloc] initWithFrame:CGRectMake(62, position, labelsMaxWidth, footerMessageSize.height)];
    footerMessage.numberOfLines = 0;
    footerMessage.backgroundColor = [UIColor clearColor];
    footerMessage.font = footerMessageFont;
    footerMessage.textColor = RGBA(153, 153, 153, 1);
    footerMessage.text = NOTIFICATIONS_WARNING_MESSAGE;
    position += footerMessageSize.height;
    [footer addSubview:footerMessage];
    
    CGFloat iconPosition = (position/2) - 16;
    UIImageView *warningIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, iconPosition, 32, 32)];
    warningIcon.image = [UIImage imageNamed:@"ic_notifications_alert"];
    [footer addSubview:warningIcon];
    
    footer.frame = CGRectMake(0, 0, self.tableView.frame.size.width, position);
    return footer;
}

- (void)showTableViewFooter:(BOOL)show {
    if (show) {
        self.tableView.tableFooterView = [UIView new];
    }
    else {
        self.tableView.tableFooterView = [self customTableViewFooter];
    }
}

#pragma mark - Gestures
- (void)swipeRight:(UISwipeGestureRecognizer *)sender {
    LogInfo(@"Right Notifications!");
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(hideNotificationsScreenGesture)])) {
        [[self delegate] hideNotificationsScreenGesture];
    }
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)sender {
    LogInfo(@"Left Notifications!");
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(showNotificationsScreenGesture)])) {
        [[self delegate] showNotificationsScreenGesture];
    }
}

#pragma mark - Notifications
- (BOOL)isNotificationsEnabled {
    return ([[[UIApplication sharedApplication] currentUserNotificationSettings] types] != UIUserNotificationTypeNone);
}

#pragma mark - UTMI
- (NSString *)UTMIIdentifier {
    return @"explore-app";
}

@end
