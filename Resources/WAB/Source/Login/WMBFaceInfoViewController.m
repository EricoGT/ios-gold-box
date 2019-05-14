//
//  WMBFaceInfoViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 12/5/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBFaceInfoViewController.h"

@interface WMBFaceInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@end

@implementation WMBFaceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _lblInfo.text = @"";
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    result = CGSizeMake(result.width , result.height);
    
    float widthScreen = result.width;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    self.view.frame = CGRectMake(0, 0, widthScreen, 80);
}

- (void) setLabelContent:(NSString *) strText {
    
    _lblInfo.text = strText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
