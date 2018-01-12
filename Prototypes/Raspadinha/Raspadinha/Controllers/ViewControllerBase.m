//
//  ViewControllerBase.m
//  Raspadinha
//
//  Created by lordesire on 10/01/2018.
//  Copyright © 2018 lordesire. All rights reserved.
//

#import "ViewControllerBase.h"

@interface ViewControllerBase ()

@property (nonatomic, weak) IBOutlet UISlider* slider;
@property (nonatomic, weak) IBOutlet UILabel* lblThickness;
@property (nonatomic, weak) IBOutlet UISwitch* switchPremium;
@property (nonatomic, weak) IBOutlet UIButton* btnScrape;
@property (nonatomic, weak) IBOutlet UIButton* btnCompleteScrape;
@property (nonatomic, weak) IBOutlet UIButton* btnAutoScrape;

@end

@implementation ViewControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.lblThickness.text = [NSString stringWithFormat:@"%.0f", self.slider.value];
    //
    [self.btnScrape.layer setBorderWidth:1.0];
    [self.btnScrape.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.btnScrape.layer setCornerRadius:10.0];
    //
    [self.btnCompleteScrape.layer setBorderWidth:1.0];
    [self.btnCompleteScrape.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.btnCompleteScrape.layer setCornerRadius:10.0];
    //
    [self.btnAutoScrape.layer setBorderWidth:1.0];
    [self.btnAutoScrape.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.btnAutoScrape.layer setCornerRadius:10.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueDidChange:(UISlider*)sender
{
    self.lblThickness.text = [NSString stringWithFormat:@"%.0f", sender.value];
}

- (IBAction)actionScrape:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToRaspadinhaIndividual" sender:sender];
}

- (IBAction)actionCompleteScrape:(id)sender
{
    //[self performSegueWithIdentifier:@"SegueToRaspadinhaInteira" sender:sender];
    [self performSegueWithIdentifier:@"SegueToRaspadinhaCompleta" sender:sender];
}

- (IBAction)actionAuto:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToAutoRaspadinha" sender:sender];
}

- (IBAction)actionSwitch:(id)sender
{
    NSLog(@"Premium Switch: %c", self.switchPremium.isOn);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SegueToRaspadinhaIndividual"]){
        
        ViewControllerRaspadinha *vcR = [segue destinationViewController];
        vcR.lineThickness = self.slider.value;
        vcR.forcePremium = self.switchPremium.isOn;
        
    }else if ([segue.identifier isEqualToString:@"SegueToRaspadinhaInteira"]){
        
        ViewControllerCompleteRaspadinha *vcCR = [segue destinationViewController];
        vcCR.lineThickness = self.slider.value;
        vcCR.forcePremium = self.switchPremium.isOn;
        
    }else if ([segue.identifier isEqualToString:@"SegueToRaspadinhaCompleta"]){
        
        ViewControllerRaspadinhaCompleta *vcRC = [segue destinationViewController];
        vcRC.lineThickness = self.slider.value;
        vcRC.forcePremium = self.switchPremium.isOn;
        
    }else if ([segue.identifier isEqualToString:@"SegueToAutoRaspadinha"]){
        
        ViewControllerAutoRaspadinha *vcAR = [segue destinationViewController];
        vcAR.lineThickness = self.slider.value;
        vcAR.forcePremium = self.switchPremium.isOn;
        
    }
}


@end
