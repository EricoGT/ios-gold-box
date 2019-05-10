//
//  NotificationItemTableViewCell.m
//  Walmart
//
//  Created by Bruno Delgado on 3/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

@import AirshipKit;

#import "NotificationItemTableViewCell.h"
#import "OFMessages.h"
#import "PushHandler.h"

@interface NotificationItemTableViewCell () <UARegistrationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *notificationTitleLabel;

- (IBAction)notificationSwitchValueChanged;

@end

@implementation NotificationItemTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconImageView.image = [UIImage imageNamed:@"ic_notifications_bell"];
    self.notificationTitleLabel.text = NOTIFICATIONS_OFFERS_TEXT;
}

- (void)notificationSwitchValueChanged
{
    if (self.switchControl.on)
    {
        [FlurryWM logEvent_menu_notification:@"on"];
        [[UAirship push] setRegistrationDelegate:self];
        [FlurryWM logEvent_notificationsOn];
        LogInfo(@"Notifications ON");
    }
    else
    {
        [FlurryWM logEvent_menu_notification:@"off"];
        [[UAirship push] setRegistrationDelegate:nil];
        [FlurryWM logEvent_notificationsOff];
        LogInfo(@"Notifications OFF");
    }
    
    [[UAirship push] setUserPushNotificationsEnabled:self.switchControl.on];
    [[NSUserDefaults standardUserDefaults] setBool:self.switchControl.on forKey:@"WantNotifications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)registrationSucceededForChannelID:(NSString *)channelID deviceToken:(NSString *)deviceToken
{
    [[PushHandler new] registerForPushNotificationsOnWalmartServer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

@end
