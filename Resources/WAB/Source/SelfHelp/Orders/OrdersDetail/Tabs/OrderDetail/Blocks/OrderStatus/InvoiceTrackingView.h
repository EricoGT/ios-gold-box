//
//  InvoiceTrackingView.h
//  Walmart
//
//  Created by Bruno Delgado on 4/27/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "TrackingViewWithXib.h"
@class WMButtonRounded;

@interface InvoiceTrackingView : TrackingViewWithXib

@property (nonatomic, weak) IBOutlet UIView *roundedView;
@property (nonatomic, weak) IBOutlet WMButtonRounded *seeInvoiceButton;

@end
