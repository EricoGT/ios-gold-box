//
//  CardHeader.m
//  Ofertas
//
//  Created by Marcelo Santos on 12/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "CardHeader.h"

@interface CardHeader ()

@end

@implementation CardHeader

@synthesize strTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andHeaderTitle:(NSString *) headerTitle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        strTitle = headerTitle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self fillLabelWithContent];
}

- (void) fillLabelWithContent {
    
    //Fonts custom
    float sizeFont = 14.0f;
    UIFont *fontCustom = [UIFont fontWithName:@"OpenSans-Semibold" size:sizeFont];
    lblHeader.font = fontCustom;
    lblHeader.text = strTitle;
}

@end
