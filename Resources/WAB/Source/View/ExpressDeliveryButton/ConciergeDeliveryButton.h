//
//  WMBExpressDeliveryButton.h
//  Walmart
//
//  Created by Renan on 8/19/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    ConciergeDeliveryButtonTypeInformative = 0,
    ConciergeDeliveryButtonTypeLate = 1
} ConciergeDeliveryButtonType;

@interface ConciergeDeliveryButton : UIButton

@property (weak, nonatomic) IBOutlet UIView *alertContainerView;

@property (assign, nonatomic) IBInspectable NSInteger conciergeDeliveryButtonType;

@end
