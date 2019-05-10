//
//  AlertInfoBlock.m
//  Walmart
//
//  Created by Bruno Delgado on 10/20/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "AlertInfoBlock.h"
#import "NSString+Additions.h"
#import "WMButton.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define kMinimumSize 47
#define kMargin 15

@interface AlertInfoBlock ()

@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UIButton *button;

@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation AlertInfoBlock

- (void)updateWithMessage:(NSString *)message alertType:(TrackingAlertType)type
{
    self.messageLabel.text = message;
    CGSize messageSize = [message sizeForTextWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(self.messageLabel.frame.size.width, CGFLOAT_MAX)];
    
    NSError *error = nil;
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                                   error:&error];
    [dataDetector enumerateMatchesInString:message options:0 range:NSMakeRange(0, message.length)
    usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (result.phoneNumber) {
            self.phoneNumber = result.phoneNumber;
            self.phoneNumber = [self.phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
            self.phoneNumber = [self.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSRange phoneRange = [self.messageLabel.text rangeOfString:result.phoneNumber];
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.messageLabel.text];
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Medium" size:15.0f] range:phoneRange];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBA(26, 117, 207, 1) range:phoneRange];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageLabel.attributedText = attributedStr.copy;
            });
        }
    }];
    
    CGRect messageFrame = self.messageLabel.frame;
    messageFrame.size.height = messageSize.height;
    self.messageLabel.frame = messageFrame;
    CGFloat size = messageFrame.origin.y + messageSize.height;
    
    switch (type)
    {
        case TrackingAlertTypeNormal:
        {
            size += kMargin;
            [self.actionButton setHidden:YES];
        }
            break;
            
        case TrackingAlertTypePayment:
        {
            [self.actionButton setHidden:YES];
            size += kMargin;
        }
            break;
            
        case TrackingAlertTypeBoleto:
        {
            [self.button setEnabled:YES];
            [self.actionButton setup];
            [self.actionButton setHidden:NO];
            
            size += kMargin;
            [self.actionButton setTitle:@"Visualizar boleto" forState:UIControlStateNormal];
            size += self.actionButton.frame.size.height;
            size += 10;
        }
            break;
            
        default:
            break;
    }
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = (size > kMinimumSize) ? size : kMinimumSize;
    self.frame = viewFrame;
}

- (IBAction)alertPressed:(id)sender {
    if (self.phoneNumber.length == 0) return;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *mnc = [carrier mobileNetworkCode];
        if (([mnc length] == 0) || ([mnc isEqualToString:@"65535"])) {
            [self showAlertUnableToCallWithMsg:DEVICE_WITHOUT_SIM_CARD];
        } else {
            [self showAlertForCallWithNumber:self.phoneNumber];
        }
    } else {
        [self showAlertUnableToCallWithMsg:DEVICE_CANT_PLACE_PHONE_CALL];
    }
}

- (void)performCall
{
    if (self.phoneNumber.length > 0)
    {
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", self.phoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        [[UIApplication sharedApplication] openURL:phoneURL];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

- (void)showAlertUnableToCallWithMsg:(NSString *)msg {
    if (self.superview) {
        UIView *rootView = self.superview;
        while (rootView.superview) {
            rootView = rootView.superview;
        }
        [rootView showAlertWithMessage:msg];
    }
}

- (void)showAlertForCallWithNumber:(NSString *)number {
    if (self.superview) {
        UIView *rootView = self.superview;
        while (rootView.superview) {
            rootView = rootView.superview;
        }
        [rootView showPopupWithTitle:@"Atendimento" message:number cancelButtonTitle:@"Cancelar" cancelBlock:nil actionButtonTitle:@"Ligar" actionBlock:^{
            [self performCall];
        }];
    }
}

@end
