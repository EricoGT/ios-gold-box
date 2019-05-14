//
//  WMBExpressDeliveryButton.m
//  Walmart
//
//  Created by Renan on 8/19/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "ConciergeDeliveryButton.h"
#import "UIViewController+Additions.h"

@implementation ConciergeDeliveryButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self setup];
}

- (void)setup {
    [self setImage:[UIImage imageNamed:@"ic_concierge_tooltip"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(receivedTouchUpInsideEvent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)receivedTouchUpInsideEvent {

    if (!_alertContainerView) {
        UIViewController *onTopController = [[UIApplication sharedApplication].keyWindow.rootViewController topVisibleViewController];
        self.alertContainerView = (onTopController.navigationController) ? onTopController.navigationController.view : onTopController.view;
    }
    
    NSString *alertMessage;
    switch (_conciergeDeliveryButtonType) {
        case ConciergeDeliveryButtonTypeInformative:
            alertMessage = CONCIERGE_DELIVERY_ALERT_INFORMATIVE;
            break;
            
        case ConciergeDeliveryButtonTypeLate:
            alertMessage = CONCIERGE_DELIVERY_ALERT_LATE;
            break;
            
        default:
            alertMessage = CONCIERGE_DELIVERY_ALERT_INFORMATIVE;
            break;
    }
    
    [_alertContainerView showAlertWithBackgroundColor:RGBA(26, 117, 207, 0.5f)
                                        iconImageName:nil
                                                title:CONCIERGE_DELIVERY_ALERT_TITLE
                                              message:alertMessage
                                   dismissButtonTitle:CONCIERGE_DELIVERY_ALERT_DISMISS
                                         dismissBlock:nil];
}

@end
