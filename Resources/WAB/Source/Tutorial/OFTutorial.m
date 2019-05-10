//
//  OFTutorial.m
//  Ofertas
//
//  Created by Marcelo Santos on 22/10/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFTutorial.h"
#import "WMButtonRounded.h"

#define BUTTONS_FONT [UIFont fontWithName:@"OpenSans-Bold" size:11]

@interface OFTutorial ()

@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet WMButtonRounded *identifyButton;
@property (weak, nonatomic) IBOutlet WMButtonRounded *offersButton;

@property (weak, nonatomic) IBOutlet UIImageView *stepOneImage;
@property (weak, nonatomic) IBOutlet UIImageView *stepTwoImage;
@property (weak, nonatomic) IBOutlet UIImageView *stepThreeImage;
@property (weak, nonatomic) IBOutlet UIImageView *stepFourImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posYscrollFixConstraint;

@end

@implementation OFTutorial

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fillWithCustomImage];
    
    _tutorialPageControl.pageIndicatorTintColor = RGBA(28, 98, 168, 1);
    _tutorialPageControl.currentPageIndicatorTintColor = RGBA(255, 255, 255, 1);
//    _tutorialPageControl.backgroundColor = [UIColor clearColor];
    
    [_tutorialPageControl setNumberOfPages:4];
    [_tutorialPageControl setCurrentPage:0];
    
//    _identifyButton.normalShadowColor = RGBA(204, 204, 204, 255);
//    _identifyButton.highlightedColor = RGBA(204, 204, 204, 255);
//    _identifyButton.highlightedShadowColor = RGBA(163, 163, 163, 255);
//    [_identifyButton setHighlighted:NO];
    
    [_tutorialScrollView setDelegate:self];
//    [_tutorialScrollView setBackgroundColor:RGBA(228, 228, 228, 1)];
    _tutorialScrollView.contentSize = CGSizeMake(_tutorialScrollView.contentSize.width,0);
    
//    _identifyButton.titleLabel.font = [UIFont fontWithName:@"Roboto" size:11];
//    _offersButton.titleLabel.font = [UIFont fontWithName:@"Roboto" size:11];
    
    _identifyButton.enabled = NO;
    [self performSelector:@selector(enableLogin) withObject:nil afterDelay:2];
}

- (void)fillWithCustomImage {
    
    if (IS_IPHONE_4_OR_LESS) {
        _stepOneImage.image = [UIImage imageNamed:@"step_one_iphone4"];
        _stepTwoImage.image = [UIImage imageNamed:@"step_two_iphone4"];
        _stepThreeImage.image = [UIImage imageNamed:@"step_three_iphone4"];
        _stepFourImage.image = [UIImage imageNamed:@"step_four_iphone4"];
    }
    else if (IS_IPHONE_5) {

        _posYscrollFixConstraint.constant = -40;
    }
    else {
        _stepOneImage.image = [UIImage imageNamed:@"step_one"];
        _stepTwoImage.image = [UIImage imageNamed:@"step_two"];
        _stepThreeImage.image = [UIImage imageNamed:@"step_three"];
        _stepFourImage.image = [UIImage imageNamed:@"step_four"];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger page = roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    _tutorialPageControl.currentPage = page;
}

- (IBAction)changePage:(id)sender {
    NSUInteger page = _tutorialPageControl.currentPage;
    [_tutorialScrollView setContentOffset:CGPointMake(page * _tutorialScrollView.bounds.size.width, _tutorialScrollView.contentOffset.y) animated:YES];
}

- (void)enableLogin {
    _identifyButton.enabled = YES;
}

- (void)identifyButtonPressed {
    [self dismissViewControllerAnimated:NO completion:^{
        [[WALMenuViewController singleton] presentLoginAnimated:NO];
    }];
}

- (void)goToOffersButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
