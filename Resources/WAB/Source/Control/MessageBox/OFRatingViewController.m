//
//  OFRatingViewController.m
//  Walmart
//
//  Created by on 12/2/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFRatingViewController.h"
#import "WMButton.h"

@interface OFRatingViewController ()

@property (nonatomic, weak) IBOutlet WMButton *ratingButtonYes;
@property (nonatomic, weak) IBOutlet WMButton *ratingButtonAfter;

- (IBAction)rateYes:(id)sender;
- (IBAction)rateAfter:(id)sender;

@end

@implementation OFRatingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.ratingButtonYes setup];
    [self.ratingButtonAfter setup];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)rateYes:(id)sender
{
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(ratingYesPressed)]))
    {
        [self.delegate ratingYesPressed];
    }
}

- (void)rateAfter:(id)sender
{
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(ratingAfterPressed)]))
    {
        [self.delegate ratingAfterPressed];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
