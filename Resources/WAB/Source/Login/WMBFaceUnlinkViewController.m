//
//  WMBFaceUnlinkViewController.m
//  Walmart
//
//  Created by Marcelo Santos on 12/13/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBFaceUnlinkViewController.h"

@interface WMBFaceUnlinkViewController ()

@property (weak, nonatomic) IBOutlet WMButtonRounded *btUnlink;
@property (weak, nonatomic) IBOutlet WMButtonRounded *btCancel;
@property (weak, nonatomic) IBOutlet UIView *viewWarning;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewWidthConstraint;

- (IBAction)close:(id)sender;
- (IBAction)unlinkFace:(id)sender;

@end

@implementation WMBFaceUnlinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    LogInfo(@"GUID: %@", _strGuid);
    
}

- (void) unlinkFace:(id)sender {
    
    [[self delegate] unlinkFace];
    [[self delegate] closeWarning];
}

- (void) close:(id)sender {
    
    [[self delegate] closeWarning];
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
