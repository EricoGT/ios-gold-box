//
//  QASkuViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 11/3/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "QASkuViewController.h"

@interface QASkuViewController ()
- (IBAction)goProduct:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtSku;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segSku;
@property (weak, nonatomic) IBOutlet UIButton *btSku;
@end

@implementation QASkuViewController

- (QASkuViewController *)init {
    self = [super initWithTitle:@"Sku ou Product ID" isModal:NO searchButton:NO cartButton:NO wishlistButton:NO];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _txtSku.layer.masksToBounds = YES;
    _txtSku.layer.borderWidth = 2.0f;
    _txtSku.layer.cornerRadius = 5.0f;
    _txtSku.layer.borderColor = RGBA(242, 242, 242, 1).CGColor;
    
    _btSku.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goProduct:(id)sender {
    
    if (_segSku.selectedSegmentIndex == 0) {
        
        [super openProductWithSKU:_txtSku.text];
    }
    else if (_segSku.selectedSegmentIndex == 1) {
        
        [super openProductWithID:_txtSku.text];
    }
    else {
        [super openProductWithSKU:_txtSku.text];
    }
    
//    [super openProductWithID:@"2409623"];
//    [super openProductWithSKU:@"33555"];
//    [self dismissViewControllerAnimated:YES completion:nil];
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
