//
//  CardHeader.h
//  Ofertas
//
//  Created by Marcelo Santos on 12/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"

@interface CardHeader : WMBaseViewController {
    
    IBOutlet UILabel *lblHeader;
    NSString *strTitle;
}

@property (nonatomic, strong) NSString *strTitle;

- (void) fillLabelWithContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andHeaderTitle:(NSString *) headerTitle;

@end
