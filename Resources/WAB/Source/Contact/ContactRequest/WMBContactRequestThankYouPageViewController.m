//
//  WMBContactRequestThankYouPageViewController.m
//  Walmart
//
//  Created by Rafael Valim dos Santos on 06/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBContactRequestThankYouPageViewController.h"

@interface WMBContactRequestThankYouPageViewController ()

@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, strong) NSString *buttonTitleString;
@property (weak, nonatomic) IBOutlet UILabel *requestIdLabel;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIButton *goToTicketListButton;
@property (weak, nonatomic) IBOutlet WMButtonRounded *finishButton;

@property (nonatomic) BOOL showedFromMenu;

@end

@implementation WMBContactRequestThankYouPageViewController

- (instancetype)initWithRequestId:(NSString *)requestId andFromMenu:(BOOL)fromMenu andButtonTitleString:(NSString *)buttonTitle {
    self = [super init];
    if (self) {
        self.showedFromMenu = fromMenu;
        self.requestId = requestId;
        self.buttonTitleString = buttonTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.finishButton setTitle:self.buttonTitleString forState:UIControlStateNormal];
    
    [self.requestIdLabel setText:self.requestId];
    
    [self showButtonTicketHistory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showButtonTicketHistory {
    BOOL isHidden = [WALSession isAuthenticated] ?  FALSE : TRUE;
    [self.goToTicketListButton setHidden:isHidden];
}

- (IBAction)touchGoToTicketList:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(thankyouPageTicketListTouched)]) {
            [self.delegate thankyouPageTicketListTouched];
        }
    }];
}

- (IBAction)backToShoppingCartAction:(id)sender {
    
    if (self.showedFromMenu) {
        [[WALMenuViewController singleton] unselectHeaderButtons];
        [[WALMenuViewController singleton] presentHomeWithAnimation:NO reset:NO];
    }

    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(thankyouPageTicketFinish)]) {
            [self.delegate thankyouPageTicketFinish];
        }
    }];
}

@end
