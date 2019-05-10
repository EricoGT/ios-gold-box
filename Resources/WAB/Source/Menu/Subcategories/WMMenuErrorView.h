//
//  WMMenuErrorView.h
//  Walmart
//
//  Created by Bruno Delgado on 2/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMMenuErrorView : UIView

@property (nonatomic, weak) IBOutlet UILabel *errorMessageLabel;

+ (UIView *)loadFromXib;

@end
